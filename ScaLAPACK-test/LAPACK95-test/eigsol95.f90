program eigsol95

! LAPACK95のコンパイル時にあわせて作成されたモジュールを使います。
  use f95_lapack

  implicit none

  integer, parameter :: N = 3
  integer :: i
  real(8) :: K(1:N,1:N), M(1:N,1:N), D(1:N)

  K(1:3,1) = (/  2.0d0, -1.0d0,  0.0d0 /)
  K(1:3,2) = (/ -1.0d0,  2.0d0, -1.0d0 /)
  K(1:3,3) = (/  0.0d0, -1.0d0,  1.0d0 /)

  write(*,'(A)') 'K ='
  write(*,'(3F12.4)') ( K(i,:), i=1,N )

  M(1:3,1) = (/  1.0d0,  0.0d0,  0.0d0 /)
  M(1:3,2) = (/  0.0d0,  1.0d0,  0.0d0 /)
  M(1:3,3) = (/  0.0d0,  0.0d0,  1.0d0 /)

  write(*,'(A)') 'M ='
  write(*,'(3F12.4)') ( M(i,:), i=1,N )

! LAPACK95（ラッパー）を介してLAPACKのルーチンを呼び出します。
! K(:,i)に i 番目の固有ベクトルが，D に固有値が昇順に格納されます。
! M には M を上三角行列にコレスキー分解した結果が格納されています。
! K や M を書き換えられたくない場合は注意しましょう。
  call LA_SYGV( K, M, D, 1,'V' )

! 固有ベクトルが必要ない場合は5番目の引き数を 'N' とします。
! もしくは4番目以降の引き数は省略してもかまいません。
! この場合にも K の対角要素を含む上三角要素は書き換えられており
! M には M を上三角行列にコレスキー分解した結果が格納されます。
! K や M を書き換えられたくない場合は注意しましょう。
! call LA_SYGV( K, M, D, 1, 'N' )
! or
! call LA_SYGV( K, M, D )

  write(*,'(A)') 'U ='
  write(*,'(3F12.4)') ( K(i,:), i=1,N )

  write(*,'(A)') 'D ='
  write(*,'(3F12.4)') D

end program eigsol95