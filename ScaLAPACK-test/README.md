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

### ATLASの導入
http://aragorn.pb.bialystok.pl/~mars/tutorial/scalapack/

### BLASの導入
-> 代わりにOpenBLAS入れてみました
https://www.kkaneko.jp/tools/ubuntu/cblaslinux.html

上記の方法だとCコンパイル時にエラーが発生するので
```bash
sudo apt-get install libopenblas-dev
```
を実行したら正常に動作確認できた
