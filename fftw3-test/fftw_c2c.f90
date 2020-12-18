program fftw_c2c
  implicit none
  include 'fftw3.f'

  real(8), parameter :: PI = atan(1.0d0) * 4
  integer, parameter :: N = 16
  integer :: j, k

  integer(8) :: plan
  complex(8) :: in(0:N-1), out(0:N-1)

  ! 1. create a FFT plan first
  call dfftw_plan_dft_1d(plan, N, in, out, FFTW_FORWARD, FFTW_ESTIMATE)

  do j = 0, N-1
    in(j) = sin(2 * PI * j / N)
  end do

  ! 2. execute FFT (as many times as you want)
  call dfftw_execute_dft(plan, in, out)

  do k = 0, N/2
    write(*, *) k, k, out(k)
  end do
  do k = N/2+1, N-1
    write(*, *) k, k - N, out(k)
  end do
end program fftw_c2c