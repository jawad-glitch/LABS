#define _POSIX_C_SOURCE 200112L
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PAGE_SIZE 4096UL
#define PTE_V (1UL << 0)
#define PTE_R (1UL << 1)
#define PTE_W (1UL << 2)
#define PTE_X (1UL << 3)
#define PTE_U (1UL << 4)
#define PTE_PPN_SHIFT 10

typedef uint64_t pte_t;

typedef enum {
    FAULT_NONE = 0,
    FAULT_PAGE_INVALID,
    FAULT_PERMISSION,
    FAULT_SUPERPAGE
} fault_code_t;

typedef struct {
    uint64_t physical_addr;
    fault_code_t fault;
} translation_result_t;

static pte_t *level1_table;
static pte_t *level0_table;

static pte_t *alloc_table(void)
{
    void *p = NULL;
    if (posix_memalign(&p, PAGE_SIZE, PAGE_SIZE) != 0)
        return NULL;
    memset(p, 0, PAGE_SIZE);
    return (pte_t *)p;
}

static uint64_t make_pte(uint64_t address, uint64_t flags)
{
    return ((address >> 12) << PTE_PPN_SHIFT) | flags;
}

uint64_t build_test_pagetable(void)
{
    pte_t *root = alloc_table();
    level1_table = alloc_table();
    level0_table = alloc_table();

    if (!root || !level1_table || !level0_table) {
        free(root);
        free(level1_table);
        free(level0_table);
        return 0;
    }

    /* Root VPN[2]=0 points to level 1; VPN[1]=0 points to level 0. */
    root[0] = make_pte((uint64_t)(uintptr_t)level1_table, PTE_V);
    level1_table[0] = make_pte((uint64_t)(uintptr_t)level0_table, PTE_V);

    /* Map exactly four virtual pages: 0x1000 through 0x4fff. */
    for (uint64_t i = 1; i <= 4; ++i) {
        uint64_t physical = 0x20000000UL + ((i - 1) * PAGE_SIZE);
        level0_table[i] = make_pte(physical, PTE_V | PTE_R | PTE_W | PTE_U);
    }

    /* Additional 2 MiB superpage at VPN[2]=0, VPN[1]=1. */
    level1_table[1] = make_pte(0x40000000UL, PTE_V | PTE_R | PTE_W);

    return (uint64_t)(uintptr_t)root >> 12;
}

static translation_result_t fault_result(fault_code_t f)
{
    translation_result_t r = {0, f};
    return r;
}

translation_result_t sv39_walk(uint64_t va, uint64_t root_ppn, uint64_t access)
{
    uint64_t vpn2 = (va >> 30) & 0x1ff;
    uint64_t vpn1 = (va >> 21) & 0x1ff;
    uint64_t vpn0 = (va >> 12) & 0x1ff;
    uint64_t offset = va & 0xfff;

    pte_t *table = (pte_t *)(uintptr_t)(root_ppn << 12);
    pte_t pte = table[vpn2];

    if (!(pte & PTE_V))
        return fault_result(FAULT_PAGE_INVALID);

    if (pte & (PTE_R | PTE_W | PTE_X))
        return fault_result(FAULT_PERMISSION); /* Level-2 superpage not implemented here. */

    table = (pte_t *)(uintptr_t)(((pte >> PTE_PPN_SHIFT) << 12));
    pte = table[vpn1];

    if (!(pte & PTE_V))
        return fault_result(FAULT_PAGE_INVALID);

    if (pte & (PTE_R | PTE_W | PTE_X)) {
        /* Level-1 superpage: 2 MiB leaf; lower 9 PPN bits must be zero. */
        if (!(pte & PTE_R) && access == PTE_R)
            return fault_result(FAULT_PERMISSION);
        if (!(pte & PTE_W) && access == PTE_W)
            return fault_result(FAULT_PERMISSION);
        if (!(pte & PTE_X) && access == PTE_X)
            return fault_result(FAULT_PERMISSION);

        uint64_t ppn = pte >> PTE_PPN_SHIFT;
        uint64_t physical = ((ppn & ~0x1ffULL) << 12) |
                            ((vpn0 & 0x1ff) << 12) | offset;
        translation_result_t r = {physical, FAULT_NONE};
        return r;
    }

    table = (pte_t *)(uintptr_t)(((pte >> PTE_PPN_SHIFT) << 12));
    pte = table[vpn0];

    if (!(pte & PTE_V))
        return fault_result(FAULT_PAGE_INVALID);

    if (!(pte & (PTE_R | PTE_W | PTE_X)))
        return fault_result(FAULT_PAGE_INVALID);

    if ((access == PTE_R && !(pte & PTE_R)) ||
        (access == PTE_W && !(pte & PTE_W)) ||
        (access == PTE_X && !(pte & PTE_X)))
        return fault_result(FAULT_PERMISSION);

    uint64_t ppn = pte >> PTE_PPN_SHIFT;
    translation_result_t r = {(ppn << 12) | offset, FAULT_NONE};
    return r;
}

static int check(const char *name, uint64_t va, uint64_t root,
                 uint64_t access, fault_code_t expected)
{
    translation_result_t r = sv39_walk(va, root, access);
    printf("%-18s VA=0x%llx PA=0x%llx fault=%d %s\n",
           name, (unsigned long long)va,
           (unsigned long long)r.physical_addr, r.fault,
           r.fault == expected ? "PASS" : "FAIL");
    return r.fault == expected;
}

int main(void)
{
    uint64_t root = build_test_pagetable();
    if (!root) {
        puts("Page-table allocation failed");
        return 1;
    }

    int ok = 1;
    translation_result_t r = sv39_walk(0x1234, root, PTE_R);
    printf("Mapped VA 0x1234 -> PA 0x%llx, fault=%d\n",
           (unsigned long long)r.physical_addr, r.fault);
    if (r.fault != FAULT_NONE || (r.physical_addr & 0xfff) != 0x234)
        ok = 0;

    ok &= check("mapped second page", 0x2345, root, PTE_R, FAULT_NONE);
    ok &= check("unmapped page", 0x9000, root, PTE_R, FAULT_PAGE_INVALID);
    ok &= check("permission denied", 0x1000, root, PTE_X, FAULT_PERMISSION);
    ok &= check("level-1 superpage", 0x200123, root, PTE_R, FAULT_NONE);

    free((void *)(uintptr_t)(root << 12));
    free(level1_table);
    free(level0_table);

    puts(ok ? "Sv39 walker tests: PASS" : "Sv39 walker tests: FAIL");
    return ok ? 0 : 1;
}
