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

## AOCLの導入
→ nvd2はIntel Xeon CPUなのでダメ
AMD Optimizing CPU Libraries
AMD EPYC CPU用のライブラリセット
https://developer.amd.com/wp-content/resources/AOCL_User%20Guide_2.2.pdf

dpkg版(.dep)をダウンロードしてインストールした
```bash
dpkg -c aocl-linux-gcc-2.2.0_1_amd64.deb
sudo apt install ./aocl-linux-gcc-2.2.0_1_amd64.deb
dpkg -s aocl-linux-gcc-2.2.0
dpkg -L aocl-linux-gcc-2.2.0
```
 ll /opt/AMD/aocl/aocl-linux-gcc-2.2.0/amd-scalapack/

### AMD BLIS( Basic LinearAlgebra Subprograms)の導入
git clone https://github.com/amd/blis.git
cd ~/blis
今回はgccを使用している点に注意


gfortran example1.f -lscalapack-openmpi -lblacs-openmpi -lm
/usr/bin/ld: cannot find -lblacs-openmpi
collect2: error: ld returned 1 exit status




```bash
## make失敗時は以下のコマンドでlog作成すると良い
make > make.log
code make.log
```

```bash
sudo apt search [name]
# で探せるものは
sudo apt install [name]
# でインストールできる
```


## 最終動作検証1221
[こちらのサイト](https://thelinuxcluster.com/2020/05/13/compiling-scalapack-2-0-2-on-centos-7/)でやれるが別途BLACS必要？
1. 必要なライブラリ一覧
- BLAS
- LAPACK
- OpenMPI
- ScaLAPACK
- BLACS（本来はScaLAPACKに入っているはずだが動作しないので別途入れた, http://www.netlib.org/blacs/）

```bash
# 検証用コードは以下のコマンドで得る
wget http://www.netlib.org/scalapack/examples/sample_pssyev_call.f
mpif90 -O3 -o test2 sample_pssyev_call.f libscalapack.a -llapack -L/usr/local/lapack/lib -lblas -L/usr/local/BLAS
mpirun ./test2 
```


## 最終版：インスタンスでやるコマンド一覧
```bash
# Nvidi HPC SDKの導入
sudo wget https://developer.download.nvidia.com/hpc-sdk/20.11/nvhpc-20-11_20.11_amd64.deb
sudo wget https://developer.download.nvidia.com/hpc-sdk/20.11/nvhpc-2020_20.11_amd64.deb 
sudo wget https://developer.download.nvidia.com/hpc-sdk/20.11/nvhpc-20-11-cuda-multi_20.11_amd64.deb
sudo apt-get install ./nvhpc-20-11_20.11_amd64.deb ./nvhpc-2020_20.11_amd64.deb ./nvhpc-20-11-cuda-multi_20.11_amd64.deb

# make
sudo apt install make

# BLASの導入
wget http://www.netlib.org/blas/blas.tgz
tar -zxvf blas.tgz
mv  BLAS-3.8.0/ BLAS/
cd BLAS/
gfortran -O3 -std=legacy -m64 -fno-second-underscore -fPIC -c *.f
ar r libfblas.a *.o
ranlib libfblas.a
rm -rf *.o
export BLAS=~/src/BLAS/libfblas.a
ln -s libfblas.a libblas.a
mv ~/BLAS /usr/local/

# LAPACK(3.4.0)の導入
wget http://www.netlib.org/lapack/lapack-3.4.0.tgz
tar -zxvf lapack-3.4.0.tgz
cd lapack-3.4.0.tgz
cp INSTALL/make.inc.gfortran make.inc
## make.incをhttps://thelinuxcluster.com/2012/04/09/building-lapack-3-4-with-intel-and-gnu-compiler/ に従って編集すること
make lapacklib
make clean
mkdir -p /usr/local/lapack
cp liblapack.a 
mv liblapack.a /usr/local/lapack/
export LAPACK=/usr/local/lapack/liblapack.a

# OpenMPI(v3.1.3)の導入
wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.3.tar.gz --no-check-certificate
gunzip -c openmpi-3.1.3.tar.gz | tar xf -
cd openmpi-3.1.3
./configure --prefix=/opt/openMPI CC=gcc CXX=g++ F77=gfortran FC=gfortran
make
sudo make install
## .bashrcをhttps://qiita.com/kitarow0309/items/8bb6fe2006760ed5a72e に従って編集する
source ~/.bashrc

# ScaLAPACK(v2.0.2)の導入
wget http://www.netlib.org/scalapack/scalapack-2.0.2.tgz
tar -zxvf scalapack-2.0.2.tgz
cd scalapack-2.0.2
cp SLmake.inc.example SLmake.inc
## SLmakeを編集(https://thelinuxcluster.com/2020/05/13/compiling-scalapack-2-0-2-on-centos-7/)
# BLASLIB       = /usr/local/BLAS/libblas.a
# LAPACKLIB     = /usr/local/lapack/liblapack.a
cd
cp -r scalapack-2.0.2 /usr/local/

# 動作検証
wget http://www.netlib.org/scalapack/examples/sample_pssyev_call.f
mpif90 -O3 -o TEST_sample_pssyev_call sample_pssyev_call.f /usr/local/scalapack-2.0.2/libscalapack.a -llapack -L/usr/local/lapack/lib -lblas -L/usr/local/BLAS
mpirun TEST_sample_pssyev_call
```