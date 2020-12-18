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