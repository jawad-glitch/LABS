#include <stdint.h>
#include <stdio.h>
#include <stddef.h>

typedef struct {
    uint8_t tag;
    uint32_t payload;
    uint8_t flags;
    uint64_t timestamp;
} record_t;

int print_record_layout(const record_t *r)
{
    size_t fields = sizeof(r->tag) + sizeof(r->payload) +
                    sizeof(r->flags) + sizeof(r->timestamp);
    int padding = (int)(sizeof(record_t) - fields);

    printf("record_t size: %zu\n", sizeof(record_t));
    printf("tag       offset=%zu size=%zu address=%p\n",
           offsetof(record_t, tag), sizeof(r->tag), (void *)&r->tag);
    printf("payload   offset=%zu size=%zu address=%p\n",
           offsetof(record_t, payload), sizeof(r->payload), (void *)&r->payload);
    printf("flags     offset=%zu size=%zu address=%p\n",
           offsetof(record_t, flags), sizeof(r->flags), (void *)&r->flags);
    printf("timestamp offset=%zu size=%zu address=%p\n",
           offsetof(record_t, timestamp), sizeof(r->timestamp), (void *)&r->timestamp);
    printf("timestamp alignment remainder: %lu\n",
           (unsigned long)((uintptr_t)&r->timestamp % 8));
    printf("padding bytes: %d\n", padding);

    return padding;
}

int main(void)
{
    record_t record = { .tag = 1, .payload = 0x12345678,
                        .flags = 3, .timestamp = 123456789ULL };
    int padding = print_record_layout(&record);

    if (padding <= 0 || ((uintptr_t)&record.timestamp % 8) != 0)
        return 1;

    return 0;
}
