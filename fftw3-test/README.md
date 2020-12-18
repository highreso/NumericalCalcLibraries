# FFTW3の導入
## 概要
離散フーリエ変換を行うFFTW3の導入を行う。

## 参考
https://www.kkaneko.jp/tools/ubuntu/fftw3linux.html
- 基本これに従えばok
- ただし`nvcc hoge.c -lm -lfftw3`という構文でコンパイル

## 導入
```bash
sudo apt -y install build-essential gcc g++ dpkg-dev pkg-config
sudo apt -y install wget make
wget http://www.fftw.org/fftw-3.3.9.tar.gz
tar -xvzof fftw-3.3.9.tar.gz
cd fftw-3.3.9
CC=gcc F77=gfortran CFLAGS="-O3 -fno-tree-vectorize -fexceptions" FFLAGS="-O3 -fno-tree-vectorize -fexceptions" ./configure --prefix=/usr/local --enable-threads --enable-shared --enable-static
sudo make
sudo make install
sudo vi /etc/ld.so.conf
sudo /sbin/ldconfig
```

### 検証
以下のコードを実行
```Fortarn
program sample
  implicit none
  include 'fftw3.f'

  write(*, *) FFTW_ESTIMATE

  stop
end program sample
```
`sample.f90`として保存
f95 sample.o -L/usr/local/lib -lfftw3
f95 -o sample  sample.o -L/usr/local/lib -lfftw3
./sample