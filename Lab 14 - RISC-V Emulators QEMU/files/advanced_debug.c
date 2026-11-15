#include <stdio.h>

typedef struct {
    int id;
    char name[50];
    float score;
} Student;

static void print_student(Student *s) {
    printf("ID: %d, Name: %s, Score: %.2f\n",
           s->id, s->name, s->score);
}

int main(void) {
    Student students[3] = {
        {1, "Alice", 95.5f},
        {2, "Bob", 87.3f},
        {3, "Charlie", 92.1f}
    };

    puts("=== Advanced RISC-V Debugging Example ===");
    for (int i = 0; i < 3; i++)
        print_student(&students[i]);

    Student *ptr = &students[1];
    puts("Accessing second student through pointer:");
    print_student(ptr);

    puts("Checking array bounds safely:");
    for (int i = 0; i <= 3; i++) {
        if (i < 3)
            print_student(&students[i]);
        else
            printf("Out-of-bounds index %d detected; access skipped.\n", i);
    }
    return 0;
}
