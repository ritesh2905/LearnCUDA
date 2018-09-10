#include<iostream>
#include <cuda_runtime.h>
#include<cuda.h>
#include "device_launch_parameters.h"
using namespace std;

#define s 96

__global__ void square(int *a, int *b)
{
	int i = threadIdx.x;
	
	if(i<s)
		b[i] = a[i] * a[i] * a[i]; 
	
}


int main()
{
	int *a,*b, i;
	a = (int *)malloc(s * sizeof(int));
	b = (int *)malloc(s * sizeof(int));

	int *d_a, *d_b;
	cudaMalloc(&d_a, s * sizeof(int));
	cudaMalloc(&d_b, s * sizeof(int));

	for (i = 0; i < s; i++)
	{
		a[i] = i;
	}

	cudaMemcpy(d_a, a, s * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, s * sizeof(int), cudaMemcpyHostToDevice);

	
	square<<< 1, s >>>(d_a,d_b);

	cudaMemcpy(a, d_a, s * sizeof(int), cudaMemcpyDeviceToHost);
	cudaMemcpy(b, d_b, s * sizeof(int), cudaMemcpyDeviceToHost);

	for (i = 0; i < s; i++)
	{
		cout <<i<<":"<< b[i] << ",";
	}

	free(a);
	free(b);

	return 0;
}