#include <complex.h>
#include <omp.h>
#include <stdio.h>

int main(int argc, char** argv) {
    #pragma omp parallel
    {
        printf("Hello from process: %d\n", omp_get_thread_num());
    }

    return 0;
}
