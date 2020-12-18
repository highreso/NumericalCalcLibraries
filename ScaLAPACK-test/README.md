# ScaLAPACKの導入
## 概要
nvdインスタンスにScaLAPACKを導入する。
http://aragorn.pb.bialystok.pl/~mars/tutorial/scalapack/
を参考にすること。

## 前提
以下のソフトが導入済みであること。
- OpenMPI
- ATLAS
- BLACS

## 導入
### OpenMPIの導入
https://qiita.com/kitarow0309/items/8bb6fe2006760ed5a72e

- 検証用コード
```Fortran
program test
implicit none

write(6,*)'Fortran with OpenMPI テストだよ'

stop
end program test
```
- 
mpif90 -o test test.f90
mpirun -n 8 ./test
`-n 8`は8スレッド並列化環境で./testを実行する意
### ATLASの導入
http://aragorn.pb.bialystok.pl/~mars/tutorial/scalapack/

### BLASの導入
基本的な行列演算を行うライブラリ
-> 代わりにOpenBLAS入れてみました
https://www.kkaneko.jp/tools/ubuntu/cblaslinux.html

上記の方法だとCコンパイル時にエラーが発生するので
```bash
sudo apt-get install libopenblas-dev
```
を実行したら正常に動作確認できた

- 動作検証
```c
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
```
上記を`hoge.c`として保存
gcc -o hoge hoge.c -L/usr/local/OpenBLAS/lib -lopenblas -lpthread
でコンパイル

### LAPACKの導入
https://qiita.com/AnchorBlues/items/69c1744de818b5e045ab

### ScaLAPACKの導入

 sudo ln -s /home/user/scalapack/libscalapack.a /usr/local/lib/libscalapack.a


 ## 動作検証


 ## 用語類
 - `.fファイル`: .fは通常「固定形式で記述された・FORTRAN 77 プログラム」と解釈されるので、 .fファイルにFortran90またはFortrn95で新規追加された機能を記述する場合には、別途オプション機能が必要となる。`f90`はFortran90を明示指定
 - `GNUコンパイラ`: `GNU Compiler Collection`, `gcc`のこと