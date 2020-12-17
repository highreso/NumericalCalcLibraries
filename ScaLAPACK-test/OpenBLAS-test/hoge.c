#include <stdio.h>
#include <stdlib.h>
#include <cblas.h>
#define N 2000

int main()
{
	// C = AB
	int i;
	double *A, *B, *C;

	A = (double *)malloc(sizeof(double) * N * N);
	B = (double *)malloc(sizeof(double) * N * N);
	C = (double *)malloc(sizeof(double) * N * N);

	for (i = 0; i < N * N; i++) {
		A[i] = (double)rand() / RAND_MAX;
		B[i] = (double)rand() / RAND_MAX;
	}
	cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, N, N, N, 1.0, A, N, B, N, 0.0, C, N);

	free(A);
	free(B);
	free(C);

	return 0;
}