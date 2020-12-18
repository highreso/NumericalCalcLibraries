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

- 動作検証
ソースコードは
http://www.rcs.arch.t.u-tokyo.ac.jp/kusuhara/tips/linux/fortran.html
より取得
```Fortran
program leqsol95

! LAPACK95のコンパイル時にあわせて作成されたモジュールを使います。
  use f95_lapack

  implicit none

  integer, parameter :: N = 3
  integer :: i
  real(8) :: K(1:N,1:N), P(1:N)

  K(1:3,1) = (/  2.0d0, -1.0d0,  0.0d0 /)
  K(1:3,2) = (/ -1.0d0,  2.0d0, -1.0d0 /)
  K(1:3,3) = (/  0.0d0, -1.0d0,  1.0d0 /)

  write(*,'(A)') 'K ='
  write(*,'(3F12.4)') ( K(i,:), i=1,N )

  P(1:3)   = (/  1.0d0,  2.0d0,  3.0d0 /)

  write(*,'(A)') 'P ='
  write(*,'(F12.4)') P

! LAPACK95（ラッパー）を介してLAPACKのルーチンを呼び出します。
! K に K を上三角行列にコレスキー分解した結果が，
! P に連立一次方程式の解が格納されます。
! K や P を書き換えられたくない場合は注意しましょう。
  call LA_POSV( K, P )

  write(*,'(A)') 'd ='
  write(*,'(F12.4)') P

end program leqsol95
```
上記を`leqsol95`として保存
gfortran -o leqsol95 leqsol95.f90 -I/usr/local/include -llapack95 -llapack -lblas
でコンパイル
./leqso95
で実行

### ScaLAPACKの導入

 sudo ln -s /home/user/scalapack/libscalapack.a /usr/local/lib/libscalapack.a


 ## 動作検証


 ## 用語類
 - `.fファイル`: .fは通常「固定形式で記述された・FORTRAN 77 プログラム」と解釈されるので、 .fファイルにFortran90またはFortrn95で新規追加された機能を記述する場合には、別途オプション機能が必要となる。`f90`はFortran90を明示指定
 - `GNUコンパイラ`: `GNU Compiler Collection`, `gcc`のこと

 ## cuSolverの使用
 /usr/local/cuda/include/
 pgfortran -o testDn  -fast -Minfo -Mcudalib=cusolver,cublas  testDn.cuf