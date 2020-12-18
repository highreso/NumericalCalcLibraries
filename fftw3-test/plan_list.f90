program plan_list
  implicit none
  include 'fftw3.f'

  integer, parameter :: N = 1024
  integer, parameter :: FLAGS = ior(FFTW_MEASURE, FFTW_DESTROY_INPUT)

  integer(8) :: plan
  real(8)    :: r_time(0:N-1), r_freq(0:N-1)
  complex(8) :: c_time(0:N-1), c_freq(0:N-1), cp_freq(0:N/2)

  ! complex <-> complex
  call dfftw_plan_dft_1d(plan, N, c_time, c_freq, FFTW_FORWARD , FLAGS)
  call dfftw_plan_dft_1d(plan, N, c_freq, c_time, FFTW_BACKWARD, FLAGS)
  !! (execute)
  call dfftw_execute_dft(plan, c_time, c_freq)

  ! real <-> complex(half)
  call dfftw_plan_dft_r2c_1d(plan, N, r_time , cp_freq, FLAGS)
  call dfftw_plan_dft_c2r_1d(plan, N, cp_freq, r_time , FLAGS)
  !! (execute)
  call dfftw_execute_dft_r2c(plan, r_time , cp_freq)
  call dfftw_execute_dft_c2r(plan, cp_freq, r_time )

  ! real <-> real
  !! real <-> half complex
  call dfftw_plan_r2r_1d(plan, N      , r_time, r_freq, FFTW_R2HC   , FLAGS)
  call dfftw_plan_r2r_1d(plan, N      , r_freq, r_time, FFTW_HC2R   , FLAGS)
  !! DCT I-IV and DST I-IV
  call dfftw_plan_r2r_1d(plan, 2*(N-1), r_time, r_freq, FFTW_REDFT00, FLAGS)
  call dfftw_plan_r2r_1d(plan, 2*N    , r_time, r_freq, FFTW_REDFT10, FLAGS)
  call dfftw_plan_r2r_1d(plan, 2*N    , r_time, r_freq, FFTW_REDFT01, FLAGS)
  call dfftw_plan_r2r_1d(plan, 2*N    , r_time, r_freq, FFTW_REDFT11, FLAGS)
  call dfftw_plan_r2r_1d(plan, 2*(N+1), r_time, r_freq, FFTW_RODFT00, FLAGS)
  call dfftw_plan_r2r_1d(plan, 2*N    , r_time, r_freq, FFTW_RODFT10, FLAGS)
  call dfftw_plan_r2r_1d(plan, 2*N    , r_time, r_freq, FFTW_RODFT01, FLAGS)
  call dfftw_plan_r2r_1d(plan, 2*N    , r_time, r_freq, FFTW_RODFT11, FLAGS)
  !! DHT
  call dfftw_plan_r2r_1d(plan, N      , r_time, r_freq, FFTW_DHT    , FLAGS)
  !! (execute)
  call dfftw_execute_r2r(plan, r_time, r_freq)

  ! (destroy)
  call dfftw_destroy_plan(plan)

  stop
end program