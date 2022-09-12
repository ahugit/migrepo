MODULE nrtype
	INTEGER, PARAMETER :: I4B = SELECTED_INT_KIND(9)
	INTEGER, PARAMETER :: I2B = SELECTED_INT_KIND(4)
	INTEGER, PARAMETER :: I1B = SELECTED_INT_KIND(2)
	INTEGER, PARAMETER :: SP = KIND(1.0)
	INTEGER, PARAMETER :: DP = KIND(1.0D0)
	INTEGER, PARAMETER :: SPC = KIND((1.0,1.0))
	INTEGER, PARAMETER :: DPC = KIND((1.0D0,1.0D0))
	INTEGER, PARAMETER :: LGT = KIND(.true.)
	REAL(SP), PARAMETER :: PI=3.141592653589793238462643383279502884197_sp
	REAL(SP), PARAMETER :: PIO2=1.57079632679489661923132169163975144209858_sp
	REAL(SP), PARAMETER :: TWOPI=6.283185307179586476925286766559005768394_sp
	REAL(SP), PARAMETER :: SQRT2=1.41421356237309504880168872420969807856967_sp
	REAL(SP), PARAMETER :: EULER=0.5772156649015328606065120900824024310422_sp
	REAL(DP), PARAMETER :: PI_D=3.141592653589793238462643383279502884197_dp
	REAL(DP), PARAMETER :: PIO2_D=1.57079632679489661923132169163975144209858_dp
	REAL(DP), PARAMETER :: TWOPI_D=6.283185307179586476925286766559005768394_dp
	TYPE sprs2_sp
		INTEGER(I4B) :: n,len
		REAL(SP), DIMENSION(:), POINTER :: val
		INTEGER(I4B), DIMENSION(:), POINTER :: irow
		INTEGER(I4B), DIMENSION(:), POINTER :: jcol
	END TYPE sprs2_sp
	TYPE sprs2_dp
		INTEGER(I4B) :: n,len
		REAL(DP), DIMENSION(:), POINTER :: val
		INTEGER(I4B), DIMENSION(:), POINTER :: irow
		INTEGER(I4B), DIMENSION(:), POINTER :: jcol
	END TYPE sprs2_dp
END MODULE nrtype
MODULE nrutil
	USE nrtype
	IMPLICIT NONE
	INTEGER(I4B), PARAMETER :: NPAR_ARTH=16,NPAR2_ARTH=8
	INTEGER(I4B), PARAMETER :: NPAR_GEOP=4,NPAR2_GEOP=2
	INTEGER(I4B), PARAMETER :: NPAR_CUMSUM=16
	INTEGER(I4B), PARAMETER :: NPAR_CUMPROD=8
	INTEGER(I4B), PARAMETER :: NPAR_POLY=8
	INTEGER(I4B), PARAMETER :: NPAR_POLYTERM=8
	INTERFACE array_copy
		MODULE PROCEDURE array_copy_r, array_copy_d, array_copy_i
	END INTERFACE
	INTERFACE swap
		MODULE PROCEDURE swap_i,swap_r,swap_rv,swap_c, &
			swap_cv,swap_cm,swap_z,swap_zv,swap_zm, &
			masked_swap_rs,masked_swap_rv,masked_swap_rm
	END INTERFACE
	INTERFACE reallocate
		MODULE PROCEDURE reallocate_rv,reallocate_rm,&
			reallocate_iv,reallocate_im,reallocate_hv
	END INTERFACE
	INTERFACE imaxloc
		MODULE PROCEDURE imaxloc_r,imaxloc_i
	END INTERFACE
	INTERFACE assert
		MODULE PROCEDURE assert1,assert2,assert3,assert4,assert_v
	END INTERFACE
	INTERFACE assert_eq
		MODULE PROCEDURE assert_eq2,assert_eq3,assert_eq4,assert_eqn
	END INTERFACE
	INTERFACE arth
		MODULE PROCEDURE arth_r, arth_d, arth_i
	END INTERFACE
	INTERFACE geop
		MODULE PROCEDURE geop_r, geop_d, geop_i, geop_c, geop_dv
	END INTERFACE
	INTERFACE cumsum
		MODULE PROCEDURE cumsum_r,cumsum_i
	END INTERFACE
	INTERFACE poly
		MODULE PROCEDURE poly_rr,poly_rrv,poly_dd,poly_ddv,&
			poly_rc,poly_cc,poly_msk_rrv,poly_msk_ddv
	END INTERFACE
	INTERFACE poly_term
		MODULE PROCEDURE poly_term_rr,poly_term_cc
	END INTERFACE
	INTERFACE outerprod
		MODULE PROCEDURE outerprod_r,outerprod_d
	END INTERFACE
	INTERFACE outerdiff
		MODULE PROCEDURE outerdiff_r,outerdiff_d,outerdiff_i
	END INTERFACE
	INTERFACE scatter_add
		MODULE PROCEDURE scatter_add_r,scatter_add_d
	END INTERFACE
	INTERFACE scatter_max
		MODULE PROCEDURE scatter_max_r,scatter_max_d
	END INTERFACE
	INTERFACE diagadd
		MODULE PROCEDURE diagadd_rv,diagadd_r
	END INTERFACE
	INTERFACE diagmult
		MODULE PROCEDURE diagmult_rv,diagmult_r
	END INTERFACE
	INTERFACE get_diag
		MODULE PROCEDURE get_diag_rv, get_diag_dv
	END INTERFACE
	INTERFACE put_diag
		MODULE PROCEDURE put_diag_rv, put_diag_r
	END INTERFACE
CONTAINS
!BL
	SUBROUTINE array_copy_r(src,dest,n_copied,n_not_copied)
	REAL(SP), DIMENSION(:), INTENT(IN) :: src
	REAL(SP), DIMENSION(:), INTENT(OUT) :: dest
	INTEGER(I4B), INTENT(OUT) :: n_copied, n_not_copied
	n_copied=min(size(src),size(dest))
	n_not_copied=size(src)-n_copied
	dest(1:n_copied)=src(1:n_copied)
	END SUBROUTINE array_copy_r
!BL
	SUBROUTINE array_copy_d(src,dest,n_copied,n_not_copied)
	REAL(DP), DIMENSION(:), INTENT(IN) :: src
	REAL(DP), DIMENSION(:), INTENT(OUT) :: dest
	INTEGER(I4B), INTENT(OUT) :: n_copied, n_not_copied
	n_copied=min(size(src),size(dest))
	n_not_copied=size(src)-n_copied
	dest(1:n_copied)=src(1:n_copied)
	END SUBROUTINE array_copy_d
!BL
	SUBROUTINE array_copy_i(src,dest,n_copied,n_not_copied)
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: src
	INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: dest
	INTEGER(I4B), INTENT(OUT) :: n_copied, n_not_copied
	n_copied=min(size(src),size(dest))
	n_not_copied=size(src)-n_copied
	dest(1:n_copied)=src(1:n_copied)
	END SUBROUTINE array_copy_i
!BL
!BL
	SUBROUTINE swap_i(a,b)
	INTEGER(I4B), INTENT(INOUT) :: a,b
	INTEGER(I4B) :: dum
	dum=a
	a=b
	b=dum
	END SUBROUTINE swap_i
!BL
	SUBROUTINE swap_r(a,b)
	REAL(SP), INTENT(INOUT) :: a,b
	REAL(SP) :: dum
	dum=a
	a=b
	b=dum
	END SUBROUTINE swap_r
!BL
	SUBROUTINE swap_rv(a,b)
	REAL(SP), DIMENSION(:), INTENT(INOUT) :: a,b
	REAL(SP), DIMENSION(SIZE(a)) :: dum
	dum=a
	a=b
	b=dum
	END SUBROUTINE swap_rv
!BL
	SUBROUTINE swap_c(a,b)
	COMPLEX(SPC), INTENT(INOUT) :: a,b
	COMPLEX(SPC) :: dum
	dum=a
	a=b
	b=dum
	END SUBROUTINE swap_c
!BL
	SUBROUTINE swap_cv(a,b)
	COMPLEX(SPC), DIMENSION(:), INTENT(INOUT) :: a,b
	COMPLEX(SPC), DIMENSION(SIZE(a)) :: dum
	dum=a
	a=b
	b=dum
	END SUBROUTINE swap_cv
!BL
	SUBROUTINE swap_cm(a,b)
	COMPLEX(SPC), DIMENSION(:,:), INTENT(INOUT) :: a,b
	COMPLEX(SPC), DIMENSION(size(a,1),size(a,2)) :: dum
	dum=a
	a=b
	b=dum
	END SUBROUTINE swap_cm
!BL
	SUBROUTINE swap_z(a,b)
	COMPLEX(DPC), INTENT(INOUT) :: a,b
	COMPLEX(DPC) :: dum
	dum=a
	a=b
	b=dum
	END SUBROUTINE swap_z
!BL
	SUBROUTINE swap_zv(a,b)
	COMPLEX(DPC), DIMENSION(:), INTENT(INOUT) :: a,b
	COMPLEX(DPC), DIMENSION(SIZE(a)) :: dum
	dum=a
	a=b
	b=dum
	END SUBROUTINE swap_zv
!BL
	SUBROUTINE swap_zm(a,b)
	COMPLEX(DPC), DIMENSION(:,:), INTENT(INOUT) :: a,b
	COMPLEX(DPC), DIMENSION(size(a,1),size(a,2)) :: dum
	dum=a
	a=b
	b=dum
	END SUBROUTINE swap_zm
!BL
	SUBROUTINE masked_swap_rs(a,b,mask)
	REAL(SP), INTENT(INOUT) :: a,b
	LOGICAL(LGT), INTENT(IN) :: mask
	REAL(SP) :: swp
	if (mask) then
		swp=a
		a=b
		b=swp
	end if
	END SUBROUTINE masked_swap_rs
!BL
	SUBROUTINE masked_swap_rv(a,b,mask)
	REAL(SP), DIMENSION(:), INTENT(INOUT) :: a,b
	LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: mask
	REAL(SP), DIMENSION(size(a)) :: swp
	where (mask)
		swp=a
		a=b
		b=swp
	end where
	END SUBROUTINE masked_swap_rv
!BL
	SUBROUTINE masked_swap_rm(a,b,mask)
	REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a,b
	LOGICAL(LGT), DIMENSION(:,:), INTENT(IN) :: mask
	REAL(SP), DIMENSION(size(a,1),size(a,2)) :: swp
	where (mask)
		swp=a
		a=b
		b=swp
	end where
	END SUBROUTINE masked_swap_rm
!BL
!BL
	FUNCTION reallocate_rv(p,n)
	REAL(SP), DIMENSION(:), POINTER :: p, reallocate_rv
	INTEGER(I4B), INTENT(IN) :: n
	INTEGER(I4B) :: nold,ierr
	allocate(reallocate_rv(n),stat=ierr)
	if (ierr /= 0) call &
		nrerror('reallocate_rv: problem in attempt to allocate memory')
	if (.not. associated(p)) RETURN
	nold=size(p)
	reallocate_rv(1:min(nold,n))=p(1:min(nold,n))
	deallocate(p)
	END FUNCTION reallocate_rv
!BL
	FUNCTION reallocate_iv(p,n)
	INTEGER(I4B), DIMENSION(:), POINTER :: p, reallocate_iv
	INTEGER(I4B), INTENT(IN) :: n
	INTEGER(I4B) :: nold,ierr
	allocate(reallocate_iv(n),stat=ierr)
	if (ierr /= 0) call &
		nrerror('reallocate_iv: problem in attempt to allocate memory')
	if (.not. associated(p)) RETURN
	nold=size(p)
	reallocate_iv(1:min(nold,n))=p(1:min(nold,n))
	deallocate(p)
	END FUNCTION reallocate_iv
!BL
	FUNCTION reallocate_hv(p,n)
	CHARACTER(1), DIMENSION(:), POINTER :: p, reallocate_hv
	INTEGER(I4B), INTENT(IN) :: n
	INTEGER(I4B) :: nold,ierr
	allocate(reallocate_hv(n),stat=ierr)
	if (ierr /= 0) call &
		nrerror('reallocate_hv: problem in attempt to allocate memory')
	if (.not. associated(p)) RETURN
	nold=size(p)
	reallocate_hv(1:min(nold,n))=p(1:min(nold,n))
	deallocate(p)
	END FUNCTION reallocate_hv
!BL
	FUNCTION reallocate_rm(p,n,m)
	REAL(SP), DIMENSION(:,:), POINTER :: p, reallocate_rm
	INTEGER(I4B), INTENT(IN) :: n,m
	INTEGER(I4B) :: nold,mold,ierr
	allocate(reallocate_rm(n,m),stat=ierr)
	if (ierr /= 0) call &
		nrerror('reallocate_rm: problem in attempt to allocate memory')
	if (.not. associated(p)) RETURN
	nold=size(p,1)
	mold=size(p,2)
	reallocate_rm(1:min(nold,n),1:min(mold,m))=&
		p(1:min(nold,n),1:min(mold,m))
	deallocate(p)
	END FUNCTION reallocate_rm
!BL
	FUNCTION reallocate_im(p,n,m)
	INTEGER(I4B), DIMENSION(:,:), POINTER :: p, reallocate_im
	INTEGER(I4B), INTENT(IN) :: n,m
	INTEGER(I4B) :: nold,mold,ierr
	allocate(reallocate_im(n,m),stat=ierr)
	if (ierr /= 0) call &
		nrerror('reallocate_im: problem in attempt to allocate memory')
	if (.not. associated(p)) RETURN
	nold=size(p,1)
	mold=size(p,2)
	reallocate_im(1:min(nold,n),1:min(mold,m))=&
		p(1:min(nold,n),1:min(mold,m))
	deallocate(p)
	END FUNCTION reallocate_im
!BL
	FUNCTION ifirstloc(mask)
	LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: mask
	INTEGER(I4B) :: ifirstloc
	INTEGER(I4B), DIMENSION(1) :: loc
	loc=maxloc(merge(1,0,mask))
	ifirstloc=loc(1)
	if (.not. mask(ifirstloc)) ifirstloc=size(mask)+1
	END FUNCTION ifirstloc
!BL
	FUNCTION imaxloc_r(arr)
	REAL(SP), DIMENSION(:), INTENT(IN) :: arr
	INTEGER(I4B) :: imaxloc_r
	INTEGER(I4B), DIMENSION(1) :: imax
	imax=maxloc(arr(:))
	imaxloc_r=imax(1)
	END FUNCTION imaxloc_r
!BL
	FUNCTION imaxloc_i(iarr)
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: iarr
	INTEGER(I4B), DIMENSION(1) :: imax
	INTEGER(I4B) :: imaxloc_i
	imax=maxloc(iarr(:))
	imaxloc_i=imax(1)
	END FUNCTION imaxloc_i
!BL
	FUNCTION iminloc(arr)
	REAL(SP), DIMENSION(:), INTENT(IN) :: arr
	INTEGER(I4B), DIMENSION(1) :: imin
	INTEGER(I4B) :: iminloc
	imin=minloc(arr(:))
	iminloc=imin(1)
	END FUNCTION iminloc
!BL
	SUBROUTINE assert1(n1,string)
	CHARACTER(LEN=*), INTENT(IN) :: string
	LOGICAL, INTENT(IN) :: n1
	if (.not. n1) then
		write (*,*) 'nrerror: an assertion failed with this tag:', &
			string
		STOP 'program terminated by assert1'
	end if
	END SUBROUTINE assert1
!BL
	SUBROUTINE assert2(n1,n2,string)
	CHARACTER(LEN=*), INTENT(IN) :: string
	LOGICAL, INTENT(IN) :: n1,n2
	if (.not. (n1 .and. n2)) then
		write (*,*) 'nrerror: an assertion failed with this tag:', &
			string
		STOP 'program terminated by assert2'
	end if
	END SUBROUTINE assert2
!BL
	SUBROUTINE assert3(n1,n2,n3,string)
	CHARACTER(LEN=*), INTENT(IN) :: string
	LOGICAL, INTENT(IN) :: n1,n2,n3
	if (.not. (n1 .and. n2 .and. n3)) then
		write (*,*) 'nrerror: an assertion failed with this tag:', &
			string
		STOP 'program terminated by assert3'
	end if
	END SUBROUTINE assert3
!BL
	SUBROUTINE assert4(n1,n2,n3,n4,string)
	CHARACTER(LEN=*), INTENT(IN) :: string
	LOGICAL, INTENT(IN) :: n1,n2,n3,n4
	if (.not. (n1 .and. n2 .and. n3 .and. n4)) then
		write (*,*) 'nrerror: an assertion failed with this tag:', &
			string
		STOP 'program terminated by assert4'
	end if
	END SUBROUTINE assert4
!BL
	SUBROUTINE assert_v(n,string)
	CHARACTER(LEN=*), INTENT(IN) :: string
	LOGICAL, DIMENSION(:), INTENT(IN) :: n
	if (.not. all(n)) then
		write (*,*) 'nrerror: an assertion failed with this tag:', &
			string
		STOP 'program terminated by assert_v'
	end if
	END SUBROUTINE assert_v
!BL
	FUNCTION assert_eq2(n1,n2,string)
	CHARACTER(LEN=*), INTENT(IN) :: string
	INTEGER, INTENT(IN) :: n1,n2
	INTEGER :: assert_eq2
	if (n1 == n2) then
		assert_eq2=n1
	else
		write (*,*) 'nrerror: an assert_eq failed with this tag:', &
			string
		STOP 'program terminated by assert_eq2'
	end if
	END FUNCTION assert_eq2
!BL
	FUNCTION assert_eq3(n1,n2,n3,string)
	CHARACTER(LEN=*), INTENT(IN) :: string
	INTEGER, INTENT(IN) :: n1,n2,n3
	INTEGER :: assert_eq3
	if (n1 == n2 .and. n2 == n3) then
		assert_eq3=n1
	else
		write (*,*) 'nrerror: an assert_eq failed with this tag:', &
			string
		STOP 'program terminated by assert_eq3'
	end if
	END FUNCTION assert_eq3
!BL
	FUNCTION assert_eq4(n1,n2,n3,n4,string)
	CHARACTER(LEN=*), INTENT(IN) :: string
	INTEGER, INTENT(IN) :: n1,n2,n3,n4
	INTEGER :: assert_eq4
	if (n1 == n2 .and. n2 == n3 .and. n3 == n4) then
		assert_eq4=n1
	else
		write (*,*) 'nrerror: an assert_eq failed with this tag:', &
			string
		STOP 'program terminated by assert_eq4'
	end if
	END FUNCTION assert_eq4
!BL
	FUNCTION assert_eqn(nn,string)
	CHARACTER(LEN=*), INTENT(IN) :: string
	INTEGER, DIMENSION(:), INTENT(IN) :: nn
	INTEGER :: assert_eqn
	if (all(nn(2:) == nn(1))) then
		assert_eqn=nn(1)
	else
		write (*,*) 'nrerror: an assert_eq failed with this tag:', &
			string
		STOP 'program terminated by assert_eqn'
	end if
	END FUNCTION assert_eqn
!BL
	SUBROUTINE nrerror(string)
	CHARACTER(LEN=*), INTENT(IN) :: string
	write (*,*) 'nrerror: ',string
	STOP 'program terminated by nrerror'
	END SUBROUTINE nrerror
!BL
	FUNCTION arth_r(first,increment,n)
	REAL(SP), INTENT(IN) :: first,increment
	INTEGER(I4B), INTENT(IN) :: n
	REAL(SP), DIMENSION(n) :: arth_r
	INTEGER(I4B) :: k,k2
	REAL(SP) :: temp
	if (n > 0) arth_r(1)=first
	if (n <= NPAR_ARTH) then
		do k=2,n
			arth_r(k)=arth_r(k-1)+increment
		end do
	else
		do k=2,NPAR2_ARTH
			arth_r(k)=arth_r(k-1)+increment
		end do
		temp=increment*NPAR2_ARTH
		k=NPAR2_ARTH
		do
			if (k >= n) exit
			k2=k+k
			arth_r(k+1:min(k2,n))=temp+arth_r(1:min(k,n-k))
			temp=temp+temp
			k=k2
		end do
	end if
	END FUNCTION arth_r
!BL
	FUNCTION arth_d(first,increment,n)
	REAL(DP), INTENT(IN) :: first,increment
	INTEGER(I4B), INTENT(IN) :: n
	REAL(DP), DIMENSION(n) :: arth_d
	INTEGER(I4B) :: k,k2
	REAL(DP) :: temp
	if (n > 0) arth_d(1)=first
	if (n <= NPAR_ARTH) then
		do k=2,n
			arth_d(k)=arth_d(k-1)+increment
		end do
	else
		do k=2,NPAR2_ARTH
			arth_d(k)=arth_d(k-1)+increment
		end do
		temp=increment*NPAR2_ARTH
		k=NPAR2_ARTH
		do
			if (k >= n) exit
			k2=k+k
			arth_d(k+1:min(k2,n))=temp+arth_d(1:min(k,n-k))
			temp=temp+temp
			k=k2
		end do
	end if
	END FUNCTION arth_d
!BL
	FUNCTION arth_i(first,increment,n)
	INTEGER(I4B), INTENT(IN) :: first,increment,n
	INTEGER(I4B), DIMENSION(n) :: arth_i
	INTEGER(I4B) :: k,k2,temp
	if (n > 0) arth_i(1)=first
	if (n <= NPAR_ARTH) then
		do k=2,n
			arth_i(k)=arth_i(k-1)+increment
		end do
	else
		do k=2,NPAR2_ARTH
			arth_i(k)=arth_i(k-1)+increment
		end do
		temp=increment*NPAR2_ARTH
		k=NPAR2_ARTH
		do
			if (k >= n) exit
			k2=k+k
			arth_i(k+1:min(k2,n))=temp+arth_i(1:min(k,n-k))
			temp=temp+temp
			k=k2
		end do
	end if
	END FUNCTION arth_i
!BL
!BL
	FUNCTION geop_r(first,factor,n)
	REAL(SP), INTENT(IN) :: first,factor
	INTEGER(I4B), INTENT(IN) :: n
	REAL(SP), DIMENSION(n) :: geop_r
	INTEGER(I4B) :: k,k2
	REAL(SP) :: temp
	if (n > 0) geop_r(1)=first
	if (n <= NPAR_GEOP) then
		do k=2,n
			geop_r(k)=geop_r(k-1)*factor
		end do
	else
		do k=2,NPAR2_GEOP
			geop_r(k)=geop_r(k-1)*factor
		end do
		temp=factor**NPAR2_GEOP
		k=NPAR2_GEOP
		do
			if (k >= n) exit
			k2=k+k
			geop_r(k+1:min(k2,n))=temp*geop_r(1:min(k,n-k))
			temp=temp*temp
			k=k2
		end do
	end if
	END FUNCTION geop_r
!BL
	FUNCTION geop_d(first,factor,n)
	REAL(DP), INTENT(IN) :: first,factor
	INTEGER(I4B), INTENT(IN) :: n
	REAL(DP), DIMENSION(n) :: geop_d
	INTEGER(I4B) :: k,k2
	REAL(DP) :: temp
	if (n > 0) geop_d(1)=first
	if (n <= NPAR_GEOP) then
		do k=2,n
			geop_d(k)=geop_d(k-1)*factor
		end do
	else
		do k=2,NPAR2_GEOP
			geop_d(k)=geop_d(k-1)*factor
		end do
		temp=factor**NPAR2_GEOP
		k=NPAR2_GEOP
		do
			if (k >= n) exit
			k2=k+k
			geop_d(k+1:min(k2,n))=temp*geop_d(1:min(k,n-k))
			temp=temp*temp
			k=k2
		end do
	end if
	END FUNCTION geop_d
!BL
	FUNCTION geop_i(first,factor,n)
	INTEGER(I4B), INTENT(IN) :: first,factor,n
	INTEGER(I4B), DIMENSION(n) :: geop_i
	INTEGER(I4B) :: k,k2,temp
	if (n > 0) geop_i(1)=first
	if (n <= NPAR_GEOP) then
		do k=2,n
			geop_i(k)=geop_i(k-1)*factor
		end do
	else
		do k=2,NPAR2_GEOP
			geop_i(k)=geop_i(k-1)*factor
		end do
		temp=factor**NPAR2_GEOP
		k=NPAR2_GEOP
		do
			if (k >= n) exit
			k2=k+k
			geop_i(k+1:min(k2,n))=temp*geop_i(1:min(k,n-k))
			temp=temp*temp
			k=k2
		end do
	end if
	END FUNCTION geop_i
!BL
	FUNCTION geop_c(first,factor,n)
	COMPLEX(SP), INTENT(IN) :: first,factor
	INTEGER(I4B), INTENT(IN) :: n
	COMPLEX(SP), DIMENSION(n) :: geop_c
	INTEGER(I4B) :: k,k2
	COMPLEX(SP) :: temp
	if (n > 0) geop_c(1)=first
	if (n <= NPAR_GEOP) then
		do k=2,n
			geop_c(k)=geop_c(k-1)*factor
		end do
	else
		do k=2,NPAR2_GEOP
			geop_c(k)=geop_c(k-1)*factor
		end do
		temp=factor**NPAR2_GEOP
		k=NPAR2_GEOP
		do
			if (k >= n) exit
			k2=k+k
			geop_c(k+1:min(k2,n))=temp*geop_c(1:min(k,n-k))
			temp=temp*temp
			k=k2
		end do
	end if
	END FUNCTION geop_c
!BL
	FUNCTION geop_dv(first,factor,n)
	REAL(DP), DIMENSION(:), INTENT(IN) :: first,factor
	INTEGER(I4B), INTENT(IN) :: n
	REAL(DP), DIMENSION(size(first),n) :: geop_dv
	INTEGER(I4B) :: k,k2
	REAL(DP), DIMENSION(size(first)) :: temp
	if (n > 0) geop_dv(:,1)=first(:)
	if (n <= NPAR_GEOP) then
		do k=2,n
			geop_dv(:,k)=geop_dv(:,k-1)*factor(:)
		end do
	else
		do k=2,NPAR2_GEOP
			geop_dv(:,k)=geop_dv(:,k-1)*factor(:)
		end do
		temp=factor**NPAR2_GEOP
		k=NPAR2_GEOP
		do
			if (k >= n) exit
			k2=k+k
			geop_dv(:,k+1:min(k2,n))=geop_dv(:,1:min(k,n-k))*&
				spread(temp,2,size(geop_dv(:,1:min(k,n-k)),2))
			temp=temp*temp
			k=k2
		end do
	end if
	END FUNCTION geop_dv
!BL
!BL
	RECURSIVE FUNCTION cumsum_r(arr,seed) RESULT(ans)
	REAL(SP), DIMENSION(:), INTENT(IN) :: arr
	REAL(SP), OPTIONAL, INTENT(IN) :: seed
	REAL(SP), DIMENSION(size(arr)) :: ans
	INTEGER(I4B) :: n,j
	REAL(SP) :: sd
	n=size(arr)
	if (n == 0_i4b) RETURN
	sd=0.0_sp
	if (present(seed)) sd=seed
	ans(1)=arr(1)+sd
	if (n < NPAR_CUMSUM) then
		do j=2,n
			ans(j)=ans(j-1)+arr(j)
		end do
	else
		ans(2:n:2)=cumsum_r(arr(2:n:2)+arr(1:n-1:2),sd)
		ans(3:n:2)=ans(2:n-1:2)+arr(3:n:2)
	end if
	END FUNCTION cumsum_r
!BL
	RECURSIVE FUNCTION cumsum_i(arr,seed) RESULT(ans)
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: arr
	INTEGER(I4B), OPTIONAL, INTENT(IN) :: seed
	INTEGER(I4B), DIMENSION(size(arr)) :: ans
	INTEGER(I4B) :: n,j,sd
	n=size(arr)
	if (n == 0_i4b) RETURN
	sd=0_i4b
	if (present(seed)) sd=seed
	ans(1)=arr(1)+sd
	if (n < NPAR_CUMSUM) then
		do j=2,n
			ans(j)=ans(j-1)+arr(j)
		end do
	else
		ans(2:n:2)=cumsum_i(arr(2:n:2)+arr(1:n-1:2),sd)
		ans(3:n:2)=ans(2:n-1:2)+arr(3:n:2)
	end if
	END FUNCTION cumsum_i
!BL
!BL
	RECURSIVE FUNCTION cumprod(arr,seed) RESULT(ans)
	REAL(SP), DIMENSION(:), INTENT(IN) :: arr
	REAL(SP), OPTIONAL, INTENT(IN) :: seed
	REAL(SP), DIMENSION(size(arr)) :: ans
	INTEGER(I4B) :: n,j
	REAL(SP) :: sd
	n=size(arr)
	if (n == 0_i4b) RETURN
	sd=1.0_sp
	if (present(seed)) sd=seed
	ans(1)=arr(1)*sd
	if (n < NPAR_CUMPROD) then
		do j=2,n
			ans(j)=ans(j-1)*arr(j)
		end do
	else
		ans(2:n:2)=cumprod(arr(2:n:2)*arr(1:n-1:2),sd)
		ans(3:n:2)=ans(2:n-1:2)*arr(3:n:2)
	end if
	END FUNCTION cumprod
!BL
!BL
	FUNCTION poly_rr(x,coeffs)
	REAL(SP), INTENT(IN) :: x
	REAL(SP), DIMENSION(:), INTENT(IN) :: coeffs
	REAL(SP) :: poly_rr
	REAL(SP) :: pow
	REAL(SP), DIMENSION(:), ALLOCATABLE :: vec
	INTEGER(I4B) :: i,n,nn
	n=size(coeffs)
	if (n <= 0) then
		poly_rr=0.0_sp
	else if (n < NPAR_POLY) then
		poly_rr=coeffs(n)
		do i=n-1,1,-1
			poly_rr=x*poly_rr+coeffs(i)
		end do
	else
		allocate(vec(n+1))
		pow=x
		vec(1:n)=coeffs
		do
			vec(n+1)=0.0_sp
			nn=ishft(n+1,-1)
			vec(1:nn)=vec(1:n:2)+pow*vec(2:n+1:2)
			if (nn == 1) exit
			pow=pow*pow
			n=nn
		end do
		poly_rr=vec(1)
		deallocate(vec)
	end if
	END FUNCTION poly_rr
!BL
	FUNCTION poly_dd(x,coeffs)
	REAL(DP), INTENT(IN) :: x
	REAL(DP), DIMENSION(:), INTENT(IN) :: coeffs
	REAL(DP) :: poly_dd
	REAL(DP) :: pow
	REAL(DP), DIMENSION(:), ALLOCATABLE :: vec
	INTEGER(I4B) :: i,n,nn
	n=size(coeffs)
	if (n <= 0) then
		poly_dd=0.0_dp
	else if (n < NPAR_POLY) then
		poly_dd=coeffs(n)
		do i=n-1,1,-1
			poly_dd=x*poly_dd+coeffs(i)
		end do
	else
		allocate(vec(n+1))
		pow=x
		vec(1:n)=coeffs
		do
			vec(n+1)=0.0_dp
			nn=ishft(n+1,-1)
			vec(1:nn)=vec(1:n:2)+pow*vec(2:n+1:2)
			if (nn == 1) exit
			pow=pow*pow
			n=nn
		end do
		poly_dd=vec(1)
		deallocate(vec)
	end if
	END FUNCTION poly_dd
!BL
	FUNCTION poly_rc(x,coeffs)
	COMPLEX(SPC), INTENT(IN) :: x
	REAL(SP), DIMENSION(:), INTENT(IN) :: coeffs
	COMPLEX(SPC) :: poly_rc
	COMPLEX(SPC) :: pow
	COMPLEX(SPC), DIMENSION(:), ALLOCATABLE :: vec
	INTEGER(I4B) :: i,n,nn
	n=size(coeffs)
	if (n <= 0) then
		poly_rc=0.0_sp
	else if (n < NPAR_POLY) then
		poly_rc=coeffs(n)
		do i=n-1,1,-1
			poly_rc=x*poly_rc+coeffs(i)
		end do
	else
		allocate(vec(n+1))
		pow=x
		vec(1:n)=coeffs
		do
			vec(n+1)=0.0_sp
			nn=ishft(n+1,-1)
			vec(1:nn)=vec(1:n:2)+pow*vec(2:n+1:2)
			if (nn == 1) exit
			pow=pow*pow
			n=nn
		end do
		poly_rc=vec(1)
		deallocate(vec)
	end if
	END FUNCTION poly_rc
!BL
	FUNCTION poly_cc(x,coeffs)
	COMPLEX(SPC), INTENT(IN) :: x
	COMPLEX(SPC), DIMENSION(:), INTENT(IN) :: coeffs
	COMPLEX(SPC) :: poly_cc
	COMPLEX(SPC) :: pow
	COMPLEX(SPC), DIMENSION(:), ALLOCATABLE :: vec
	INTEGER(I4B) :: i,n,nn
	n=size(coeffs)
	if (n <= 0) then
		poly_cc=0.0_sp
	else if (n < NPAR_POLY) then
		poly_cc=coeffs(n)
		do i=n-1,1,-1
			poly_cc=x*poly_cc+coeffs(i)
		end do
	else
		allocate(vec(n+1))
		pow=x
		vec(1:n)=coeffs
		do
			vec(n+1)=0.0_sp
			nn=ishft(n+1,-1)
			vec(1:nn)=vec(1:n:2)+pow*vec(2:n+1:2)
			if (nn == 1) exit
			pow=pow*pow
			n=nn
		end do
		poly_cc=vec(1)
		deallocate(vec)
	end if
	END FUNCTION poly_cc
!BL
	FUNCTION poly_rrv(x,coeffs)
	REAL(SP), DIMENSION(:), INTENT(IN) :: coeffs,x
	REAL(SP), DIMENSION(size(x)) :: poly_rrv
	INTEGER(I4B) :: i,n,m
	m=size(coeffs)
	n=size(x)
	if (m <= 0) then
		poly_rrv=0.0_sp
	else if (m < n .or. m < NPAR_POLY) then
		poly_rrv=coeffs(m)
		do i=m-1,1,-1
			poly_rrv=x*poly_rrv+coeffs(i)
		end do
	else
		do i=1,n
			poly_rrv(i)=poly_rr(x(i),coeffs)
		end do
	end if
	END FUNCTION poly_rrv
!BL
	FUNCTION poly_ddv(x,coeffs)
	REAL(DP), DIMENSION(:), INTENT(IN) :: coeffs,x
	REAL(DP), DIMENSION(size(x)) :: poly_ddv
	INTEGER(I4B) :: i,n,m
	m=size(coeffs)
	n=size(x)
	if (m <= 0) then
		poly_ddv=0.0_dp
	else if (m < n .or. m < NPAR_POLY) then
		poly_ddv=coeffs(m)
		do i=m-1,1,-1
			poly_ddv=x*poly_ddv+coeffs(i)
		end do
	else
		do i=1,n
			poly_ddv(i)=poly_dd(x(i),coeffs)
		end do
	end if
	END FUNCTION poly_ddv
!BL
	FUNCTION poly_msk_rrv(x,coeffs,mask)
	REAL(SP), DIMENSION(:), INTENT(IN) :: coeffs,x
	LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: mask
	REAL(SP), DIMENSION(size(x)) :: poly_msk_rrv
	poly_msk_rrv=unpack(poly_rrv(pack(x,mask),coeffs),mask,0.0_sp)
	END FUNCTION poly_msk_rrv
!BL
	FUNCTION poly_msk_ddv(x,coeffs,mask)
	REAL(DP), DIMENSION(:), INTENT(IN) :: coeffs,x
	LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: mask
	REAL(DP), DIMENSION(size(x)) :: poly_msk_ddv
	poly_msk_ddv=unpack(poly_ddv(pack(x,mask),coeffs),mask,0.0_dp)
	END FUNCTION poly_msk_ddv
!BL
!BL
	RECURSIVE FUNCTION poly_term_rr(a,b) RESULT(u)
	REAL(SP), DIMENSION(:), INTENT(IN) :: a
	REAL(SP), INTENT(IN) :: b
	REAL(SP), DIMENSION(size(a)) :: u
	INTEGER(I4B) :: n,j
	n=size(a)
	if (n <= 0) RETURN
	u(1)=a(1)
	if (n < NPAR_POLYTERM) then
		do j=2,n
			u(j)=a(j)+b*u(j-1)
		end do
	else
		u(2:n:2)=poly_term_rr(a(2:n:2)+a(1:n-1:2)*b,b*b)
		u(3:n:2)=a(3:n:2)+b*u(2:n-1:2)
	end if
	END FUNCTION poly_term_rr
!BL
	RECURSIVE FUNCTION poly_term_cc(a,b) RESULT(u)
	COMPLEX(SPC), DIMENSION(:), INTENT(IN) :: a
	COMPLEX(SPC), INTENT(IN) :: b
	COMPLEX(SPC), DIMENSION(size(a)) :: u
	INTEGER(I4B) :: n,j
	n=size(a)
	if (n <= 0) RETURN
	u(1)=a(1)
	if (n < NPAR_POLYTERM) then
		do j=2,n
			u(j)=a(j)+b*u(j-1)
		end do
	else
		u(2:n:2)=poly_term_cc(a(2:n:2)+a(1:n-1:2)*b,b*b)
		u(3:n:2)=a(3:n:2)+b*u(2:n-1:2)
	end if
	END FUNCTION poly_term_cc
!BL
!BL
	FUNCTION zroots_unity(n,nn)
	INTEGER(I4B), INTENT(IN) :: n,nn
	COMPLEX(SPC), DIMENSION(nn) :: zroots_unity
	INTEGER(I4B) :: k
	REAL(SP) :: theta
	zroots_unity(1)=1.0
	theta=TWOPI/n
	k=1
	do
		if (k >= nn) exit
		zroots_unity(k+1)=cmplx(cos(k*theta),sin(k*theta),SPC)
		zroots_unity(k+2:min(2*k,nn))=zroots_unity(k+1)*&
			zroots_unity(2:min(k,nn-k))
		k=2*k
	end do
	END FUNCTION zroots_unity
!BL
	FUNCTION outerprod_r(a,b)
	REAL(SP), DIMENSION(:), INTENT(IN) :: a,b
	REAL(SP), DIMENSION(size(a),size(b)) :: outerprod_r
	outerprod_r = spread(a,dim=2,ncopies=size(b)) * &
		spread(b,dim=1,ncopies=size(a))
	END FUNCTION outerprod_r
!BL
	FUNCTION outerprod_d(a,b)
	REAL(DP), DIMENSION(:), INTENT(IN) :: a,b
	REAL(DP), DIMENSION(size(a),size(b)) :: outerprod_d
	outerprod_d = spread(a,dim=2,ncopies=size(b)) * &
		spread(b,dim=1,ncopies=size(a))
	END FUNCTION outerprod_d
!BL
	FUNCTION outerdiv(a,b)
	REAL(SP), DIMENSION(:), INTENT(IN) :: a,b
	REAL(SP), DIMENSION(size(a),size(b)) :: outerdiv
	outerdiv = spread(a,dim=2,ncopies=size(b)) / &
		spread(b,dim=1,ncopies=size(a))
	END FUNCTION outerdiv
!BL
	FUNCTION outersum(a,b)
	REAL(SP), DIMENSION(:), INTENT(IN) :: a,b
	REAL(SP), DIMENSION(size(a),size(b)) :: outersum
	outersum = spread(a,dim=2,ncopies=size(b)) + &
		spread(b,dim=1,ncopies=size(a))
	END FUNCTION outersum
!BL
	FUNCTION outerdiff_r(a,b)
	REAL(SP), DIMENSION(:), INTENT(IN) :: a,b
	REAL(SP), DIMENSION(size(a),size(b)) :: outerdiff_r
	outerdiff_r = spread(a,dim=2,ncopies=size(b)) - &
		spread(b,dim=1,ncopies=size(a))
	END FUNCTION outerdiff_r
!BL
	FUNCTION outerdiff_d(a,b)
	REAL(DP), DIMENSION(:), INTENT(IN) :: a,b
	REAL(DP), DIMENSION(size(a),size(b)) :: outerdiff_d
	outerdiff_d = spread(a,dim=2,ncopies=size(b)) - &
		spread(b,dim=1,ncopies=size(a))
	END FUNCTION outerdiff_d
!BL
	FUNCTION outerdiff_i(a,b)
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: a,b
	INTEGER(I4B), DIMENSION(size(a),size(b)) :: outerdiff_i
	outerdiff_i = spread(a,dim=2,ncopies=size(b)) - &
		spread(b,dim=1,ncopies=size(a))
	END FUNCTION outerdiff_i
!BL
	FUNCTION outerand(a,b)
	LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: a,b
	LOGICAL(LGT), DIMENSION(size(a),size(b)) :: outerand
	outerand = spread(a,dim=2,ncopies=size(b)) .and. &
		spread(b,dim=1,ncopies=size(a))
	END FUNCTION outerand
!BL
	SUBROUTINE scatter_add_r(dest,source,dest_index)
	REAL(SP), DIMENSION(:), INTENT(OUT) :: dest
	REAL(SP), DIMENSION(:), INTENT(IN) :: source
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: dest_index
	INTEGER(I4B) :: m,n,j,i
	n=assert_eq2(size(source),size(dest_index),'scatter_add_r')
	m=size(dest)
	do j=1,n
		i=dest_index(j)
		if (i > 0 .and. i <= m) dest(i)=dest(i)+source(j)
	end do
	END SUBROUTINE scatter_add_r
	SUBROUTINE scatter_add_d(dest,source,dest_index)
	REAL(DP), DIMENSION(:), INTENT(OUT) :: dest
	REAL(DP), DIMENSION(:), INTENT(IN) :: source
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: dest_index
	INTEGER(I4B) :: m,n,j,i
	n=assert_eq2(size(source),size(dest_index),'scatter_add_d')
	m=size(dest)
	do j=1,n
		i=dest_index(j)
		if (i > 0 .and. i <= m) dest(i)=dest(i)+source(j)
	end do
	END SUBROUTINE scatter_add_d
	SUBROUTINE scatter_max_r(dest,source,dest_index)
	REAL(SP), DIMENSION(:), INTENT(OUT) :: dest
	REAL(SP), DIMENSION(:), INTENT(IN) :: source
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: dest_index
	INTEGER(I4B) :: m,n,j,i
	n=assert_eq2(size(source),size(dest_index),'scatter_max_r')
	m=size(dest)
	do j=1,n
		i=dest_index(j)
		if (i > 0 .and. i <= m) dest(i)=max(dest(i),source(j))
	end do
	END SUBROUTINE scatter_max_r
	SUBROUTINE scatter_max_d(dest,source,dest_index)
	REAL(DP), DIMENSION(:), INTENT(OUT) :: dest
	REAL(DP), DIMENSION(:), INTENT(IN) :: source
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: dest_index
	INTEGER(I4B) :: m,n,j,i
	n=assert_eq2(size(source),size(dest_index),'scatter_max_d')
	m=size(dest)
	do j=1,n
		i=dest_index(j)
		if (i > 0 .and. i <= m) dest(i)=max(dest(i),source(j))
	end do
	END SUBROUTINE scatter_max_d
!BL
	SUBROUTINE diagadd_rv(mat,diag)
	REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: mat
	REAL(SP), DIMENSION(:), INTENT(IN) :: diag
	INTEGER(I4B) :: j,n
	n = assert_eq2(size(diag),min(size(mat,1),size(mat,2)),'diagadd_rv')
	do j=1,n
		mat(j,j)=mat(j,j)+diag(j)
	end do
	END SUBROUTINE diagadd_rv
!BL
	SUBROUTINE diagadd_r(mat,diag)
	REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: mat
	REAL(SP), INTENT(IN) :: diag
	INTEGER(I4B) :: j,n
	n = min(size(mat,1),size(mat,2))
	do j=1,n
		mat(j,j)=mat(j,j)+diag
	end do
	END SUBROUTINE diagadd_r
!BL
	SUBROUTINE diagmult_rv(mat,diag)
	REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: mat
	REAL(SP), DIMENSION(:), INTENT(IN) :: diag
	INTEGER(I4B) :: j,n
	n = assert_eq2(size(diag),min(size(mat,1),size(mat,2)),'diagmult_rv')
	do j=1,n
		mat(j,j)=mat(j,j)*diag(j)
	end do
	END SUBROUTINE diagmult_rv
!BL
	SUBROUTINE diagmult_r(mat,diag)
	REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: mat
	REAL(SP), INTENT(IN) :: diag
	INTEGER(I4B) :: j,n
	n = min(size(mat,1),size(mat,2))
	do j=1,n
		mat(j,j)=mat(j,j)*diag
	end do
	END SUBROUTINE diagmult_r
!BL
	FUNCTION get_diag_rv(mat)
	REAL(SP), DIMENSION(:,:), INTENT(IN) :: mat
	REAL(SP), DIMENSION(size(mat,1)) :: get_diag_rv
	INTEGER(I4B) :: j
	j=assert_eq2(size(mat,1),size(mat,2),'get_diag_rv')
	do j=1,size(mat,1)
		get_diag_rv(j)=mat(j,j)
	end do
	END FUNCTION get_diag_rv
!BL
	FUNCTION get_diag_dv(mat)
	REAL(DP), DIMENSION(:,:), INTENT(IN) :: mat
	REAL(DP), DIMENSION(size(mat,1)) :: get_diag_dv
	INTEGER(I4B) :: j
	j=assert_eq2(size(mat,1),size(mat,2),'get_diag_dv')
	do j=1,size(mat,1)
		get_diag_dv(j)=mat(j,j)
	end do
	END FUNCTION get_diag_dv
!BL
	SUBROUTINE put_diag_rv(diagv,mat)
	REAL(SP), DIMENSION(:), INTENT(IN) :: diagv
	REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: mat
	INTEGER(I4B) :: j,n
	n=assert_eq2(size(diagv),min(size(mat,1),size(mat,2)),'put_diag_rv')
	do j=1,n
		mat(j,j)=diagv(j)
	end do
	END SUBROUTINE put_diag_rv
!BL
	SUBROUTINE put_diag_r(scal,mat)
	REAL(SP), INTENT(IN) :: scal
	REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: mat
	INTEGER(I4B) :: j,n
	n = min(size(mat,1),size(mat,2))
	do j=1,n
		mat(j,j)=scal
	end do
	END SUBROUTINE put_diag_r
!BL
	SUBROUTINE unit_matrix(mat)
	REAL(SP), DIMENSION(:,:), INTENT(OUT) :: mat
	INTEGER(I4B) :: i,n
	n=min(size(mat,1),size(mat,2))
	mat(:,:)=0.0_sp
	do i=1,n
		mat(i,i)=1.0_sp
	end do
	END SUBROUTINE unit_matrix
!BL
	FUNCTION upper_triangle(j,k,extra)
	INTEGER(I4B), INTENT(IN) :: j,k
	INTEGER(I4B), OPTIONAL, INTENT(IN) :: extra
	LOGICAL(LGT), DIMENSION(j,k) :: upper_triangle
	INTEGER(I4B) :: n
	n=0
	if (present(extra)) n=extra
	upper_triangle=(outerdiff(arth_i(1,1,j),arth_i(1,1,k)) < n)
	END FUNCTION upper_triangle
!BL
	FUNCTION lower_triangle(j,k,extra)
	INTEGER(I4B), INTENT(IN) :: j,k
	INTEGER(I4B), OPTIONAL, INTENT(IN) :: extra
	LOGICAL(LGT), DIMENSION(j,k) :: lower_triangle
	INTEGER(I4B) :: n
	n=0
	if (present(extra)) n=extra
	lower_triangle=(outerdiff(arth_i(1,1,j),arth_i(1,1,k)) > -n)
	END FUNCTION lower_triangle
!BL
	FUNCTION vabs(v)
	REAL(SP), DIMENSION(:), INTENT(IN) :: v
	REAL(SP) :: vabs
	vabs=sqrt(dot_product(v,v))
	END FUNCTION vabs
!BL
END MODULE nrutil
MODULE nr
	INTERFACE
		SUBROUTINE airy(x,ai,bi,aip,bip)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP), INTENT(OUT) :: ai,bi,aip,bip
		END SUBROUTINE airy
	END INTERFACE
	INTERFACE
		SUBROUTINE amebsa(p,y,pb,yb,ftol,func,iter,temptr)
		USE nrtype
		INTEGER(I4B), INTENT(INOUT) :: iter
		REAL(SP), INTENT(INOUT) :: yb
		REAL(SP), INTENT(IN) :: ftol,temptr
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: y,pb
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: p
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE amebsa
	END INTERFACE
	INTERFACE
		SUBROUTINE amoeba(p,y,ftol,func,iter)
		USE nrtype
		INTEGER(I4B), INTENT(OUT) :: iter
		REAL(SP), INTENT(IN) :: ftol
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: y
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: p
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE amoeba
	END INTERFACE
	INTERFACE
		SUBROUTINE anneal(x,y,iorder)
		USE nrtype
		INTEGER(I4B), DIMENSION(:), INTENT(INOUT) :: iorder
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y
		END SUBROUTINE anneal
	END INTERFACE
	INTERFACE
		SUBROUTINE asolve(b,x,itrnsp)
		USE nrtype
		REAL(DP), DIMENSION(:), INTENT(IN) :: b
		REAL(DP), DIMENSION(:), INTENT(OUT) :: x
		INTEGER(I4B), INTENT(IN) :: itrnsp
		END SUBROUTINE asolve
	END INTERFACE
	INTERFACE
		SUBROUTINE atimes(x,r,itrnsp)
		USE nrtype
		REAL(DP), DIMENSION(:), INTENT(IN) :: x
		REAL(DP), DIMENSION(:), INTENT(OUT) :: r
		INTEGER(I4B), INTENT(IN) :: itrnsp
		END SUBROUTINE atimes
	END INTERFACE
	INTERFACE
		SUBROUTINE avevar(data,ave,var)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: data
		REAL(SP), INTENT(OUT) :: ave,var
		END SUBROUTINE avevar
	END INTERFACE
	INTERFACE
		SUBROUTINE balanc(a)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		END SUBROUTINE balanc
	END INTERFACE
	INTERFACE
		SUBROUTINE banbks(a,m1,m2,al,indx,b)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: m1,m2
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: indx
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: a,al
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: b
		END SUBROUTINE banbks
	END INTERFACE
	INTERFACE
		SUBROUTINE bandec(a,m1,m2,al,indx,d)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: m1,m2
		INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: indx
		REAL(SP), INTENT(OUT) :: d
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: al
		END SUBROUTINE bandec
	END INTERFACE
	INTERFACE
		SUBROUTINE banmul(a,m1,m2,x,b)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: m1,m2
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(:), INTENT(OUT) :: b
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: a
		END SUBROUTINE banmul
	END INTERFACE
	INTERFACE
		SUBROUTINE bcucof(y,y1,y2,y12,d1,d2,c)
		USE nrtype
		REAL(SP), INTENT(IN) :: d1,d2
		REAL(SP), DIMENSION(4), INTENT(IN) :: y,y1,y2,y12
		REAL(SP), DIMENSION(4,4), INTENT(OUT) :: c
		END SUBROUTINE bcucof
	END INTERFACE
	INTERFACE
		SUBROUTINE bcuint(y,y1,y2,y12,x1l,x1u,x2l,x2u,x1,x2,ansy,&
			ansy1,ansy2)
		USE nrtype
		REAL(SP), DIMENSION(4), INTENT(IN) :: y,y1,y2,y12
		REAL(SP), INTENT(IN) :: x1l,x1u,x2l,x2u,x1,x2
		REAL(SP), INTENT(OUT) :: ansy,ansy1,ansy2
		END SUBROUTINE bcuint
	END INTERFACE
	INTERFACE beschb
		SUBROUTINE beschb_s(x,gam1,gam2,gampl,gammi)
		USE nrtype
		REAL(DP), INTENT(IN) :: x
		REAL(DP), INTENT(OUT) :: gam1,gam2,gampl,gammi
		END SUBROUTINE beschb_s
!BL
		SUBROUTINE beschb_v(x,gam1,gam2,gampl,gammi)
		USE nrtype
		REAL(DP), DIMENSION(:), INTENT(IN) :: x
		REAL(DP), DIMENSION(:), INTENT(OUT) :: gam1,gam2,gampl,gammi
		END SUBROUTINE beschb_v
	END INTERFACE
	INTERFACE bessi
		FUNCTION bessi_s(n,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessi_s
		END FUNCTION bessi_s
!BL
		FUNCTION bessi_v(n,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessi_v
		END FUNCTION bessi_v
	END INTERFACE
	INTERFACE bessi0
		FUNCTION bessi0_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessi0_s
		END FUNCTION bessi0_s
!BL
		FUNCTION bessi0_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessi0_v
		END FUNCTION bessi0_v
	END INTERFACE
	INTERFACE bessi1
		FUNCTION bessi1_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessi1_s
		END FUNCTION bessi1_s
!BL
		FUNCTION bessi1_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessi1_v
		END FUNCTION bessi1_v
	END INTERFACE
	INTERFACE
		SUBROUTINE bessik(x,xnu,ri,rk,rip,rkp)
		USE nrtype
		REAL(SP), INTENT(IN) :: x,xnu
		REAL(SP), INTENT(OUT) :: ri,rk,rip,rkp
		END SUBROUTINE bessik
	END INTERFACE
	INTERFACE bessj
		FUNCTION bessj_s(n,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessj_s
		END FUNCTION bessj_s
!BL
		FUNCTION bessj_v(n,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessj_v
		END FUNCTION bessj_v
	END INTERFACE
	INTERFACE bessj0
		FUNCTION bessj0_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessj0_s
		END FUNCTION bessj0_s
!BL
		FUNCTION bessj0_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessj0_v
		END FUNCTION bessj0_v
	END INTERFACE
	INTERFACE bessj1
		FUNCTION bessj1_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessj1_s
		END FUNCTION bessj1_s
!BL
		FUNCTION bessj1_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessj1_v
		END FUNCTION bessj1_v
	END INTERFACE
	INTERFACE bessjy
		SUBROUTINE bessjy_s(x,xnu,rj,ry,rjp,ryp)
		USE nrtype
		REAL(SP), INTENT(IN) :: x,xnu
		REAL(SP), INTENT(OUT) :: rj,ry,rjp,ryp
		END SUBROUTINE bessjy_s
!BL
		SUBROUTINE bessjy_v(x,xnu,rj,ry,rjp,ryp)
		USE nrtype
		REAL(SP), INTENT(IN) :: xnu
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(:), INTENT(OUT) :: rj,rjp,ry,ryp
		END SUBROUTINE bessjy_v
	END INTERFACE
	INTERFACE bessk
		FUNCTION bessk_s(n,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessk_s
		END FUNCTION bessk_s
!BL
		FUNCTION bessk_v(n,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessk_v
		END FUNCTION bessk_v
	END INTERFACE
	INTERFACE bessk0
		FUNCTION bessk0_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessk0_s
		END FUNCTION bessk0_s
!BL
		FUNCTION bessk0_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessk0_v
		END FUNCTION bessk0_v
	END INTERFACE
	INTERFACE bessk1
		FUNCTION bessk1_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessk1_s
		END FUNCTION bessk1_s
!BL
		FUNCTION bessk1_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessk1_v
		END FUNCTION bessk1_v
	END INTERFACE
	INTERFACE bessy
		FUNCTION bessy_s(n,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessy_s
		END FUNCTION bessy_s
!BL
		FUNCTION bessy_v(n,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessy_v
		END FUNCTION bessy_v
	END INTERFACE
	INTERFACE bessy0
		FUNCTION bessy0_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessy0_s
		END FUNCTION bessy0_s
!BL
		FUNCTION bessy0_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessy0_v
		END FUNCTION bessy0_v
	END INTERFACE
	INTERFACE bessy1
		FUNCTION bessy1_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: bessy1_s
		END FUNCTION bessy1_s
!BL
		FUNCTION bessy1_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: bessy1_v
		END FUNCTION bessy1_v
	END INTERFACE
	INTERFACE beta
		FUNCTION beta_s(z,w)
		USE nrtype
		REAL(SP), INTENT(IN) :: z,w
		REAL(SP) :: beta_s
		END FUNCTION beta_s
!BL
		FUNCTION beta_v(z,w)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: z,w
		REAL(SP), DIMENSION(size(z)) :: beta_v
		END FUNCTION beta_v
	END INTERFACE
	INTERFACE betacf
		FUNCTION betacf_s(a,b,x)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b,x
		REAL(SP) :: betacf_s
		END FUNCTION betacf_s
!BL
		FUNCTION betacf_v(a,b,x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a,b,x
		REAL(SP), DIMENSION(size(x)) :: betacf_v
		END FUNCTION betacf_v
	END INTERFACE
	INTERFACE betai
		FUNCTION betai_s(a,b,x)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b,x
		REAL(SP) :: betai_s
		END FUNCTION betai_s
!BL
		FUNCTION betai_v(a,b,x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a,b,x
		REAL(SP), DIMENSION(size(a)) :: betai_v
		END FUNCTION betai_v
	END INTERFACE
	INTERFACE bico
		FUNCTION bico_s(n,k)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n,k
		REAL(SP) :: bico_s
		END FUNCTION bico_s
!BL
		FUNCTION bico_v(n,k)
		USE nrtype
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: n,k
		REAL(SP), DIMENSION(size(n)) :: bico_v
		END FUNCTION bico_v
	END INTERFACE
	INTERFACE
		FUNCTION bnldev(pp,n)
		USE nrtype
		REAL(SP), INTENT(IN) :: pp
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP) :: bnldev
		END FUNCTION bnldev
	END INTERFACE
	INTERFACE
		FUNCTION brent(ax,bx,cx,func,tol,xmin)
		USE nrtype
		REAL(SP), INTENT(IN) :: ax,bx,cx,tol
		REAL(SP), INTENT(OUT) :: xmin
		REAL(SP) :: brent
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION brent
	END INTERFACE
	INTERFACE
		SUBROUTINE broydn(x,check)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: x
		LOGICAL(LGT), INTENT(OUT) :: check
		END SUBROUTINE broydn
	END INTERFACE
	INTERFACE
		SUBROUTINE bsstep(y,dydx,x,htry,eps,yscal,hdid,hnext,derivs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: y
		REAL(SP), DIMENSION(:), INTENT(IN) :: dydx,yscal
		REAL(SP), INTENT(INOUT) :: x
		REAL(SP), INTENT(IN) :: htry,eps
		REAL(SP), INTENT(OUT) :: hdid,hnext
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
		END INTERFACE
		END SUBROUTINE bsstep
	END INTERFACE
	INTERFACE
		SUBROUTINE caldat(julian,mm,id,iyyy)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: julian
		INTEGER(I4B), INTENT(OUT) :: mm,id,iyyy
		END SUBROUTINE caldat
	END INTERFACE
	INTERFACE
		FUNCTION chder(a,b,c)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP), DIMENSION(:), INTENT(IN) :: c
		REAL(SP), DIMENSION(size(c)) :: chder
		END FUNCTION chder
	END INTERFACE
	INTERFACE chebev
		FUNCTION chebev_s(a,b,c,x)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b,x
		REAL(SP), DIMENSION(:), INTENT(IN) :: c
		REAL(SP) :: chebev_s
		END FUNCTION chebev_s
!BL
		FUNCTION chebev_v(a,b,c,x)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP), DIMENSION(:), INTENT(IN) :: c,x
		REAL(SP), DIMENSION(size(x)) :: chebev_v
		END FUNCTION chebev_v
	END INTERFACE
	INTERFACE
		FUNCTION chebft(a,b,n,func)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), DIMENSION(n) :: chebft
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION chebft
	END INTERFACE
	INTERFACE
		FUNCTION chebpc(c)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: c
		REAL(SP), DIMENSION(size(c)) :: chebpc
		END FUNCTION chebpc
	END INTERFACE
	INTERFACE
		FUNCTION chint(a,b,c)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP), DIMENSION(:), INTENT(IN) :: c
		REAL(SP), DIMENSION(size(c)) :: chint
		END FUNCTION chint
	END INTERFACE
	INTERFACE
		SUBROUTINE choldc(a,p)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		REAL(SP), DIMENSION(:), INTENT(OUT) :: p
		END SUBROUTINE choldc
	END INTERFACE
	INTERFACE
		SUBROUTINE cholsl(a,p,b,x)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: a
		REAL(SP), DIMENSION(:), INTENT(IN) :: p,b
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: x
		END SUBROUTINE cholsl
	END INTERFACE
	INTERFACE
		SUBROUTINE chsone(bins,ebins,knstrn,df,chsq,prob)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: knstrn
		REAL(SP), INTENT(OUT) :: df,chsq,prob
		REAL(SP), DIMENSION(:), INTENT(IN) :: bins,ebins
		END SUBROUTINE chsone
	END INTERFACE
	INTERFACE
		SUBROUTINE chstwo(bins1,bins2,knstrn,df,chsq,prob)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: knstrn
		REAL(SP), INTENT(OUT) :: df,chsq,prob
		REAL(SP), DIMENSION(:), INTENT(IN) :: bins1,bins2
		END SUBROUTINE chstwo
	END INTERFACE
	INTERFACE
		SUBROUTINE cisi(x,ci,si)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP), INTENT(OUT) :: ci,si
		END SUBROUTINE cisi
	END INTERFACE
	INTERFACE
		SUBROUTINE cntab1(nn,chisq,df,prob,cramrv,ccc)
		USE nrtype
		INTEGER(I4B), DIMENSION(:,:), INTENT(IN) :: nn
		REAL(SP), INTENT(OUT) :: chisq,df,prob,cramrv,ccc
		END SUBROUTINE cntab1
	END INTERFACE
	INTERFACE
		SUBROUTINE cntab2(nn,h,hx,hy,hygx,hxgy,uygx,uxgy,uxy)
		USE nrtype
		INTEGER(I4B), DIMENSION(:,:), INTENT(IN) :: nn
		REAL(SP), INTENT(OUT) :: h,hx,hy,hygx,hxgy,uygx,uxgy,uxy
		END SUBROUTINE cntab2
	END INTERFACE
	INTERFACE
		FUNCTION convlv(data,respns,isign)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: data
		REAL(SP), DIMENSION(:), INTENT(IN) :: respns
		INTEGER(I4B), INTENT(IN) :: isign
		REAL(SP), DIMENSION(size(data)) :: convlv
		END FUNCTION convlv
	END INTERFACE
	INTERFACE
		FUNCTION correl(data1,data2)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: data1,data2
		REAL(SP), DIMENSION(size(data1)) :: correl
		END FUNCTION correl
	END INTERFACE
	INTERFACE
		SUBROUTINE cosft1(y)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: y
		END SUBROUTINE cosft1
	END INTERFACE
	INTERFACE
		SUBROUTINE cosft2(y,isign)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: y
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE cosft2
	END INTERFACE
	INTERFACE
		SUBROUTINE covsrt(covar,maska)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: covar
		LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: maska
		END SUBROUTINE covsrt
	END INTERFACE
	INTERFACE
		SUBROUTINE cyclic(a,b,c,alpha,beta,r,x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN):: a,b,c,r
		REAL(SP), INTENT(IN) :: alpha,beta
		REAL(SP), DIMENSION(:), INTENT(OUT):: x
		END SUBROUTINE cyclic
	END INTERFACE
	INTERFACE
		SUBROUTINE daub4(a,isign)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: a
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE daub4
	END INTERFACE
	INTERFACE dawson
		FUNCTION dawson_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: dawson_s
		END FUNCTION dawson_s
!BL
		FUNCTION dawson_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: dawson_v
		END FUNCTION dawson_v
	END INTERFACE
	INTERFACE
		FUNCTION dbrent(ax,bx,cx,func,dbrent_dfunc,tol,xmin)
		USE nrtype
		REAL(SP), INTENT(IN) :: ax,bx,cx,tol
		REAL(SP), INTENT(OUT) :: xmin
		REAL(SP) :: dbrent
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
!BL
			FUNCTION dbrent_dfunc(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: dbrent_dfunc
			END FUNCTION dbrent_dfunc
		END INTERFACE
		END FUNCTION dbrent
	END INTERFACE
	INTERFACE
		SUBROUTINE ddpoly(c,x,pd)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP), DIMENSION(:), INTENT(IN) :: c
		REAL(SP), DIMENSION(:), INTENT(OUT) :: pd
		END SUBROUTINE ddpoly
	END INTERFACE
	INTERFACE
		FUNCTION decchk(string,ch)
		USE nrtype
		CHARACTER(1), DIMENSION(:), INTENT(IN) :: string
		CHARACTER(1), INTENT(OUT) :: ch
		LOGICAL(LGT) :: decchk
		END FUNCTION decchk
	END INTERFACE
	INTERFACE
		SUBROUTINE dfpmin(p,gtol,iter,fret,func,dfunc)
		USE nrtype
		INTEGER(I4B), INTENT(OUT) :: iter
		REAL(SP), INTENT(IN) :: gtol
		REAL(SP), INTENT(OUT) :: fret
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: p
		INTERFACE
			FUNCTION func(p)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: p
			REAL(SP) :: func
			END FUNCTION func
!BL
			FUNCTION dfunc(p)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: p
			REAL(SP), DIMENSION(size(p)) :: dfunc
			END FUNCTION dfunc
		END INTERFACE
		END SUBROUTINE dfpmin
	END INTERFACE
	INTERFACE
		FUNCTION dfridr(func,x,h,err)
		USE nrtype
		REAL(SP), INTENT(IN) :: x,h
		REAL(SP), INTENT(OUT) :: err
		REAL(SP) :: dfridr
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION dfridr
	END INTERFACE
	INTERFACE
		SUBROUTINE dftcor(w,delta,a,b,endpts,corre,corim,corfac)
		USE nrtype
		REAL(SP), INTENT(IN) :: w,delta,a,b
		REAL(SP), INTENT(OUT) :: corre,corim,corfac
		REAL(SP), DIMENSION(:), INTENT(IN) :: endpts
		END SUBROUTINE dftcor
	END INTERFACE
	INTERFACE
		SUBROUTINE dftint(func,a,b,w,cosint,sinint)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b,w
		REAL(SP), INTENT(OUT) :: cosint,sinint
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE dftint
	END INTERFACE
	INTERFACE
		SUBROUTINE difeq(k,k1,k2,jsf,is1,isf,indexv,s,y)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: is1,isf,jsf,k,k1,k2
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: indexv
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: s
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: y
		END SUBROUTINE difeq
	END INTERFACE
	INTERFACE
		FUNCTION eclass(lista,listb,n)
		USE nrtype
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: lista,listb
		INTEGER(I4B), INTENT(IN) :: n
		INTEGER(I4B), DIMENSION(n) :: eclass
		END FUNCTION eclass
	END INTERFACE
	INTERFACE
		FUNCTION eclazz(equiv,n)
		USE nrtype
		INTERFACE
			FUNCTION equiv(i,j)
			USE nrtype
			LOGICAL(LGT) :: equiv
			INTEGER(I4B), INTENT(IN) :: i,j
			END FUNCTION equiv
		END INTERFACE
		INTEGER(I4B), INTENT(IN) :: n
		INTEGER(I4B), DIMENSION(n) :: eclazz
		END FUNCTION eclazz
	END INTERFACE
	INTERFACE
		FUNCTION ei(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: ei
		END FUNCTION ei
	END INTERFACE
	INTERFACE
		SUBROUTINE eigsrt(d,v)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: d
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: v
		END SUBROUTINE eigsrt
	END INTERFACE
	INTERFACE elle
		FUNCTION elle_s(phi,ak)
		USE nrtype
		REAL(SP), INTENT(IN) :: phi,ak
		REAL(SP) :: elle_s
		END FUNCTION elle_s
!BL
		FUNCTION elle_v(phi,ak)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: phi,ak
		REAL(SP), DIMENSION(size(phi)) :: elle_v
		END FUNCTION elle_v
	END INTERFACE
	INTERFACE ellf
		FUNCTION ellf_s(phi,ak)
		USE nrtype
		REAL(SP), INTENT(IN) :: phi,ak
		REAL(SP) :: ellf_s
		END FUNCTION ellf_s
!BL
		FUNCTION ellf_v(phi,ak)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: phi,ak
		REAL(SP), DIMENSION(size(phi)) :: ellf_v
		END FUNCTION ellf_v
	END INTERFACE
	INTERFACE ellpi
		FUNCTION ellpi_s(phi,en,ak)
		USE nrtype
		REAL(SP), INTENT(IN) :: phi,en,ak
		REAL(SP) :: ellpi_s
		END FUNCTION ellpi_s
!BL
		FUNCTION ellpi_v(phi,en,ak)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: phi,en,ak
		REAL(SP), DIMENSION(size(phi)) :: ellpi_v
		END FUNCTION ellpi_v
	END INTERFACE
	INTERFACE
		SUBROUTINE elmhes(a)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		END SUBROUTINE elmhes
	END INTERFACE
	INTERFACE erf
		FUNCTION erf_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: erf_s
		END FUNCTION erf_s
!BL
		FUNCTION erf_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: erf_v
		END FUNCTION erf_v
	END INTERFACE
	INTERFACE erfc
		FUNCTION erfc_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: erfc_s
		END FUNCTION erfc_s
!BL
		FUNCTION erfc_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: erfc_v
		END FUNCTION erfc_v
	END INTERFACE
	INTERFACE erfcc
		FUNCTION erfcc_s(x)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: erfcc_s
		END FUNCTION erfcc_s
!BL
		FUNCTION erfcc_v(x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: erfcc_v
		END FUNCTION erfcc_v
	END INTERFACE
	INTERFACE
		SUBROUTINE eulsum(sum,term,jterm)
		USE nrtype
		REAL(SP), INTENT(INOUT) :: sum
		REAL(SP), INTENT(IN) :: term
		INTEGER(I4B), INTENT(IN) :: jterm
		END SUBROUTINE eulsum
	END INTERFACE
	INTERFACE
		FUNCTION evlmem(fdt,d,xms)
		USE nrtype
		REAL(SP), INTENT(IN) :: fdt,xms
		REAL(SP), DIMENSION(:), INTENT(IN) :: d
		REAL(SP) :: evlmem
		END FUNCTION evlmem
	END INTERFACE
	INTERFACE expdev
		SUBROUTINE expdev_s(harvest)
		USE nrtype
		REAL(SP), INTENT(OUT) :: harvest
		END SUBROUTINE expdev_s
!BL
		SUBROUTINE expdev_v(harvest)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(OUT) :: harvest
		END SUBROUTINE expdev_v
	END INTERFACE
	INTERFACE
		FUNCTION expint(n,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: expint
		END FUNCTION expint
	END INTERFACE
	INTERFACE factln
		FUNCTION factln_s(n)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP) :: factln_s
		END FUNCTION factln_s
!BL
		FUNCTION factln_v(n)
		USE nrtype
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: n
		REAL(SP), DIMENSION(size(n)) :: factln_v
		END FUNCTION factln_v
	END INTERFACE
	INTERFACE factrl
		FUNCTION factrl_s(n)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP) :: factrl_s
		END FUNCTION factrl_s
!BL
		FUNCTION factrl_v(n)
		USE nrtype
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: n
		REAL(SP), DIMENSION(size(n)) :: factrl_v
		END FUNCTION factrl_v
	END INTERFACE
	INTERFACE
		SUBROUTINE fasper(x,y,ofac,hifac,px,py,jmax,prob)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y
		REAL(SP), INTENT(IN) :: ofac,hifac
		INTEGER(I4B), INTENT(OUT) :: jmax
		REAL(SP), INTENT(OUT) :: prob
		REAL(SP), DIMENSION(:), POINTER :: px,py
		END SUBROUTINE fasper
	END INTERFACE
	INTERFACE
		SUBROUTINE fdjac(x,fvec,df)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: fvec
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: x
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: df
		END SUBROUTINE fdjac
	END INTERFACE
	INTERFACE
		SUBROUTINE fgauss(x,a,y,dyda)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,a
		REAL(SP), DIMENSION(:), INTENT(OUT) :: y
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: dyda
		END SUBROUTINE fgauss
	END INTERFACE
	INTERFACE
		SUBROUTINE fit(x,y,a,b,siga,sigb,chi2,q,sig)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y
		REAL(SP), INTENT(OUT) :: a,b,siga,sigb,chi2,q
		REAL(SP), DIMENSION(:), OPTIONAL, INTENT(IN) :: sig
		END SUBROUTINE fit
	END INTERFACE
	INTERFACE
		SUBROUTINE fitexy(x,y,sigx,sigy,a,b,siga,sigb,chi2,q)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y,sigx,sigy
		REAL(SP), INTENT(OUT) :: a,b,siga,sigb,chi2,q
		END SUBROUTINE fitexy
	END INTERFACE
	INTERFACE
		SUBROUTINE fixrts(d)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: d
		END SUBROUTINE fixrts
	END INTERFACE
	INTERFACE
		FUNCTION fleg(x,n)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), DIMENSION(n) :: fleg
		END FUNCTION fleg
	END INTERFACE
	INTERFACE
		SUBROUTINE flmoon(n,nph,jd,frac)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n,nph
		INTEGER(I4B), INTENT(OUT) :: jd
		REAL(SP), INTENT(OUT) :: frac
		END SUBROUTINE flmoon
	END INTERFACE
	INTERFACE four1
		SUBROUTINE four1_dp(data,isign)
		USE nrtype
		COMPLEX(DPC), DIMENSION(:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE four1_dp
!BL
		SUBROUTINE four1_sp(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE four1_sp
	END INTERFACE
	INTERFACE
		SUBROUTINE four1_alt(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE four1_alt
	END INTERFACE
	INTERFACE
		SUBROUTINE four1_gather(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE four1_gather
	END INTERFACE
	INTERFACE
		SUBROUTINE four2(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:,:), INTENT(INOUT) :: data
		INTEGER(I4B),INTENT(IN) :: isign
		END SUBROUTINE four2
	END INTERFACE
	INTERFACE
		SUBROUTINE four2_alt(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:,:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE four2_alt
	END INTERFACE
	INTERFACE
		SUBROUTINE four3(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:,:,:), INTENT(INOUT) :: data
		INTEGER(I4B),INTENT(IN) :: isign
		END SUBROUTINE four3
	END INTERFACE
	INTERFACE
		SUBROUTINE four3_alt(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:,:,:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE four3_alt
	END INTERFACE
	INTERFACE
		SUBROUTINE fourcol(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:,:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE fourcol
	END INTERFACE
	INTERFACE
		SUBROUTINE fourcol_3d(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:,:,:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE fourcol_3d
	END INTERFACE
	INTERFACE
		SUBROUTINE fourn_gather(data,nn,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:), INTENT(INOUT) :: data
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: nn
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE fourn_gather
	END INTERFACE
	INTERFACE fourrow
		SUBROUTINE fourrow_dp(data,isign)
		USE nrtype
		COMPLEX(DPC), DIMENSION(:,:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE fourrow_dp
!BL
		SUBROUTINE fourrow_sp(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:,:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE fourrow_sp
	END INTERFACE
	INTERFACE
		SUBROUTINE fourrow_3d(data,isign)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:,:,:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE fourrow_3d
	END INTERFACE
	INTERFACE
		FUNCTION fpoly(x,n)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), DIMENSION(n) :: fpoly
		END FUNCTION fpoly
	END INTERFACE
	INTERFACE
		SUBROUTINE fred2(a,b,t,f,w,g,ak)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP), DIMENSION(:), INTENT(OUT) :: t,f,w
		INTERFACE
			FUNCTION g(t)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: t
			REAL(SP), DIMENSION(size(t)) :: g
			END FUNCTION g
!BL
			FUNCTION ak(t,s)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: t,s
			REAL(SP), DIMENSION(size(t),size(s)) :: ak
			END FUNCTION ak
		END INTERFACE
		END SUBROUTINE fred2
	END INTERFACE
	INTERFACE
		FUNCTION fredin(x,a,b,t,f,w,g,ak)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,t,f,w
		REAL(SP), DIMENSION(size(x)) :: fredin
		INTERFACE
			FUNCTION g(t)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: t
			REAL(SP), DIMENSION(size(t)) :: g
			END FUNCTION g
!BL
			FUNCTION ak(t,s)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: t,s
			REAL(SP), DIMENSION(size(t),size(s)) :: ak
			END FUNCTION ak
		END INTERFACE
		END FUNCTION fredin
	END INTERFACE
	INTERFACE
		SUBROUTINE frenel(x,s,c)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP), INTENT(OUT) :: s,c
		END SUBROUTINE frenel
	END INTERFACE
	INTERFACE
		SUBROUTINE frprmn(p,ftol,iter,fret)
		USE nrtype
		INTEGER(I4B), INTENT(OUT) :: iter
		REAL(SP), INTENT(IN) :: ftol
		REAL(SP), INTENT(OUT) :: fret
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: p
		END SUBROUTINE frprmn
	END INTERFACE
	INTERFACE
		SUBROUTINE ftest(data1,data2,f,prob)
		USE nrtype
		REAL(SP), INTENT(OUT) :: f,prob
		REAL(SP), DIMENSION(:), INTENT(IN) :: data1,data2
		END SUBROUTINE ftest
	END INTERFACE
	INTERFACE
		FUNCTION gamdev(ia)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: ia
		REAL(SP) :: gamdev
		END FUNCTION gamdev
	END INTERFACE
	INTERFACE gammln
		FUNCTION gammln_s(xx)
		USE nrtype
		REAL(SP), INTENT(IN) :: xx
		REAL(SP) :: gammln_s
		END FUNCTION gammln_s
!BL
		FUNCTION gammln_v(xx)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: xx
		REAL(SP), DIMENSION(size(xx)) :: gammln_v
		END FUNCTION gammln_v
	END INTERFACE
	INTERFACE gammp
		FUNCTION gammp_s(a,x)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,x
		REAL(SP) :: gammp_s
		END FUNCTION gammp_s
!BL
		FUNCTION gammp_v(a,x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a,x
		REAL(SP), DIMENSION(size(a)) :: gammp_v
		END FUNCTION gammp_v
	END INTERFACE
	INTERFACE gammq
		FUNCTION gammq_s(a,x)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,x
		REAL(SP) :: gammq_s
		END FUNCTION gammq_s
!BL
		FUNCTION gammq_v(a,x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a,x
		REAL(SP), DIMENSION(size(a)) :: gammq_v
		END FUNCTION gammq_v
	END INTERFACE
	INTERFACE gasdev
		SUBROUTINE gasdev_s(harvest)
		USE nrtype
		REAL(SP), INTENT(OUT) :: harvest
		END SUBROUTINE gasdev_s
!BL
		SUBROUTINE gasdev_v(harvest)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(OUT) :: harvest
		END SUBROUTINE gasdev_v
	END INTERFACE
	INTERFACE
		SUBROUTINE gaucof(a,b,amu0,x,w)
		USE nrtype
		REAL(SP), INTENT(IN) :: amu0
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: a,b
		REAL(SP), DIMENSION(:), INTENT(OUT) :: x,w
		END SUBROUTINE gaucof
	END INTERFACE
	INTERFACE
		SUBROUTINE gauher(x,w)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(OUT) :: x,w
		END SUBROUTINE gauher
	END INTERFACE
	INTERFACE
		SUBROUTINE gaujac(x,w,alf,bet)
		USE nrtype
		REAL(SP), INTENT(IN) :: alf,bet
		REAL(SP), DIMENSION(:), INTENT(OUT) :: x,w
		END SUBROUTINE gaujac
	END INTERFACE
	INTERFACE
		SUBROUTINE gaulag(x,w,alf)
		USE nrtype
		REAL(SP), INTENT(IN) :: alf
		REAL(SP), DIMENSION(:), INTENT(OUT) :: x,w
		END SUBROUTINE gaulag
	END INTERFACE
	INTERFACE
		SUBROUTINE gauleg(x1,x2,x,w)
		USE nrtype
		REAL(SP), INTENT(IN) :: x1,x2
		REAL(SP), DIMENSION(:), INTENT(OUT) :: x,w
		END SUBROUTINE gauleg
	END INTERFACE
	INTERFACE
		SUBROUTINE gaussj(a,b)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a,b
		END SUBROUTINE gaussj
	END INTERFACE
	INTERFACE gcf
		FUNCTION gcf_s(a,x,gln)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,x
		REAL(SP), OPTIONAL, INTENT(OUT) :: gln
		REAL(SP) :: gcf_s
		END FUNCTION gcf_s
!BL
		FUNCTION gcf_v(a,x,gln)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a,x
		REAL(SP), DIMENSION(:), OPTIONAL, INTENT(OUT) :: gln
		REAL(SP), DIMENSION(size(a)) :: gcf_v
		END FUNCTION gcf_v
	END INTERFACE
	INTERFACE
		FUNCTION golden(ax,bx,cx,func,tol,xmin)
		USE nrtype
		REAL(SP), INTENT(IN) :: ax,bx,cx,tol
		REAL(SP), INTENT(OUT) :: xmin
		REAL(SP) :: golden
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION golden
	END INTERFACE
	INTERFACE gser
		FUNCTION gser_s(a,x,gln)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,x
		REAL(SP), OPTIONAL, INTENT(OUT) :: gln
		REAL(SP) :: gser_s
		END FUNCTION gser_s
!BL
		FUNCTION gser_v(a,x,gln)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a,x
		REAL(SP), DIMENSION(:), OPTIONAL, INTENT(OUT) :: gln
		REAL(SP), DIMENSION(size(a)) :: gser_v
		END FUNCTION gser_v
	END INTERFACE
	INTERFACE
		SUBROUTINE hqr(a,wr,wi)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(OUT) :: wr,wi
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		END SUBROUTINE hqr
	END INTERFACE
	INTERFACE
		SUBROUTINE hunt(xx,x,jlo)
		USE nrtype
		INTEGER(I4B), INTENT(INOUT) :: jlo
		REAL(SP), INTENT(IN) :: x
		REAL(SP), DIMENSION(:), INTENT(IN) :: xx
		END SUBROUTINE hunt
	END INTERFACE
	INTERFACE
		SUBROUTINE hypdrv(s,ry,rdyds)
		USE nrtype
		REAL(SP), INTENT(IN) :: s
		REAL(SP), DIMENSION(:), INTENT(IN) :: ry
		REAL(SP), DIMENSION(:), INTENT(OUT) :: rdyds
		END SUBROUTINE hypdrv
	END INTERFACE
	INTERFACE
		FUNCTION hypgeo(a,b,c,z)
		USE nrtype
		COMPLEX(SPC), INTENT(IN) :: a,b,c,z
		COMPLEX(SPC) :: hypgeo
		END FUNCTION hypgeo
	END INTERFACE
	INTERFACE
		SUBROUTINE hypser(a,b,c,z,series,deriv)
		USE nrtype
		COMPLEX(SPC), INTENT(IN) :: a,b,c,z
		COMPLEX(SPC), INTENT(OUT) :: series,deriv
		END SUBROUTINE hypser
	END INTERFACE
	INTERFACE
		FUNCTION icrc(crc,buf,jinit,jrev)
		USE nrtype
		CHARACTER(1), DIMENSION(:), INTENT(IN) :: buf
		INTEGER(I2B), INTENT(IN) :: crc,jinit
		INTEGER(I4B), INTENT(IN) :: jrev
		INTEGER(I2B) :: icrc
		END FUNCTION icrc
	END INTERFACE
	INTERFACE
		FUNCTION igray(n,is)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n,is
		INTEGER(I4B) :: igray
		END FUNCTION igray
	END INTERFACE
	INTERFACE
		RECURSIVE SUBROUTINE index_bypack(arr,index,partial)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: arr
		INTEGER(I4B), DIMENSION(:), INTENT(INOUT) :: index
		INTEGER, OPTIONAL, INTENT(IN) :: partial
		END SUBROUTINE index_bypack
	END INTERFACE
	INTERFACE indexx
		SUBROUTINE indexx_sp(arr,index)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: arr
		INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: index
		END SUBROUTINE indexx_sp
		SUBROUTINE indexx_i4b(iarr,index)
		USE nrtype
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: iarr
		INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: index
		END SUBROUTINE indexx_i4b
	END INTERFACE
	INTERFACE
		FUNCTION interp(uc)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(IN) :: uc
		REAL(DP), DIMENSION(2*size(uc,1)-1,2*size(uc,1)-1) :: interp
		END FUNCTION interp
	END INTERFACE
	INTERFACE
		FUNCTION rank(indx)
		USE nrtype
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: indx
		INTEGER(I4B), DIMENSION(size(indx)) :: rank
		END FUNCTION rank
	END INTERFACE
	INTERFACE
		FUNCTION irbit1(iseed)
		USE nrtype
		INTEGER(I4B), INTENT(INOUT) :: iseed
		INTEGER(I4B) :: irbit1
		END FUNCTION irbit1
	END INTERFACE
	INTERFACE
		FUNCTION irbit2(iseed)
		USE nrtype
		INTEGER(I4B), INTENT(INOUT) :: iseed
		INTEGER(I4B) :: irbit2
		END FUNCTION irbit2
	END INTERFACE
	INTERFACE
		SUBROUTINE jacobi(a,d,v,nrot)
		USE nrtype
		INTEGER(I4B), INTENT(OUT) :: nrot
		REAL(SP), DIMENSION(:), INTENT(OUT) :: d
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: v
		END SUBROUTINE jacobi
	END INTERFACE
	INTERFACE
		SUBROUTINE jacobn(x,y,dfdx,dfdy)
		USE nrtype
		REAL(SP), INTENT(IN) :: x
		REAL(SP), DIMENSION(:), INTENT(IN) :: y
		REAL(SP), DIMENSION(:), INTENT(OUT) :: dfdx
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: dfdy
		END SUBROUTINE jacobn
	END INTERFACE
	INTERFACE
		FUNCTION julday(mm,id,iyyy)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: mm,id,iyyy
		INTEGER(I4B) :: julday
		END FUNCTION julday
	END INTERFACE
	INTERFACE
		SUBROUTINE kendl1(data1,data2,tau,z,prob)
		USE nrtype
		REAL(SP), INTENT(OUT) :: tau,z,prob
		REAL(SP), DIMENSION(:), INTENT(IN) :: data1,data2
		END SUBROUTINE kendl1
	END INTERFACE
	INTERFACE
		SUBROUTINE kendl2(tab,tau,z,prob)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: tab
		REAL(SP), INTENT(OUT) :: tau,z,prob
		END SUBROUTINE kendl2
	END INTERFACE
	INTERFACE
		FUNCTION kermom(y,m)
		USE nrtype
		REAL(DP), INTENT(IN) :: y
		INTEGER(I4B), INTENT(IN) :: m
		REAL(DP), DIMENSION(m) :: kermom
		END FUNCTION kermom
	END INTERFACE
	INTERFACE
		SUBROUTINE ks2d1s(x1,y1,quadvl,d1,prob)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x1,y1
		REAL(SP), INTENT(OUT) :: d1,prob
		INTERFACE
			SUBROUTINE quadvl(x,y,fa,fb,fc,fd)
			USE nrtype
			REAL(SP), INTENT(IN) :: x,y
			REAL(SP), INTENT(OUT) :: fa,fb,fc,fd
			END SUBROUTINE quadvl
		END INTERFACE
		END SUBROUTINE ks2d1s
	END INTERFACE
	INTERFACE
		SUBROUTINE ks2d2s(x1,y1,x2,y2,d,prob)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x1,y1,x2,y2
		REAL(SP), INTENT(OUT) :: d,prob
		END SUBROUTINE ks2d2s
	END INTERFACE
	INTERFACE
		SUBROUTINE ksone(data,func,d,prob)
		USE nrtype
		REAL(SP), INTENT(OUT) :: d,prob
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: data
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE ksone
	END INTERFACE
	INTERFACE
		SUBROUTINE kstwo(data1,data2,d,prob)
		USE nrtype
		REAL(SP), INTENT(OUT) :: d,prob
		REAL(SP), DIMENSION(:), INTENT(IN) :: data1,data2
		END SUBROUTINE kstwo
	END INTERFACE
	INTERFACE
		SUBROUTINE laguer(a,x,its)
		USE nrtype
		INTEGER(I4B), INTENT(OUT) :: its
		COMPLEX(SPC), INTENT(INOUT) :: x
		COMPLEX(SPC), DIMENSION(:), INTENT(IN) :: a
		END SUBROUTINE laguer
	END INTERFACE
	INTERFACE
		SUBROUTINE lfit(x,y,sig,a,maska,covar,chisq,funcs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y,sig
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: a
		LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: maska
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: covar
		REAL(SP), INTENT(OUT) :: chisq
		INTERFACE
			SUBROUTINE funcs(x,arr)
			USE nrtype
			REAL(SP),INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(OUT) :: arr
			END SUBROUTINE funcs
		END INTERFACE
		END SUBROUTINE lfit
	END INTERFACE
	INTERFACE
		SUBROUTINE linbcg(b,x,itol,tol,itmax,iter,err)
		USE nrtype
		REAL(DP), DIMENSION(:), INTENT(IN) :: b
		REAL(DP), DIMENSION(:), INTENT(INOUT) :: x
		INTEGER(I4B), INTENT(IN) :: itol,itmax
		REAL(DP), INTENT(IN) :: tol
		INTEGER(I4B), INTENT(OUT) :: iter
		REAL(DP), INTENT(OUT) :: err
		END SUBROUTINE linbcg
	END INTERFACE
	INTERFACE
		SUBROUTINE linmin(p,xi,fret)
		USE nrtype
		REAL(SP), INTENT(OUT) :: fret
		REAL(SP), DIMENSION(:), TARGET, INTENT(INOUT) :: p,xi
		END SUBROUTINE linmin
	END INTERFACE
	INTERFACE
		SUBROUTINE lnsrch(xold,fold,g,p,x,f,stpmax,check,func)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: xold,g
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: p
		REAL(SP), INTENT(IN) :: fold,stpmax
		REAL(SP), DIMENSION(:), INTENT(OUT) :: x
		REAL(SP), INTENT(OUT) :: f
		LOGICAL(LGT), INTENT(OUT) :: check
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP) :: func
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE lnsrch
	END INTERFACE
	INTERFACE
		FUNCTION locate(xx,x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: xx
		REAL(SP), INTENT(IN) :: x
		INTEGER(I4B) :: locate
		END FUNCTION locate
	END INTERFACE
	INTERFACE
		FUNCTION lop(u)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(IN) :: u
		REAL(DP), DIMENSION(size(u,1),size(u,1)) :: lop
		END FUNCTION lop
	END INTERFACE
	INTERFACE
		SUBROUTINE lubksb(a,indx,b)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: a
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: indx
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: b
		END SUBROUTINE lubksb
	END INTERFACE
	INTERFACE
		SUBROUTINE ludcmp(a,indx,d)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: indx
		REAL(SP), INTENT(OUT) :: d
		END SUBROUTINE ludcmp
	END INTERFACE
	INTERFACE
		SUBROUTINE machar(ibeta,it,irnd,ngrd,machep,negep,iexp,minexp,&
			maxexp,eps,epsneg,xmin,xmax)
		USE nrtype
		INTEGER(I4B), INTENT(OUT) :: ibeta,iexp,irnd,it,machep,maxexp,&
			minexp,negep,ngrd
		REAL(SP), INTENT(OUT) :: eps,epsneg,xmax,xmin
		END SUBROUTINE machar
	END INTERFACE
	INTERFACE
		SUBROUTINE medfit(x,y,a,b,abdev)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y
		REAL(SP), INTENT(OUT) :: a,b,abdev
		END SUBROUTINE medfit
	END INTERFACE
	INTERFACE
		SUBROUTINE memcof(data,xms,d)
		USE nrtype
		REAL(SP), INTENT(OUT) :: xms
		REAL(SP), DIMENSION(:), INTENT(IN) :: data
		REAL(SP), DIMENSION(:), INTENT(OUT) :: d
		END SUBROUTINE memcof
	END INTERFACE
	INTERFACE
		SUBROUTINE mgfas(u,maxcyc)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(INOUT) :: u
		INTEGER(I4B), INTENT(IN) :: maxcyc
		END SUBROUTINE mgfas
	END INTERFACE
	INTERFACE
		SUBROUTINE mglin(u,ncycle)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(INOUT) :: u
		INTEGER(I4B), INTENT(IN) :: ncycle
		END SUBROUTINE mglin
	END INTERFACE
	INTERFACE
		SUBROUTINE midexp(funk,aa,bb,s,n)
		USE nrtype
		REAL(SP), INTENT(IN) :: aa,bb
		REAL(SP), INTENT(INOUT) :: s
		INTEGER(I4B), INTENT(IN) :: n
		INTERFACE
			FUNCTION funk(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: funk
			END FUNCTION funk
		END INTERFACE
		END SUBROUTINE midexp
	END INTERFACE
	INTERFACE
		SUBROUTINE midinf(funk,aa,bb,s,n)
		USE nrtype
		REAL(SP), INTENT(IN) :: aa,bb
		REAL(SP), INTENT(INOUT) :: s
		INTEGER(I4B), INTENT(IN) :: n
		INTERFACE
			FUNCTION funk(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: funk
			END FUNCTION funk
		END INTERFACE
		END SUBROUTINE midinf
	END INTERFACE
	INTERFACE
		SUBROUTINE midpnt(func,a,b,s,n)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP), INTENT(INOUT) :: s
		INTEGER(I4B), INTENT(IN) :: n
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE midpnt
	END INTERFACE
	INTERFACE
		SUBROUTINE midsql(funk,aa,bb,s,n)
		USE nrtype
		REAL(SP), INTENT(IN) :: aa,bb
		REAL(SP), INTENT(INOUT) :: s
		INTEGER(I4B), INTENT(IN) :: n
		INTERFACE
			FUNCTION funk(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: funk
			END FUNCTION funk
		END INTERFACE
		END SUBROUTINE midsql
	END INTERFACE
	INTERFACE
		SUBROUTINE midsqu(funk,aa,bb,s,n)
		USE nrtype
		REAL(SP), INTENT(IN) :: aa,bb
		REAL(SP), INTENT(INOUT) :: s
		INTEGER(I4B), INTENT(IN) :: n
		INTERFACE
			FUNCTION funk(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: funk
			END FUNCTION funk
		END INTERFACE
		END SUBROUTINE midsqu
	END INTERFACE
	INTERFACE
		RECURSIVE SUBROUTINE miser(func,regn,ndim,npts,dith,ave,var)
		USE nrtype
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP) :: func
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			END FUNCTION func
		END INTERFACE
		REAL(SP), DIMENSION(:), INTENT(IN) :: regn
		INTEGER(I4B), INTENT(IN) :: ndim,npts
		REAL(SP), INTENT(IN) :: dith
		REAL(SP), INTENT(OUT) :: ave,var
		END SUBROUTINE miser
	END INTERFACE
	INTERFACE
		SUBROUTINE mmid(y,dydx,xs,htot,nstep,yout,derivs)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: nstep
		REAL(SP), INTENT(IN) :: xs,htot
		REAL(SP), DIMENSION(:), INTENT(IN) :: y,dydx
		REAL(SP), DIMENSION(:), INTENT(OUT) :: yout
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
		END INTERFACE
		END SUBROUTINE mmid
	END INTERFACE
	INTERFACE
		SUBROUTINE mnbrak(ax,bx,cx,fa,fb,fc,func)
		USE nrtype
		REAL(SP), INTENT(INOUT) :: ax,bx
		REAL(SP), INTENT(OUT) :: cx,fa,fb,fc
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE mnbrak
	END INTERFACE
	INTERFACE
		SUBROUTINE mnewt(ntrial,x,tolx,tolf,usrfun)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: ntrial
		REAL(SP), INTENT(IN) :: tolx,tolf
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: x
		INTERFACE
			SUBROUTINE usrfun(x,fvec,fjac)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(OUT) :: fvec
			REAL(SP), DIMENSION(:,:), INTENT(OUT) :: fjac
			END SUBROUTINE usrfun
		END INTERFACE
		END SUBROUTINE mnewt
	END INTERFACE
	INTERFACE
		SUBROUTINE moment(data,ave,adev,sdev,var,skew,curt)
		USE nrtype
		REAL(SP), INTENT(OUT) :: ave,adev,sdev,var,skew,curt
		REAL(SP), DIMENSION(:), INTENT(IN) :: data
		END SUBROUTINE moment
	END INTERFACE
	INTERFACE
		SUBROUTINE mp2dfr(a,s,n,m)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		INTEGER(I4B), INTENT(OUT) :: m
		CHARACTER(1), DIMENSION(:), INTENT(INOUT) :: a
		CHARACTER(1), DIMENSION(:), INTENT(OUT) :: s
		END SUBROUTINE mp2dfr
	END INTERFACE
	INTERFACE
		SUBROUTINE mpdiv(q,r,u,v,n,m)
		USE nrtype
		CHARACTER(1), DIMENSION(:), INTENT(OUT) :: q,r
		CHARACTER(1), DIMENSION(:), INTENT(IN) :: u,v
		INTEGER(I4B), INTENT(IN) :: n,m
		END SUBROUTINE mpdiv
	END INTERFACE
	INTERFACE
		SUBROUTINE mpinv(u,v,n,m)
		USE nrtype
		CHARACTER(1), DIMENSION(:), INTENT(OUT) :: u
		CHARACTER(1), DIMENSION(:), INTENT(IN) :: v
		INTEGER(I4B), INTENT(IN) :: n,m
		END SUBROUTINE mpinv
	END INTERFACE
	INTERFACE
		SUBROUTINE mpmul(w,u,v,n,m)
		USE nrtype
		CHARACTER(1), DIMENSION(:), INTENT(IN) :: u,v
		CHARACTER(1), DIMENSION(:), INTENT(OUT) :: w
		INTEGER(I4B), INTENT(IN) :: n,m
		END SUBROUTINE mpmul
	END INTERFACE
	INTERFACE
		SUBROUTINE mppi(n)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		END SUBROUTINE mppi
	END INTERFACE
	INTERFACE
		SUBROUTINE mprove(a,alud,indx,b,x)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: a,alud
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: indx
		REAL(SP), DIMENSION(:), INTENT(IN) :: b
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: x
		END SUBROUTINE mprove
	END INTERFACE
	INTERFACE
		SUBROUTINE mpsqrt(w,u,v,n,m)
		USE nrtype
		CHARACTER(1), DIMENSION(:), INTENT(OUT) :: w,u
		CHARACTER(1), DIMENSION(:), INTENT(IN) :: v
		INTEGER(I4B), INTENT(IN) :: n,m
		END SUBROUTINE mpsqrt
	END INTERFACE
	INTERFACE
		SUBROUTINE mrqcof(x,y,sig,a,maska,alpha,beta,chisq,funcs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y,a,sig
		REAL(SP), DIMENSION(:), INTENT(OUT) :: beta
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: alpha
		REAL(SP), INTENT(OUT) :: chisq
		LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: maska
		INTERFACE
			SUBROUTINE funcs(x,a,yfit,dyda)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x,a
			REAL(SP), DIMENSION(:), INTENT(OUT) :: yfit
			REAL(SP), DIMENSION(:,:), INTENT(OUT) :: dyda
			END SUBROUTINE funcs
		END INTERFACE
		END SUBROUTINE mrqcof
	END INTERFACE
	INTERFACE
		SUBROUTINE mrqmin(x,y,sig,a,maska,covar,alpha,chisq,funcs,alamda)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y,sig
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: a
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: covar,alpha
		REAL(SP), INTENT(OUT) :: chisq
		REAL(SP), INTENT(INOUT) :: alamda
		LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: maska
		INTERFACE
			SUBROUTINE funcs(x,a,yfit,dyda)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x,a
			REAL(SP), DIMENSION(:), INTENT(OUT) :: yfit
			REAL(SP), DIMENSION(:,:), INTENT(OUT) :: dyda
			END SUBROUTINE funcs
		END INTERFACE
		END SUBROUTINE mrqmin
	END INTERFACE
	INTERFACE
		SUBROUTINE newt(x,check)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: x
		LOGICAL(LGT), INTENT(OUT) :: check
		END SUBROUTINE newt
	END INTERFACE
	INTERFACE
		SUBROUTINE odeint(ystart,x1,x2,eps,h1,hmin,derivs,rkqs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: ystart
		REAL(SP), INTENT(IN) :: x1,x2,eps,h1,hmin
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
!BL
			SUBROUTINE rkqs(y,dydx,x,htry,eps,yscal,hdid,hnext,derivs)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(INOUT) :: y
			REAL(SP), DIMENSION(:), INTENT(IN) :: dydx,yscal
			REAL(SP), INTENT(INOUT) :: x
			REAL(SP), INTENT(IN) :: htry,eps
			REAL(SP), INTENT(OUT) :: hdid,hnext
				INTERFACE
				SUBROUTINE derivs(x,y,dydx)
					USE nrtype
					REAL(SP), INTENT(IN) :: x
					REAL(SP), DIMENSION(:), INTENT(IN) :: y
					REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
					END SUBROUTINE derivs
				END INTERFACE
			END SUBROUTINE rkqs
		END INTERFACE
		END SUBROUTINE odeint
	END INTERFACE
	INTERFACE
		SUBROUTINE orthog(anu,alpha,beta,a,b)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: anu,alpha,beta
		REAL(SP), DIMENSION(:), INTENT(OUT) :: a,b
		END SUBROUTINE orthog
	END INTERFACE
	INTERFACE
		SUBROUTINE pade(cof,resid)
		USE nrtype
		REAL(DP), DIMENSION(:), INTENT(INOUT) :: cof
		REAL(SP), INTENT(OUT) :: resid
		END SUBROUTINE pade
	END INTERFACE
	INTERFACE
		FUNCTION pccheb(d)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: d
		REAL(SP), DIMENSION(size(d)) :: pccheb
		END FUNCTION pccheb
	END INTERFACE
	INTERFACE
		SUBROUTINE pcshft(a,b,d)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: d
		END SUBROUTINE pcshft
	END INTERFACE
	INTERFACE
		SUBROUTINE pearsn(x,y,r,prob,z)
		USE nrtype
		REAL(SP), INTENT(OUT) :: r,prob,z
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y
		END SUBROUTINE pearsn
	END INTERFACE
	INTERFACE
		SUBROUTINE period(x,y,ofac,hifac,px,py,jmax,prob)
		USE nrtype
		INTEGER(I4B), INTENT(OUT) :: jmax
		REAL(SP), INTENT(IN) :: ofac,hifac
		REAL(SP), INTENT(OUT) :: prob
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y
		REAL(SP), DIMENSION(:), POINTER :: px,py
		END SUBROUTINE period
	END INTERFACE
	INTERFACE plgndr
		FUNCTION plgndr_s(l,m,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: l,m
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: plgndr_s
		END FUNCTION plgndr_s
!BL
		FUNCTION plgndr_v(l,m,x)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: l,m
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(size(x)) :: plgndr_v
		END FUNCTION plgndr_v
	END INTERFACE
	INTERFACE
		FUNCTION poidev(xm)
		USE nrtype
		REAL(SP), INTENT(IN) :: xm
		REAL(SP) :: poidev
		END FUNCTION poidev
	END INTERFACE
	INTERFACE
		FUNCTION polcoe(x,y)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y
		REAL(SP), DIMENSION(size(x)) :: polcoe
		END FUNCTION polcoe
	END INTERFACE
	INTERFACE
		FUNCTION polcof(xa,ya)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: xa,ya
		REAL(SP), DIMENSION(size(xa)) :: polcof
		END FUNCTION polcof
	END INTERFACE
	INTERFACE
		SUBROUTINE poldiv(u,v,q,r)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: u,v
		REAL(SP), DIMENSION(:), INTENT(OUT) :: q,r
		END SUBROUTINE poldiv
	END INTERFACE
	INTERFACE
		SUBROUTINE polin2(x1a,x2a,ya,x1,x2,y,dy)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x1a,x2a
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: ya
		REAL(SP), INTENT(IN) :: x1,x2
		REAL(SP), INTENT(OUT) :: y,dy
		END SUBROUTINE polin2
	END INTERFACE
	INTERFACE
		SUBROUTINE polint(xa,ya,x,y,dy)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: xa,ya
		REAL(SP), INTENT(IN) :: x
		REAL(SP), INTENT(OUT) :: y,dy
		END SUBROUTINE polint
	END INTERFACE
	INTERFACE
		SUBROUTINE powell(p,xi,ftol,iter,fret)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: p
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: xi
		INTEGER(I4B), INTENT(OUT) :: iter
		REAL(SP), INTENT(IN) :: ftol
		REAL(SP), INTENT(OUT) :: fret
		END SUBROUTINE powell
	END INTERFACE
	INTERFACE
		FUNCTION predic(data,d,nfut)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: data,d
		INTEGER(I4B), INTENT(IN) :: nfut
		REAL(SP), DIMENSION(nfut) :: predic
		END FUNCTION predic
	END INTERFACE
	INTERFACE
		FUNCTION probks(alam)
		USE nrtype
		REAL(SP), INTENT(IN) :: alam
		REAL(SP) :: probks
		END FUNCTION probks
	END INTERFACE
	INTERFACE psdes
		SUBROUTINE psdes_s(lword,rword)
		USE nrtype
		INTEGER(I4B), INTENT(INOUT) :: lword,rword
		END SUBROUTINE psdes_s
!BL
		SUBROUTINE psdes_v(lword,rword)
		USE nrtype
		INTEGER(I4B), DIMENSION(:), INTENT(INOUT) :: lword,rword
		END SUBROUTINE psdes_v
	END INTERFACE
	INTERFACE
		SUBROUTINE pwt(a,isign)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: a
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE pwt
	END INTERFACE
	INTERFACE
		SUBROUTINE pwtset(n)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		END SUBROUTINE pwtset
	END INTERFACE
	INTERFACE pythag
		FUNCTION pythag_dp(a,b)
		USE nrtype
		REAL(DP), INTENT(IN) :: a,b
		REAL(DP) :: pythag_dp
		END FUNCTION pythag_dp
!BL
		FUNCTION pythag_sp(a,b)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP) :: pythag_sp
		END FUNCTION pythag_sp
	END INTERFACE
	INTERFACE
		SUBROUTINE pzextr(iest,xest,yest,yz,dy)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: iest
		REAL(SP), INTENT(IN) :: xest
		REAL(SP), DIMENSION(:), INTENT(IN) :: yest
		REAL(SP), DIMENSION(:), INTENT(OUT) :: yz,dy
		END SUBROUTINE pzextr
	END INTERFACE
	INTERFACE
		SUBROUTINE qrdcmp(a,c,d,sing)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		REAL(SP), DIMENSION(:), INTENT(OUT) :: c,d
		LOGICAL(LGT), INTENT(OUT) :: sing
		END SUBROUTINE qrdcmp
	END INTERFACE
	INTERFACE
		FUNCTION qromb(func,a,b)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP) :: qromb
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION qromb
	END INTERFACE
	INTERFACE
		FUNCTION qromo(func,a,b,choose)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP) :: qromo
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: func
			END FUNCTION func
		END INTERFACE
		INTERFACE
			SUBROUTINE choose(funk,aa,bb,s,n)
			USE nrtype
			REAL(SP), INTENT(IN) :: aa,bb
			REAL(SP), INTENT(INOUT) :: s
			INTEGER(I4B), INTENT(IN) :: n
			INTERFACE
				FUNCTION funk(x)
				USE nrtype
				REAL(SP), DIMENSION(:), INTENT(IN) :: x
				REAL(SP), DIMENSION(size(x)) :: funk
				END FUNCTION funk
			END INTERFACE
			END SUBROUTINE choose
		END INTERFACE
		END FUNCTION qromo
	END INTERFACE
	INTERFACE
		SUBROUTINE qroot(p,b,c,eps)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: p
		REAL(SP), INTENT(INOUT) :: b,c
		REAL(SP), INTENT(IN) :: eps
		END SUBROUTINE qroot
	END INTERFACE
	INTERFACE
		SUBROUTINE qrsolv(a,c,d,b)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: a
		REAL(SP), DIMENSION(:), INTENT(IN) :: c,d
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: b
		END SUBROUTINE qrsolv
	END INTERFACE
	INTERFACE
		SUBROUTINE qrupdt(r,qt,u,v)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: r,qt
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: u
		REAL(SP), DIMENSION(:), INTENT(IN) :: v
		END SUBROUTINE qrupdt
	END INTERFACE
	INTERFACE
		FUNCTION qsimp(func,a,b)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP) :: qsimp
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION qsimp
	END INTERFACE
	INTERFACE
		FUNCTION qtrap(func,a,b)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP) :: qtrap
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION qtrap
	END INTERFACE
	INTERFACE
		SUBROUTINE quadct(x,y,xx,yy,fa,fb,fc,fd)
		USE nrtype
		REAL(SP), INTENT(IN) :: x,y
		REAL(SP), DIMENSION(:), INTENT(IN) :: xx,yy
		REAL(SP), INTENT(OUT) :: fa,fb,fc,fd
		END SUBROUTINE quadct
	END INTERFACE
	INTERFACE
		SUBROUTINE quadmx(a)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: a
		END SUBROUTINE quadmx
	END INTERFACE
	INTERFACE
		SUBROUTINE quadvl(x,y,fa,fb,fc,fd)
		USE nrtype
		REAL(SP), INTENT(IN) :: x,y
		REAL(SP), INTENT(OUT) :: fa,fb,fc,fd
		END SUBROUTINE quadvl
	END INTERFACE
	INTERFACE
		FUNCTION ran(idum)
		INTEGER(selected_int_kind(9)), INTENT(INOUT) :: idum
		REAL :: ran
		END FUNCTION ran
	END INTERFACE
	INTERFACE ran0
		SUBROUTINE ran0_s(harvest)
		USE nrtype
		REAL(SP), INTENT(OUT) :: harvest
		END SUBROUTINE ran0_s
!BL
		SUBROUTINE ran0_v(harvest)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(OUT) :: harvest
		END SUBROUTINE ran0_v
	END INTERFACE
	INTERFACE ran1
		SUBROUTINE ran1_s(harvest)
		USE nrtype
		REAL(SP), INTENT(OUT) :: harvest
		END SUBROUTINE ran1_s
!BL
		SUBROUTINE ran1_v(harvest)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(OUT) :: harvest
		END SUBROUTINE ran1_v
	END INTERFACE
	INTERFACE ran2
		SUBROUTINE ran2_s(harvest)
		USE nrtype
		REAL(SP), INTENT(OUT) :: harvest
		END SUBROUTINE ran2_s
!BL
		SUBROUTINE ran2_v(harvest)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(OUT) :: harvest
		END SUBROUTINE ran2_v
	END INTERFACE
	INTERFACE ran3
		SUBROUTINE ran3_s(harvest)
		USE nrtype
		REAL(SP), INTENT(OUT) :: harvest
		END SUBROUTINE ran3_s
!BL
		SUBROUTINE ran3_v(harvest)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(OUT) :: harvest
		END SUBROUTINE ran3_v
	END INTERFACE
	INTERFACE
		SUBROUTINE ratint(xa,ya,x,y,dy)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: xa,ya
		REAL(SP), INTENT(IN) :: x
		REAL(SP), INTENT(OUT) :: y,dy
		END SUBROUTINE ratint
	END INTERFACE
	INTERFACE
		SUBROUTINE ratlsq(func,a,b,mm,kk,cof,dev)
		USE nrtype
		REAL(DP), INTENT(IN) :: a,b
		INTEGER(I4B), INTENT(IN) :: mm,kk
		REAL(DP), DIMENSION(:), INTENT(OUT) :: cof
		REAL(DP), INTENT(OUT) :: dev
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(DP), DIMENSION(:), INTENT(IN) :: x
			REAL(DP), DIMENSION(size(x)) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE ratlsq
	END INTERFACE
	INTERFACE ratval
		FUNCTION ratval_s(x,cof,mm,kk)
		USE nrtype
		REAL(DP), INTENT(IN) :: x
		INTEGER(I4B), INTENT(IN) :: mm,kk
		REAL(DP), DIMENSION(mm+kk+1), INTENT(IN) :: cof
		REAL(DP) :: ratval_s
		END FUNCTION ratval_s
!BL
		FUNCTION ratval_v(x,cof,mm,kk)
		USE nrtype
		REAL(DP), DIMENSION(:), INTENT(IN) :: x
		INTEGER(I4B), INTENT(IN) :: mm,kk
		REAL(DP), DIMENSION(mm+kk+1), INTENT(IN) :: cof
		REAL(DP), DIMENSION(size(x)) :: ratval_v
		END FUNCTION ratval_v
	END INTERFACE
	INTERFACE rc
		FUNCTION rc_s(x,y)
		USE nrtype
		REAL(SP), INTENT(IN) :: x,y
		REAL(SP) :: rc_s
		END FUNCTION rc_s
!BL
		FUNCTION rc_v(x,y)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y
		REAL(SP), DIMENSION(size(x)) :: rc_v
		END FUNCTION rc_v
	END INTERFACE
	INTERFACE rd
		FUNCTION rd_s(x,y,z)
		USE nrtype
		REAL(SP), INTENT(IN) :: x,y,z
		REAL(SP) :: rd_s
		END FUNCTION rd_s
!BL
		FUNCTION rd_v(x,y,z)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y,z
		REAL(SP), DIMENSION(size(x)) :: rd_v
		END FUNCTION rd_v
	END INTERFACE
	INTERFACE realft
		SUBROUTINE realft_dp(data,isign,zdata)
		USE nrtype
		REAL(DP), DIMENSION(:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		COMPLEX(DPC), DIMENSION(:), OPTIONAL, TARGET :: zdata
		END SUBROUTINE realft_dp
!BL
		SUBROUTINE realft_sp(data,isign,zdata)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: data
		INTEGER(I4B), INTENT(IN) :: isign
		COMPLEX(SPC), DIMENSION(:), OPTIONAL, TARGET :: zdata
		END SUBROUTINE realft_sp
	END INTERFACE
	INTERFACE
		RECURSIVE FUNCTION recur1(a,b) RESULT(u)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a,b
		REAL(SP), DIMENSION(size(a)) :: u
		END FUNCTION recur1
	END INTERFACE
	INTERFACE
		FUNCTION recur2(a,b,c)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a,b,c
		REAL(SP), DIMENSION(size(a)) :: recur2
		END FUNCTION recur2
	END INTERFACE
	INTERFACE
		SUBROUTINE relax(u,rhs)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(INOUT) :: u
		REAL(DP), DIMENSION(:,:), INTENT(IN) :: rhs
		END SUBROUTINE relax
	END INTERFACE
	INTERFACE
		SUBROUTINE relax2(u,rhs)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(INOUT) :: u
		REAL(DP), DIMENSION(:,:), INTENT(IN) :: rhs
		END SUBROUTINE relax2
	END INTERFACE
	INTERFACE
	FUNCTION resid(u,rhs)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(IN) :: u,rhs
		REAL(DP), DIMENSION(size(u,1),size(u,1)) :: resid
		END FUNCTION resid
	END INTERFACE
	INTERFACE rf
		FUNCTION rf_s(x,y,z)
		USE nrtype
		REAL(SP), INTENT(IN) :: x,y,z
		REAL(SP) :: rf_s
		END FUNCTION rf_s
!BL
		FUNCTION rf_v(x,y,z)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y,z
		REAL(SP), DIMENSION(size(x)) :: rf_v
		END FUNCTION rf_v
	END INTERFACE
	INTERFACE rj
		FUNCTION rj_s(x,y,z,p)
		USE nrtype
		REAL(SP), INTENT(IN) :: x,y,z,p
		REAL(SP) :: rj_s
		END FUNCTION rj_s
!BL
		FUNCTION rj_v(x,y,z,p)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y,z,p
		REAL(SP), DIMENSION(size(x)) :: rj_v
		END FUNCTION rj_v
	END INTERFACE
	INTERFACE
		SUBROUTINE rk4(y,dydx,x,h,yout,derivs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: y,dydx
		REAL(SP), INTENT(IN) :: x,h
		REAL(SP), DIMENSION(:), INTENT(OUT) :: yout
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
		END INTERFACE
		END SUBROUTINE rk4
	END INTERFACE
	INTERFACE
		SUBROUTINE rkck(y,dydx,x,h,yout,yerr,derivs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: y,dydx
		REAL(SP), INTENT(IN) :: x,h
		REAL(SP), DIMENSION(:), INTENT(OUT) :: yout,yerr
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
		END INTERFACE
		END SUBROUTINE rkck
	END INTERFACE
	INTERFACE
		SUBROUTINE rkdumb(vstart,x1,x2,nstep,derivs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: vstart
		REAL(SP), INTENT(IN) :: x1,x2
		INTEGER(I4B), INTENT(IN) :: nstep
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
		END INTERFACE
		END SUBROUTINE rkdumb
	END INTERFACE
	INTERFACE
		SUBROUTINE rkqs(y,dydx,x,htry,eps,yscal,hdid,hnext,derivs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: y
		REAL(SP), DIMENSION(:), INTENT(IN) :: dydx,yscal
		REAL(SP), INTENT(INOUT) :: x
		REAL(SP), INTENT(IN) :: htry,eps
		REAL(SP), INTENT(OUT) :: hdid,hnext
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
		END INTERFACE
		END SUBROUTINE rkqs
	END INTERFACE
	INTERFACE
		SUBROUTINE rlft2(data,spec,speq,isign)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: data
		COMPLEX(SPC), DIMENSION(:,:), INTENT(OUT) :: spec
		COMPLEX(SPC), DIMENSION(:), INTENT(OUT) :: speq
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE rlft2
	END INTERFACE
	INTERFACE
		SUBROUTINE rlft3(data,spec,speq,isign)
		USE nrtype
		REAL(SP), DIMENSION(:,:,:), INTENT(INOUT) :: data
		COMPLEX(SPC), DIMENSION(:,:,:), INTENT(OUT) :: spec
		COMPLEX(SPC), DIMENSION(:,:), INTENT(OUT) :: speq
		INTEGER(I4B), INTENT(IN) :: isign
		END SUBROUTINE rlft3
	END INTERFACE
	INTERFACE
		SUBROUTINE rotate(r,qt,i,a,b)
		USE nrtype
		REAL(SP), DIMENSION(:,:), TARGET, INTENT(INOUT) :: r,qt
		INTEGER(I4B), INTENT(IN) :: i
		REAL(SP), INTENT(IN) :: a,b
		END SUBROUTINE rotate
	END INTERFACE
	INTERFACE
		SUBROUTINE rsolv(a,d,b)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: a
		REAL(SP), DIMENSION(:), INTENT(IN) :: d
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: b
		END SUBROUTINE rsolv
	END INTERFACE
	INTERFACE
		FUNCTION rstrct(uf)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(IN) :: uf
		REAL(DP), DIMENSION((size(uf,1)+1)/2,(size(uf,1)+1)/2) :: rstrct
		END FUNCTION rstrct
	END INTERFACE
	INTERFACE
		FUNCTION rtbis(func,x1,x2,xacc)
		USE nrtype
		REAL(SP), INTENT(IN) :: x1,x2,xacc
		REAL(SP) :: rtbis
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION rtbis
	END INTERFACE
	INTERFACE
		FUNCTION rtflsp(func,x1,x2,xacc)
		USE nrtype
		REAL(SP), INTENT(IN) :: x1,x2,xacc
		REAL(SP) :: rtflsp
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION rtflsp
	END INTERFACE
	INTERFACE
		FUNCTION rtnewt(funcd,x1,x2,xacc)
		USE nrtype
		REAL(SP), INTENT(IN) :: x1,x2,xacc
		REAL(SP) :: rtnewt
		INTERFACE
			SUBROUTINE funcd(x,fval,fderiv)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), INTENT(OUT) :: fval,fderiv
			END SUBROUTINE funcd
		END INTERFACE
		END FUNCTION rtnewt
	END INTERFACE
	INTERFACE
		FUNCTION rtsafe(funcd,x1,x2,xacc)
		USE nrtype
		REAL(SP), INTENT(IN) :: x1,x2,xacc
		REAL(SP) :: rtsafe
		INTERFACE
			SUBROUTINE funcd(x,fval,fderiv)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), INTENT(OUT) :: fval,fderiv
			END SUBROUTINE funcd
		END INTERFACE
		END FUNCTION rtsafe
	END INTERFACE
	INTERFACE
		FUNCTION rtsec(func,x1,x2,xacc)
		USE nrtype
		REAL(SP), INTENT(IN) :: x1,x2,xacc
		REAL(SP) :: rtsec
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION rtsec
	END INTERFACE
	INTERFACE
		SUBROUTINE rzextr(iest,xest,yest,yz,dy)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: iest
		REAL(SP), INTENT(IN) :: xest
		REAL(SP), DIMENSION(:), INTENT(IN) :: yest
		REAL(SP), DIMENSION(:), INTENT(OUT) :: yz,dy
		END SUBROUTINE rzextr
	END INTERFACE
	INTERFACE
		FUNCTION savgol(nl,nrr,ld,m)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: nl,nrr,ld,m
		REAL(SP), DIMENSION(nl+nrr+1) :: savgol
		END FUNCTION savgol
	END INTERFACE
	INTERFACE
		SUBROUTINE scrsho(func)
		USE nrtype
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE scrsho
	END INTERFACE
	INTERFACE
		FUNCTION select(k,arr)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: k
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr
		REAL(SP) :: select
		END FUNCTION select
	END INTERFACE
	INTERFACE
		FUNCTION select_bypack(k,arr)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: k
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr
		REAL(SP) :: select_bypack
		END FUNCTION select_bypack
	END INTERFACE
	INTERFACE
		SUBROUTINE select_heap(arr,heap)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: arr
		REAL(SP), DIMENSION(:), INTENT(OUT) :: heap
		END SUBROUTINE select_heap
	END INTERFACE
	INTERFACE
		FUNCTION select_inplace(k,arr)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: k
		REAL(SP), DIMENSION(:), INTENT(IN) :: arr
		REAL(SP) :: select_inplace
		END FUNCTION select_inplace
	END INTERFACE
	INTERFACE
		SUBROUTINE simplx(a,m1,m2,m3,icase,izrov,iposv)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		INTEGER(I4B), INTENT(IN) :: m1,m2,m3
		INTEGER(I4B), INTENT(OUT) :: icase
		INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: izrov,iposv
		END SUBROUTINE simplx
	END INTERFACE
	INTERFACE
		SUBROUTINE simpr(y,dydx,dfdx,dfdy,xs,htot,nstep,yout,derivs)
		USE nrtype
		REAL(SP), INTENT(IN) :: xs,htot
		REAL(SP), DIMENSION(:), INTENT(IN) :: y,dydx,dfdx
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: dfdy
		INTEGER(I4B), INTENT(IN) :: nstep
		REAL(SP), DIMENSION(:), INTENT(OUT) :: yout
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
		END INTERFACE
		END SUBROUTINE simpr
	END INTERFACE
	INTERFACE
		SUBROUTINE sinft(y)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: y
		END SUBROUTINE sinft
	END INTERFACE
	INTERFACE
		SUBROUTINE slvsm2(u,rhs)
		USE nrtype
		REAL(DP), DIMENSION(3,3), INTENT(OUT) :: u
		REAL(DP), DIMENSION(3,3), INTENT(IN) :: rhs
		END SUBROUTINE slvsm2
	END INTERFACE
	INTERFACE
		SUBROUTINE slvsml(u,rhs)
		USE nrtype
		REAL(DP), DIMENSION(3,3), INTENT(OUT) :: u
		REAL(DP), DIMENSION(3,3), INTENT(IN) :: rhs
		END SUBROUTINE slvsml
	END INTERFACE
	INTERFACE
		SUBROUTINE sncndn(uu,emmc,sn,cn,dn)
		USE nrtype
		REAL(SP), INTENT(IN) :: uu,emmc
		REAL(SP), INTENT(OUT) :: sn,cn,dn
		END SUBROUTINE sncndn
	END INTERFACE
	INTERFACE
		FUNCTION snrm(sx,itol)
		USE nrtype
		REAL(DP), DIMENSION(:), INTENT(IN) :: sx
		INTEGER(I4B), INTENT(IN) :: itol
		REAL(DP) :: snrm
		END FUNCTION snrm
	END INTERFACE
	INTERFACE
		SUBROUTINE sobseq(x,init)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(OUT) :: x
		INTEGER(I4B), OPTIONAL, INTENT(IN) :: init
		END SUBROUTINE sobseq
	END INTERFACE
	INTERFACE
		SUBROUTINE solvde(itmax,conv,slowc,scalv,indexv,nb,y)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: itmax,nb
		REAL(SP), INTENT(IN) :: conv,slowc
		REAL(SP), DIMENSION(:), INTENT(IN) :: scalv
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: indexv
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: y
		END SUBROUTINE solvde
	END INTERFACE
	INTERFACE
		SUBROUTINE sor(a,b,c,d,e,f,u,rjac)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(IN) :: a,b,c,d,e,f
		REAL(DP), DIMENSION(:,:), INTENT(INOUT) :: u
		REAL(DP), INTENT(IN) :: rjac
		END SUBROUTINE sor
	END INTERFACE
	INTERFACE
		SUBROUTINE sort(arr)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr
		END SUBROUTINE sort
	END INTERFACE
	INTERFACE
		SUBROUTINE sort2(arr,slave)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr,slave
		END SUBROUTINE sort2
	END INTERFACE
	INTERFACE
		SUBROUTINE sort3(arr,slave1,slave2)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr,slave1,slave2
		END SUBROUTINE sort3
	END INTERFACE
	INTERFACE
		SUBROUTINE sort_bypack(arr)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr
		END SUBROUTINE sort_bypack
	END INTERFACE
	INTERFACE
		SUBROUTINE sort_byreshape(arr)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr
		END SUBROUTINE sort_byreshape
	END INTERFACE
	INTERFACE
		SUBROUTINE sort_heap(arr)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr
		END SUBROUTINE sort_heap
	END INTERFACE
	INTERFACE
		SUBROUTINE sort_pick(arr)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr
		END SUBROUTINE sort_pick
	END INTERFACE
	INTERFACE
		SUBROUTINE sort_radix(arr)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr
		END SUBROUTINE sort_radix
	END INTERFACE
	INTERFACE
		SUBROUTINE sort_shell(arr)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr
		END SUBROUTINE sort_shell
	END INTERFACE
	INTERFACE
		SUBROUTINE spctrm(p,k,ovrlap,unit,n_window)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(OUT) :: p
		INTEGER(I4B), INTENT(IN) :: k
		LOGICAL(LGT), INTENT(IN) :: ovrlap
		INTEGER(I4B), OPTIONAL, INTENT(IN) :: n_window,unit
		END SUBROUTINE spctrm
	END INTERFACE
	INTERFACE
		SUBROUTINE spear(data1,data2,d,zd,probd,rs,probrs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: data1,data2
		REAL(SP), INTENT(OUT) :: d,zd,probd,rs,probrs
		END SUBROUTINE spear
	END INTERFACE
	INTERFACE sphbes
		SUBROUTINE sphbes_s(n,x,sj,sy,sjp,syp)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), INTENT(IN) :: x
		REAL(SP), INTENT(OUT) :: sj,sy,sjp,syp
		END SUBROUTINE sphbes_s
!BL
		SUBROUTINE sphbes_v(n,x,sj,sy,sjp,syp)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), DIMENSION(:), INTENT(IN) :: x
		REAL(SP), DIMENSION(:), INTENT(OUT) :: sj,sy,sjp,syp
		END SUBROUTINE sphbes_v
	END INTERFACE
	INTERFACE
		SUBROUTINE splie2(x1a,x2a,ya,y2a)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x1a,x2a
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: ya
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: y2a
		END SUBROUTINE splie2
	END INTERFACE
	INTERFACE
		FUNCTION splin2(x1a,x2a,ya,y2a,x1,x2)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x1a,x2a
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: ya,y2a
		REAL(SP), INTENT(IN) :: x1,x2
		REAL(SP) :: splin2
		END FUNCTION splin2
	END INTERFACE
	INTERFACE
		SUBROUTINE spline(x,y,yp1,ypn,y2)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y
		REAL(SP), INTENT(IN) :: yp1,ypn
		REAL(SP), DIMENSION(:), INTENT(OUT) :: y2
		END SUBROUTINE spline
	END INTERFACE
	INTERFACE
		FUNCTION splint(xa,ya,y2a,x)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: xa,ya,y2a
		REAL(SP), INTENT(IN) :: x
		REAL(SP) :: splint
		END FUNCTION splint
	END INTERFACE
	INTERFACE sprsax
		SUBROUTINE sprsax_dp(sa,x,b)
		USE nrtype
		TYPE(sprs2_dp), INTENT(IN) :: sa
		REAL(DP), DIMENSION (:), INTENT(IN) :: x
		REAL(DP), DIMENSION (:), INTENT(OUT) :: b
		END SUBROUTINE sprsax_dp
!BL
		SUBROUTINE sprsax_sp(sa,x,b)
		USE nrtype
		TYPE(sprs2_sp), INTENT(IN) :: sa
		REAL(SP), DIMENSION (:), INTENT(IN) :: x
		REAL(SP), DIMENSION (:), INTENT(OUT) :: b
		END SUBROUTINE sprsax_sp
	END INTERFACE
	INTERFACE sprsdiag
		SUBROUTINE sprsdiag_dp(sa,b)
		USE nrtype
		TYPE(sprs2_dp), INTENT(IN) :: sa
		REAL(DP), DIMENSION(:), INTENT(OUT) :: b
		END SUBROUTINE sprsdiag_dp
!BL
		SUBROUTINE sprsdiag_sp(sa,b)
		USE nrtype
		TYPE(sprs2_sp), INTENT(IN) :: sa
		REAL(SP), DIMENSION(:), INTENT(OUT) :: b
		END SUBROUTINE sprsdiag_sp
	END INTERFACE
	INTERFACE sprsin
		SUBROUTINE sprsin_sp(a,thresh,sa)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: a
		REAL(SP), INTENT(IN) :: thresh
		TYPE(sprs2_sp), INTENT(OUT) :: sa
		END SUBROUTINE sprsin_sp
!BL
		SUBROUTINE sprsin_dp(a,thresh,sa)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(IN) :: a
		REAL(DP), INTENT(IN) :: thresh
		TYPE(sprs2_dp), INTENT(OUT) :: sa
		END SUBROUTINE sprsin_dp
	END INTERFACE
	INTERFACE
		SUBROUTINE sprstp(sa)
		USE nrtype
		TYPE(sprs2_sp), INTENT(INOUT) :: sa
		END SUBROUTINE sprstp
	END INTERFACE
	INTERFACE sprstx
		SUBROUTINE sprstx_dp(sa,x,b)
		USE nrtype
		TYPE(sprs2_dp), INTENT(IN) :: sa
		REAL(DP), DIMENSION (:), INTENT(IN) :: x
		REAL(DP), DIMENSION (:), INTENT(OUT) :: b
		END SUBROUTINE sprstx_dp
!BL
		SUBROUTINE sprstx_sp(sa,x,b)
		USE nrtype
		TYPE(sprs2_sp), INTENT(IN) :: sa
		REAL(SP), DIMENSION (:), INTENT(IN) :: x
		REAL(SP), DIMENSION (:), INTENT(OUT) :: b
		END SUBROUTINE sprstx_sp
	END INTERFACE
	INTERFACE
		SUBROUTINE stifbs(y,dydx,x,htry,eps,yscal,hdid,hnext,derivs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: y
		REAL(SP), DIMENSION(:), INTENT(IN) :: dydx,yscal
		REAL(SP), INTENT(IN) :: htry,eps
		REAL(SP), INTENT(INOUT) :: x
		REAL(SP), INTENT(OUT) :: hdid,hnext
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
		END INTERFACE
		END SUBROUTINE stifbs
	END INTERFACE
	INTERFACE
		SUBROUTINE stiff(y,dydx,x,htry,eps,yscal,hdid,hnext,derivs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: y
		REAL(SP), DIMENSION(:), INTENT(IN) :: dydx,yscal
		REAL(SP), INTENT(INOUT) :: x
		REAL(SP), INTENT(IN) :: htry,eps
		REAL(SP), INTENT(OUT) :: hdid,hnext
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
		END INTERFACE
		END SUBROUTINE stiff
	END INTERFACE
	INTERFACE
		SUBROUTINE stoerm(y,d2y,xs,htot,nstep,yout,derivs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: y,d2y
		REAL(SP), INTENT(IN) :: xs,htot
		INTEGER(I4B), INTENT(IN) :: nstep
		REAL(SP), DIMENSION(:), INTENT(OUT) :: yout
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP), DIMENSION(:), INTENT(IN) :: y
			REAL(SP), DIMENSION(:), INTENT(OUT) :: dydx
			END SUBROUTINE derivs
		END INTERFACE
		END SUBROUTINE stoerm
	END INTERFACE
	INTERFACE svbksb
		SUBROUTINE svbksb_dp(u,w,v,b,x)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(IN) :: u,v
		REAL(DP), DIMENSION(:), INTENT(IN) :: w,b
		REAL(DP), DIMENSION(:), INTENT(OUT) :: x
		END SUBROUTINE svbksb_dp
!BL
		SUBROUTINE svbksb_sp(u,w,v,b,x)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: u,v
		REAL(SP), DIMENSION(:), INTENT(IN) :: w,b
		REAL(SP), DIMENSION(:), INTENT(OUT) :: x
		END SUBROUTINE svbksb_sp
	END INTERFACE
	INTERFACE svdcmp
		SUBROUTINE svdcmp_dp(a,w,v)
		USE nrtype
		REAL(DP), DIMENSION(:,:), INTENT(INOUT) :: a
		REAL(DP), DIMENSION(:), INTENT(OUT) :: w
		REAL(DP), DIMENSION(:,:), INTENT(OUT) :: v
		END SUBROUTINE svdcmp_dp
!BL
		SUBROUTINE svdcmp_sp(a,w,v)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		REAL(SP), DIMENSION(:), INTENT(OUT) :: w
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: v
		END SUBROUTINE svdcmp_sp
	END INTERFACE
	INTERFACE
		SUBROUTINE svdfit(x,y,sig,a,v,w,chisq,funcs)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: x,y,sig
		REAL(SP), DIMENSION(:), INTENT(OUT) :: a,w
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: v
		REAL(SP), INTENT(OUT) :: chisq
		INTERFACE
			FUNCTION funcs(x,n)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			INTEGER(I4B), INTENT(IN) :: n
			REAL(SP), DIMENSION(n) :: funcs
			END FUNCTION funcs
		END INTERFACE
		END SUBROUTINE svdfit
	END INTERFACE
	INTERFACE
		SUBROUTINE svdvar(v,w,cvm)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(IN) :: v
		REAL(SP), DIMENSION(:), INTENT(IN) :: w
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: cvm
		END SUBROUTINE svdvar
	END INTERFACE
	INTERFACE
		FUNCTION toeplz(r,y)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: r,y
		REAL(SP), DIMENSION(size(y)) :: toeplz
		END FUNCTION toeplz
	END INTERFACE
	INTERFACE
		SUBROUTINE tptest(data1,data2,t,prob)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: data1,data2
		REAL(SP), INTENT(OUT) :: t,prob
		END SUBROUTINE tptest
	END INTERFACE
	INTERFACE
		SUBROUTINE tqli(d,e,z)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: d,e
		REAL(SP), DIMENSION(:,:), OPTIONAL, INTENT(INOUT) :: z
		END SUBROUTINE tqli
	END INTERFACE
	INTERFACE
		SUBROUTINE trapzd(func,a,b,s,n)
		USE nrtype
		REAL(SP), INTENT(IN) :: a,b
		REAL(SP), INTENT(INOUT) :: s
		INTEGER(I4B), INTENT(IN) :: n
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: x
			REAL(SP), DIMENSION(size(x)) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE trapzd
	END INTERFACE
	INTERFACE
		SUBROUTINE tred2(a,d,e,novectors)
		USE nrtype
		REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a
		REAL(SP), DIMENSION(:), INTENT(OUT) :: d,e
		LOGICAL(LGT), OPTIONAL, INTENT(IN) :: novectors
		END SUBROUTINE tred2
	END INTERFACE
!	On a purely serial machine, for greater efficiency, remove
!	the generic name tridag from the following interface,
!	and put it on the next one after that.
	INTERFACE
		RECURSIVE SUBROUTINE tridag_par(a,b,c,r,u)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a,b,c,r
		REAL(SP), DIMENSION(:), INTENT(OUT) :: u
		END SUBROUTINE tridag_par
	END INTERFACE
	INTERFACE
		SUBROUTINE tridag_ser(a,b,c,r,u)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a,b,c,r
		REAL(SP), DIMENSION(:), INTENT(OUT) :: u
		END SUBROUTINE tridag_ser
	END INTERFACE
	INTERFACE
		SUBROUTINE ttest(data1,data2,t,prob)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: data1,data2
		REAL(SP), INTENT(OUT) :: t,prob
		END SUBROUTINE ttest
	END INTERFACE
	INTERFACE
		SUBROUTINE tutest(data1,data2,t,prob)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: data1,data2
		REAL(SP), INTENT(OUT) :: t,prob
		END SUBROUTINE tutest
	END INTERFACE
	INTERFACE
		SUBROUTINE twofft(data1,data2,fft1,fft2)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: data1,data2
		COMPLEX(SPC), DIMENSION(:), INTENT(OUT) :: fft1,fft2
		END SUBROUTINE twofft
	END INTERFACE
	INTERFACE
		FUNCTION vander(x,q)
		USE nrtype
		REAL(DP), DIMENSION(:), INTENT(IN) :: x,q
		REAL(DP), DIMENSION(size(x)) :: vander
		END FUNCTION vander
	END INTERFACE
	INTERFACE
		SUBROUTINE vegas(region,func,init,ncall,itmx,nprn,tgral,sd,chi2a)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: region
		INTEGER(I4B), INTENT(IN) :: init,ncall,itmx,nprn
		REAL(SP), INTENT(OUT) :: tgral,sd,chi2a
		INTERFACE
			FUNCTION func(pt,wgt)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(IN) :: pt
			REAL(SP), INTENT(IN) :: wgt
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE vegas
	END INTERFACE
	INTERFACE
		SUBROUTINE voltra(t0,h,t,f,g,ak)
		USE nrtype
		REAL(SP), INTENT(IN) :: t0,h
		REAL(SP), DIMENSION(:), INTENT(OUT) :: t
		REAL(SP), DIMENSION(:,:), INTENT(OUT) :: f
		INTERFACE
			FUNCTION g(t)
			USE nrtype
			REAL(SP), INTENT(IN) :: t
			REAL(SP), DIMENSION(:), POINTER :: g
			END FUNCTION g
!BL
			FUNCTION ak(t,s)
			USE nrtype
			REAL(SP), INTENT(IN) :: t,s
			REAL(SP), DIMENSION(:,:), POINTER :: ak
			END FUNCTION ak
		END INTERFACE
		END SUBROUTINE voltra
	END INTERFACE
	INTERFACE
		SUBROUTINE wt1(a,isign,wtstep)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: a
		INTEGER(I4B), INTENT(IN) :: isign
		INTERFACE
			SUBROUTINE wtstep(a,isign)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(INOUT) :: a
			INTEGER(I4B), INTENT(IN) :: isign
			END SUBROUTINE wtstep
		END INTERFACE
		END SUBROUTINE wt1
	END INTERFACE
	INTERFACE
		SUBROUTINE wtn(a,nn,isign,wtstep)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(INOUT) :: a
		INTEGER(I4B), DIMENSION(:), INTENT(IN) :: nn
		INTEGER(I4B), INTENT(IN) :: isign
		INTERFACE
			SUBROUTINE wtstep(a,isign)
			USE nrtype
			REAL(SP), DIMENSION(:), INTENT(INOUT) :: a
			INTEGER(I4B), INTENT(IN) :: isign
			END SUBROUTINE wtstep
		END INTERFACE
		END SUBROUTINE wtn
	END INTERFACE
	INTERFACE
		FUNCTION wwghts(n,h,kermom)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		REAL(SP), INTENT(IN) :: h
		REAL(SP), DIMENSION(n) :: wwghts
		INTERFACE
			FUNCTION kermom(y,m)
			USE nrtype
			REAL(DP), INTENT(IN) :: y
			INTEGER(I4B), INTENT(IN) :: m
			REAL(DP), DIMENSION(m) :: kermom
			END FUNCTION kermom
		END INTERFACE
		END FUNCTION wwghts
	END INTERFACE
	INTERFACE
		SUBROUTINE zbrac(func,x1,x2,succes)
		USE nrtype
		REAL(SP), INTENT(INOUT) :: x1,x2
		LOGICAL(LGT), INTENT(OUT) :: succes
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE zbrac
	END INTERFACE
	INTERFACE
		SUBROUTINE zbrak(func,x1,x2,n,xb1,xb2,nb)
		USE nrtype
		INTEGER(I4B), INTENT(IN) :: n
		INTEGER(I4B), INTENT(OUT) :: nb
		REAL(SP), INTENT(IN) :: x1,x2
		REAL(SP), DIMENSION(:), POINTER :: xb1,xb2
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END SUBROUTINE zbrak
	END INTERFACE
	INTERFACE
		FUNCTION zbrent(func,x1,x2,tol)
		USE nrtype
		REAL(SP), INTENT(IN) :: x1,x2,tol
		REAL(SP) :: zbrent
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION zbrent
	END INTERFACE
	INTERFACE
		SUBROUTINE zrhqr(a,rtr,rti)
		USE nrtype
		REAL(SP), DIMENSION(:), INTENT(IN) :: a
		REAL(SP), DIMENSION(:), INTENT(OUT) :: rtr,rti
		END SUBROUTINE zrhqr
	END INTERFACE
	INTERFACE
		FUNCTION zriddr(func,x1,x2,xacc)
		USE nrtype
		REAL(SP), INTENT(IN) :: x1,x2,xacc
		REAL(SP) :: zriddr
		INTERFACE
			FUNCTION func(x)
			USE nrtype
			REAL(SP), INTENT(IN) :: x
			REAL(SP) :: func
			END FUNCTION func
		END INTERFACE
		END FUNCTION zriddr
	END INTERFACE
	INTERFACE
		SUBROUTINE zroots(a,roots,polish)
		USE nrtype
		COMPLEX(SPC), DIMENSION(:), INTENT(IN) :: a
		COMPLEX(SPC), DIMENSION(:), INTENT(OUT) :: roots
		LOGICAL(LGT), INTENT(IN) :: polish
		END SUBROUTINE zroots
	END INTERFACE
END MODULE nr
MODULE pNelder_Mead
!ahu 010417: TOOK THIS FROM COHABITC/CLUSTER 040615. ONLY CHANGE FOR NOW WILL BE THE INCLUDE MPIF.H AND UNCOMMENTING OUT USE GLOBAL. 
!AND ALSO SOME CHANGED AT THE BEGINNING ABOUT HOW REALRANK IS OBTAINED (WAS EQUATING TO MYID BEFORE WHICH REQUIRED THE USE OF GLOBAL. 
!BUT NOW UNCOMMENTED OUT THE CALL MPI AT THE BEGINNING AND I OBTAIN REALRANK THAT WAY). 
use nrtype, only: dp
!use global  !, only: myid
!use mpi

IMPLICIT NONE
INCLUDE 'mpif.h'
!ahu f14 putting this in the subroutine so that it does not clash with nrtype INTEGER, PARAMETER :: dp = SELECTED_REAL_KIND(12, 60)
PRIVATE
PUBLIC :: pminim

CONTAINS


SUBROUTINE pminim(p, step, nop, func, maxfn, iprint, stopcr, nloop, iquad,  &
                 simp, var, functn, functn2, ifault, myrank,nprocs,T0, Tstep, Tfreq, randseed)
!     A PROGRAM FOR FUNCTION MINIMIZATION USING THE SIMPLEX METHOD.

!     FOR DETAILS, SEE NELDER & MEAD, THE COMPUTER JOURNAL, JANUARY 1965

!     PROGRAMMED BY D.E.SHAW,
!     CSIRO, DIVISION OF MATHEMATICS & STATISTICS
!     P.O. BOX 218, LINDFIELD, N.S.W. 2070

!     WITH AMENDMENTS BY R.W.M.WEDDERBURN
!     ROTHAMSTED EXPERIMENTAL STATION
!     HARPENDEN, HERTFORDSHIRE, ENGLAND

!     Further amended by Alan Miller
!     CSIRO Division of Mathematical & Information Sciences
!     Private Bag 10, CLAYTON, VIC. 3169

!     Fortran 90 conversion by Alan Miller, June 1995
!     Alan.Miller @ vic.cmis.csiro.au
!     Latest revision - 5 December 1999

!     Parallelization and Simulated Annealing added by Steven Laufer, March 2012
!     Parallelization follows algorithm of Lee and Wiswall, Comput Econ (2007) 30:171-187
!     Simulated Annealing follows Numerical Recipes (10.9)
!     Latest revision - 3 May 2012


!     ARGUMENTS:-
!     P()     = INPUT, STARTING VALUES OF PARAMETERS
!               OUTPUT, FINAL VALUES OF PARAMETERS
!     STEP()  = INPUT, INITIAL STEP SIZES
!     NOP     = INPUT, NO. OF PARAMETERS, INCL. ANY TO BE HELD FIXED
!     FUNC    = OUTPUT, THE FUNCTION VALUE CORRESPONDING TO THE FINAL
!                 PARAMETER VALUES.
!     maxfn     = INPUT, THE MAXIMUM NO. OF FUNCTION EVALUATIONS ALLOWED.
!               Say, 20 times the number of parameters, NOP.
!               If negative, the absolute value is the maximum number of function
!                   evaluations per processor. 
!     IPRINT  = INPUT, PRINT CONTROL PARAMETER
!                 < 0 NO PRINTING
!                 = 0 PRINTING OF PARAMETER VALUES AND THE FUNCTION
!                     VALUE AFTER INITIAL EVIDENCE OF CONVERGENCE.
!                 > 0 AS FOR IPRINT = 0 PLUS PROGRESS REPORTS AFTER EVERY
!                     IPRINT EVALUATIONS, PLUS PRINTING FOR THE INITIAL SIMPLEX.
!     STOPCR  = INPUT, STOPPING CRITERION.
!               The criterion is applied to the standard deviation of
!               the values of FUNC at the points of the simplex.
!     NLOOP   = INPUT, THE STOPPING RULE IS APPLIED AFTER EVERY NLOOP
!               FUNCTION EVALUATIONS.   Normally NLOOP should be slightly
!               greater than NOP, say NLOOP = 2*NOP.
!     IQUAD   = INPUT, = 1 IF FITTING OF A QUADRATIC SURFACE IS REQUIRED
!                      = 0 IF NOT
!               N.B. The fitting of a quadratic surface is strongly
!               recommended, provided that the fitted function is
!               continuous in the vicinity of the minimum.   It is often
!               a good indicator of whether a premature termination of
!               the search has occurred.
!     SIMP    = INPUT, CRITERION FOR EXPANDING THE SIMPLEX TO OVERCOME
!               ROUNDING ERRORS BEFORE FITTING THE QUADRATIC SURFACE.
!               The simplex is expanded so that the function values at
!               the points of the simplex exceed those at the supposed
!               minimum by at least an amount SIMP.
!     VAR()   = OUTPUT, CONTAINS THE DIAGONAL ELEMENTS OF THE INVERSE OF
!               THE INFORMATION MATRIX.
!     FUNCTN  = INPUT, NAME OF THE USER'S SUBROUTINE - ARGUMENTS (P,FUNC)
!               WHICH RETURNS THE FUNCTION VALUE FOR A GIVEN SET OF
!               PARAMETER VALUES IN ARRAY P.
!     FUNCTN2 = INPUT, FUNCTION TO BE CALLED BY MASTER AFTER EACH
!               NLOOP EVALUATIONS ON BEST POINT IN CURRENT SIMPLX,
!               IF BEST POINT OF SIMPLEX IS P WITH VALUE H, CALLS FUNCTN2(P,H)
!               e.g. Check if have point better than previous best, if so
!               calculate some numbers of interest and write them to a file
!****    FUNCTN, FUNCTN2 MUST BE DECLARED EXTERNAL IN THE CALLING PROGRAM.
!     IFAULT  = OUTPUT, = 0 FOR SUCCESSFUL TERMINATION
!                 = 1 IF MAXIMUM NO. OF FUNCTION EVALUATIONS EXCEEDED
!                 = 2 IF INFORMATION MATRIX IS NOT +VE SEMI-DEFINITE
!                 = 3 IF NOP < 1
!                 = 4 IF NLOOP < 1
! NOTE DEFINITIONS OF MYRANK AND NPROCS. COUNTER-INTUITIVE.
!     MYRANK   = WHICH GROUP THIS PROCESSOR IS PART OF
!     NPROCS   = NUMBER OF GROUPS
!     T0       = STARTING TEMPERATURE FOR ANNEALING
!     Tstep    = FRACTION BY WHICH TEMPERATURE IS DECREASED AT EACH STEP
!     Tfreq    = FREQUENCY (NUMBER OF FUNCTION EVALUATIONS) AT WHICH
!                TEMPERATURE IS DECREASED
!     randseed = RANDOM SEED FOR THERMAL FLUCTUATIONS
!     N.B. P, STEP AND VAR (IF IQUAD = 1) MUST HAVE DIMENSION AT LEAST NOP
!          IN THE CALLING PROGRAM.

!*****************************************************************************

INTEGER, INTENT(IN)        :: nop, maxfn, iprint, nloop, iquad
INTEGER, INTENT(OUT)       :: ifault
REAL(8), INTENT(IN)      :: stopcr, simp
REAL(8), INTENT(IN OUT)  :: p(:), step(:)
REAL(8), INTENT(OUT)     :: var(:), func
INTEGER, INTENT(IN)      :: myrank,nprocs
EXTERNAL functn
EXTERNAL functn2
REAL(8), INTENT(IN)      :: T0,Tstep
INTEGER, INTENT(IN)      :: Tfreq,randseed
!INTERFACE
!  SUBROUTINE functn(p, func)
!    IMPLICIT NONE
!    INTEGER, PARAMETER     :: dp = SELECTED_REAL_KIND(12, 60)
!    REAL, INTENT(IN)  :: p(:)
!    REAL, INTENT(OUT) :: func
!  END SUBROUTINE functn
!  SUBROUTINE functn2(p, func)
!    IMPLICIT NONE
!    REAL, INTENT(IN)  :: p(:)
!    REAL, INTENT(IN) :: func
!  END SUBROUTINE functn2
!END INTERFACE


!     Local variables
REAL(8)   :: g(nop+1,nop), h(nop+1), pbar(nop), pstar(nop), pstst(nop), &
               aval(nop), pmin(nop), temp(nop), bmat(nop*(nop+1)/2),  &
               vc(nop*(nop+1)/2), ymin, rmax, hstst, a0, hmin, test, hmean, &
               hstd, hstar, hmax, savemn, savehstd

REAL(8), PARAMETER :: zero = 0._dp, half = 0.5_dp, one = 1._dp, two = 2._dp
INTEGER     :: i, i1, i2, iflag, ii, ij, imax, imin, irank, irow, j, j1, jj, &
               k, l, loop, nap, neval, nmore, np1, nullty

!     A = REFLECTION COEFFICIENT, B = CONTRACTION COEFFICIENT, AND
!     C = EXPANSION COEFFICIENT.

REAL(8), PARAMETER :: a = 1._dp, b = 0.5_dp, c = 2._dp

!     SET LOUT = LOGICAL UNIT NO. FOR OUTPUT

INTEGER, PARAMETER :: lout = 6

! Delcaraltions related to parallelization
INTEGER :: nrounds,nround,nevalp,myimax
REAL(8) :: htilde
REAL(8), DIMENSION(nop) :: ptilde
INTEGER, PARAMETER :: maxprocs=200  !ahu s15 changed from 48
INTEGER, DIMENSION(maxprocs) :: mycase
REAL(8), DIMENSION(maxprocs) :: myval
REAL(8), DIMENSION(maxprocs,nop) :: mypoint
INTEGER :: npoints
REAL(8), DIMENSION(nop*(nop-1)/2,nop) :: points
REAL(8), DIMENSION(nop*(nop-1)/2) :: values
INTEGER, DIMENSION(1) :: best1
! additional variables for simulated annealing: current temperature plus thermal fluctuations
REAL(8)   :: SAtemp, htherm(nop+1), thermsimp(nop+1),thermstar(nop),thermstst(nop),SArandom(2*ABS(maxfn),3*nop)
INTEGER   :: tstepnext,r,SAnrand

integer :: realrank,mpierr,mpistat(MPI_STATUS_SIZE)

real(dp) :: timing(2)

CALL MPI_Comm_rank(MPI_COMM_WORLD,realrank,mpierr)
!CALL MPI_Comm_rank(comm,i,mpierr)
!print*, "Here is ME AT COMM ", myrank,i !,myrank_world
!realrank=myid
if (realrank==0) then 
	OPEN(UNIT=lout,FILE='opt.txt',STATUS='replace')
!	write(lout,'("realrank,mygroup,myrank,mygrank,iprint:",5I4)') realrank,mygroup,myrank,mygrank,iprint
    write(lout,'("nop,maxfn,iprint,nloop,iquad: ",5I4)') nop, maxfn, iprint, nloop, iquad
    write(lout,'("stopcr,simp: ",2g14.6)') stopcr,simp
    write(lout,'("T0,Tstep: ",2g14.6)') T0,Tstep
    write(lout,'("Tfreq: ",I4)') Tfreq
!	write(*,'("realrank,mygroup,myrank,mygrank,iprint:",5I4)') realrank,mygroup,myrank,mygrank,iprint
    write(*,'("nop,maxfn,iprint,nloop,iquad: ",5I4)') nop, maxfn, iprint, nloop, iquad
    write(*,'("stopcr,simp: ",2g14.6)') stopcr,simp
    write(*,'("T0,Tstep: ",2g14.6)') T0,Tstep
    write(*,'("Tfreq: ",I4)') Tfreq
end if 
!write(*,'("realrank,mygroup,myrank,mygrank,iprint:",5I4)') realrank,mygroup,myrank,mygrank,iprint



!     CHECK INPUT ARGUMENTS

ifault = 0
IF (nop <= 0) ifault = 3
IF (nloop <= 0) ifault = 4
!IF ((realrank<nprocs).AND.(realrank/=myrank)) ifault = 5
IF (ifault /= 0) RETURN

!     SET NAP = NO. OF PARAMETERS TO BE VARIED, I.E. WITH STEP /= 0

nap = COUNT(step /= zero)
neval = 0
nevalp= 0
loop = 0
iflag = 0

!     IF NAP = 0 EVALUATE FUNCTION AT THE STARTING POINT AND RETURN

IF (nap <= 0) THEN
  CALL functn(p,func)
  RETURN
END IF


! IF NAP<=NPROCS, RETURN
IF (nap <=nprocs) THEN
  CALL functn(p,func)
  RETURN
ENDIF

! If printing, print degree of parallelization
IF ((iprint>=0).AND.(realrank==0))  WRITE(lout,4900) nap,nprocs
!     IF PROGRESS REPORTS HAVE BEEN REQUESTED, PRINT HEADING
IF ((iprint > 0).AND.(realrank==0)) WRITE (lout,5000) iprint

!     SET UP THE INITIAL SIMPLEX
		  !IF (iprint > 0) THEN
		!	WRITE (lout,'("Set up initial simplex ")') 
		  !END IF
20 g(1,:) = p
irow = 2
DO i = 1, nop
  IF (step(i) /= zero) THEN
    g(irow,:) = p
    g(irow,i) = p(i) + step(i)
    irow = irow + 1
  END IF
END DO

np1 = nap + 1

!SUBROUTINE function_distribute(npoints,minrank,maxrank,points,vals,nevalps,func)
!print*, "realrank,nprocs,myrank ", realrank,nprocs,myrank 	!ahu april13
CALL function_distribute(np1,0,nprocs-1,g(1:np1,:),h(1:np1),nevalp,functn,myrank) 
neval=np1
IF ((iprint > 0).AND.(realrank==0)) THEN
  DO i=1,np1
    WRITE (lout,5100) i, h(i), g(i,:)
  ENDDO
END IF

! Initialize simulated annealing
SAtemp=T0 ! set initial temperature
tstepnext=neval+Tfreq ! next time will lower temperature
SAnrand=1 ! which set of random numbers up to
! set seed of RANDOM_NUMBER function and draw random numbers
CALL RANDOM_SEED (SIZE=r)
CALL RANDOM_SEED (PUT = randseed*(/(k,k=1,r)/))
CALL RANDOM_NUMBER(SArandom)

!     START OF MAIN CYCLE.

!     FIND MAX. & MIN. VALUES FOR CURRENT SIMPLEX (HMAX & HMIN).

Main_loop: DO
  loop = loop + 1
	!if (realrank==0.or.realrank==1) PRINT*, "HERE I AM starting loop", MYRANK,MYRANK_WORLD,loop
    IF ((iprint > 0).AND.(realrank==0)) THEN
        WRITE(LOUT,'("beginning of Main_loop, just augmented loop: loop=loop+1")') 
        write(LOUT,'("loop,SAtemp,neval,tstepnext ",I4,g14.6,2I4)') loop,SAtemp,neval,tstepnext
    END IF 
    
  If (neval>tstepnext) THEN ! lower temperature
      SAtemp=SAtemp*Tstep
      tstepnext=tstepnext+Tfreq ! next time will lower temperature
        IF ((iprint > 0).AND.(realrank==0)) THEN
            WRITE(LOUT,*) 
            write(LOUT,'("SAtemp and Tstep are: ",2g14.6)') SAtemp,Tstep
            WRITE(LOUT,'("Checked neval>tstepnext so lowering temperature now")') 
            write(LOUT,'("Get the new temp: SAtemp=SAtemp*Tstep gives: ",g14.6)') SAtemp
            write(LOUT,'("Next time, will lower temprature at tstepnext=tstepnext+Tfreq which gives: ",I4)') tstepnext            
        END IF 
        !if (realrank==0) write(*,'("lowering temperature now ",2I4,g14.6,I4)') realrank,loop,SAtemp,tstepnext
  ENDIF
  ! POSITIVE THERMAL FLUCTUATIONS
  thermsimp=-1*SAtemp*LOG(SArandom(SAnrand,1:nop+1))
  thermstar(1:nprocs)=-1*SAtemp*LOG(SArandom(SAnrand,nop+2:nop+nprocs+1))
  thermstst(1:nprocs)=-1*SAtemp*LOG(SArandom(SAnrand,2*nop+2:2*nop+nprocs+1))
    IF ((iprint > 0).AND.(realrank==0)) THEN
        write(lout,*) 
        write(lout,*) 
        WRITE(LOUT,'(tr3,"i",tr6,"SArandom",tr3,"logSArandom",tr4,"SAtemp*log",tr5,"thermsimp",tr6,"h",tr7,"htherm=h+thermsimp")')
        do i=1,np1
            WRITE(LOUT,'(I4,6g14.6)') i,SArandom(SAnrand,i),LOG(SArandom(SAnrand,i)),SAtemp*LOG(SArandom(SAnrand,i)),thermsimp(i),h(i),h(i)+thermsimp(i)
        end do 
        write(*,'("loop,thermsimp(1:2) ",I4,2g14.6)') loop,thermsimp(1:2)
    END IF 
  SAnrand=SAnrand+1
  IF (SAnrand>2*ABS(maxfn)) THEN ! used up all random numbers- don't think this should happen
    SAnrand=1
  ENDIF
  !thermsimp=0.0_dp !ahu 112213
  !thermstar=0.0_dp
  !thermstst=0.0_dp
  
! SORT SIMPLEX SO VALUES OF h (with thermal fluctuations)  ARE INCREASING IN INDEX. SORT g AND h
  htherm(1:np1)=h(1:np1)+thermsimp(1:np1)
  CALL QsortC3(htherm(1:np1),g(1:np1,:))
  htherm(1:np1)=h(1:np1)+thermsimp(1:np1)
  CALL QsortC2(htherm(1:np1),h(1:np1))

    IF ((iprint > 0).AND.(realrank==0)) THEN
        write(lout,*) 
        write(lout,*) 
        WRITE(LOUT,'(tr3,"i",tr13,"h",tr8,"htherm")')
        do i=1,np1
            WRITE(LOUT,'(I4,2g14.6)') i,h(i),htherm(i)
        end do 
    END IF 
  
  
  imax=np1
  hmax=h(np1)
  imin=1
  hmin=h(1)

!     FIND THE CENTROID OF THE VERTICES OF BEST np1 MINUS nprocs POINTS

  pbar = zero
  DO i = 1, np1-nprocs
    pbar = pbar + g(i,:)
  END DO
  pbar = pbar / (np1-nprocs)
  IF ((iprint > 0).AND.(realrank==0)) THEN
	WRITE (lout,*) 
	WRITE (lout,*) 
	WRITE (lout,*) 
	WRITE (lout,'("Position of centroid PBAR (midway between all points other than imax) is calculated. ")') 
	WRITE (lout,*) 
	write(lout,'(TR2,"maxloc",TR2,"minloc",TR4,"maxval",TR4,"minval",TR2,"thermsimp")')
	WRITE (lout,'(2(4x,I4),3F10.2)') maxloc(htherm(1:np1)),minloc(htherm(1:np1)),maxval(htherm(1:np1)),minval(htherm(1:np1)),thermsimp(1)
	WRITE (lout,*) 
	WRITE (lout,'("Here is G(IMAX,:) ")') 
	WRITE (lout,5100) neval, hmax,g(imax,:)
	WRITE (lout,*) 
	WRITE (lout,'("Here is the centroid PBAR ")') 
	WRITE (lout,5100) neval, 0.0_dp, pbar
	WRITE (lout,*) 
  END IF

! ASSIGN EACH PROCESSOR ONE OF THE NPROCS WORST POINTS
  myimax=np1-myrank
!For example: if numprocs is 2 so that myrank is 0 or 1, we will 
!have myimax=np1 for myrank=0 and myimax=np1-1 for myrank=1. 
!Thes are the worst and the second worst points in the current simplex values with thermal fluctuations
!   A reflection of the worst-response point W is performed and the response RR of the reflected point R is evaluated. 
!	Reflect the worst (i.e.G(MYIMAX,:)) point through PBAR
!	Call this reflection point PSTAR and evaluate the obj function at PSTAR
!	HSTAR = function value at PSTAR
 pstar = a * (pbar - g(myimax,:)) + pbar
 timing(1)=MPI_WTIME() !ahu 0317
 CALL functn(pstar,hstar)
 timing(2)=MPI_WTIME() !ahu 0317
 if (realrank==0) WRITE (lout,'("Just calling func ",2I4,F14.2)') realrank,myrank,timing(2)-timing(1) !ahu 0317
 IF ((iprint > 0).AND.(realrank==0)) THEN
	WRITE (lout,*) 
	WRITE (lout,*) 
	WRITE (lout,'("REFLECTION --> reflecting MAXIMUM through PBAR to get the reflection point PSTAR. ")') 
	WRITE (lout,'("(R) PSTAR = a * (PBAR - g(imax,:)) + PBAR ")') 
	WRITE (lout,'("(RR) HSTAR=functn(PSTAR,HSTAR) ")') 
	WRITE (lout,*) 
 END IF

	! NOW EACH PROCESSOR DOES THE FOLLOWING SEPARATELY:
	! Each processor follows instrcutions based on hstar, returns a point MYPOINT with value MYVAL
	! in approproate index corresponding to which processor. Record what happened in entry of MYCASE

	! case 1: hstar < hmin 
	! reflection did well i.e. hstar is beter than the best point hmin 
	! ---> expand further i.e. expand pbar in the direction of pstar
	! ---> g and h at expansion pt: PSTST,HSTST
	IF (hstar-thermstar(myrank+1) < htherm(1)) THEN ! case 1 - return the better of the expansion point and the reflection point
		mycase(myrank+1)=1
		pstst = c * (pstar - pbar) + pstar
		CALL functn(pstst,hstst)
		IF (hstst<hstar) THEN ! return expansion point (pstst)
			mypoint(myrank+1,:)=pstst
			myval(myrank+1)=hstst
		ELSE ! return reflection point (pstar)
			mypoint(myrank+1,:) = pstar
			myval(myrank+1) = hstar
		END IF
		
	! case 2: hstar > hmin  and hstar<htherm(np1-1) or (np1-2) ... (np1-myrank-1) .. etc. 	
	! reflection did ok i.e. hstar not beter than the best point, BUT better than the second (or third etc. depending on myrank) worst point 
	! ---> do nothing and just return the original reflection point pstar.  
	! ---> Note that this is the only case in which the processor does not do an extra function call
	ELSEIF (hstar-thermstar(myrank+1)<htherm(np1-myrank-1)) THEN ! case 2 - return the relction point
		mycase(myrank+1)=2
		mypoint(myrank+1,:)=pstar
		myval(myrank+1) = hstar

	! case 3 or 4: hstar > hmin AND hstar > hterm(..) 
	! reflection did not do any good i.e. hstar not better than the best AND not better than any of the worst points
	! ---> contract by getting the convex combo of pstar and pbar
	! ---> contraction point: PSTST
	! ---> fnctn value at contraction point: HSTST
	ELSE 
		! calculate contraction point, pstst
		pstst= b * pstar + (one-b) * pbar
		CALL functn(pstst,hstst)
		! compare the contraction point to the better of pstar and the original point of the simplex
		IF (hstar-thermstar(myrank+1)<htherm(myimax)) THEN ! pstar is better of the two
			IF (hstst<hstar) THEN ! case 3 - return the contraction point
			mycase(myrank+1)=3
			mypoint(myrank+1,:)=pstst
			myval(myrank+1) = hstst
			ELSE ! case 4 - return the better of pstar and the original point, which is here pstar
			mycase(myrank+1)=4
			mypoint(myrank+1,:)=pstar
			myval(myrank+1) = hstar
			ENDIF
		ELSE ! ther original point of the simplex is better than pstar
			IF (hstst-thermstst(myrank+1)<htherm(myimax)) THEN ! case 3 - return the contraction point
			mycase(myrank+1)=3
			mypoint(myrank+1,:)=pstst
			myval(myrank+1) = hstst
			ELSE ! case 4 - return the better of pstar and the original point of the simplex,here g(myimax,:)
			mycase(myrank+1)=4
			mypoint(myrank+1,:)=g(myimax,:)
			myval(myrank+1) = h(myimax)
			ENDIF
		ENDIF 
	ENDIF

! SHARE OUTCOMES AND THEN FIGURE OUT WHAT THE NEW SIMPLEX WILL LOOK LIKE  
! First share outcomes MYCASE, MYPOINT and MYVAL, count number of function evaluations, print as appropriate
  nrounds=1 ! the number of evals per processor
  DO ii=0,nprocs-1
    CALL MPI_BCAST(mycase(ii+1),1,MPI_INTEGER,ii,MPI_COMM_WORLD,mpierr)
    CALL MPI_BCAST(mypoint(ii+1,:),nop,MPI_REAL8,ii,MPI_COMM_WORLD,mpierr)
    CALL MPI_BCAST(myval(ii+1),1,MPI_REAL8,ii,MPI_COMM_WORLD,mpierr)
    IF (mycase(ii+1) == 2) THEN ! only did one function evaluation at point MYPOINT(ii+1)
      neval=neval+1
      IF ((iprint > 0).AND.(realrank==0)) THEN
        IF (MOD(neval,iprint) == 0) WRITE (lout,5100) neval, myval(ii+1), mypoint(ii+1,:)
      END IF
    ELSE ! two function evaluations
      IF ((ii>0) .AND. (iprint>0)) THEN
         ! Send pstar, hstar, pstst,hstst to master for printing. If ii=0, this is master, have values already.
         IF (realrank==ii) THEN
           CALL MPI_SEND(pstar,nop, MPI_REAL8,0,1,MPI_COMM_WORLD,mpierr)
           CALL MPI_SEND(hstar,1, MPI_REAL8,0,2, MPI_COMM_WORLD,mpierr)
           CALL MPI_SEND(pstst,nop, MPI_REAL8,0,3, MPI_COMM_WORLD,mpierr)
           CALL MPI_SEND(hstst,1, MPI_REAL8,0,4, MPI_COMM_WORLD,mpierr)
         ENDIF
         IF (realrank==0) THEN
           CALL MPI_RECV(pstar,nop, MPI_REAL8,ii,1,MPI_COMM_WORLD, mpistat,mpierr)
           CALL MPI_RECV(hstar,1, MPI_REAL8,ii,2,MPI_COMM_WORLD, mpistat,mpierr)
           CALL MPI_RECV(pstst,nop, MPI_REAL8,ii,3,MPI_COMM_WORLD, mpistat,mpierr)
           CALL MPI_RECV(hstst,1, MPI_REAL8,ii,4,MPI_COMM_WORLD, mpistat,mpierr)
         ENDIF
      ENDIF
      neval=neval+1 
      IF ((iprint > 0).AND.(realrank==0)) THEN
        IF (MOD(neval,iprint) == 0) WRITE (lout,5100) neval, hstar, pstar
      ENDIF
      neval=neval+1 
      IF ((iprint > 0).AND.(realrank==0)) THEN
        IF (MOD(neval,iprint) == 0) WRITE (lout,5100) neval, hstst, pstst
      ENDIF 
      nrounds=2 ! at least one processor did two evaluations rather than one, update nevalp by 2
    ENDIF
  ENDDO
  nevalp=nevalp+nrounds
  
	
	if (iprint>0.and.realrank==0) then
		do ii=0,nprocs
			write(lout,*) 
			write(lout,'(TR2,"myrank",TR2,"mycase",TR5,"myval")')
			write(lout,'(2(4x,I4),F10.2)') myrank,mycase(ii+1),myval(ii+1)
			write(lout,*) 
			if (mycase(ii+1)==1) then
				write(lout,*) "case 1: hstar < hmin. reflection did well i.e. hstar is beter than the best point hmin"
				write(lout,*) " ---> expand further i.e. expand pbar in the direction of pstar"
				write(lout,*) " ---> g and h at expansion pt: PSTST,HSTST"
			else if (mycase(ii+1)==2) then
				write(lout,*) "case 2: hstar > hmin  and hstar<htherm(np1-1) or (np1-2) ... (np1-myrank-1) .. etc."
				write(lout,*) "reflection did ok i.e. hstar not beter than the best point, BUT did do better than the second (or third etc. depending on myrank) worst point"
				write(lout,*) " ---> do nothing and just return the original reflection point pstar."
				write(lout,*) " ---> Note that this is the only case in which the processor does not do an extra function call"
			else if (mycase(ii+1)>2) then
				write(lout,*) "case 3 or 4: hstar > hmin AND hstar > hterm(..)"
				write(lout,*) "reflection did not do any good i.e. hstar not better than the best AND not better than any of the worst points"
				write(lout,*) "---> contract by getting the convex combo of pstar and pbar"
				write(lout,*) "---> compare the contraction point to the better of pstar and the worst point of the original simplex"
				write(lout,*) "---> g and h at contraction point: PSTST,HSTST"
			end if   
			write(lout,*) 
			write(lout,*) 
		end do   
	end if 
	
  ! if at least one processor did not have case 4, replace the worst nprocs points of simplex
  if (MINVAL(mycase(1:nprocs))<4) then ! use points and values from each processor
	if (iprint>0.and.realrank==0) then
		write(lout,*) 
		write(lout,*) "At least one process did not have case 4 ---> replace the worst nprocs points of simplex and restart loop"
		write(lout,*) "g(np1-nprocs+1:np1,:)=mypoint(1:nprocs,:)"   
		write(lout,*) "h(np1-nprocs+1:np1)=myval(1:nprocs)"
		write(lout,*) "go to 250"
		write(lout,*) 
		write(lout,*) 
	end if 
	g(np1-nprocs+1:np1,:)=mypoint(1:nprocs,:)
    h(np1-nprocs+1:np1)=myval(1:nprocs)
    GO TO 250
  endif

!  Otherwise, all the processors had case 4
!	---> shrink the simplex by replacing each point other than the current minimum 
!	     by a point mid-way between its current position and the minimum"
	if (iprint>0.and.realrank==0) then
		write(lout,*) "All the processors had case 4"
		write(lout,*) "---> shrink the simplex by replacing each point other than the current minimum"
		write(lout,*) "     by a point mid-way between its current position and the minimum"
	end if 
		
  DO i = 2, np1
      DO j = 1, nop
        IF (step(j) /= zero) g(i,j) = (g(i,j) + g(1,j)) * half
      END DO
  ENDDO

 if (iprint>0.and.realrank==0) then
	write(lout,*) 
	write(lout,*) 
	write(lout,*) "calling function_distribute "
	write(lout,*) "increase count of number of evals per procesor (nevalp=nevalp+nrounds) "
	write(lout,*) 
	write(lout,*) 
 end if 	 
  !SUBROUTINE function_distribute(npoints,minrank,maxrank,points,vals,nevalps,func)
  CALL function_distribute(nap,0,nprocs-1,g(2:np1,:),h(2:np1),nrounds,functn,myrank)
  ! increase count of number of evals per processor
  nevalp=nevalp+nrounds
  ! count evals and print 
 if (iprint>0.and.realrank==0) then
	write(lout,*) 
	write(lout,*) 
	write(lout,'("nevalp,nrounds:",2I6)') nevalp,nrounds
	write(lout,'("now count evals and print")') 
	write(lout,*) 
	write(lout,*) 
 end if 	 
  DO i=2,np1
      neval = neval + 1
      IF ((iprint > 0).AND.(realrank==0)) THEN
        IF (MOD(neval,iprint) == 0) WRITE (lout,5100) neval, h(i), g(i,:)
      END IF
  END DO
 if (iprint>0.and.realrank==0) then
	write(lout,*) 
	write(lout,*) 
	write(lout,'("neval:",2I6)') nevalp
	write(lout,'("now count evals and print")') 
	write(lout,*) 
	write(lout,*) 
 end if 	 

!     IF LOOP = NLOOP TEST FOR CONVERGENCE, OTHERWISE REPEAT MAIN CYCLE.
 if (iprint>0.and.realrank==0) then
	write(lout,*) 
	write(lout,*) 
	!ahu s15 write(lout,'("if loop=nloop, test for convergence, otherwise repeat main cycle",2I6)') nevalp,nrounds
	!ahu s15 write(lout,'("loop,nloop:",2I6)') nevalp,nrounds
	write(lout,'("if loop=nloop, test for convergence, otherwise repeat main cycle",2I6)') loop,nloop
	write(lout,'("loop,nloop:",2I6)') loop,nloop
    write(lout,*) 
	write(lout,*) 
 end if 
  250 IF (loop < nloop) CYCLE Main_loop

  IF (iprint>0.and.realrank==0) THEN	
	write(lout,*) 
	write(lout,*) 
	write(lout,*) "calling write now but just parameters and not the moments. see the change in functn2 " !ahu s15
	write(lout,*) 
	write(lout,*) 
    best1=MINLOC(h(1:np1))
    CALL functn2(g(best1(1),:),h(best1(1)))
  ENDIF

!     CALCULATE MEAN & STANDARD DEVIATION OF FUNCTION VALUES FOR THE
!     CURRENT SIMPLEX.

  hmean = SUM( h(1:np1) ) / np1
  hstd = SUM( (h(1:np1) - hmean) ** 2 )
  hstd = SQRT(hstd / np1)

	IF ((iprint > 0).AND.(realrank==0)) THEN
		WRITE (lout,5300) hstd
	END IF


!     IF THE RMS > STOPCR, SET IFLAG & LOOP TO ZERO AND GO TO THE
!     START OF THE MAIN CYCLE AGAIN.

  IF (hstd > stopcr .AND. (((maxfn>=0).AND.(neval <= maxfn)).OR.((maxfn<0).AND.(nevalp <= -1*maxfn))  )) THEN
    iflag = 0
    loop = 0
    CYCLE Main_loop
  END IF

!     FIND THE CENTROID OF THE CURRENT SIMPLEX AND THE FUNCTION VALUE THERE.

  DO i = 1, nop
    IF (step(i) /= zero) THEN
      p(i) = SUM( g(1:np1,i) ) / np1
    END IF
  END DO
  ! Note: all processors will do this eval
  CALL functn(p,func)
  neval = neval + 1
  nevalp= nevalp+1
  IF ((iprint > 0).AND.(realrank==0)) THEN
    IF (MOD(neval,iprint) == 0) WRITE (lout,5100) neval, func, p
  END IF

!     TEST WHETHER THE NO. OF FUNCTION VALUES ALLOWED, maxfn, HAS BEEN
!     OVERRUN; IF SO, EXIT WITH IFAULT = 1.
!  If MAXFN>0, check based on neval. If MAXFN<0, check based on nevalp.
  IF (((maxfn>=0).AND.(neval > maxfn)).OR.((maxfn<0).AND.(nevalp > -1*maxfn))) THEN
    ifault = 1
    IF (iprint < 0) RETURN
    IF ((iprint > 0).AND.(realrank==0)) THEN
      IF (maxfn>=0) THEN
        WRITE (lout,5200) maxfn
      ELSE
        WRITE (lout,5201) -1*maxfn
      ENDIF
      WRITE (lout,5300) hstd
      WRITE (lout,5400) p
      WRITE (lout,5500) func
    ENDIF
    RETURN
  END IF

!     CONVERGENCE CRITERION SATISFIED.
!     IF IFLAG = 0, SET IFLAG & SAVE HMEAN.
!     IF IFLAG = 1 & CHANGE IN HMEAN <= STOPCR THEN SEARCH IS COMPLETE.

  IF ((iprint >= 0).AND.(realrank==0)) THEN
    WRITE (lout,5600)
    WRITE (lout,5400) p
    WRITE (lout,5500) func
  END IF

  IF (iflag == 0 .OR. ABS(savemn-hmean) >= stopcr) THEN
    iflag = 1
    savemn = hmean
    loop = 0
  ELSE
    EXIT Main_loop
  END IF

END DO Main_loop

IF((iprint >= 0).AND.(realrank==0)) THEN
  WRITE (lout,5700) neval
  IF (maxfn<0) THEN
    WRITE (lout,5701) nevalp
  ENDIF
  WRITE (lout,5800) p
  WRITE (lout,5900) func
  CLOSE(LOUT) ! ahu f14
END IF
IF (iquad <= 0) RETURN

!------------------------------------------------------------------

!     QUADRATIC SURFACE FITTING

IF ((iprint >= 0).AND.(realrank==0)) WRITE (lout,6000)

!     EXPAND THE FINAL SIMPLEX, IF NECESSARY, TO OVERCOME ROUNDING
!     ERRORS.
!     NOTE: This step does not take advantage of prallelization
hmin = func
nmore = 0
DO i = 1, np1
  DO
    test = ABS(h(i)-func)
    IF (test < simp) THEN
      DO j = 1, nop
        IF (step(j) /= zero) g(i,j) = (g(i,j)-p(j)) + g(i,j)
        pstst(j) = g(i,j)
      END DO
      CALL functn(pstst,h(i))
      nmore = nmore + 1
      neval = neval + 1
      nevalp = nevalp + 1
      IF (h(i) >= hmin) CYCLE
      hmin = h(i)
      IF ((iprint >= 0).AND.(realrank==0)) WRITE (lout,5100) neval, hmin, pstst
    ELSE
      EXIT
    END IF
  END DO
END DO

!     FUNCTION VALUES ARE CALCULATED AT AN ADDITIONAL NAP POINTS.

DO i = 1, nap
  i1 = i + 1
  points(i,:) = (g(1,:) + g(i1,:)) * half
ENDDO
!SUBROUTINE function_distribute(npoints,minrank,maxrank,points,vals,nevalps,func)
CALL function_distribute(nap,0,nprocs-1,points(1:nap,:),aval(1:nap),nrounds,functn,myrank)
nmore = nmore + nap
neval = neval + nap
nevalp = nevalp + nrounds

!     THE MATRIX OF ESTIMATED SECOND DERIVATIVES IS CALCULATED AND ITS
!     LOWER TRIANGLE STORED IN BMAT.

a0 = h(1)
! Get points to evaluate at
ii=1
DO i = 1, nap
  i1 = i - 1
  i2 = i + 1
  DO j = 1, i1
    j1 = j + 1
    points(ii,:) = (g(i2,:) + g(j1,:)) * half
    ii=ii+1
  ENDDO
ENDDO
npoints=nap*(nap-1)/2
! Evaluate points
!SUBROUTINE function_distribute(npoints,nprocs,points,vals,nevalps,func)
CALL function_distribute(npoints,0,nprocs-1,points(1:npoints,:),values(1:npoints),nrounds,functn,myrank)
! Enter values into bmat
ii=1
DO i = 1, nap
  i1 = i - 1
  i2 = i + 1
  DO j = 1, i1
    j1 = j + 1
    l = i * (i-1) / 2 + j
    bmat(l) = two * (values(ii) + a0 - aval(i) - aval(j))
    ii=ii+1
  END DO
END DO
! Update counts of function evaluations
nmore = nmore + nap*(nap-1)/2
neval = neval + nap*(nap-1)/2
nevalp = nevalp + nrounds
! ORIGINAL NON-PARALLEL VERSION
!DO i = 1, nap
!  i1 = i - 1
!  i2 = i + 1
!  DO j = 1, i1
!    j1 = j + 1
!    pstst = (g(i2,:) + g(j1,:)) * half
!    CALL functn(pstst,hstst)
!    nmore = nmore + 1
!    neval = neval + 1
!    nevalp = nevalp + 1
!    l = i * (i-1) / 2 + j
!    bmat(l) = two * (hstst + a0 - aval(i) - aval(j))
!  END DO
!END DO

l = 0
DO i = 1, nap
  i1 = i + 1
  l = l + i
  bmat(l) = two * (h(i1) + a0 - two*aval(i))
END DO

!     THE VECTOR OF ESTIMATED FIRST DERIVATIVES IS CALCULATED AND
!     STORED IN AVAL.

DO i = 1, nap
  i1 = i + 1
  aval(i) = two * aval(i) - (h(i1) + 3._dp*a0) * half
END DO

!     THE MATRIX Q OF NELDER & MEAD IS CALCULATED AND STORED IN G.

pmin = g(1,:)
DO i = 1, nap
  i1 = i + 1
  g(i1,:) = g(i1,:) - g(1,:)
END DO

DO i = 1, nap
  i1 = i + 1
  g(i,:) = g(i1,:)
END DO

!     INVERT BMAT

CALL syminv(bmat, nap, bmat, temp, nullty, ifault, rmax)
IF (ifault == 0) THEN
  irank = nap - nullty
ELSE                                 ! BMAT not +ve definite
                                     ! Resume search for the minimum
  IF ((iprint >= 0).AND.(realrank==0)) WRITE (lout,6100)
  ifault = 2
  IF (((maxfn>=0).AND.(neval > maxfn)).OR.((maxfn<0).AND.(nevalp > -1*maxfn))) RETURN
  IF (realrank==0) WRITE (lout,6200)
  step = half * step
  GO TO 20
END IF

!     BMAT*A/2 IS CALCULATED AND STORED IN H.

DO i = 1, nap
  h(i) = zero
  DO j = 1, nap
    IF (j <= i) THEN
      l = i * (i-1) / 2 + j
    ELSE
      l = j * (j-1) / 2 + i
    END IF
    h(i) = h(i) + bmat(l) * aval(j)
  END DO
END DO

!     FIND THE POSITION, PMIN, & VALUE, YMIN, OF THE MINIMUM OF THE
!     QUADRATIC.

ymin = DOT_PRODUCT( h(1:nap), aval(1:nap) )
ymin = a0 - ymin
DO i = 1, nop
  pstst(i) = DOT_PRODUCT( h(1:nap), g(1:nap,i) )
END DO
pmin = pmin - pstst
IF ((iprint >= 0).AND.(realrank==0)) THEN
  WRITE (lout,6300) ymin, pmin
  WRITE (lout,6400)
END IF

!     Q*BMAT*Q'/2 IS CALCULATED & ITS LOWER TRIANGLE STORED IN VC

DO i = 1, nop
  DO j = 1, nap
    h(j) = zero
    DO k = 1, nap
      IF (k <= j) THEN
        l = j * (j-1) / 2 + k
      ELSE
        l = k * (k-1) / 2 + j
      END IF
      h(j) = h(j) + bmat(l) * g(k,i) * half
    END DO
  END DO

  DO j = i, nop
    l = j * (j-1) / 2 + i
    vc(l) = DOT_PRODUCT( h(1:nap), g(1:nap,j) )
  END DO
END DO

!     THE DIAGONAL ELEMENTS OF VC ARE COPIED INTO VAR.

j = 0
DO i = 1, nop
  j = j + i
  var(i) = vc(j)
END DO
IF (iprint < 0) RETURN
IF (realrank==0) THEN
  WRITE (lout,6500) irank
  CALL print_tri_matrix(vc, nop, lout)
  WRITE (lout,6600)
ENDIF
CALL syminv(vc, nap, bmat, temp, nullty, ifault, rmax)

!     BMAT NOW CONTAINS THE INFORMATION MATRIX

IF (realrank==0) THEN
  WRITE (lout,6700)
  CALL print_tri_matrix(bmat, nop, lout)
ENDIF

ii = 0
ij = 0
DO i = 1, nop
  ii = ii + i
  IF (vc(ii) > zero) THEN
    vc(ii) = one / SQRT(vc(ii))
  ELSE
    vc(ii) = zero
  END IF
  jj = 0
  DO j = 1, i - 1
    jj = jj + j
    ij = ij + 1
    vc(ij) = vc(ij) * vc(ii) * vc(jj)
  END DO
  ij = ij + 1
END DO

IF (realrank==0) WRITE (lout,6800)
ii = 0
DO i = 1, nop
  ii = ii + i
  IF (vc(ii) /= zero) vc(ii) = one
END DO
IF (realrank==0) CALL print_tri_matrix(vc, nop, lout)

!     Exit, on successful termination.

IF (realrank==0) WRITE (lout,6900) nmore
RETURN

4900 FORMAT (' Estimating ',i4,' parameters on ',i3,' communicators')
5000 FORMAT (' Progress Report every',i4,' function evaluations'/  &
             ' EVAL.   FUNC.VALUE.          PARAMETER VALUES')
5100 FORMAT (/' ', i4, '  ', g12.5, '  ', 5G11.4, 3(/t22, 5G11.4))
5200 FORMAT (' No. of function evaluations > ',i5)
5201 FORMAT (' No. of function evaluations per processor > ',i5)
5300 FORMAT (' RMS of function values of last simplex =', g14.6)
5400 FORMAT (' Centroid of last simplex =',4(/' ', 6G13.5))
5500 FORMAT (' Function value at centroid =', g14.6)
5600 FORMAT (/' EVIDENCE OF CONVERGENCE')
5700 FORMAT (/' Minimum found after',i5,' function evaluations')
5701 FORMAT (/' Minimum found after',i5,' function evaluations per processor')
5800 FORMAT (' Minimum at',4(/' ', 6G13.6))
5900 FORMAT (' Function value at minimum =', g14.6)
6000 FORMAT (/' Fitting quadratic surface about supposed minimum'/)
6100 FORMAT (/' MATRIX OF ESTIMATED SECOND DERIVATIVES NOT +VE DEFN.'/ &
             ' MINIMUM PROBABLY NOT FOUND'/)
6200 FORMAT (/t11, 'Search restarting'/)
6300 FORMAT (' Minimum of quadratic surface =',g14.6,' at',4(/' ', 6G13.5))
6400 FORMAT (' IF THIS DIFFERS BY MUCH FROM THE MINIMUM ESTIMATED ',      &
             'FROM THE MINIMIZATION,'/' THE MINIMUM MAY BE FALSE &/OR THE ',  &
             'INFORMATION MATRIX MAY BE INACCURATE'/)
6500 FORMAT (' Rank of information matrix =',i3/ &
             ' Inverse of information matrix:-')
6600 FORMAT (/' If the function minimized was -LOG(LIKELIHOOD),'/         &
             ' this is the covariance matrix of the parameters.'/         &
             ' If the function was a sum of squares of residuals,'/       &
             ' this matrix must be multiplied by twice the estimated ',   &
             'residual variance'/' to obtain the covariance matrix.'/)
6700 FORMAT (' INFORMATION MATRIX:-'/)
6800 FORMAT (/' CORRELATION MATRIX:-')
6900 FORMAT (/' A further',i4,' function evaluations have been used'/)

call MPI_Finalize(mpierr)

END SUBROUTINE pminim




SUBROUTINE syminv(a, n, c, w, nullty, ifault, rmax)

!     ALGORITHM AS7, APPLIED STATISTICS, VOL.17, 1968.

!     ARGUMENTS:-
!     A()    = INPUT, THE SYMMETRIC MATRIX TO BE INVERTED, STORED IN
!                LOWER TRIANGULAR FORM
!     N      = INPUT, ORDER OF THE MATRIX
!     C()    = OUTPUT, THE INVERSE OF A (A GENERALIZED INVERSE IF C IS
!                SINGULAR), ALSO STORED IN LOWER TRIANGULAR FORM.
!                C AND A MAY OCCUPY THE SAME LOCATIONS.
!     W()    = WORKSPACE, DIMENSION AT LEAST N.
!     NULLTY = OUTPUT, THE RANK DEFICIENCY OF A.
!     IFAULT = OUTPUT, ERROR INDICATOR
!                 = 1 IF N < 1
!                 = 2 IF A IS NOT +VE SEMI-DEFINITE
!                 = 0 OTHERWISE
!     RMAX   = OUTPUT, APPROXIMATE BOUND ON THE ACCURACY OF THE DIAGONAL
!                ELEMENTS OF C.  E.G. IF RMAX = 1.E-04 THEN THE DIAGONAL
!                ELEMENTS OF C WILL BE ACCURATE TO ABOUT 4 DEC. DIGITS.

!     LATEST REVISION - 1 April 1985

!***************************************************************************

REAL(8), INTENT(IN OUT) :: a(:), c(:), w(:)
INTEGER, INTENT(IN)       :: n
INTEGER, INTENT(OUT)      :: nullty, ifault
REAL(8), INTENT(OUT)    :: rmax

REAL(8), PARAMETER :: zero = 0._dp, one = 1._dp
INTEGER              :: i, icol, irow, j, jcol, k, l, mdiag, ndiag, nn, nrow
REAL(8)            :: x

nrow = n
ifault = 1
IF (nrow > 0) THEN
  ifault = 0

!     CHOLESKY FACTORIZATION OF A, RESULT IN C

  CALL chola(a, nrow, c, nullty, ifault, rmax, w)
  IF (ifault == 0) THEN

!     INVERT C & FORM THE PRODUCT (CINV)'*CINV, WHERE CINV IS THE INVERSE
!     OF C, ROW BY ROW STARTING WITH THE LAST ROW.
!     IROW = THE ROW NUMBER, NDIAG = LOCATION OF LAST ELEMENT IN THE ROW.

    nn = nrow * (nrow+1) / 2
    irow = nrow
    ndiag = nn
    10 IF (c(ndiag) /= zero) THEN
      l = ndiag
      DO i = irow, nrow
        w(i) = c(l)
        l = l + i
      END DO
      icol = nrow
      jcol = nn
      mdiag = nn

      30 l = jcol
      x = zero
      IF (icol == irow) x = one / w(irow)
      k = nrow
      40 IF (k /= irow) THEN
        x = x - w(k) * c(l)
        k = k - 1
        l = l - 1
        IF (l > mdiag) l = l - k + 1
        GO TO 40
      END IF

      c(l) = x / w(irow)
      IF (icol == irow) GO TO 60
      mdiag = mdiag - icol
      icol = icol - 1
      jcol = jcol - 1
      GO TO 30
    END IF ! (c(ndiag) /= zero)

    l = ndiag
    DO j = irow, nrow
      c(l) = zero
      l = l + j
    END DO

    60 ndiag = ndiag - irow
    irow = irow - 1
    IF (irow /= 0) GO TO 10
  END IF
END IF
RETURN

END SUBROUTINE syminv



SUBROUTINE chola(a, n, u, nullty, ifault, rmax, r)

!     ALGORITHM AS6, APPLIED STATISTICS, VOL.17, 1968, WITH
!     MODIFICATIONS BY A.J.MILLER

!     ARGUMENTS:-
!     A()    = INPUT, A +VE DEFINITE MATRIX STORED IN LOWER-TRIANGULAR
!                FORM.
!     N      = INPUT, THE ORDER OF A
!     U()    = OUTPUT, A LOWER TRIANGULAR MATRIX SUCH THAT U*U' = A.
!                A & U MAY OCCUPY THE SAME LOCATIONS.
!     NULLTY = OUTPUT, THE RANK DEFICIENCY OF A.
!     IFAULT = OUTPUT, ERROR INDICATOR
!                 = 1 IF N < 1
!                 = 2 IF A IS NOT +VE SEMI-DEFINITE
!                 = 0 OTHERWISE
!     RMAX   = OUTPUT, AN ESTIMATE OF THE RELATIVE ACCURACY OF THE
!                DIAGONAL ELEMENTS OF U.
!     R()    = OUTPUT, ARRAY CONTAINING BOUNDS ON THE RELATIVE ACCURACY
!                OF EACH DIAGONAL ELEMENT OF U.

!     LATEST REVISION - 1 April 1985

!***************************************************************************

REAL(8), INTENT(IN)   :: a(:)
INTEGER, INTENT(IN)     :: n
REAL(8), INTENT(OUT)  :: u(:)
INTEGER, INTENT(OUT)    :: nullty, ifault
REAL(8), INTENT(OUT)  :: rmax, r(:)

!     ETA SHOULD BE SET EQUAL TO THE SMALLEST +VE VALUE SUCH THAT
!     1._dp + ETA IS CALCULATED AS BEING GREATER THAN 1._dp IN THE ACCURACY
!     BEING USED.

REAL(8), PARAMETER :: eta = EPSILON(1.0_dp), zero = 0._dp
INTEGER              :: i, icol, irow, j, k, l, m
REAL(8)            :: rsq, w

ifault = 1
IF (n > 0) THEN
  ifault = 2
  nullty = 0
  rmax = eta
  r(1) = eta
  j = 1
  k = 0

!     FACTORIZE COLUMN BY COLUMN, ICOL = COLUMN NO.

  DO  icol = 1, n
    l = 0

!     IROW = ROW NUMBER WITHIN COLUMN ICOL

    DO  irow = 1, icol
      k = k + 1
      w = a(k)
      IF (irow == icol) rsq = (w*eta) ** 2
      m = j
      DO  i = 1, irow
        l = l + 1
        IF (i == irow) EXIT
        w = w - u(l) * u(m)
        IF (irow == icol) rsq = rsq + (u(l)**2*r(i)) ** 2
        m = m + 1
      END DO

      IF (irow == icol) EXIT
      IF (u(l) /= zero) THEN
        u(k) = w / u(l)
      ELSE
        u(k) = zero
        IF (ABS(w) > ABS(rmax*a(k))) GO TO 60
      END IF
    END DO

!     END OF ROW, ESTIMATE RELATIVE ACCURACY OF DIAGONAL ELEMENT.

    rsq = SQRT(rsq)
    IF (ABS(w) > 5.*rsq) THEN
      IF (w < zero) RETURN
      u(k) = SQRT(w)
      r(i) = rsq / w
      IF (r(i) > rmax) rmax = r(i)
    ELSE
      u(k) = zero
      nullty = nullty + 1
    END IF

    j = j + icol
  END DO
  ifault = zero
END IF
60 RETURN

END SUBROUTINE chola



SUBROUTINE print_tri_matrix(a, n, lout)

INTEGER, INTENT(IN)    :: n, lout
REAL(8), INTENT(IN)  :: a(:)

!     Local variables
INTEGER  :: i, ii, i1, i2, l

l = 1
DO l = 1, n, 6
  ii = l * (l-1) / 2
  DO i = l, n
    i1 = ii + l
    ii = ii + i
    i2 = MIN(ii,i1+5)
    WRITE (lout,'(1X,6G13.5)') a(i1:i2)
  END DO
END DO
RETURN

END SUBROUTINE print_tri_matrix

! QsortC2
!  IF have and arrays A and B
! with each element of B corresponding to an entry of A,
! sort both A and the B by the entries of A.
! Like row sort.

recursive subroutine QsortC2(A,B)
  real(8), intent(in out), dimension(:) :: A
  real(8), intent(in out), dimension(:) :: B
  integer :: iq

  if(size(A) > 1) then
     call Partition2(A,B,iq)
     call QsortC2(A(:iq-1),B(:iq-1))
     call QsortC2(A(iq:),B(iq:))
  endif
end subroutine QsortC2

subroutine Partition2(A,B,marker)
  real(8), intent(in out), dimension(:) :: A
  real(8), intent(in out), dimension(:) :: B
  integer, intent(out) :: marker
  integer :: i, j
  real(8) :: temp
  real(8) :: temp1
  real(8) :: x      ! pivot point
  x = A(1)
  i= 0
  j= size(A) + 1

  do
     j = j-1
     do
        if (A(j) <= x) exit
        j = j-1
     end do
     i = i+1
     do
        if (A(i) >= x) exit
        i = i+1
     end do
     if (i < j) then
        ! exchange A(i) and A(j), B(i) and B(j)
        temp = A(i)
        A(i) = A(j)
        A(j) = temp
        temp1 = B(i)
        B(i) = B(j)
        B(j) = temp1
     elseif (i == j) then
        marker = i+1
        return
     else
        marker = i
        return
     endif
  end do

end subroutine Partition2

! QsortC3
!  IF have and array A and 2D array B
! with each row of B corresponding to an entry of A,
! sort both A and the rows of B by the entries of A.
! Like row sort.

recursive subroutine QsortC3(A,B)
  real(8), intent(in out), dimension(:) :: A
  real(8), intent(in out), dimension(:,:) :: B
  integer :: iq

  if(size(A) > 1) then
     call Partition3(A,B,iq)
     call QsortC3(A(:iq-1),B(:iq-1,:))
     call QsortC3(A(iq:),B(iq:,:))
  endif
end subroutine QsortC3

subroutine Partition3(A,B,marker)
  real(8), intent(in out), dimension(:) :: A
  real(8), intent(in out), dimension(:,:) :: B
  integer, intent(out) :: marker
  integer :: i, j
  real(8) :: temp
  real(8), dimension(size(B,2)) :: temp1
  real(8) :: x      ! pivot point
  x = A(1)
  i= 0
  j= size(A) + 1

  do
     j = j-1
     do
        if (A(j) <= x) exit
        j = j-1
     end do
     i = i+1
     do
        if (A(i) >= x) exit
        i = i+1
     end do
     if (i < j) then
        ! exchange A(i) and A(j), B(i,:) and B(j,:)
        temp = A(i)
        A(i) = A(j)
        A(j) = temp
        temp1 = B(i,:)
        B(i,:) = B(j,:)
        B(j,:) = temp1
     elseif (i == j) then
        marker = i+1
        return
     else
        marker = i
        return
     endif
  end do

end subroutine Partition3

! function_distribute: Evaluate a function at an array of points, dividing
!     the function calls among the available processors
SUBROUTINE function_distribute(npoints,minrank,maxrank,points,vals,nevalsp,functn,myrank)
    INTEGER, INTENT(IN) :: npoints ! number of points to be evaluated
    INTEGER, INTENT(IN) :: minrank,maxrank ! range of processes/groups to distribute over
    REAL(8), DIMENSION(:,:), INTENT(IN) ::  points ! npoints x nop points to evaluate at
    REAL(8), DIMENSION(:), INTENT(OUT) :: vals ! function values at each point
    INTEGER, INTENT(OUT) :: nevalsp ! number of evaluations per processor
    EXTERNAL functn ! function to be evaluated
    INTEGER, INTENT(IN) :: myrank ! group/communicator of current processor

    INTEGER :: nrounds,nround,mpierr,i,nprocs,IERR

    real(dp) :: timing(2)
    
    !CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank,mpierr)
	!CALL MPI_Comm_rank(comm,i,mpierr)
	!print*, "Here is ", myrank,i !,myrank_world
    !CALL MPI_Comm_size(MPI_COMM_WORLD,nprocs,mpierr)
    !print*, "myrank,myrank_world ",myrank,myrank_world
    
    nprocs=maxrank-minrank+1
    nrounds=npoints/nprocs ! number of full rounds
    DO nround=1,nrounds
      DO i=1,nprocs
        IF (i==myrank-minrank+1) THEN
            timing(1)=MPI_WTIME()
		CALL functn(points(i+nprocs*(nround-1),:),vals(i+nprocs*(nround-1)))	
            timing(2)=MPI_WTIME()		
            !write(*,'("After functn ",2I4,F14.4,F10.2)') myrank,i+nprocs*(nround-1),vals(i+nprocs*(nround-1)),timing(2)-timing(1)
        ENDIF
      ENDDO
      DO i=1,nprocs
		!PRINT*, "Bfre bcast ",MYRANK,i+nprocs*(nround-1),vals(i+nprocs*(nround-1))
        CALL MPI_BCAST(vals(i+nprocs*(nround-1)),1,MPI_REAL8,i-1,MPI_COMM_WORLD,mpierr) 		
		!IF (MYRANK_WORLD==I) PRINT*, MYRANK,i+nprocs*(nround-1)
		!PRINT*, "After bcast ",MYRANK,i+nprocs*(nround-1),vals(i+nprocs*(nround-1))
	  ENDDO
    ENDDO
	  		!print*, myrank,myrank_world,vals(1:15)

			
			
    DO i=1,npoints-nprocs*nrounds
      IF (i==myrank-minrank+1) THEN
	  !print*, "second if ",myrank,myrank_world,  i+nprocs*(nround-1)
        CALL functn(points(i+nprocs*nrounds,:),vals(i+nprocs*nrounds))
      ENDIF
    ENDDO
    DO i=1,npoints-nrounds*nprocs
	CALL MPI_BCAST(vals(i+nrounds*nprocs),1,MPI_REAL8,i-1,MPI_COMM_WORLD,mpierr)
    ENDDO
    
	!if (myrank==1) then 
	!	print*, "myrank and vals ",myrank,
	
	!	print*, vals
	!end if 
    IF (npoints==nprocs+nrounds) THEN
      nevalsp=nrounds
    ELSE
      nevalsp=nrounds+1
    ENDIF

END SUBROUTINE function_distribute

END MODULE pNelder_Mead

	SUBROUTINE indexx_sp(arr,index)
	USE nrtype; USE nrutil, ONLY : arth,assert_eq,nrerror,swap
	IMPLICIT NONE
	REAL(SP), DIMENSION(:), INTENT(IN) :: arr
	INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: index
	INTEGER(I4B), PARAMETER :: NN=15, NSTACK=50
	REAL(SP) :: a
	INTEGER(I4B) :: n,k,i,j,indext,jstack,l,r
	INTEGER(I4B), DIMENSION(NSTACK) :: istack
	n=assert_eq(size(index),size(arr),'indexx_sp')
	index=arth(1,1,n)
	jstack=0
	l=1
	r=n
	do
		if (r-l < NN) then
			do j=l+1,r
				indext=index(j)
				a=arr(indext)
				do i=j-1,l,-1
					if (arr(index(i)) <= a) exit
					index(i+1)=index(i)
				end do
				index(i+1)=indext
			end do
			if (jstack == 0) RETURN
			r=istack(jstack)
			l=istack(jstack-1)
			jstack=jstack-2
		else
			k=(l+r)/2
			call swap(index(k),index(l+1))
			call icomp_xchg(index(l),index(r))
			call icomp_xchg(index(l+1),index(r))
			call icomp_xchg(index(l),index(l+1))
			i=l+1
			j=r
			indext=index(l+1)
			a=arr(indext)
			do
				do
					i=i+1
					if (arr(index(i)) >= a) exit
				end do
				do
					j=j-1
					if (arr(index(j)) <= a) exit
				end do
				if (j < i) exit
				call swap(index(i),index(j))
			end do
			index(l+1)=index(j)
			index(j)=indext
			jstack=jstack+2
			if (jstack > NSTACK) call nrerror('indexx: NSTACK too small')
			if (r-i+1 >= j-l) then
				istack(jstack)=r
				istack(jstack-1)=i
				r=j-1
			else
				istack(jstack)=j-1
				istack(jstack-1)=l
				l=i
			end if
		end if
	end do
	CONTAINS
!BL
	SUBROUTINE icomp_xchg(i,j)
	INTEGER(I4B), INTENT(INOUT) :: i,j
	INTEGER(I4B) :: swp
	if (arr(j) < arr(i)) then
		swp=i
		i=j
		j=swp
	end if
	END SUBROUTINE icomp_xchg
	END SUBROUTINE indexx_sp

	SUBROUTINE indexx_i4b(iarr,index)
	USE nrtype; USE nrutil, ONLY : arth,assert_eq,nrerror,swap
	IMPLICIT NONE
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: iarr
	INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: index
	INTEGER(I4B), PARAMETER :: NN=15, NSTACK=50
	INTEGER(I4B) :: a
	INTEGER(I4B) :: n,k,i,j,indext,jstack,l,r
	INTEGER(I4B), DIMENSION(NSTACK) :: istack
	n=assert_eq(size(index),size(iarr),'indexx_sp')
	index=arth(1,1,n)
	jstack=0
	l=1
	r=n
	do
		if (r-l < NN) then
			do j=l+1,r
				indext=index(j)
				a=iarr(indext)
				do i=j-1,l,-1
					if (iarr(index(i)) <= a) exit
					index(i+1)=index(i)
				end do
				index(i+1)=indext
			end do
			if (jstack == 0) RETURN
			r=istack(jstack)
			l=istack(jstack-1)
			jstack=jstack-2
		else
			k=(l+r)/2
			call swap(index(k),index(l+1))
			call icomp_xchg(index(l),index(r))
			call icomp_xchg(index(l+1),index(r))
			call icomp_xchg(index(l),index(l+1))
			i=l+1
			j=r
			indext=index(l+1)
			a=iarr(indext)
			do
				do
					i=i+1
					if (iarr(index(i)) >= a) exit
				end do
				do
					j=j-1
					if (iarr(index(j)) <= a) exit
				end do
				if (j < i) exit
				call swap(index(i),index(j))
			end do
			index(l+1)=index(j)
			index(j)=indext
			jstack=jstack+2
			if (jstack > NSTACK) call nrerror('indexx: NSTACK too small')
			if (r-i+1 >= j-l) then
				istack(jstack)=r
				istack(jstack-1)=i
				r=j-1
			else
				istack(jstack)=j-1
				istack(jstack-1)=l
				l=i
			end if
		end if
	end do
	CONTAINS
!BL
	SUBROUTINE icomp_xchg(i,j)
	INTEGER(I4B), INTENT(INOUT) :: i,j
	INTEGER(I4B) :: swp
	if (iarr(j) < iarr(i)) then
		swp=i
		i=j
		j=swp
	end if
	END SUBROUTINE icomp_xchg
	END SUBROUTINE indexx_i4b
	SUBROUTINE sort2(arr,slave)
	USE nrtype; USE nrutil, ONLY : assert_eq
	USE nr, ONLY : indexx
	IMPLICIT NONE
	REAL(SP), DIMENSION(:), INTENT(INOUT) :: arr,slave
	INTEGER(I4B) :: ndum
	INTEGER(I4B), DIMENSION(size(arr)) :: index
	ndum=assert_eq(size(arr),size(slave),'sort2')
	call indexx(arr,index)
	arr=arr(index)
	slave=slave(index)
	END SUBROUTINE sort2
	FUNCTION locate(xx,x)
	USE nrtype
	IMPLICIT NONE
	REAL(SP), DIMENSION(:), INTENT(IN) :: xx
	REAL(SP), INTENT(IN) :: x
	INTEGER(I4B) :: locate
	INTEGER(I4B) :: n,jl,jm,ju
	LOGICAL :: ascnd
	n=size(xx)
	ascnd = (xx(n) >= xx(1))
	jl=0
	ju=n+1
	do
		if (ju-jl <= 1) exit
		jm=(ju+jl)/2
		if (ascnd .eqv. (x >= xx(jm))) then
			jl=jm
		else
			ju=jm
		end if
	end do
	if (x == xx(1)) then
		locate=1
	else if (x == xx(n)) then
		locate=n-1
	else
		locate=jl
	end if
	END FUNCTION locate
	SUBROUTINE gauher(x,w)
	USE nrtype; USE nrutil, ONLY : arth,assert_eq,nrerror
	IMPLICIT NONE
	REAL(SP), DIMENSION(:), INTENT(OUT) :: x,w
	REAL(DP), PARAMETER :: EPS=3.0e-13_dp,PIM4=0.7511255444649425_dp
	INTEGER(I4B) :: its,j,m,n
	INTEGER(I4B), PARAMETER :: MAXIT=10
	REAL(SP) :: anu
	REAL(SP), PARAMETER :: C1=9.084064e-01_sp,C2=5.214976e-02_sp,&
		C3=2.579930e-03_sp,C4=3.986126e-03_sp
	REAL(SP), DIMENSION((size(x)+1)/2) :: rhs,r2,r3,theta
	REAL(DP), DIMENSION((size(x)+1)/2) :: p1,p2,p3,pp,z,z1
	LOGICAL(LGT), DIMENSION((size(x)+1)/2) :: unfinished
	n=assert_eq(size(x),size(w),'gauher')
	m=(n+1)/2
	anu=2.0_sp*n+1.0_sp
	rhs=arth(3,4,m)*PI/anu
	r3=rhs**(1.0_sp/3.0_sp)
	r2=r3**2
	theta=r3*(C1+r2*(C2+r2*(C3+r2*C4)))
	z=sqrt(anu)*cos(theta)
	unfinished=.true.
	do its=1,MAXIT
		where (unfinished)
			p1=PIM4
			p2=0.0
		end where
		do j=1,n
			where (unfinished)
				p3=p2
				p2=p1
				p1=z*sqrt(2.0_dp/j)*p2-sqrt(real(j-1,dp)/real(j,dp))*p3
			end where
		end do
		where (unfinished)
			pp=sqrt(2.0_dp*n)*p2
			z1=z
			z=z1-p1/pp
			unfinished=(abs(z-z1) > EPS)
		end where
		if (.not. any(unfinished)) exit
	end do
	if (its == MAXIT+1) call nrerror('too many iterations in gauher')
	x(1:m)=z
	x(n:n-m+1:-1)=-z
	w(1:m)=2.0_dp/pp**2
	w(n:n-m+1:-1)=w(1:m)
	END SUBROUTINE gauher

MODULE alib
	USE nrtype
	USE nrutil
	USE nr
	IMPLICIT NONE
	real(dp), PARAMETER :: SQRTPI=1.7724539_dp

	INTERFACE logit
	MODULE PROCEDURE logit_scalar,logit_vec,logit_scalar_dble,logit_vec_dble
	END INTERFACE
	
	
	INTERFACE min2pls
	MODULE PROCEDURE min2pls_scalar,min2pls_vec,min2pls_scalar_dble,min2pls_vec_dble
	END INTERFACE

	INTERFACE multinom
	MODULE PROCEDURE multinom_sngl, multinom_dble
	END INTERFACE


	INTERFACE condmom
	MODULE PROCEDURE condmom1_sngl, condmom2_sngl,condmom1_dble, condmom2_dble
	END INTERFACE

	INTERFACE one
	MODULE PROCEDURE one0, one1, one2, one3
	END INTERFACE

CONTAINS
	!Pdf of normal with mean mu and stdev sigma
	FUNCTION normpdf(x,mu,sigma)
	real(dp), DIMENSION(:), INTENT(IN) :: x
	real(dp), INTENT(IN) :: mu,sigma
	real(dp), DIMENSION(size(x)) :: normpdf
	normpdf=1.0_dp/ sigma*sqrt(2.0_dp)*SQRTPI * exp(-(x-mu)**2/2.0_dp*sigma**2 ) 
	END FUNCTION normpdf

	!Pdf of log-normal with mean mu and stdev sigma
	FUNCTION normpdfl(x,mu,sigma) 
	real(dp), DIMENSION(:), INTENT(IN) :: x
	real(dp), INTENT(IN) :: mu,sigma
	real(dp), DIMENSION(size(x)) :: normpdfl
	normpdfl=1.0_dp/ x*sigma*sqrt(2.0_dp)*SQRTPI * exp(-(log(x)-mu)**2/2.0_dp*sigma**2 ) 
	END FUNCTION normpdfl

	!For calculating conditional expectation of a normal random variable using nr's gauleg. Used by gauleg. 
	FUNCTION funcn(x,mu,sigma) 
	real(dp), DIMENSION(:), INTENT(IN) :: x
	real(dp), INTENT(IN) :: mu,sigma
	real(dp), DIMENSION(size(x)) :: funcn
	funcn=x*normpdf(x,mu,sigma)
	END FUNCTION funcn

	!Uses GAUSSBIN from SLgenlib to get the prob weights on the variables that are 
	!joint normal with mean 0 and sig(1:2) and ro and using a given grid
	SUBROUTINE anormjnt2(npoint,sig,ro,grid,wgtcond)
	INTEGER(I4B), INTENT(IN) :: NPOINT
	real(dp), INTENT(IN) :: sig(2),ro
	real(dp), DIMENSION(NPOINT), INTENT(IN) :: grid
	real(dp), DIMENSION(NPOINT,2,2) :: wgtcond
	INTEGER(I4B) :: i
	real(dp), PARAMETER :: mu(2)=0.0_dp
	real(dp) :: mq,sq,varcov(2,2),wgt(NPOINT,2)
	varcov(1,1)=sig(1)**2.0
	varcov(2,2)=sig(2)**2.0 
	varcov(1,2)=ro*sig(1)*sig(2)
	varcov(2,1)=varcov(1,2)
	do i=1,NPOINT
		mq=grid(i)*varcov(1,2)/varcov(1,1)
		sq=varcov(1,1)*(1.0_dp-ro**2)
		sq=sq**0.5_dp
		!call gaussbin(mq,sq,grid,wgtcond(:,i,1))

		mq=grid(i)*varcov(1,2)/varcov(2,2)
		sq=varcov(2,2)*(1.0_dp-ro**2)
		sq=sq**0.5_dp
		!call gaussbin(mq,sq,grid,wgtcond(:,i,2))
	end do 
	write(*,'(/1x,t3,a,t10,a,t22,a/)') '#','GRID(I)','WGT1COND2(:,I)','WGT2COND1(:,I)'
	do i=1,NPOINT
		write(*,'(1x,i2,3f12.6)') i,grid(i),wgtcond(:,i,1),wgtcond(:,i,2)
	end do
	!The below is to check the results of the above 
	! gaussbin- takes in paramters of continuous normal distribution (mu, sigma) and vector
	! of allowed values (values) and calculates fraction of outcomes closest to
	! each element in vector, i.e. a discrete approximation to that normal distribution
	!call gaussbin(mu(1),sig(1),grid,wgt(:,1))
	!call gaussbin(mu(2),sig(2),grid,wgt(:,2))		
	write(*,'(/1x,t3,a,t10,a,t22,a/)') '#','WGT(i,1)','SUM'
		do i=1,NPOINT
			write(*,'(I4,2F12.4)') i,wgt(i,1),sum(wgt(:,2)*wgtcond(:,i,1))
		end do 
	END SUBROUTINE anormjnt2

	! transforms number on real line into [0,1] using logit transformation
	FUNCTION logit_scalar(xx)
	real, INTENT(IN) :: xx
	real :: logit_scalar
	logit_scalar=EXP(xx)/(1.0_dp+EXP(xx))
	END FUNCTION logit_scalar

	FUNCTION logit_vec(xx)
	real, DIMENSION(:), INTENT(IN) :: xx
	real, DIMENSION(size(xx)) :: logit_vec
	logit_vec=EXP(xx)/(1.0_dp+EXP(xx))
	END FUNCTION logit_vec

	FUNCTION logit_scalar_dble(xx)
	real(dp), INTENT(IN) :: xx
	real(dp) :: logit_scalar_dble
	logit_scalar_dble=EXP(xx)/(1.0_dp+EXP(xx))
	END FUNCTION logit_scalar_dble

	FUNCTION logit_vec_dble(xx)
	real(dp), DIMENSION(:), INTENT(IN) :: xx
	real(dp), DIMENSION(size(xx)) :: logit_vec_dble
	logit_vec_dble=EXP(xx)/(1.0_dp+EXP(xx))
	END FUNCTION logit_vec_dble
    
	
	! inverse of logit transformation
	FUNCTION logitinv(xx)
	REAL(DP), INTENT(IN) :: xx  
	REAL(DP) :: logitinv
	REAL(DP) :: xmin,xmax
	xmin=0.000001_dp
	xmax=0.999999_dp     
	IF (xx<xmin) THEN
		logitinv=LOG(xmin/(1.0_dp-xmin))
	ELSEIF (xx>xmax) THEN
		logitinv=LOG(xmax/(1.0_dp-xmax))
	ELSE
		logitinv=LOG(xx/(1.0_dp-xx))
	ENDIF        
	END FUNCTION


	FUNCTION min2pls_scalar(xx)
	! transforms any real number into something at the [-1.0,1.0] interval
	real, INTENT(IN) :: xx
	real :: min2pls_scalar
	min2pls_scalar=2.0_dp*(1.0_dp/(1.0_dp+exp(-xx)))-1.0_dp 
	END FUNCTION
	FUNCTION min2pls_vec(xx)
	! transforms any real number into something at the [-1.0,1.0] interval
	real, DIMENSION(:), INTENT(IN) :: xx
	real, DIMENSION(size(xx)) :: min2pls_vec
	min2pls_vec=2.0_dp*(1.0_dp/(1.0_dp+exp(-xx)))-1.0_dp 
	END FUNCTION


	FUNCTION min2pls_scalar_dble(xx)
	! transforms any real number into something at the [-1.0,1.0] interval
	real(dp), INTENT(IN) :: xx
	real(dp) :: min2pls_scalar_dble
	min2pls_scalar_dble=2.0_dp*(1.0_dp/(1.0_dp+exp(-xx)))-1.0_dp 
	END FUNCTION 
	FUNCTION min2pls_vec_dble(xx)
	! transforms any real number into something at the [-1.0,1.0] interval
	real(dp), DIMENSION(:), INTENT(IN) :: xx
	real(dp), DIMENSION(size(xx)) :: min2pls_vec_dble
	min2pls_vec_dble=2.0_dp*(1.0_dp/(1.0_dp+exp(-xx)))-1.0_dp 
	END FUNCTION

	FUNCTION min2plsinv(yy)	
	! transforms any real number into something at the [-1.0,1.0] interval
	real(dp), INTENT(IN) :: yy
	real(dp) :: min2plsinv
	min2plsinv=logitinv(  (yy+1)/2.0_dp ) 
	END FUNCTION
    
    
	SUBROUTINE cholesky (a,n,p)
	implicit none
	INTEGER(I4B),intent(in)::n
	real(dp), DIMENSION(n,n),intent(in)::a
	real(dp), DIMENSION(n,n),intent(out)::p
	real(dp), DIMENSION(n,n)::aa
	real(dp) :: sum
	INTEGER(I4B) i,j,k
	sum = 0.0_dp
	aa(1:n,1:n)=a(1:n,1:n)
	do 13 i = 1,n
		do 12 j = i,n
			sum=aa(i,j)
			do 11 k = i-1,1,-1
				sum = sum - aa(i,k)*aa(j,k)
11			continue 
			if (i.eq.j) then
				if (sum.le.0.0_dp) stop 'choldc failed'
				p(i,i) = dsqrt(sum)
			else
				aa(j,i) = sum/p(i,i)
				p(j,i) = aa(j,i)
			end if
12		continue
13	continue
	return
	end SUBROUTINE cholesky

	SUBROUTINE getcholesky(sig,ro,cd)	
	real(dp), INTENT(IN) :: sig(2),ro  !,rho(2,2)	!rho is the correlation matrix and cd is the cholesky decomposition which is declared in global
	real(dp), INTENT(OUT) :: cd(2,2)
	INTEGER(I4B) :: j,k 
	real(dp) :: rho(2,2) 
	!**********************************************************************
	!*Call Cholesky routine that does the following:                      *
	!*Construct the covariance matrix btw male and female wage draws      *
	!*Take Cholesky Decomposition of the covariance matrix                *
	!**********************************************************************
	cd=0.0_dp 
	!Construct the correlation matrix. And then using the corr matrix, construct the cov matrix
	!sigma(1)=sig(1)   
	!sigma(2)=sig(2)	
	RHO(1,1)=1.0_dp		
	RHO(2,2)=1.0_dp		
	RHO(2,1)=ro		
	RHO(1,2)=RHO(2,1)
	!if (myid.eq.0) then
	!	print*, "Here are the sigmas: ", sig_w1,sig_w2,ro
	!	print*, "Here is the correlation matrix: "
	!	print*, RHO(1,1),RHO(1,2)
	!	print*, RHO(2,1),RHO(2,2)
	!end if
	!Now turn correlation matrix into varcov matrix
	do j=1,2
		do k=1,2
			RHO(j,k)=RHO(j,k)*sig(j)*sig(k)
		end do 
	end do 
	!if (myid.eq.0) then
	!	print*, "Here is the covariance matrix: "
	!	print*, RHO(1,1),RHO(1,2)
	!	print*, RHO(2,1),RHO(2,2)
	!end if
	!now get the cholesky decomposition
	call cholesky (RHO,2,CD)
	!!if (myid.eq.0) then
	!!	print*, "Here is the cholesky decomposition: ", sig_w1,sig_w2,ro
	!!	print*, CDM(1,1),CDM(1,2)
	!!	print*, CDM(2,1),CDM(2,2)
	!!end if
	END SUBROUTINE getcholesky

	! convert from n-dimensional index to linear one
	FUNCTION ndim2lin(dims,nindex)
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: dims !like outpit of size(A)- vector
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: nindex !n-dimensional index- row vector
	INTEGER(I4B) :: ndim2lin
	INTEGER(I4B), DIMENSION(SIZE(dims)-1) :: cumprod ! running cumulative product of dims
	INTEGER(I4B) :: ii,ndims 
	ndims=SIZE(dims)
	cumprod(1)=dims(1)
	DO ii=2,ndims-1
		cumprod(ii)=dims(ii)*cumprod(ii-1)
	ENDDO
	ndim2lin=nindex(1)+SUM(cumprod*(nindex(2:ndims)-1))
	END FUNCTION ndim2lin
    
    ! convert from linear index to n-dimensional one
	FUNCTION lin2ndim(dims,linindex)
	INTEGER(I4B), DIMENSION(:), INTENT(IN) :: dims ! like outpit of size(A)
	INTEGER(I4B), INTENT(IN) :: linindex ! linear index
	INTEGER(I4B) :: lin2ndim(SIZE(dims)) 
	INTEGER(I4B) :: nn, prod, linindexcopy,ndims        
	ndims=SIZE(dims)
	linindexcopy=linindex
	DO nn=NDims,2,-1
		!WRITE(*,*) linindexcopy
		prod=PRODUCT(dims(1:nn-1))
		lin2ndim(nn)=CEILING(REAL(linindexcopy)/prod)
		linindexcopy=MOD(linindexcopy,prod)
		IF (linindexcopy==0) THEN
			linindexcopy=prod
		ENDIF
	ENDDO
	lin2ndim(1)=linindexcopy        
	END FUNCTION lin2ndim

	RECURSIVE FUNCTION recsum(n)  result(rec)
	!-----Recsum------------------------------------------------------
	!  FUNCTION to calculate sums recursively
	!---------------------------------------------------------------------
	INTEGER(I4B) :: rec
	INTEGER(I4B), intent(in) :: n
	if (n == 0) then
		rec = 0
	else
		rec = n + recsum(n-1)
	END if 
	END FUNCTION recsum

	! draw from a multinomal distribution.
	! Inputs are the vector of probabilities for each outcome and a U[0,1] random draw
	! Output is the index of the outcome
	FUNCTION multinom_sngl(probvec,randdraw)
		real(sp), DIMENSION(:), INTENT(IN) :: probvec ! probabilities of each state
		real(sp), INTENT(IN) :: randdraw ! U[0,1]
		real(sp) :: multinom_sngl
		INTEGER(I4B) :: nn
		real(sp) :: cutoff
		real(sp), DIMENSION(SIZE(probvec)) :: probvecnorm
		probvecnorm=probvec/SUM(probvec) ! normalize if probabilities don't sum to one 
		! cutoff is upper bound of interval that if randdraw falls in that interval, get current outcome
		cutoff=probvecnorm(1)
		nn=1
		DO WHILE (randdraw>cutoff)
			cutoff=cutoff+probvecnorm(nn+1)
			nn=nn+1
		ENDDO
		multinom_sngl=nn 
	END FUNCTION
	FUNCTION multinom_dble(probvec,randdraw)
		real(dp), DIMENSION(:), INTENT(IN) :: probvec ! probabilities of each state
		real(dp), INTENT(IN) :: randdraw ! U[0,1]
		real(dp) :: multinom_dble
		INTEGER(I4B) :: nn
		real(dp) :: cutoff
		real(dp), DIMENSION(SIZE(probvec)) :: probvecnorm
		probvecnorm=probvec/SUM(probvec) ! normalize if probabilities don't sum to one 
		! cutoff is upper bound of interval that if randdraw falls in that interval, get current outcome
		cutoff=probvecnorm(1)
		nn=1
		DO WHILE (randdraw>cutoff)
			cutoff=cutoff+probvecnorm(nn+1)
			nn=nn+1
		ENDDO
		multinom_dble=nn 
	END FUNCTION


	! condmom are subroutines that calculate conditional moments from arrays of data
	! condmom1 is for moments defined over a 1-dim array of observations
	! condmom2 is for moments defined over a 2-dim array of observations
	SUBROUTINE condmom1_sngl(im,cond,xx,moment,countmom,varmom)
	INTEGER(I4B), INTENT(IN) :: im
	LOGICAL, DIMENSION(:), INTENT(IN) :: cond ! condition that must be true for observation to contribute to the moment
	real(sp), DIMENSION(:), INTENT(IN) :: xx ! moment to be calculated
	real(sp), DIMENSION(:), INTENT(OUT) :: moment ! value of conditional moment
	INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: countmom ! number of observations contributing to each moment
	real(sp), DIMENSION(:), INTENT(OUT) :: varmom ! now CONDITIONAL variance of each moemnt	
	real(sp),PARAMETER :: d1=1.0_sp	
	countmom(im)=SUM(one(cond))
	moment(im)=SUM(xx,cond)/MAX(d1*countmom(im),0.1_sp)
	varmom(im)=SUM(xx**2,cond)/MAX(d1*countmom(im),0.1_sp) - (SUM(xx,cond)/MAX(d1*countmom(im),0.1_sp))**2
	END SUBROUTINE
	SUBROUTINE condmom2_sngl(im,cond,xx,moment,countmom,varmom)
	INTEGER(I4B), INTENT(IN) :: im
	LOGICAL, DIMENSION(:,:), INTENT(IN) :: cond ! condition that must be true for observation to contribute to the moment
	real(sp), DIMENSION(:,:), INTENT(IN) :: xx ! moment to be calculated
	real(sp), DIMENSION(:), INTENT(OUT) :: moment ! value of conditional moment
	INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: countmom ! number of observations contributing to each moment
	real(sp), DIMENSION(:), INTENT(OUT) :: varmom ! now CONDITIONAL variance of each moemnt	
	real(sp), PARAMETER :: d1=1.0_sp
	countmom(im)=SUM(one(cond))
	moment(im)=SUM(xx,cond)/MAX(d1*countmom(im),0.1_sp)
	varmom(im)=SUM(xx**2,cond)/MAX(d1*countmom(im),0.1_sp) - (SUM(xx,cond)/MAX(d1*countmom(im),0.1_sp))**2
	!varmom(im)=SUM(xx**2,cond)/SIZE(xx) - (SUM(xx,cond)/SIZE(xx))**2
	!ahu 081212: adding that whenever there is noone in that cell, the moment should be -1, not 0 as it is now 
	!because otherwise it is never clear, whether it is really 0 or that is just because there is noone in that cell 
	!ahu 082112 taking this out again because it causes the objective function to be too non-smooth
	!ahu 082112 if (countmom(im)==0) then
	!ahu 082112 	moment(im)=-1
	!ahu 082112 end if 
	!ahu 082112 taking this out again because it causes the objective function to be too non-smooth
	!ahu 101012: putting it back in temporarily
	!ahu 111412 if (countmom(im)==0) then
	!ahu 111412  	moment(im)=-1
	!ahu 111412 end if 
	END SUBROUTINE

	SUBROUTINE condmom1_dble(im,cond,xx,moment,countmom,varmom)
	INTEGER(I4B), INTENT(IN) :: im
	LOGICAL, DIMENSION(:), INTENT(IN) :: cond ! condition that must be true for observation to contribute to the moment
	real(dp), DIMENSION(:), INTENT(IN) :: xx ! moment to be calculated
	real(dp), DIMENSION(:), INTENT(OUT) :: moment ! value of conditional moment
	INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: countmom ! number of observations contributing to each moment
	real(dp), DIMENSION(:), INTENT(OUT) :: varmom ! now CONDITIONAL variance of each moemnt	
	real(dp),PARAMETER :: d1=1.0_dp	
	countmom(im)=SUM(one(cond))
	moment(im)=SUM(xx,cond)/MAX(d1*countmom(im),0.1_dp)
	varmom(im)=SUM(xx**2,cond)/MAX(d1*countmom(im),0.1_dp) - (SUM(xx,cond)/MAX(d1*countmom(im),0.1_dp))**2
	END SUBROUTINE
	SUBROUTINE condmom2_dble(im,cond,xx,moment,countmom,varmom)
	INTEGER(I4B), INTENT(IN) :: im
	LOGICAL, DIMENSION(:,:), INTENT(IN) :: cond ! condition that must be true for observation to contribute to the moment
	real(dp), DIMENSION(:,:), INTENT(IN) :: xx ! moment to be calculated
	real(dp), DIMENSION(:), INTENT(OUT) :: moment ! value of conditional moment
	INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: countmom ! number of observations contributing to each moment
	real(dp), DIMENSION(:), INTENT(OUT) :: varmom ! now CONDITIONAL variance of each moemnt	
	real(dp), PARAMETER :: d1=1.0_dp	
	countmom(im)=SUM(one(cond))
	moment(im)=SUM(xx,cond)/MAX(d1*countmom(im),0.1_dp)
	varmom(im)=SUM(xx**2,cond)/MAX(d1*countmom(im),0.1_dp) - (SUM(xx,cond)/MAX(d1*countmom(im),0.1_dp))**2
	END SUBROUTINE



	pure function one0(x)
	logical, intent(in):: x
	integer(i4b) one0
	one0=0
	if (x) one0=1
	end function one0

	pure function one1(x)
	logical, intent(in):: x(:)
	integer(I4B) one1(size(x))
	one1=0
	where (x) one1=1
	end function one1

	pure function one2(x)
	logical, intent(in):: x(:,:)
	integer(I4B) one2(size(x,1),size(x,2))
	one2=0
	where (x) one2=1
	end function one2

	pure function one3(x)
	logical, intent(in):: x(:,:,:)
	integer(I4B) one3(size(x,1),size(x,2),size(x,3))
	one3=0
	where (x) one3=1
	end function one3

	SUBROUTINE precisiontests
	! look at p.457 in the fortran book
	REAL(SP), PARAMETER :: dum=-10000000_sp,dum2=-1000000000_sp,dum5=0.00000000005_sp
	REAL(DP), PARAMETER :: dum5dp=0.00000000005_dp
	REAL(SP), PARAMETER :: dum6sp=0.12345972985_sp
	REAL(DP), PARAMETER :: dum6dp=0.12345972985_dp
	REAL(SP), PARAMETER :: dum7sp=12345972985.0_sp
	REAL(DP), PARAMETER :: dum7dp=12345972985.0_dp
	real(sp) :: test8sp=0.000000000050000000_sp !6.666666666666666 !, test2=0_dp, test3=0
	real(dp) :: test8dp=0.000000000050000000_dp !6.666666666666666 !, test2=0_dp, test3=0
	real(sp) :: test1sp=0.005_sp  !5_sp !0.00000000005_sp !  0 000 000_sp !6.666666666666666 !, test2=0_dp, test3=0
	real(dp) :: test1dp=0.005_dp  !5_sp !0.00000000005_sp !  0 000 000_sp !6.666666666666666 !, test2=0_dp, test3=0
	real(dp) :: test2=6.66666666666666 !, test2=0_dp, test3=0
	real(dp) :: test3=6.666666666666666_dp !, test2=0_dp, test3=0
	real(sp) :: test4=6.666666_sp
	REAL(SP) :: test5=6.60_sp,test6=6.60 !6.6666666_sp
	REAL(DP) :: test7=6.60_dp,test8=6.60,tempd !6.6666666_sp
	REAL(SP) :: temp,val(2)

	write(*,'(F20.15)') 2.0_dp+1.0_sp
	write(*,*) "Here is dum "
	write(*,'(2F20.2)') dum,dum2
	write(*,'(2F20.15)') dum5,dum5dp
	write(*,'(2F20.15,2I4)') dum6sp,dum6dp,precision(dum6sp),precision(dum6dp)
	write(*,'(2F20.2)') dum7sp,dum7dp
	write(*,*) kind(0.0),kind(0.0_sp),kind(0._sp)
	write(*,*) 2_sp*test1sp-0.01_sp
	write(*,*) "Here is test1sp and test1dp (0.005) "
	write(*,'(F10.5)') test8sp
	write(*,'(2F10.5)') test1sp,test1dp  !,kind(test1),precision(test1),kind(0.0),kind(0.0d0)  !,test2,test3
	write(*,*) test2,test3,kind(test2),kind(test3),precision(test2),precision(test3)
	write(*,*) test4,kind(test4),precision(test4)
	write(*,*) "test 5 and test 6 : "
	write(*,'(3F20.15)') test5,test6,test5-test6
	write(*,'(3F12.6)') test5,test6,test5-test6
	write(*,'(3F12.7)') test5,test6,test5-test6
	write(*,*) "test 7 and test 8 : "
	write(*,'(2F12.6,F20.15)') test7,test8,test7-test8
	write(*,'(3F20.15)') test7,test8,test7-test8
	write(*,'(3F12.6)') test7,test8,test7-test8
	write(*,'(3F12.7)') test7,test8,test7-test8
	write(*,*) test7,test8,test7-test8
	!cdfcheck=2.0_sp
	!print*, "Here sp ", cdfcheck,	sqrt(cdfcheck)
	!print*, "Here sp ", 2.0_sp,	sqrt(2.0_sp)
	!cdfcheck=2d0
	!print*, "Here d0 ", cdfcheck,	sqrt(cdfcheck)
	!print*, "Here d0 ", 2d0,	sqrt(2d0)
	!print*, "Here sp*d0 ", 1.0_sp*2d0,	sqrt(1.0_sp*2d0)
	!print*, "Here epsilon ", epsilon(1d0),cdfcheck
	!call precisiontests
	!write(*,*) 0.	
	!write(*,*) 0.0
	!write(*,*) 0._sp
	!write(*,*) 0.0_sp
	!write(*,*) PI,PI_D

	VAL = 12345783123.8976
	!TG = 12345678.8976_DP
	!WRITE(*,*) val(1),precision(val(1)),precision(1.),precision(ttt),kind(val(1))
	!WRITE(*,'(es14.8)') val(1)
	!WRITE(*,*) TG
	val(2) = 123456789.		! since val is declared as SP it will lose the last digit and will round off the 8 before it to 9 so that you'll only get 12345679 for this number (since the mantissa is only 8 digits)
	WRITE(*,*) val(2)    
	WRITE(*,'(es20.4)') val(2)
	WRITE(*,'(es20.7)') val(2)	! this is the best one, because it is exactly using 1 main and 7 decimal points and this is good since 8 is exactly the size of the mantissa. 
					! so then it doesn't truncate (see the one above this) or fill in the rest with weird unnecessary numbers (see the e ones below this)
	WRITE(*,'(es20.8)') val(2)
	WRITE(*,'(es20.9)') val(2)
	WRITE(*,'(es20.10)') val(2)
	WRITE(*,'(es15.7)') val(2)	! this is the best one too because it saves space 
	WRITE(*,'(e15.7)')  val(2)	
	WRITE(*,'(e15.8)')  val(2)	! this is the best one also 
	!WRITE(*,'(e15.9)')  val(2)	! this doesn't work 
	WRITE(*,*) "STOP "
	WRITE(*,*) val(2)		! for sp, mantissa can only be 8 digits so that the computer reads val as 12345679 (where 9 is for roudded off 8). so this writes 1.2345679E+08
	WRITE(*,'(F11.2)') val(2)	! the width of the field is not large enough for 123456789 (which has 9 digits). so this writes **************
	WRITE(*,'(F12.2)') val(2)	! width of the field is fine, but now it will fill up that 9th digit with SOME number (in this case 2) so that it will write 123456792.00
	WRITE(*,'(F13.2)') val(2)	! width of the field is fine, but now it will fill up that 9th digit with SOME number (in this case 2) so that it will write 123456792.00 (but with more space in the beginning than the above one) 
	WRITE(*,'(F20.2)') val(2)	! width of the field is fine, but now it will fill up that 9th digit with SOME number (in this case 2) so that it will write 123456792.00 (but with more space in the beginning than the above one) 				
	WRITE(*,*) "STOP "
	val(2)=12345678912345.
	WRITE(*,'(F12.2)') val(2)	! same explanations above (i.e. the comp will just add a different number 2. only now, the number does the width of field. 
	WRITE(*,'(F13.2)') val(2)   
	WRITE(*,'(F20.2)') val(2)   

	!write(*,'(3E15.8)') val
	!write(*,'(3E16.9)') val
	!write(*,'(3E20.12)') val
	!write(*,'(3F10.2)') val
	!write(*,'(3F15.2)') val
	!write(*,'(4EN10.1)') val,val(3)+100000.
	!write(*,'(4EN12.3)') val,val(3)+100000.

	write(*,*) kind(1d0),precision(1d0)
	PRINT*, TINY(TEMP),TINY(TEMPD) 
	PRINT*, EPSILON(TEMP),EPSILON(TEMPD)
	PRINT*, (TEMP >= TINY(TEMP))
	PRINT*, (TEMP >= 0.)
	PRINT*, (TEMP >= 0D0)

	write(*,*) kind(pi),precision(pi)
	write(*,*) kind(1d0),precision(1d0)
	print*, pi 
	!print*, rp(6:7),temp,eps,temp-eps
	temp=7365.370_sp
	print*, temp
	write(*,'(G10.3)') temp
	write(*,'(G14.7)') temp
	temp=7.124370_sp
	print*, temp
	write(*,'(G10.3)') temp
	write(*,'(G14.7)') temp
	stop
	temp=7365.370_sp
	write(*,'(F10.3)') temp
	write(*,'(F13.5)') temp
	write(*,'(F18.9)') temp
	write(*,'(F20.10)') temp
	write(*,'(F30.20)') temp
	write(*,'(F30.20)') 7365.370_sp
	stop
	temp=7365.370000_sp
	print*, temp
	write(*,'(F13.5)') temp
	write(*,'(F18.9)') temp
	write(*,'(F20.10)') temp
	write(*,'(F30.20)') temp
	write(*,'(F30.20)') 7365.370_sp
	stop
	temp=7365.3701171875_sp
	write(*,'(F13.5)') temp
	write(*,'(F18.9)') temp
	write(*,'(F20.10)') temp
	write(*,'(F30.20)') temp
	write(*,'(F30.20)') 7365.3701171875_sp
	temp=7365.3701171875123456789_sp
	write(*,'(F13.5)') temp
	write(*,'(F18.9)') temp
	write(*,'(F20.10)') temp
	write(*,'(F30.20)') temp
	tempd=6.66666666666666
	write(*,*) tempd
	tempd=6.6666_dp
	write(*,*) tempd
	write(*,'(F30.20)') tempd
	write(*,'(F30.15)') tempd
	write(*,'(F20.14)') tempd
	temp=6.6666_sp
	write(*,*) temp
	write(*,'(F30.20)') temp
	write(*,'(F30.15)') temp
	write(*,'(F20.14)') temp
	write(*,'(F20.7)') temp
	write(*,'(F20.6)') temp
	write(*,'(F20.5)') temp
	temp=6.666666_sp
	write(*,*) temp
	write(*,'(F30.20)') temp
	write(*,'(F30.15)') temp
	write(*,'(F20.14)') temp
	write(*,'(F20.7)') temp
	write(*,'(F20.6)') temp
	write(*,'(F20.5)') temp
	stop
	tempd=6.6666666666666_dp
	write(*,*) tempd
	write(*,'(F30.20)') tempd
	tempd=6.66666666666666_dp
	write(*,*) tempd
	write(*,'(F30.20)') tempd
	write(*,'(F40.30)') tempd
	tempd=6.66660000000_dp
	write(*,*) tempd
	write(*,'(F20.14)') tempd
	write(*,'(F30.20)') tempd

	stop

	tempd=6.66666666666666_dp
	write(*,*) tempd
	tempd=6.666666666666666_dp
	write(*,*) tempd
	tempd=6.66666666666666666_dp
	write(*,*) tempd
	tempd=6.666666666666666_dp
	write(*,*) tempd
	tempd=6.666666666666666666_dp
	write(*,*) tempd
	write(*,*) " ********************** TEMPD   ******************************** "
	tempd=7365.370_dp
	print*, tempd
	write(*,'(F13.5)') tempd
	write(*,'(F18.9)') tempd
	write(*,'(F20.10)') tempd
	write(*,'(F30.20)') tempd


	!VAL = 12345783123.8976
	!print*, val(2) 

	!TG = 12345678.8976_DP
	!WRITE(*,*) val(1),precision(val(1)),precision(1.),precision(ttt),kind(val(1))
	!WRITE(*,'(es14.8)') val(1)
	!WRITE(*,*) TG
	val(2) = 123456789.		! since val is declared as SP it will lose the last digit and will round off the 8 before it to 9 so that you'll only get 12345679 for this number (since the mantissa is only 8 digits)
	WRITE(*,*) val(2)    
	WRITE(*,'("es20.4",es20.4)') val(2)
	WRITE(*,'("es20.7",es20.7)') val(2)	! this is the best one, because it is exactly using 1 main and 7 decimal points and this is good since 8 is exactly the size of the mantissa. 
					! so then it doesn't truncate (see the one above this) or fill in the rest with weird unnecessary numbers (see the e ones below this)
	WRITE(*,'("es20.8",es20.8)') val(2)
	WRITE(*,'("es20.9",es20.9)') val(2)
	WRITE(*,'("es20.10",es20.10)') val(2)
	WRITE(*,'("es15.7",es15.7)') val(2)	! this is the best one too because it saves space 
	WRITE(*,'("e20.4",e15.7)')  val(2)	
	WRITE(*,'("e15.8",e15.8)')  val(2)	! this is the best one also 
	!WRITE(*,'(e15.9)')  val(2)	! this doesn't work 
	!WRITE(*,*) "STOP "
	WRITE(*,*) val(2)		! for sp, mantissa can only be 8 digits so that the computer reads val as 12345679 (where 9 is for roudded off 8). so this writes 1.2345679E+08
	WRITE(*,'("F11.2",F11.2)') val(2)	! the width of the field is not large enough for 123456789 (which has 9 digits). so this writes **************
	WRITE(*,'("F12.2",F12.2)') val(2)	! width of the field is fine, but now it will fill up that 9th digit with SOME number (in this case 2) so that it will write 123456792.00
	WRITE(*,'("F13.2",F13.2)') val(2)	! width of the field is fine, but now it will fill up that 9th digit with SOME number (in this case 2) so that it will write 123456792.00 (but with more space in the beginning than the above one) 
	WRITE(*,'("F20.2",F20.2)') val(2)	! width of the field is fine, but now it will fill up that 9th digit with SOME number (in this case 2) so that it will write 123456792.00 (but with more space in the beginning than the above one) 				
	WRITE(*,*) "STOP "
	val(2)=12345678912345.
	WRITE(*,'(F12.2)') val(2)	! same explanations above (i.e. the comp will just add a different number 2. only now, the number does the width of field. 
	WRITE(*,'(F13.2)') val(2)   
	WRITE(*,'(F20.2)') val(2)   
	END SUBROUTINE precisiontests


SUBROUTINE compwage(ai,aj,gamma,w) 
	real(dp), INTENT(IN) :: ai,aj,gamma 
	real(dp), INTENT(OUT) :: w
	w = (ai - aj)** (-gamma) - gamma * ai * (ai - aj)** (-gamma-1)
	!w = 1./exp(ai - aj) - ai * (1./exp(ai-aj) )
	!w = ( exp(ai - aj) ) ** (-gamma)  *  (1.-gamma*ai) 
END SUBROUTINE 

subroutine rand2num(mu,sig,rand,num) 
	real(dp), INTENT(IN) :: rand(:),mu,sig
	real(dp), INTENT(OUT) :: num(:)
	num=sqrt(2.0_Dp) * SIG * rand(:) + MU
end subroutine rand2num

END MODULE alib
	module params
	!insert space and keep tabs option in visual studio
    ! testing
	use nrtype 
	use nr 
	use alib, only: one,logit,logitinv,min2pls,min2plsinv,lin2ndim,ndim2lin,sqrtpi,multinom,condmom
	implicit none 
    include 'mpif.h'
    integer :: mysay,mygroup
	integer :: iter,comm,iwritegen 
	!real(dp) :: one=1.0_dp
	!integer(i4b), parameter :: rp = kind(1.0d0)			! kind(1.0) !!!
    real(dp), parameter :: replacement_rate=0.4_dp          !ahu summer18 050318: added replacement rate
    integer(i4b), parameter :: nl=9,ndecile=10
	logical, parameter :: groups=.true.,onlysingles=.true.,onlymales=.false.,onlyfem=.false.,optimize=.true.,chkstep=.false.,condmomcompare=.false.,comparepars=.false.,extramoments=.false.
    logical :: nonneg
    logical, parameter :: onthejobsearch=.TRUE. !set in m\ain
	integer(i4b), parameter :: numit=2
    real(dp), dimension(2) :: nonlabinc !=(/ 0.0_dp,0.0_dp /) !(/ 300.0_dp,1100.0_dp /) !ahu summer18 051418: changing it back to parameter and changing dimension to 2 (not educ and educ) !ahu summer18 042318 changing this so it is set at main again
	real(dp), parameter :: eps = 1.0d-6,zero=0.0_dp,epstest=2.0_dp					! could do tiny(.) but that gives a number that is way too small and therefore not appropriate for those places where we check the inequalities or equalities	
	real(dp), parameter :: eps2= 1.0d-6
	integer(i4b), parameter :: nhome=1,nhomep=nl
	logical :: conditional_moments		! can set this in main
	logical :: skriv,yaz,insol
	integer(i4b) :: whereami
	character(len=1), parameter :: runid='r'		! string inserted into output filenames to identify which run !ahu 062413 set this in main instead 
	integer(i4b), parameter :: nco=1,ncop=1
	integer(i4b), parameter :: ntyp=1,ntypp=4   ! types !ahu 0327 changed ntypp from 2 to 1
	integer(i4b), parameter :: nin  = nco * ntyp * nhome
	integer(i4b), parameter :: ninp = ncop * ntypp * nhomep
    integer(i4b) :: nindex !determined in objf according to groups, it's either nin or ninp
	integer(i4b) :: iwritemom,myhome,mytyp,myco,myindex,mygrank
	logical, parameter :: indsimplexwrite=.false.		! in optimiation with parallel simplex, re-solve model and write moments to file whenever check for,find new best point 
	logical, parameter :: write_welfare=.false.			! write things needed for welfare calculations
	logical, parameter :: grid_usage=.false.			! keep track of how much of each grid is being used in simulations
	logical, parameter :: moremom=.false.
	logical, parameter :: icheck_eqvmvf=.false.,icheck_eqvcvs=.false.,icheck_probs=.false.
	integer(i4b), parameter :: npars    = 93
    character(len=15), dimension(npars) :: parname ! names of each parameter   !ahu 121118 now declkare as global it here instead of getsteps
    real(dp), dimension(npars) :: stepmin,realpartemp,parsforcheck,stepos !ahu 121118
	!character(len=15), dimension(npars) :: parname 
	integer(i4b), parameter :: mna=18,mxa=50   !,mxai=50		!ahu 070713 40	!if you ever change mina from 16 that might be problematic, because of psiddata%home and simdata%home definitions. look in read_data and read simdata for this
    integer(i4b), parameter :: MNAD=MNA-1,MXAD=MXA-1            !ahu jan19 010219
    integer(i4b), parameter :: nh=2,nexp=4,nsimeach=10,neduc=2,nkid=2 !kid is 1 if no kid,2 if yes kid !ahu 0327 changed nsimeach from 10 to 5
	integer(i4b), parameter :: np=3,nz=1 !ahu 121818 changed from 3 to 6 !ahu 0327 changed np from 5 to 2
	integer(i4b), parameter :: nqs = (np+2) *  nl
	integer(i4b), parameter :: nq  = (np+2) * (np+2) * nl
	integer(i4b), parameter :: np1=np+1, np2=np+2   !w=np1 is getting laid off in the shock space q and w=np2 is nothing happening. In the state space q, np1 is unemployment and np2 is not in the state space q (I try to check that it is not there, at various points in code)
	integer(i4b), parameter :: nxs = neduc * nexp * nkid
	integer(i4b), parameter :: nx  = nxs * nxs
	integer(i4b), parameter :: ncs = nl+2
	integer(i4b), parameter :: nc  = nl+8
    integer(i4b), parameter :: nepsmove=13, nepskid=2
	integer(i4b), parameter :: ndata    = 5233 !5390 !2386   
	integer(i4b), parameter :: ndataobs = 84507 !86873 !41494  
	integer(i4b), parameter :: nsim     = ndata*nsimeach  
	integer(i4b), parameter :: nmom     = 1400 !ahu summer18 050418: changed from 4200 to 498
    integer(i4b) :: calcvar(nmom),calcorr(nmom)
	integer(i4b), parameter :: maxrellength=10
	integer(i4b), parameter :: namelen=60					!if you change this, don't forget to also change a100 in writemoments	
	integer(i4b), parameter :: ma=1,fe=2
    INTEGER(I4B), PARAMETER :: NOCOLLEGE=1,COLLEGE=2
	integer(i4b), parameter, dimension(2) :: agestart=(/ mna,22 /)		!changed this from 18,22 !chanage this back ahu 070312 (/18,22/) !starting age for simulations for each education level
	real(dp), parameter :: mult1=50000.0_dp !ahu jan19 012519
    real(dp), parameter :: multmar=20000.0_dp,mult1c=50000.0_dp  !ahu jan19 012019  
	real(dp), parameter :: maxhgrid=8.0_dp 
	real(dp), parameter :: tottime=16.0_dp
	real(dp), parameter :: hhours_conv=250.0_dp					! multuiply hours per day by this to get hours per year for hours worked
	real(dp), parameter :: maxh=hhours_conv*maxhgrid				! hhours_conv*hmgrid(ntwork) ! truncation point of labor market hours in data !ahu 071712
	real(dp), parameter, dimension(nh) :: hgrid=(/ 0.0_dp,maxhgrid /) 
	real(dp), parameter, dimension(nh) :: hgrid_ann=hgrid*hhours_conv
	real(dp), parameter :: d1=1.0_dp						! note that now doing calculations as single real(sp) not double real (i modified module1 to allow this)
	real(dp), parameter :: h_parttime=1000.0_dp					! number of hours to be considred part time !ahu 071712
	real(dp), parameter :: h_fulltime=1000.0_dp					! ahu 071712 changed from 1000 too 2000 !ahu 062812 changed this to 1000. 2000. ! number of hours to be considred full time 
        !ahu 021817: note that the employment is decided according to whether hours is more than h_fulltime which is 1000 but annual wages is calculated using wge*h_wmult where h_wmult is 2000. 
        !This is how you did it in the original version. I do the same thing so that the wage numbers are consistent with the previous version. See page 15 last paragraph in the original text.	
    real(dp), parameter :: h_wmult=2000.0_dp                    !what you multiply hourly wages with in order to turn them into annual wages
    real(dp), parameter :: hbar=h_parttime
	real(dp), parameter :: minw=1.0_dp					! lower truncation point of male log wage
	real(dp), parameter :: maxw=150.0_dp                ! upper truncation point of male log wage
	real(dp), parameter :: pen=-99999999.0_dp
	integer(i4b), parameter :: ipen=-99999	
	real(dp), parameter :: init=pen,initi=ipen
    !ahu 122818 changed wmove mar from 100 to 1000
    real(dp), parameter :: wtrans=50.0_dp,wwaged=50.0_dp,wdifww=50.0_dp,wrel=1.0_dp,wmove=10.0_dp,whour=1.0_dp,wwage=10.0_dp,wkid=1.0_dp,wmovemar=1.0_dp,wmovesin=1.0_dp,wwagebymove=1.0_dp		!ahu 121918 changed wmove to 10 from 1 and changed wmovemar from 10 to 100		! weights for moments for married couples. set in objfunc.
    !real(dp), parameter :: wtrans=10.0_dp,wwaged=1.0_dp,wdifww=1.0_dp,wrel=1.0_dp,wmove=10.0_dp,whour=1.0_dp,wwage=1.0_dp,wkid=1.0_dp,wmovemar=1.0_dp,wmovesin=1.0_dp,wwagebymove=1.0_dp		!ahu 121918 changed wmove to 10 from 1 and changed wmovemar from 10 to 100		! weights for moments for married couples. set in objfunc.
    !real(dp), parameter :: wtrans=50.0_dp,wwaged=50.0_dp,wdifww=1.0_dp,wrel=1.0_dp,wmove=10.0_dp,whour=1.0_dp,wwage=10.0_dp,wkid=1.0_dp,wmovemar=1.0_dp,wmovesin=1.0_dp,wwagebymove=1.0_dp		!ahu 121918 changed wmove to 10 from 1 and changed wmovemar from 10 to 100		! weights for moments for married couples. set in objfunc.
    !real(dp), parameter :: wrel=10.0_dp,wmove=10.0_dp,whour=1.0_dp,wwage=1.0_dp,wkid=1.0_dp,wmovemar=10.0_dp,wmovesin=10.0_dp,wwagebymove=1.0_dp		!ahu 121918 changed wmove to 10 from 1 and changed wmovemar from 10 to 100		! weights for moments for married couples. set in objfunc.
    !real(dp), parameter :: wrel=1.0_dp,wmove=10.0_dp,whour=1.0_dp,wwage=1.0_dp,wkid=1.0_dp,wmovemar=1000.0_dp,wmovesin=1.0_dp,wwagebymove=10.0_dp		!ahu 121918 changed wmove to 10 from 1 and changed wmovemar from 10 to 100		! weights for moments for married couples. set in objfunc.
    !real(dp), parameter :: wrel=1.0_dp,wmove=1.0_dp,whour=1.0_dp,wwage=1.0_dp,wkid=1.0_dp,wmovemar=1.0_dp,wmovesin=1.0_dp,wwagebymove=1.0_dp	! weights for moments for married couples. set in objfunc.
    character(len=23), parameter :: datafilename= 'familymigpsid.txt' ! data filename
	!character(len=23), parameter :: initcondfile= 'familymiginit111113.txt' ! filename of initial conditions
	character(len=23) :: momentfile='mom.txt'
    character(len=23) :: momentonlyfile='momonly.txt'
    integer(i4b) :: mominfo(0:5,nmom)
	!model parameters 
	!real(sp):: umdist_condf(np,np),ufdist_condm(np,np)
	real(dp), parameter :: delta=0.96_dp,alf=0.5_dp 
	real(dp), parameter :: mu_wge(2)=0.0_dp
	real(dp) :: sig_wge(2),mu_mar(ntypp),sig_mar,ro,mu_o , sigo_m,sigo_f
	real(dp) :: uhome(2),alphaed(2,neduc),alphakid(2,nkid),alfhme
	real(dp) :: gam_e,gam_u,cst(ntypp),kcst,ecst,scst,divpenalty,uloc(nl),sig_uloc
	real(dp) :: alf10(nl),alf11,alf12,alf13,alf1t(ntypp)            ! types
	real(dp) :: alf20(nl),alf21,alf22,alf23,alf2t(ntypp)            ! types
	real(dp) :: ptype,pmeet,omega(2),ptypehs(ntypp),ptypecol(ntypp) ! types
	real(dp) :: pkid,psio(12),psil(2),psih(4)
	real(dp) :: popsize(nl)
	integer(i4b) :: distance(nl,nl)
	real(dp) :: wg(np,2),wgt(np),mg(nz,ninp),mgt(nz),best
	type :: initcond
        integer(i4b) :: id
		integer(i4b) :: co				
		integer(i4b) :: sexr			
		integer(i4b) :: hme
		integer(i4b) :: endage		
		integer(i4b) :: edr			
    end type
	type, extends(initcond) :: statevar
        integer(i4b) :: expr
        integer(i4b) :: kidr      
        integer(i4b) :: hhr		! annual hours worked by r (turned into discrete in read_data)
		real(dp) :: logwr,wr	! wr is annual income and logwr is log of annual income. hourly wage (wr_perhour or wsp_perhour) is read from the data (see familymig_2.do to see how it's turned into hourly) and that hourly wage is turned into annual by multiplying it by h_wmult	  
        integer(i4b) :: l		! location		
        integer(i4b) :: rel		! relationship status. -1: not observed, 0: single, 1: married, 2: cohabiting
		integer(i4b) :: rellen	! length of current relationship starting from 1 in first period
        integer(i4b) :: edsp
        integer(i4b) :: expsp
        integer(i4b) :: kidsp
        integer(i4b) :: hhsp	! annual hours worked by spouse (turned into discrete in read_data)
		real(dp) :: logwsp,wsp  ! see explanation for logwr,wr.  
        integer(i4b) :: lsp
        integer(i4b) :: nomiss
        integer(i4b) :: nn,mm,r,typ
	end type
	type :: shock
		real(dp) :: meet 
		real(dp) :: marie
		real(dp) :: meetq 
		real(dp) :: meetx 
		real(dp) :: q
		real(dp) :: x
        real(dp) :: iepsmove
        real(dp) :: typ
	end type	
	type(statevar) :: ones
    type(initcond) :: ones_init
contains




	! get parameters from transformed values. input is free
	! to be any real(sp) resulting parameters are appropriately constrained
	subroutine getpars(par,realpar)
	real(dp), dimension(npars), intent(in)  :: par ! vector of parameters
	real(dp), dimension(npars), intent(out) :: realpar ! vector of parameters
	integer(i4b) :: g,i,j,ed,indust1(ntypp),indust2(ntypp)
    integer(i4b) :: dw0,de,dsex
    real(dp) :: oftemp(3,np1,2,2)

    stepos=0.0_dp
    indust1=0
    indust2=0
    
	realpar=pen 
    parname=''
    j=1
    !ahu jan19 012819: not iterating on ed offers anymore. replacing them with curloc and ofloc offers instead 
	realpar(j)=par(j)               ; parname(j)='emp,cur,m' ; stepos(j)=-1.0_dp  ; if (onlyfem) stepos(j)=0.0_dp !psio is for the offer function
	psio(1)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='emp,cur,m' ; stepos(j)=1.0_dp  ; if (onlyfem) stepos(j)=0.0_dp !psio is for the offer function
	psio(2)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='emp,of,m' ; stepos(j)=-1.0_dp  ; if (onlyfem) stepos(j)=0.0_dp!psio is for the offer function
	psio(3)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='emp,of,m' ; stepos(j)=0.0_dp  ; if (onlyfem) stepos(j)=0.0_dp !psio is for the offer function !NO MORE OFLOC LAYOFF NONSENSE
	psio(4)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='emp,cur,f' ; stepos(j)=-1.2_dp ; if (onlymales) stepos(j)=0.0_dp !psio is for the offer function
	psio(5)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='emp,cur,f' ; stepos(j)=-1.5_dp ; if (onlymales) stepos(j)=0.0_dp  !psio is for the offer function
	psio(6)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='emp,of,f' ; stepos(j)=1.0_dp ; if (onlymales) stepos(j)=0.0_dp  !psio is for the offer function
	psio(7)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='emp,of,f' ; stepos(j)=0.0_dp ; if (onlymales) stepos(j)=0.0_dp  !psio is for the offer function !NO MORE OFLOC LAYOFF NONSENSE
	psio(8)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='u,cur,m' ; stepos(j)=-1.0_dp  ; if (onlyfem) stepos(j)=0.0_dp !psio is for the offer function
	psio(9)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='u,of,m' ; stepos(j)=-1.0_dp  ; if (onlyfem) stepos(j)=0.0_dp !psio is for the offer function
	psio(10)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='u,cur,f' ; stepos(j)=0.2_dp  ; if (onlymales) stepos(j)=0.0_dp !psio is for the offer function
	psio(11)=realpar(j)	            ; j=j+1
	realpar(j)=par(j)               ; parname(j)='u,of,f' ; stepos(j)=1.0_dp  ; if (onlymales) stepos(j)=0.0_dp !psio is for the offer function
	psio(12)=realpar(j)	            ; j=j+1

	realpar(j)=par(j)               ; parname(j)='psil(1)' ; stepos(j)=0.0_dp 
	psil(1)=realpar(j)	            ; j=j+1
	realpar(j)=0.0_dp               ; parname(j)='alfhme' ; stepos(j)=0.0_dp 
	alfhme=realpar(j)	            ; j=j+1
	realpar(j)=min2pls(par(j))      ; parname(j)='ro'	; stepos(j)=0.5_dp ; if (onlysingles) stepos(j)=0.0_dp !15 !2.0_dp*(1.0_dp/(1.0_dp+exp(-par(j))))-1.0_dp 
	ro=realpar(j)                   ; j=j+1

	realpar(j)=logit(par(j))               ; parname(j)='psih(1)' ; stepos(j)=-1.0_dp !ahu jan19 011719 changing to logit
	psih(1)=realpar(j)	            ; j=j+1
	realpar(j)=logit(par(j))               ; parname(j)='psih(2)' ; stepos(j)=0.0_dp !ahu jan19 011719 changing to logit
	psih(2)=realpar(j)	            ; j=j+1
	realpar(j)=0.0_dp               ; parname(j)='psih(3)' ; stepos(j)=0.0_dp !ahu jan19 011519 getting rid of probdown
	psih(3)=realpar(j)	            ; j=j+1
	realpar(j)=0.0_dp               ; parname(j)='psih(4)' ; stepos(j)=0.0_dp  !ahu jan19 011519 getting rid of probdown
	psih(4)=realpar(j)	            ; j=j+1

    
    realpar(j)=logit(par(j))        ; parname(j)='pkid' ; stepos(j)=1.0_dp  ; if (onlysingles) stepos(j)=0.0_dp !20
	pkid=realpar(j)                 ; j=j+1
    realpar(j)=logit(par(j))	    ; parname(j)='pmeet' ; stepos(j)=0.5_dp ; if (onlysingles) stepos(j)=0.0_dp !21
	pmeet=realpar(j)                ; j=j+1


    !realpar(j) = mult1c * logit(par(j))              ; parname(j)='uhome(1)' ; stepos(j)=0.2_dp	!mult3*logit(par(2:3)) !22:23
	!uhome(1)=realpar(j)                             ; j=j+1
    !realpar(j) = mult1c * logit(par(j))              ; parname(j)='uhome(2)' ; stepos(j)=0.2_dp	 ; if (onlymales) stepos(j)=0.0_dp !mult3*logit(par(2:3)) !22:23
	!uhome(2)=realpar(j)                             ; j=j+1

    realpar(j) = par(j)             ; parname(j)='uhome(1)' ; stepos(j)=0.5_dp*PAR(J)	 ; if (onlyfem) stepos(j)=0.0_dp !mult3*logit(par(2:3)) !22:23
	uhome(1)=realpar(j)                             ; j=j+1
    realpar(j) = par(j)              ; parname(j)='uhome(2)' ; stepos(j)=0.5_dp*PAR(J)	 ; if (onlymales) stepos(j)=0.0_dp !mult3*logit(par(2:3)) !22:23
	uhome(2)=realpar(j)                             ; j=j+1
    realpar(j)=par(j)            ; parname(j)='ecst'	; stepos(j)=0.5_dp*par(j) !24 !-1.0_dp*mult1c * logit(par(j)) !ahu 112718 changing to only minus from: mult1 * min2pls(par(j))     ! types
    ecst=realpar(j)                                     ; j=j+1               ! types
	realpar(j) = par(j)          ; parname(j)='kcst'	; stepos(j)=0.5_dp*par(j) !25 !-1.0_dp*mult1c * logit(par(j)) !ahu 112718 changing to only minus from: mult1 * min2pls(par(5)) !mult2*logit(par(4:6))	
	kcst=realpar(j)                                     ; j=j+1
	realpar(j) = -1.0_dp*mult1 * logit(par(j))          ; parname(j)='divpenalty'	; stepos(j)=1.5_dp ; if (onlysingles) stepos(j)=0.0_dp !26 !ahu 112718 changing to only minus from: mult1 * min2pls(par(6))                         !ahu summer18 050418: changed from 1000 to 10,000 (mult to mult1)
	divpenalty=realpar(j)                               ; j=j+1
    !print*, 'Here is divpenalty',j-1,divpenalty 

    realpar(j:j+1) = mult1 * logit(par(j:j+1))          ; parname(j)='alphaed(m,ned)' ; parname(j+1)='alphaed(f,ned)'    !27:28   !ahu jan19 012719 changing it yet again back to logit because there is not that much of different in objval between alpha=0 and alpha=-49000    !ahu jan19 012019 changing it back to min2pls  ! noed !ahu 112718 changing to only plus from: mult1*min2pls(par(7:8))   !mult1 * logit(par(7))	
	stepos(j)=0.5_dp  ; if (onlyfem) stepos(j)=0.0_dp ; 	stepos(j+1)=0.5_dp  ; if (onlymales) stepos(j+1)=0.0_dp 
    alphaed(:,1)=realpar(j:j+1)                         ; j=j+2
    !realpar(j:j+1)= mult1 * min2pls(par(j:j+1))           ; parname(j)='alphaed(m,ed)' ; parname(j+1)='alphaed(f,ed)'         !ahu jan19 012019 changing it back to min2pls       ! ed !ahu 112718 changing to only plus from: mult1 * min2pls(par(9:10))	 !mult1 * logit(par(9:10))	
	!stepos(j)=5.0_dp ; 	stepos(j+1)=5.0_dp   ; if (onlymales) stepos(j+1)=0.0_dp 
    realpar(j:j+1)=alphaed(:,1)            ; parname(j)='alphaed(m,ed)' ; parname(j+1)='alphaed(f,ed)'     !ahu jan19 012419 changing this so that there is no alpha by ed no more    !ahu jan19 012019 changing it back to min2pls       ! ed !ahu 112718 changing to only plus from: mult1 * min2pls(par(9:10))	 !mult1 * logit(par(9:10))	
	stepos(j)=0.0_dp  ; if (onlyfem) stepos(j)=0.0_dp ; 	stepos(j+1)=0.0_dp   ; if (onlymales) stepos(j+1)=0.0_dp 
    alphaed(:,2)=realpar(j:j+1)                         ; j=j+2 
    realpar(j:j+1)=mult1 * logit(par(j:j+1))            ; parname(j)='alphakid(m)' ; parname(j+1)='alphakid(f)'          !31:32           !ahu 112718 changing to only plus from: mult1 * min2pls(par(j:j+1))	 !mult1 * logit(par(9:10))	
    stepos(j)=5.0_dp  ; if (onlyfem) stepos(j)=0.0_dp ; 	stepos(j+1)=0.5_dp  ; if (onlymales) stepos(j:j+1)=0.0_dp 
    alphakid(:,2)=realpar(j:j+1)                        ; j=j+2         
	
    !uloc: 33-41
    !do ed=1,2
        do i=1,nl
            if (i==2) then
			    realpar(j) = 0.0_dp  ; stepos(j)=0.0_dp
			    uloc(i)=0.0_dp
		    else 
			    realpar(j) = par(j) ; stepos(j)=0.5_dp*PAR(J)    !mult1 * min2pls( par(j) )
			    uloc(i)=realpar(j)
		    end if 
            parname(j)='uloc' 
            j=j+1
        end do
	!end do
    !print*, 'Here is alf10',j
	!wage 42: 65
    do i=1,nl
        realpar(j)=par(j) !1.5_dp*min2pls(par(j))+8.5_dp 
		alf10(i)=realpar(j)
        parname(j)='alf10' ; stepos(j)=0.15_dp ; if (i==3) stepos(j)=0.0_dp  ; if (onlyfem) stepos(j)=0.0_dp !dont iterate on alpha10(1) for a second
        j=j+1
    end do 
    !print*, 'Here is alf10',j-1
    realpar(j)=logit(par(j))                        ; parname(j)='alf11' ; stepos(j)=0.3_dp  ; if (onlyfem) stepos(j)=0.0_dp
	alf11=realpar(j)                                ; j=j+1
    !print*, 'Here is alf12',j	
    realpar(j)=3.0_dp*logit(par(j))                 ; parname(j)='alf12' ; stepos(j)=0.3_dp  ; if (onlyfem) stepos(j)=0.0_dp
    alf12=realpar(j)                                ; j=j+1
    !print*, 'Here is alf13',j	
    realpar(j)=0.0_dp                               ; parname(j)='alf13' ; stepos(j)=0.0_dp   ; if (onlyfem) stepos(j)=0.0_dp  !-1.0_dp*logit(par(j)) 
    alf13=realpar(j)	                            ; j=j+1
    !print*, 'Here is alf20',j
    do i=1,nl
		realpar(j)=par(j) !1.5_dp*min2pls(par(j))+8.5_dp    
		alf20(i)=realpar(j) 
        parname(j)='alf20' ; stepos(j)=0.15_dp  ; if (onlymales) stepos(j)=0.0_dp 
		j=j+1
	end do 
    !print*, 'Here is alf20',j-1
	realpar(j)=logit(par(j))                        ; parname(j)='alf21' ; stepos(j)=0.3_dp  ; if (onlymales) stepos(j)=0.0_dp 
	alf21=realpar(j)                                ; j=j+1
    !print*, 'Here is alf22',j	    
    realpar(j)=3.0_dp*logit(par(j))                 ; parname(j)='alf22' ; stepos(j)=0.3_dp  ; if (onlymales) stepos(j)=0.0_dp 
	alf22=realpar(j)                                ; j=j+1
    !print*, 'Here is alf23',j	
    realpar(j)=0.0_dp                               ; parname(j)='alf23' ; stepos(j)=0.0_dp  ; if (onlymales) stepos(j)=0.0_dp !-1.0_dp*logit(par(j)) 
	alf23=realpar(j)	                            ; j=j+1
	
    realpar(j:j+1)=logit(par(j:j+1))                ; parname(j:j+1)='sig_wge'	; stepos(j:j+1)=0.7_dp	  ; if (onlyfem) stepos(j)=0.0_dp  ; if (onlymales) stepos(j+1)=0.0_dp !66:67
	sig_wge(1:2)=realpar(j:j+1)                     ; j=j+2
    !sigom and sigof: 68:69
    realpar(j)=par(j)                               ; parname(j)='sigo_m'	; stepos(j)=0.5_dp*PAR(J) ; if (nepsmove==1) stepos(j)=0.0_dp ; if (onlyfem) stepos(j)=0.0_dp
	sigo_m=realpar(j)                                ; j=j+1
    realpar(j)=par(j)                               ; parname(j)='sigo_f'	; stepos(j)=0.5_dp*PAR(J) ; if (nepsmove==1) stepos(j)=0.0_dp ; if (onlymales) stepos(j)=0.0_dp
	sigo_f=realpar(j)                                ; j=j+1

    
    do i=1,ntypp
        if (i==1) then 
            realpar(j)=0.0_dp                           ; parname(j)='ptypehs' ; stepos(j)=0.0_dp
            ptypehs(i)=exp(realpar(j))                  ; indust1(i)=j ; j=j+1
            realpar(j)=0.0_dp                           ; parname(j)='ptypecol'  ; stepos(j)=0.0_dp
            ptypecol(i)=exp(realpar(j))                 ; indust2(i)=j ; j=j+1
            realpar(j)=par(j)                           ; parname(j)='alf1t'     ; stepos(j)=0.2_dp  ; if (onlyfem) stepos(j)=0.0_dp
            alf1t(i)=realpar(j)                         ; j=j+1
            realpar(j)=par(j)                          ; parname(j)='alf2t'     ; stepos(j)=0.2_dp  ; if (onlymales) stepos(j)=0.0_dp
	        alf2t(i)=realpar(j)                         ; j=j+1
            !realpar(j)= -1.0_dp*mult1c * logit(par(j))   ; parname(j)='cst'       ; stepos(j)=0.5_dp
            !cst(i)=realpar(j)                           ; j=j+1 
            realpar(j)= par(j)   ; parname(j)='cst'       ; stepos(j)=1.5_dp*par(j) !not iterating on this anymore. see notes. under cost vs. sigo. they are just not sep ident I think. 
            cst(i)=realpar(j)                           ; j=j+1 
            realpar(j)=multmar * min2pls(par(j))          ; parname(j)='mu_mar'     ; stepos(j)=-0.5_dp    ; if (onlysingles) stepos(j)=0.0_dp 	    
            mu_mar(i)=realpar(j)                        ; j=j+1      
        else
            realpar(j)=0.0_dp                            ; parname(j)='ptypehs' ; stepos(j)=0.0_dp
            ptypehs(i)=exp(realpar(j))                  ; indust1(i)=j ; j=j+1
            realpar(j)=0.0_dp                            ; parname(j)='ptypecol'  ; stepos(j)=0.0_dp
            ptypecol(i)=exp(realpar(j))                 ; indust2(i)=j ; j=j+1
            realpar(j)=par(j)                           ; parname(j)='alf1t'     ; stepos(j)=0.2_dp  ; if (onlyfem) stepos(j)=0.0_dp
            alf1t(i)=realpar(j)                         ; j=j+1
            realpar(j)=par(j)                           ; parname(j)='alf2t'     ; stepos(j)=0.2_dp  ; if (onlymales) stepos(j)=0.0_dp
	        alf2t(i)=realpar(j)                         ; j=j+1
            realpar(j)= par(j)                          ; parname(j)='cst'       ; stepos(j)=1.5_dp*par(j)
            cst(i)=realpar(j)                           ; j=j+1 
            realpar(j)=mu_mar(1)                        ; parname(j)='mu_mar'     ; stepos(j)=0.0_dp    ; if (onlysingles) stepos(j)=0.0_dp 	    
            mu_mar(i)=realpar(j)                        ; j=j+1      
        end if 
    	!print*, 'Here is cost',cst(i),par(j-1),realpar(j-1)
        !ahu 122818 changed mult1 to multmar 
    end do 
    ptypehs(:)=ptypehs(:)/sum(ptypehs)
    ptypecol(:)=ptypecol(:)/sum(ptypecol)
    do i=1,ntypp
        realpar(indust1(i))=ptypehs(i)
        realpar(indust2(i))=ptypecol(i)
    end do 
 
!ahu jan19 012419: not iterating the below anymore 
psih(2)=0.0_dp
!ECST=-8000.0_DP
!kcst=0.0_dp
alphaed(:,2)=alphaed(:,1)



    !alf11=alf21
    !alf12=alf22
    !alf13=alf23
    !psio(1:4)=psio(5:8)
    !psio(9:10)=psio(11:12)
    
    
    !ahu 121918 make all types the same 
    !    alf1t=0.0_dp
    !    alf2t=0.0_dp
    !    cst=-10000.0_dp
    !    mu_mar=1993.0_dp
    !if (ntypp==1) then 
    !    ptypehs=1.0_dp 
    !    ptypecol=1.0_dp 
    !else 
    !    ptypehs=0.25_dp
    !    ptypecol=0.25_dp
    !end if
    !print*, 'ptypehs', ptypehs
    !print*, 'ptypecol',ptypecol
    !print*, 'alf1t',alf1t
    !print*, 'alf2t',alf2t
    !print*, 'cst',cst
    !print*, 'mu_mar',mu_mar

    

    
    
    !print*, 'ptype', ptypehs, ptypecol
    
    !print*, 'Here is IT ISISISISISI npars', j-1
    !if (j.ne.npars) then
    !    print*, 'j not equal to npars',j,npars
    !    stop
    !end if


    mu_o=0.0_dp
    !sig_o=1000.0_dp
    scst=0.0_dp
    sig_mar=0.0_dp
    
    !alf11=0.0_Dp 
    !alf12=0.0_dp
    !alf13=0.0_dp 
    !sig_wge=0.0001_dp
    
    !if (ntypp==1) then 
    !    ptypehs(1)=1.0_dp    ! types
    !    ptypecol(1)=1.0_dp  ! types
    !else if (ntypp==2) then 
    !    ptypehs(ntypp)=1.0_dp-ptypehs(1)    ! types
    !    ptypecol(ntypp)=1.0_dp-ptypecol(1)  ! types
    !end if     
    !alf1t(1)=0.0_dp                 ! types
    !alf2t(1)=0.0_dp                 ! types
    alphakid(:,1)=0.0_dp

    !cst=0.0_dp
    !ecst=0.0_dp
    !kcst=0.0_dp
    
    
    !***********************
    !ahu 041118 del and remove later:
    !alphaed(2,:)=alphaed(1,:)
    !psio(5:8)=psio(1:4)
    !psio(11:12)=psio(9:10)
    !alphakid(2,:)=alphakid(1,:)
    
    !alf20=alf10
    !alf21=alf11
    !alf22=alf12
    !alf23=alf13
    !uhome(2)=uhome(1)
    !***********************
    
    !psio(1:4)=psio(5:8)
    !psio(9:10)=psio(11:12)
    
    !pkid=0.0_dp
    !alphakid=0.0_dp
    !kcst=0.0_dp 
    !ro=0.0_dp
    !sig_mar=0.0_dp
    !scst=0.0_dp
    
    !alf11=0.0_dp
    !alf21=0.0_dp
    !psio(3:4)=psio(1:2)
    !psio(7:8)=psio(5:6)
    !psio(10)=psio(9)
    !psio(12)=psio(11)
    !uloc(:,2)=uloc(:,1)
    !alphaed(:,2)=alphaed(:,1)
    !alf1t(2)=0.0_dp
    !alf2t(2)=0.0_dp
    !ptypecol=ptypehs
    
    
    !cst=0.0_dp
    !kcst=0.0_dp
    
    !ro=0.0_dp !0.98_dp
!alpha=0.0_dp
!kcst=0.0_dp
!pkid=0.0_dp
!alf1t(2)=alf1t(1)
!alf2t(2)=alf2t(1)
!cst(1)=cst(2)
!uhome=0.0_dp

    !uhome=0.0_dp
    !cst=-150000.0_dp
    !kcst=-150000.0_dp
    !divpenalty=0.0_dp
    !pkid=0.0_dp
    !kcst=0.0_dp
    !alpha(:,2)=alpha(:,1)
    
    
    !sig_o=sig_mar    
    !alpha(1,:)=alpha(2,:) 
    	!if ((.not.optimize).and.(.not.chkstep) ) print*, "sig_mar,mu_mar,npars;,; ", sig_mar,mu_mar,j
    
	!print*, logitinv(alf11),logitinv(alf12),logitinv(alf13)
	!print*, logitinv(alf21),logitinv(alf22),logitinv(alf23)

	!realpar(j)=exp(par(j))
	!sig_uloc=realpar(j) !; j=j+1		
	!realpar(j)=logit(par(j))
	!omega(1)=realpar(j) ; j=j+1
	!realpar(j)=logit(par(j))
	!omega(2)=realpar(j) 
	!realpar(j)=par(j)
	!alf14(ntyp)=realpar(j)  ; j=j+1
	!alf14(1)=0.0_sp
	!realpar(j)=par(j)
	!alf24(ntyp)=realpar(j) ; j=j+1  
	!alf24(1)=0.0_sp
	!realpar(j)=logit(par(j))
	!ptype=realpar(j)	!low type prob 
	!if (j/=npars) then ; print*, "something wrong in getpar! ",j,npars ; stop ; end if
    

    oftemp=0.0_dp
    do dsex=1,2
        do de=1,2            
            do dw0=1,np1
                if ( dw0 <= np ) then 
		            if ( de==1 .and. dsex==1 ) then 
			            oftemp(1:2,dw0,de,dsex)=exp(psio(1:2)) !exp( psio(1) + psio(2) * abs(dsex==1) + psio(3) * abs(de==2) )	! offer 
		            else if ( de==2 .and. dsex==1 ) then 
			            oftemp(1:2,dw0,de,dsex)=exp(psio(3:4)) 
                    else if ( de==1 .and. dsex==2 ) then 
			            oftemp(1:2,dw0,de,dsex)=exp(psio(5:6)) 
                    else if ( de==2 .and. dsex==2 ) then 
			            oftemp(1:2,dw0,de,dsex)=exp(psio(7:8)) 
                    end if 
		            oftemp(3,dw0,de,dsex)=exp( 0.0_dp )		! nothing happens												
	            else if (dw0 == np1) then 
		            if ( de==1 .and. dsex==1 ) then 
			            oftemp(1,dw0,de,dsex)=exp(psio(9)) !exp( psio(1) + psio(2) * abs(dsex==1) + psio(3) * abs(de==2) )	! offer 	 
                        realpar(9)=oftemp(1,np1,1,1)
                    else if ( de==2 .and. dsex==1 ) then 
			            oftemp(1,dw0,de,dsex)=exp(psio(10) )
                        realpar(10)=oftemp(1,np1,2,1)
                    else if ( de==1 .and. dsex==2 ) then 
			            oftemp(1,dw0,de,dsex)=exp(psio(11)) 
                        realpar(11)=oftemp(1,np1,1,2)
		            else if ( de==2 .and. dsex==2 ) then 
			            oftemp(1,dw0,de,dsex)=exp(psio(12)) 
                        realpar(12)=oftemp(1,np1,2,2)
                    end if 
		            oftemp(2,dw0,de,dsex)=0.0_dp		! 0 since you can't get laid off if you don't have a job! 
		            oftemp(3,dw0,de,dsex)=exp(0.0_dp)		! nothing happens												
	            else  
		            print*, "in fnprof: dw0 > np1 which doesnt' make sense as that's a state variable " 
		            stop
	            end if 
	            oftemp(1:3,dw0,de,dsex)=oftemp(:,dw0,de,dsex)/sum( oftemp(:,dw0,de,dsex)     )
            end do 
        end do 
    end do 
                       realpar(1:2)=oftemp(1:2,1,1,1)  !emp,noed,male
                        realpar(3:4)=oftemp(1:2,1,2,1)  !emp,ed,male
                        realpar(5:6)=oftemp(1:2,1,1,2)  !emp,noed,fem
                        realpar(7:8)=oftemp(1:2,1,2,2)  !emp,ed,fem
                        realpar(9)=oftemp(1,np1,1,1)  !unemp,noed,male
                        realpar(10)=oftemp(1,np1,2,1)  !unemp,ed,male
                        realpar(11)=oftemp(1,np1,1,2)  !unemp,noed,fem
                        realpar(12)=oftemp(1,np1,2,2)  !unemp,ed,fem
    
        realpartemp=realpar
	end subroutine getpars

	subroutine getsteps(par,step)
	real(dp), dimension(:), intent(in) :: par 
	!character(len=15), dimension(:), intent(out) :: name ! names of each parameter
	real(dp), dimension(:), intent(out) :: step 
	integer(i4b) :: i,j
	!name='' 
	!step=0.0_dp
    !name(1)='sig_o'		        ; step(1)=0.5_dp ; if (nepsmove==1) step(1)=0.0_dp 
    !name(2)='uhome(m)'		    ; step(2)=1.0_dp*par(2)
	!name(3)='uhome(f)'		    ; step(3)=1.0_dp*par(3)
	!name(4)='cst(1)'			; step(4)=-1.0_dp*par(4)
	!name(5)='kcst'		        ; step(5)=1.0_dp*par(5)
	!name(6)='divpenalty'		; step(6)=1.0_dp*par(6) ; if (onlysingles) step(6)=0.0_dp
	!name(7)='alphaed(m,1)'		; step(7)=1.0_dp*par(7)
	!name(8)='alphaed(f,1)'		; step(8)=1.0_dp*par(8)
	!name(9)='alphaed(m,2)'		; step(9)=1.0_dp*par(9) 
	!name(10)='alphaed(f,2)'		; step(10)=1.0_dp*par(10) 
	!name(11)='pkid'		        ; step(11)=1.0_dp   
	!name(12)='pmeet'		    ; step(12)=-1.0_dp ; if (onlysingles) step(12)=0.0_dp
	!j=13
    !do i=1,nl
    !    name(j)='uloc'	; step(j)=1.0_dp*par(j)    ; if (i==2) step(j)=0.0_dp ; j=j+1
    !end do 	
    
	!do i=1,nl
    !    name(j)='alf10' ; step(j)=0.5_dp*par(j)  ; j=j+1
	!end do 
	!name(j)='alf11'		; step(j)=0.5_dp*par(j) ; j=j+1
	!name(j)='alf12'     ; step(j)=0.5_dp*par(j) ; j=j+1
    !name(j)='alf13'		; step(j)=0.5_dp*par(j) ; j=j+1
    
    
	!do i=1,nl
    !    name(j)='alf20'	; step(j)=0.5_dp*par(j) ; j=j+1
	!end do
	!name(j)='alf21'		; step(j)=0.5_dp*par(j) ; j=j+1
    !name(j)='alf22'		; step(j)=0.5_dp*par(j) ; j=j+1
    !name(j)='alf23'		; step(j)=0.5_dp*par(j) ; j=j+1
    !name(j)='sig_wge(1)'	; step(j)=0.5_dp ; j=j+1
    !name(j)='sig_wge(2)'	; step(j)=0.5_dp ; j=j+1
    !name(j)='ro'			; step(j)=0.5_dp  ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psio'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psil'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psil'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psil'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psih'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psih'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psih'		; step(j)=0.5_dp ; j=j+1
    !name(j)='psih'		; step(j)=0.5_dp ; j=j+1
    !name(j)='mu_mar(1)'		    ; step(j)=1.0_dp*par(j)    ; if (onlysingles) step(j)=0.0_dp ; j=j+1
    !name(j)='mu_mar(ntypp)'		; step(j)=1.0_dp*par(j)    ; if (onlysingles) step(j)=0.0_dp ; j=j+1
    !name(j)='sig_mar'		; step(j)=0.0_dp    ; if (onlysingles) step(j)=0.0_dp ; j=j+1
    !name(j)='ptypehs(1)'		; step(j)=-1.0_dp    ; j=j+1  
    !name(j)='ptypecol(1)'		; step(j)=-1.0_dp    ; j=j+1 
    !name(j)='alf1t(2)'		    ; step(j)=0.5_dp    ; j=j+1 
    !name(j)='alf2t(2)'		    ; step(j)=0.5_dp    ; j=j+1
    !name(j)='cst(2)'            ; step(j)=1.0_dp*par(j) ; j=j+1    
    !name(j)='ecst'              ; step(j)=-1.0_dp*par(j) ; j=j+1     
    !name(j)='alphakid(m,2)'     ; step(j)=1.0_dp*par(j) ; j=j+1 
    !name(j)='alphakid(f,2)'     ; step(j)=1.0_dp*par(j) ; j=j+1
    !name(j)='scst'              ; step(j)=0.0_dp    !*par(j)     
	!if (j.ne.npars) then 
    !    print*, 'j not equal to npars',j,npars
    !    stop
    !end if 
    step=0.0_dp
	end subroutine getsteps

	subroutine getdistpop
	integer(i4b) :: i,j
	distance=0
	popsize=0.0_dp 
    !ahu 030717: redid this adjacence thing. see map and appendix of the draft. 
	distance(1,2)=1 
	distance(2,1)=1 
	distance(2,5)=1 
	distance(2,3)=1 
	distance(3,2)=1 
	distance(3,4)=1 
	distance(3,6)=1 
	distance(3,5)=1 
	distance(4,3)=1 
	distance(4,8)=1 
	distance(4,7)=1 
	distance(4,6)=1 
	distance(5,8)=1 
	distance(5,3)=1 
	distance(5,6)=1 
	distance(6,5)=1 
	distance(6,7)=1 
	distance(6,4)=1 
	distance(6,3)=1 
	distance(7,6)=1 
	distance(7,8)=1 
	distance(7,4)=1 
	distance(8,7)=1 
	distance(8,9)=1 
	distance(8,4)=1 
	distance(9,8)=1 
    do i=1,nl 
		do j=1,nl 
			if (j==i) then 
				if (distance(j,i)==1) then 		! ahu 061513: for some locaitons, you did have that their distance(i,i) was 1 so corrected this
                    print*, 'distance(i,i) should not be 1 because that is not adjacence'
                    stop
                end if 
			end if 
		end do 
	end do 

	popsize(1)=0.9112_dp	!new england
	popsize(2)=2.695_dp		!middle atlantic 
	popsize(3)=2.9598_dp	!east north central
	popsize(4)=1.2468_dp	!west north central
	popsize(5)=2.5736_dp	!south atlantic
	popsize(6)=1.0089_dp	!east south central
	popsize(7)=1.6121_dp	!west south central
	popsize(8)=0.7661_dp	!mountain
	popsize(9)=2.2757_dp	!pacific
	end subroutine getdistpop

	subroutine getones
		ones%co=-99
		ones%sexr=-99
		ones%hme=-99
		ones%endage=-99
		ones%edr=-99
		ones%expr=-99
        ones%kidr=-99
		ones%hhr=-99
        ones%logwr=-99.0_dp
        ones%wr=-99.0_dp
        ones%wsp=-99.0_dp
        ones%l=-99
        ones%rel=-99
        ones%rellen=-99
        ones%edsp=-99
        ones%expsp=-99
        ones%kidsp=-99
        ones%hhsp=-99
        ones%logwsp=-99.0_dp
		ones%lsp=-99        
		ones%nomiss=-99
        ones%nn=-99
        ones%mm=-99
        ones%r=-99
        ones%typ=-99
        
        ones_init%id=-99
        ones_init%co=-99
        ones_init%sexr=-99
        ones_init%hme=-99
        ones_init%endage=-99
        ones_init%edr=-99
        end subroutine getones	
        
        
end module params
module share
	use params
	implicit none
	integer(i4b) :: qstart(2,nl),xstart(2,neduc)
	integer(i4b) :: qq2q(2,nq),xx2x(2,nx),q2qq(nqs,nqs),x2xx(nxs,nxs)
	integer(i4b) :: qq2w(2,nq),qq2l(2,nq),xx2e(2,nx),xx2r(2,nx),xx2kid(2,nx)
	integer(i4b) :: q2w(nqs),q2l(nqs),x2e(nxs),x2r(nxs) ,x2kid(nxs)
	integer(i4b) :: wl2q(np2,nl),erkid2x(neduc,nexp,nkid) 
	integer(i4b) :: chs(ncs,nqs,nqs),ch(nc,nq,nq)
	real(dp) :: ppsq(nqs,nqs,nxs,2) , ppcq(nq,nq,nx)  !, ptemp(nqs,nqs,nxs,2)
	real(dp) :: ppmq_check(nqs,nqs,nxs),ppfq_check(nqs,nqs,nxs)
	real(dp) :: ppsx  (nxs,nqs,nxs) , ppcx(nx,nq,nx) 
	real(dp) :: ppmeetq(nqs,nqs),ppmeetx(nxs,nxs),empdec(mna:mxa,2)
	real(dp), dimension(2,nqs,nxs,ninp) :: ws,ubs     !ahu summer18 050318: added ubs
	real(dp), dimension(2,nq,nx,ninp) :: wc,ubc       !ahu summer18 050318: added ubc
	real(dp), dimension(2,nqs,nxs,ninp) :: utils
	real(dp), dimension(2,nq,nx,ninp) :: utilc
    real(dp), dimension(nqs,nxs,ninp) :: movecost
	real(dp), dimension(nqs,nxs,mna:mxa) :: emaxm_s,emaxf_s
	real(dp), dimension(nq,nx,mna:mxa)   :: emaxm_c,emaxf_c
	!integer(i4b), dimension(nepsmove,nqs,nxs,nqs,mna:mxa,nin) :: decm0_s,decf0_s,decm_s,decf_s
	!real(dp), dimension(nepsmove,nqs,nxs,nqs,mna:mxa,nin) :: vm,vf
    !integer(i4b), dimension(nz,nq,nx,mna:mxa,nin) :: dec_mar   
	!real(dp), dimension(nq,nx,mna:mxa,nin) :: vm0_c,vf0_c	
    !the below is allocatable because nindex (the last dimension) is determined according to groups
    integer(i4b), allocatable, dimension(:,:,:,:,:,:) :: decm0_s,decf0_s
    integer(i4b), allocatable, dimension(:,:,:,:,:,:) :: decm_s,decf_s
	real(dp), allocatable, dimension(:,:,:,:,:,:) :: vm,vf
    integer(i4b), allocatable, dimension(:,:,:,:,:) :: dec_mar   
	real(dp), allocatable, dimension(:,:,:,:) :: vm0_c,vf0_c	
    
    
    
    logical :: ppc(nq,nq),pps(nqs,nqs,2)
    real(dp) :: ppso(nepsmove),ppsk(nepskid),moveshock_m(nepsmove),moveshock_f(nepsmove),kidshock(nepskid),bshock_m(nepsmove),bshock_f(nepsmove)
contains 

	subroutine getq2q
	integer(i4b) :: q,qq,i,j,w(2),l(2),z,check
	qq2q=0 ; q2qq=0 ; qq=0 ; qq2w=0 ; qq2l=0 ; wl2q=0
	do z=1,3
	qm: do i=1,nqs
		call q2wloc(i, w(1) , l(1) )			! put all this into arrays below so that you don't have to keep calling this
		q2w(i) = w(1)					! these are all the same for males and females
		q2l(i) = l(1)					! these are all the same for males and females
		wl2q( w(1), l(1) ) = i				! these are all the same for males and females
        !the below is just for checking to make sure wl2q and wloc2q are the same (one is a function and the oth
        call wloc2q(check,w(1),l(1))
        if (check .ne. wl2q( w(1), l(1) ) ) then ; print*, 'something wrong in wl2q' ; stop ; end if
        qf: do j=1,nqs
			call q2wloc(j, w(2) , l(2) )		! do not need to do the above again since q2w,q2l and wl2q are the same for males and females
			if (l(1) == l(2) ) then 
				if ( z==1.and.w(1)==np1.and.w(2)==np1 ) then  
					qq=qq+1
					q2qq(i,j)	= qq 
					qq2q(:,qq)	= (/ i , j /) 
					qq2w(:,qq)	= w(:)
					qq2l(:,qq)	= l(:)
					if (skriv) then 
						write(40,10) 
						write(40,20) i,w(1),l(1),j,w(2),l(2),qq
					end if 
				else if (z==2.and.(w(1)<=np.or.w(2)<=np)) then 
					qq=qq+1
					q2qq(i,j)	= qq 
					qq2q(:,qq)	= (/ i , j /) 
					qq2w(:,qq)	= w(:)
					qq2l(:,qq)	= l(:)
					if ( skriv) then 
						write(40,10) 
						write(40,20) i,w(1),l(1),j,w(2),l(2),qq
					end if 
				else if (z==3.and.(w(1)>=np1.and.w(2)>=np1).and.(w(1)==np2.or.w(2)==np2) ) then 
					qq=qq+1
					q2qq(i,j)	= qq 
					qq2q(:,qq)	= (/ i , j /) 
					qq2w(:,qq)	= w(:)
					qq2l(:,qq)	= l(:)						
					if (skriv) then 
						write(40,10) 
						write(40,20) i,w(1),l(1),j,w(2),l(2),qq
					end if 					
				end if				 
			end if 
		end do qf
	end do qm
	end do 
	10 format (/ 1x,tr5,'qm',tr2,'w1',tr2,'l1',tr6,'qf',tr2,'w2',tr2,'l2',tr6,'qq' /) 
	20 format (i8,2i4,i8,2i4,i8)
	if (skriv) then 
		if ( qq /= nq ) then ; print*, "qq not equal to nq! ",qq,nq ; stop ; end if 
		if ( qq /= np2 * np2 * nl ) then ; print*, "qq not equal to npr*npr*nl! ",qq,np2*np2*nl ; stop ; end if 
	!	print*, "done with getq2q "
	end if
	if (skriv) then 
		do q=1,nqs
			i=q2w(q)
			j=q2l(q)
			if (wl2q(i,j)/=q) then 
				print*, "in getq2q: wl2q does not work ",q,wl2q(i,j),i,j
				stop 
			end if 
		end do 
		do qq=1,nq
			w=qq2w(:,qq)
			l=qq2l(:,qq)
			i=qq2q(1,qq)
			j=qq2q(2,qq)			
			if (wl2q(w(1),l(1))/=i .or. wl2q(w(2),l(2))/=j) then 
				print*, "in getq2q: qq2w,qq2l,wl2q does not work "  !,q,wl2q(i,j),i,j
				stop 
			end if 
			if ( q2qq(i,j) /= qq) then 
				print*, "in getq2q: q2qq does not work "   !,q,wl2q(i,j),i,j
				stop 
			end if 
		end do 
	end if 
	end subroutine getq2q

	subroutine getx2x
	integer(i4b) :: x,xx,i,j,e(2),r(2),kid(2)		!e is education and r is experience 
	xx2x=0 ; x2xx=0 ; xx=0 ; xx2e=0 ; xx2r=0 
	xm: do i=1,nxs
		call x2edexpkid(i, e(1) , r(1) , kid(1) )
		x2e(i) = e(1) 
		x2r(i) = r(1)
        x2kid(i) = kid(1)
		erkid2x( e(1), r(1) , kid(1) ) = i 
		xf: do j=1,nxs
			call x2edexpkid(j, e(2) , r(2) , kid(2) )
			xx=xx+1
			x2xx(i,j)	= xx 
			xx2x(:,xx)	= (/ i , j /)
			xx2e(:,xx)	= e(:)		! education
			xx2r(:,xx)	= r(:)		! experience
			xx2kid(:,xx)= kid(:)    ! kid          
		end do xf
	end do xm
	if (skriv) then 
		if ( xx /= nx ) then ; print*, "xx not equal to nx! ",xx,nx ; stop ; end if 
		if ( xx /= neduc*nexp*nkid*neduc*nexp*nkid ) then ; print*, "xx not equal to neduc*nexp*nkid*neduc*nexp*nkid! " ; stop ; end if 
	!	print*, "done with getx2x "
	end if 
	end subroutine getx2x

	subroutine getppsq
	! calculates transition probs between q0 and q. getgauss needs to be called before this as you need wgt
	integer(i4b) :: g,n,i,j,e,r,w,l,w0,l0
	real(dp):: prof(3),prloc(nl),dum(np2,nl),proftemp(3)
	ppsq=0.0_dp 
	sex: do g=1,2					! sex
		x0: do n=1,nxs				! x0
			e=x2e(n)			! e is education 
			q0: do i=1,nqs			! q0
				if ( q2w(i)<=np1 ) then	!state variable part of the q space i.e. w /= np2
					w0=q2w(i) 
					l0=q2l(i)
					prof=abs(fnprof(w0,e,1)-fnprof(w0,e,2)) 
					if ( icheck_eqvmvf.and.maxval(prof)>eps ) then 
						print*, "not even ",w,e,prof
						!stop
					end if 
					prloc(:) = fnprloc(l0) 				 
					q: do j=1,nqs
						w=q2w(j) 
						l=q2l(j)	
                        !ahu jan19 012819: separating the offer probs by whether it's curloc or ofloc. no more ed. 
                        if (q2l(j)==q2l(i) ) then   !if curloc
    					    prof(:)  = fnprof (w0,5,g)
                        else                        !if ofloc
    					    prof(:)  = fnprof (w0,10,g)
                        end if                         

                        !ahu jan19 011219: no on the job seearch since not identified
                        !if (onthejobsearch ) then 
                        proftemp=prof
                        !else
                        !    if (q2w(i)<=np ) then           !if working
                        !        if (q2l(j)==q2l(i) ) then   !and the offer is from curloc
                        !            proftemp(1)=0.0_dp ; proftemp(2)=prof(2) ; proftemp(3)=prof(1)+prof(3)  !then there is no job offer so that p(offer)=0 and p(layoff) is just the same i.e. prof(layoff) and p(nothing) is prof(offer)+prof(nothing)
                        !        else                        !and the offer is from ofloc
                        !            proftemp(:)=prof(:)     !then there is potentially a job offer
                        !        end if 
                        !    else                            !if not working, no such complications. can get job offer regardless of curloc or ofloc
                        !        proftemp(:)=prof(:)
                        !    end if
                        !end if !onthejobsearch
                        !ahu jan19 011219: no on the job seearch since not identified
                        
						if	( w <= np ) then 
							dum(w,l) = prloc(l) * proftemp(1) * wgt(w)  !ahu jan19 011219:
						else if ( w == np1 ) then 
							dum(w,l) = prloc(l) * proftemp(2)           !ahu jan19 011219:
						else if ( w == np2 ) then 
							dum(w,l) = prloc(l) * proftemp(3)           !ahu jan19 011219:
						end if 				
                        ppsq(j,i,n,g) = dum(w,l) !ahu040917 prob changes 
					end do q 
					!ahu040917 prob changes ppsq(:,i,n,g) = reshape( dum, (/ np2 * nl /) ) 
					if ( q2w(i) == np2 ) then ; print*, "error in ppsq: q2w does not agree with ps0 " ; stop ; end if  
                    if ( abs( sum(ppsq(:,i,n,g))-1.0_dp   ) > eps   ) then ; print*, 'ppsq does not sum to 1',sum(ppsq(:,i,n,g)) ; stop ; end if 
				else 
					ppsq(:,i,n,g) = pen 
				end if 									
			end do	q0
		end do x0

		pps(:,:,g)=.false.			
		do i=1,nqs
			do j=1,nqs				
				if (  q2w(i)<=np1 .and. maxval(ppsq(j,i,:,g)) > 0.0_dp ) then 
					pps(j,i,g) = .true.
				end if 
			end do 
		end do 
	end do sex 

	if (icheck_eqvmvf) then 
	do n=1,nxs
		do i=1,nqs
			do j=1,nqs
				if ( abs(ppsq(j,i,n,1)-ppsq(j,i,n,2))>eps ) then 
					print*, "m f par same but ppsq not equal! ", n,i,j,ppsq(j,i,n,:)
					stop
				end if 
			end do 
		end do 
	end do 
	end if 
	!if (skriv) print*, "done with getppsq "
	end subroutine getppsq

	subroutine getppcq
	integer(i4b) :: n,i,j,ns(2),is(2),js(2)
    integer(i4b) :: w0(2),l0(2),w(2),l(2),e0(2)
    real(dp) :: profm(3),proff(3),prloc(nl),profmtemp(3),profftemp(3)
    
    !ahu 040917 prob changes: 
	ppcq=0.0_dp 	
	x0: do n=1,nx				
        ns(:)=xx2x(:,n)
        e0(1)=x2e( ns(1) )
        e0(2)=x2e( ns(2) )
		q0: do i=1,nq	
        
			if ( maxval(qq2w(:,i)) <= np1 ) then !state variable part of the q space i.e. w <= np1

                is(:)=qq2q(:,i)   
			    w0(1)=q2w( is(1) )
			    w0(2)=q2w( is(2) )       
			    l0(1)=q2l( is(1) )
			    l0(2)=q2l( is(2) )       
                !profm(:)  = fnprof (w0(1),e0(1),1)
                !proff(:)  = fnprof (w0(2),e0(2),2)
                prloc(:) = fnprloc(l0(1)) 				   
                if (l0(1).ne.l0(2)) then ; print*, 'l0 not equal' ; stop ; end if 
                q: do j=1,nq
                    js(:)=qq2q(:,j)   
			        w(1)=q2w( js(1) )
			        w(2)=q2w( js(2) )       
			        l(1)=q2l( js(1) )
			        l(2)=q2l( js(2) )
                    
                    !ahu jan19 012819: separating the offer probs by whether it's curloc or ofloc. no more ed. 
                    if (q2l(js(1))==q2l(is(1)) ) then   !if curloc
    					profm(:)  = fnprof (w0(1),5,1)
    					proff(:)  = fnprof (w0(2),5,2)
                    else                                !if ofloc
    					profm(:)  = fnprof (w0(1),10,1)
    					proff(:)  = fnprof (w0(2),10,2)
                    end if                         

                    !ahu jan19 011219: no on the job seearch since not identified
                    !if (onthejobsearch ) then
                    profmtemp=profm
                    profftemp=proff
                    !else
                    !    if ( w0(1) <=np ) then           !if working
                    !        if (l(1)==l0(1) ) then       !and the offer is from curloc
                    !            profmtemp(1)=0.0_dp ; profmtemp(2)=profm(2) ; profmtemp(3)=profm(1)+profm(3)  !then there is no job offer so that p(offer)=0 and p(layoff) is just the same i.e. prof(layoff) and p(nothing) is prof(offer)+prof(nothing)
                    !        else                        !and the offer is from ofloc
                    !            profmtemp(:)=profm(:)     !then there is potentially a job offer
                    !        end if 
                    !    else                            !if not working, no such complications. can get job offer regardless of curloc or ofloc
                    !        profmtemp(:)=profm(:)
                    !    end if
                    !    if ( w0(2) <=np ) then           !if working
                    !        if (l(2)==l0(2) ) then       !and the offer is from curloc
                    !            profftemp(1)=0.0_dp ; profftemp(2)=proff(2) ; profftemp(3)=proff(1)+proff(3)  !then there is no job offer so that p(offer)=0 and p(layoff) is just the same i.e. prof(layoff) and p(nothing) is prof(offer)+prof(nothing)
                    !        else                        !and the offer is from ofloc
                    !            profftemp(:)=proff(:)     !then there is potentially a job offer
                    !        end if 
                    !    else                            !if not working, no such complications. can get job offer regardless of curloc or ofloc
                    !        profftemp(:)=proff(:)
                    !    end if
                    !end if !onthejobsearch
                    !ahu jan19 011219: no on the job seearch since not identified

                    if (l(1).ne.l(2)) then ; print*, 'l not equal' ; stop ; end if 
                    
                    if	( w(1) <= np .and. w(2)<=np ) then 
					    ppcq(j,i,n) = prloc(l(1)) * profmtemp(1) * wgt(w(1)) * profftemp(1) * wgt(w(2))
                    else if	( w(1) <= np .and. w(2)==np1 ) then 
					    ppcq(j,i,n) = prloc(l(1)) * profmtemp(1) * wgt(w(1)) * profftemp(2)
                    else if	( w(1) <= np .and. w(2)==np2 ) then 
					    ppcq(j,i,n) = prloc(l(1)) * profmtemp(1) * wgt(w(1)) * profftemp(3)
                        
                    else if	( w(1) == np1 .and. w(2)<=np ) then 
					    ppcq(j,i,n) = prloc(l(1)) * profmtemp(2) * profftemp(1) * wgt(w(2))
                    else if ( w(1) == np1 .and. w(2)==np1 ) then 
					    ppcq(j,i,n) = prloc(l(1)) * profmtemp(2) * profftemp(2) 
                    else if ( w(1) == np1 .and. w(2)==np2 ) then 
					    ppcq(j,i,n) = prloc(l(1)) * profmtemp(2) * profftemp(3) 
                    
                    else if	( w(1) == np2 .and. w(2)<=np ) then 
					    ppcq(j,i,n) = prloc(l(1)) * profmtemp(3) * profftemp(1) * wgt(w(2))
                    else if ( w(1) == np2 .and. w(2)==np1 ) then 
					    ppcq(j,i,n) = prloc(l(1)) * profmtemp(3) * profftemp(2) 
                    else if ( w(1) == np2 .and. w(2)==np2 ) then 
					    ppcq(j,i,n) = prloc(l(1)) * profmtemp(3) * profftemp(3) 
                    end if 		
                    
                end do q          
				if (maxval(qq2w(:,i)) == np2) then ; print*, "error in ppcq: qq2w does not agree with pc0 " ; stop ; end if  	
                if ( abs( sum(ppcq(:,i,n))-1.0_dp   ) > eps   ) then ; print*, 'ppcq does not sum to 1',sum(ppcq(:,i,n)) ; stop ; end if 
			else 
				ppcq(:,i,n)=pen 
			end if 
                     
		end do q0
	end do x0

	!ahu 040917 prob changes ppcq=0.0_dp		
	!ahu 040917 prob changes x0: do n=1,nx				
    !ahu 040917 prob changes ns=xx2x(:,n)
		!ahu 040917 prob changes q0: do i=1,nq	
			!ahu 040917 prob changes if ( maxval(qq2w(:,i)) <= np1 ) then !state variable part of the q space i.e. w <= np1
				!ahu 040917 prob changes is=qq2q(:,i)
				!ahu 040917 prob changes q: do j=1,nq
					!ahu 040917 prob changes js=qq2q(:,j)	
					!ahu 040917 prob changes ppcq(j,i,n) = ppsq(js(1),is(1),ns(1),1) * ppsq(js(2),is(2),ns(2),2) 	! normalize: i.e. taking into account that they only receive offer from same loc (by modeling restriction, not because its prob is 0) 					
                                                                                            ! the q for couples just does not include points where the l is different for the partners. so this is how this restriction is imposed. 
				!ahu 040917 prob changes end do q			 
				!ahu 040917 prob changes ppcq(:,i,n)=ppcq(:,i,n)/sum( ppcq(:,i,n) )
				!ahu 040917 prob changes if (maxval(qq2w(:,i)) == np2) then ; print*, "error in ppcq: qq2w does not agree with pc0 " ; stop ; end if  			
			!ahu 040917 prob changes else 
				!ahu 040917 prob changes ppcq(:,i,n)=pen 
			!ahu 040917 prob changes end if 
		!ahu 040917 prob changes end do q0
	!ahu 040917 prob changes end do x0
	!if ( q2l(qm) == q2l(qf) ) then 
	!	tmpsum( q2qq(qm,qf) ) = tmpsum( q2qq(qm,qf) ) + ppsq(qm,is(1),ns(1),1) * ppsq(qf,is(2),ns(2),2) 						
	!end if 
	!if ( maxval( qq2w(:,j) ) >= np1 ) then		! they can't both get offers
	! by assumption, if they do get offers at all, both spouses' offer location is the same
	! incorporate this as a conditioning statement when calculating the joint offer/loc probabilities of castanza
	! this is more transparent than the ptemp and prloc calculation that we were doing in the previous versions  i.e. ppcq(j,i,n) = ptemp(js(1),is(1),ns(1),1) * ptemp(js(2),is(2),ns(2),2) * prloc(loc)
	! the above boils down to calculating the prob of the conditioning statement and dividing by it to get the conditional probability	
	!defining ppc below just so that we don't need to use x0 in the big loop when trying to save time by skipping the zero prob q points
	ppc=.false.
	do i=1,nq
		do j=1,nq
			if ( maxval(qq2w(:,i)) <= np1 .and.  maxval(ppcq(j,i,:)) > 0.0_dp  ) then 
				ppc(j,i) = .true. 
			end if 
		end do 
	end do 	
	!if (skriv) print*, "done with getppcq "

 
	end subroutine getppcq

	subroutine getppsx
	real(dp), dimension(nexp) :: prhc
	integer(i4b) :: n,i,j,e0,e1,r0,r1,w0,l,kid0,kid1
    real(dp) :: probkid
	prhc=0.0_dp
	ppsx=0.0_dp 	
	x0: do n=1,nxs	
		e0=x2e(n)
		r0=x2r(n)
        kid0=x2kid(n)
		q0: do i=1,nqs				
            if ( q2w(i)<=np1 ) then	!state variable part of the q space i.e. w /= np2

                w0=q2w(i)
                prhc(1:nexp) = fnprhc( r0 , w0 ) 
                
			    x: do j=1,nxs	
				    e1=x2e(j)
				    r1=x2r(j)
                    kid1=x2kid(j)
                    probkid=-99.0_dp
                    if (kid0==1.and.kid1==1) then
                        probkid=1.0_dp-pkid
                    else if (kid0==1.and.kid1==2) then
                        probkid=pkid 
                    else if (kid0==2.and.kid1==1) then
                        probkid=0.0_dp
                    else if (kid0==2.and.kid1==2) then
                        probkid=1.0_dp
                    end if          
                    if (probkid<0) then ; print*, 'probkid is negative in getppsx' ; stop ; end if 
				    !ppsx(j,i,n) = prhc(r1) * one(e0==e1) * one(kid0==kid1)	! trans prob is 0 if educ is not equal. it is also 0 if kid state is not equal. 
			        ppsx(j,i,n) = prhc(r1) * one(e0==e1) * probkid	! trans prob is 0 if educ is not equal. it is also 0 if kid state is not equal. 
                end do x 
                
                if ( abs( sum(ppsx(:,i,n))-1.0_dp   ) > eps   ) then ; print*, 'ppsx does not sum to 1',sum(ppsx(:,i,n)) ; stop ; end if 
                
			else 
				ppsx(:,i,n)=pen 
			end if 
                
        end do q0
	end do 	x0
	!if (skriv) print*, "done with getppsx "
	end subroutine getppsx
    
	subroutine getppcx
	integer(i4b) :: n,i,j,ns(2),is(2),js(2)
    integer(i4b) :: e0(2),r0(2),kid0(2),w0(2)
    integer(i4b) :: e1(2),r1(2),kid1(2)
    real(dp) :: probkid,prhc_m(nexp),prhc_f(nexp)
	ppcx=0.0_dp 	
	x0: do n=1,nx				
        ns(:)=xx2x(:,n)
        e0(1)=x2e( ns(1) )
		r0(1)=x2r( ns(1) )
        kid0(1)=x2kid( ns(1) )
        e0(2)=x2e( ns(2) )
		r0(2)=x2r( ns(2) )
        kid0(2)=x2kid( ns(2) )        
		q0: do i=1,nq	
			if ( maxval(qq2w(:,i)) <= np1 ) then !state variable part of the q space i.e. w <= np1

                is(:)=qq2q(:,i)   
			    w0(1)=q2w( is(1) )
			    w0(2)=q2w( is(2) )       
 
                prhc_m(1:nexp) = fnprhc( r0(1) , w0(1) ) 
                prhc_f(1:nexp) = fnprhc( r0(2) , w0(2) ) 
            
			    x: do j=1,nx
				    js(:)=xx2x(:,j)
				    e1(1)=x2e( js(1) )
				    r1(1)=x2r( js(1) )
                    kid1(1)=x2kid( js(1) )
				    e1(2)=x2e( js(2) )
				    r1(2)=x2r( js(2) )
                    kid1(2)=x2kid( js(2) )
                    probkid=-99.0_dp
                    if ( kid0(1) == 1 .and. kid0(2)==1 ) then 
                        if (kid1(1)==1 .and. kid1(2)==1 ) then 
                                probkid=(1.0_dp-pkid)*(1.0_dp-pkid)
                        else if (kid1(1)==2 .and. kid1(2)==1 ) then 
                                probkid=pkid*(1.0_dp-pkid)
                        else if (kid1(1)==1 .and. kid1(2)==2 ) then 
                                probkid=(1.0_dp-pkid)*pkid
                        else if (kid1(1)==2 .and. kid1(2)==2 ) then 
                                probkid=pkid*pkid
                        end if 
                    else if ( kid0(1) == 2 .and. kid0(2)==1 ) then 
                        if (kid1(1)==1 .and. kid1(2)==1 ) then 
                                probkid=0.0_dp
                        else if (kid1(1)==2 .and. kid1(2)==1 ) then 
                                probkid=(1.0_dp-pkid)
                        else if (kid1(1)==1 .and. kid1(2)==2 ) then 
                                probkid=0.0_dp
                        else if (kid1(1)==2 .and. kid1(2)==2 ) then 
                                probkid=pkid
                        end if 
                    else if ( kid0(1) == 1 .and. kid0(2)==2 ) then 
                        if (kid1(1)==1 .and. kid1(2)==1 ) then 
                                probkid=0.0_dp
                        else if (kid1(1)==2 .and. kid1(2)==1 ) then 
                                probkid=0.0_dp
                        else if (kid1(1)==1 .and. kid1(2)==2 ) then 
                                probkid=(1.0_dp-pkid)
                        else if (kid1(1)==2 .and. kid1(2)==2 ) then 
                                probkid=pkid
                        end if 
                    else if ( kid0(1) == 2 .and. kid0(2)==2 ) then 
                        if (kid1(1)==1 .and. kid1(2)==1 ) then 
                                probkid=0.0_dp
                        else if (kid1(1)==2 .and. kid1(2)==1 ) then 
                                probkid=0.0_dp
                        else if (kid1(1)==1 .and. kid1(2)==2 ) then 
                                probkid=0.0_dp
                        else if (kid1(1)==2 .and. kid1(2)==2 ) then 
                                probkid=1.0_dp
                        end if 
                    end if 
                    if (probkid<0) then ; print*, 'something wrong with probkid',probkid,kid0,kid1 ; stop ; end if 
                    !ppcx(j,i,n) = ppsx( js(1), is(1), ns(1) ) * ppsx( js(2), is(2), ns(2) )
                    ppcx(j,i,n) = prhc_m( r1(1) ) * prhc_f( r1(2) ) * one( e0(1) == e1(1) ) * one( e0(2) == e1(2) ) * probkid  
			    end do x
                
                if ( abs( sum(ppcx(:,i,n))-1.0_dp   ) > eps   ) then ; print*, 'ppcx does not sum to 1',sum(ppcx(:,i,n)) ; stop ; end if 
			else 
				ppcx(:,i,n)=pen 
			end if 

		end do q0
	end do x0
	!if (skriv) print*, "done with getppcx "
	end subroutine getppcx


	subroutine getch_single
	! choice vectors that indicate whether an alternative is feasible given the status quo and given the offer situation
	! w=np+1 --> this is layoff if you're working and otherwise it's nothing. and choosing to go anywhere unemp is always an option in any case
	! w=np+2 --> this is just the "nothing happens" case and choosing that doesn't make sense 
	integer(i4b) :: i,j,w0,w,c,l0,l,dum(2,nl)
	chs=0 ; c=0
	do i=1,nl							! choice index
		c=c+1
		w=np1							! w=np+1 denotes unemployment 
		j=wl2q(w,i)						! get what choosing unemployment (w=np+1) at location l corresponds to in terms of the composite index q
		chs(c,:,:)=j						! moving anywhere unemployed is always an option					
		dum(1,c)=w
		dum(2,c)=i
	end do 	
	if (skriv) then 		
		if ( c /= nl ) then ; print*, "c is not equal to nl! ",c,nl ; stop ; end if 		
	end if 
	q0: do i=1,nqs
		w0 = q2w(i)
		l0 = q2l(i)
		if (w0<=np1) then 
			q: do j=1,nqs					
				!call q2wloc(j,w,l) 
				w = q2w(j)
				l = q2l(j)
                
                if (w0<=np) then        !currently employed 
                    if (l==l0) then         !curloc draw
                        if (w<=np) then         !gets wage offer
                            chs(c+1,j,i) = i    !status quo
                            chs(c+2,j,i) = j    !accept offer
                        else if (w==np1) then   !gets laid off
                            chs(:,j,i) = 0      !when gets laid off, nothing is feasible other than unemployment at l0
                            chs(l0,j,i) = wl2q(np1,l0)	     !when gets laid off, nothing is feasible other than unemployment at l0
                            chs(c+1,j,i) = 0    !when gets laid off, status quo not feasible
                            chs(c+2,j,i) = 0    !when gets laid off, no offer to accept
                        else if (w==np2) then   !nothing happens
                            chs(c+1,j,i) = i    !status quo
                            chs(c+2,j,i) = 0    !when nothing happens, no offer to accept
                        end if
                    else if (l/=l0) then         !ofloc draw
                        if (w<=np) then         !gets wage offer
                            chs(c+1,j,i) = i    !status quo
                            chs(c+2,j,i) = j    !accept offer
                        else if (w==np1) then   !gets laid off !BUT NOTE THT THIS DOES NOT HAPPEN WHEN THE DRAW IS OFLOC
                            chs(c+1,j,i) = 0    !when gets laid off, status quo not feasible
                            chs(c+2,j,i) = 0    !when gets laid off, no offer to accept
                        else if (w==np2) then   !nothing happens
                            chs(c+1,j,i) = i    !status quo
                            chs(c+2,j,i) = 0    !when nothing happens, no offer to accept
                        end if
                    end if 
                else if (w0==np1) then      !currently unemployed 
                    if (l==l0) then         !curloc draw
                        if (w<=np) then         !gets wage offer
                            chs(c+1,j,i) = i    !status quo
                            chs(c+2,j,i) = j    !accept offer
                        else if (w==np1) then   !gets laid off BUT NOTE THAT THIS DOES NOT HAPPEN WHEN UNEMPLOYED
                            chs(c+1,j,i) = 0    !when gets laid off, status quo not feasible
                            chs(c+2,j,i) = 0    !when gets laid off, no offer to accept
                        else if (w==np2) then   !nothing happens
                            chs(c+1,j,i) = i    !status quo
                            chs(c+2,j,i) = 0    !when nothing happens, no offer to accept
                        end if
                    else if (l/=l0) then         !ofloc draw
                        if (w<=np) then         !gets wage offer
                            chs(c+1,j,i) = i    !status quo
                            chs(c+2,j,i) = j    !accept offer
                        else if (w==np1) then   !gets laid off  BUT NOTE THAT THIS DOES NOT HAPPEN WHEN UNEMPLOYED
                            chs(c+1,j,i) = 0    !when gets laid off, status quo not feasible
                            chs(c+2,j,i) = 0    !when gets laid off, no offer to accept
                        else if (w==np2) then   !nothing happens
                            chs(c+1,j,i) = i    !status quo
                            chs(c+2,j,i) = 0    !when nothing happens, no offer to accept
                        end if
                    end if 
                end if     
                        

				!if ( w /= np1 .and. w0 /= np1 ) then	! w=np+1 denotes getting laid off (in the case where q denotes shocks) 
									! and w0=np+1 denotes the state variable w0 indicating that you start that period as unemployed 
				!	chs(c+1,j,i) = i		! c+1 is nl+1 which denotes the status quo option. can choose the status quo only if you don't get laid off. also don't need to allow this choice if the status quo is unemployment 	
				!end if 
				!if ( w <= np ) then			! offer is only the cases where w<=np. in other offer situation where w>np, it means either that you get laid off or nothing happens, so those things do not really give you any options. 
				!	chs(c+2,j,i) = j		! c+2 is nl+2 which denotes the option of taking the offer q
				!end if 		
			end do q
		else 
			chs(:,:,i)=0
		end if 
	end do q0
	!if (skriv) print*, "done with getch_single "
    end subroutine 
	subroutine getch_couple
	! choice vectors that indicate whether an alternative is feasible given the status quo and given the offer situation
	integer(i4b) :: i,j,a,b,cc,qc(2),is(2),js(2),l(2), d(nc),k
	ch=0
	qq0: do i=1,nq
			if (  qq2w(1,i)<=np1 .or.  qq2w(2,i)<=np1 )  then
				qq: do j=1,nq			
					cc=0						! counter for number of choices for couple
					is(:)=qq2q(:,i)				! transform qq0 into single's q0
					js(:)=qq2q(:,j)				! transform qq  into single's q
					do a=1,ncs					! choice of husband
						do b=1,ncs				! choice of wife
							qc(1)=chs(a,js(1),is(1))	! transform husband's choice into q
							qc(2)=chs(b,js(2),is(2))	! transform wife's choice into q
							if ( minval(qc) > 0 ) then	! the option has to be feasible for both of them which is denoted by qc(1) and qc(2) both being larger than 0.
								l(1) = q2l( qc(1) )	! get the location that corresponds to husband choice qc(1) here 
								l(2) = q2l( qc(2) )	! get the location that corresponds to wife whoice qc(2) here 
								if ( l(1) == l(2) ) then !a choice is feasible for the couple only if the respective locations of that choice is equal. the others are not options.
									cc=cc+1		
									ch(cc,j,i)=q2qq( qc(1) , qc(2) )	!transform single's choice qm and qf into couple's choice qq  
								end if 
							end if 
						end do 
					end do 
				end  do qq
			else 
				ch(:,:,i)=0
			end if 
	end do 	qq0
	if (skriv) then 
		if (cc > nc ) then ; print*, " cc > nc " , cc , nc ; end if		!theoretically, the max number of options they have is nl+8 (nl is the uu for each l option, and then it's 3*3-1 because it's combinatorial of --- --- where each have 3 things they can be (u,q0,q). so the total combo comes to 3*3. but then you subtract 1 because uu is already accounted for in the first nl options
	!	print*, "done with getch_couple "
	end if 
	end subroutine getch_couple

	subroutine getgauss
	! gauss quadrature hermite weights and abscissas for wage draws and marriage utility shocks
	integer(i4b) :: g,i,j,k,trueindex
	real(sp) :: abs1(np),wgt1(np)
	real(sp) :: abs2(nz),wgt2(nz)
	real(sp) :: abs3(nepsmove),wgt3(nepsmove)
    real(sp) :: dum1(np),dum2(np)
	real(sp) :: dum3(nz),dum4(nz)
	real(sp) :: dum5(nepsmove),dum6(nepsmove)
    real(dp) :: RHO(2,2),CD(2,2),epsw(2)

    !**********************************************************************
    !*Call Cholesky routine that does the following:                      *
    !*Construct the covariance matrix btw male and female wage draws         *
    !*Take Cholesky Decomposition of the covariance matrix                *
    !**********************************************************************
    !Construct the correlation matrix 
    !And then using the corr matrix, construct the cov matrix
    !sigma(1)=sig_wge(1)
    !sigma(2)=sig_wge(2)
    RHO(1,1)=1.0_dp		
    RHO(2,2)=1.0_dp	
    RHO(2,1)=ro		
    RHO(1,2)=RHO(2,1)
    !if (myid.eq.0) then
    !	print*, "Here are the sigmas: "
    !	print*, sig_w1,sig_w2,ro1
    !	print*, "Here is the correlation matrix: "
    !	print*, RHO(1,1),RHO(1,2)
    !	print*, RHO(2,1),RHO(2,2)
    !end if
    !Now turn correlation matrix into varcov matrix
    do j=1,2
	    do k=1,2
		    RHO(j,k)=RHO(j,k)*sig_wge(j)*sig_wge(k)
	    end do 
    end do 
    if (skriv) then
    	print*, "Here is the covariance matrix: "
    	print*, RHO(1,1),RHO(1,2)
    	print*, RHO(2,1),RHO(2,2)
    end if
    CALL cholesky_m(RHO,2,CD)
    if (skriv) then
    	print*, "Here is the cholesky decomposition: "
    	print*, CD(1,1),CD(1,2)
    	print*, CD(2,1),CD(2,2)
    end if

	call gauher(abs1 , wgt1 )				
	do i=1,np
		dum1(i)=abs1(np-i+1)
		dum2(i)=wgt1(np-i+1)
	end do 
	abs1	=	dum1
	wgt1	=	dum2
	wgt	=	wgt1 / sqrtpi						! weights for wage distributions
	!sex: do g=1,2
		!ahu 0327 wg(:,g) = sqrt(2.0_dp) * sig_wge(g) * abs1(:) + mu_wge(g)	! abscissas for wage draw distribution (g for males and females)
        !wg(:,g) = sqrt(2.0_dp) * abs1(:) 	!ahu 0327  abscissas for wage draw distribution (g for males and females)
    wg(:,1)=CD(1,1)*sqrt(2.0_dp) * abs1(:)
    wg(:,2)=CD(2,1)*sqrt(2.0_dp) * abs1(:) + CD(2,2)*sqrt(2.0_dp) * abs1(:)
	!end do sex 

    
	call gauher( abs2 , wgt2)				
	do i=1,nz
		dum3(i)=abs2(nz-i+1)
		dum4(i)=wgt2(nz-i+1)
    end do 
	!if (skriv.and.(.not.chkstep).and.(.not.optimize)) print*, "abs2 ", abs2
    !if (skriv.and.(.not.chkstep).and.(.not.optimize)) print*, "dum3 ", dum3
    abs2=dum3
	wgt2=dum4
	mgt = wgt2 / sqrtpi							! weights for mar distribution
	!call rand2num(mu_mar,sig_mar,abs2,mg)
    do trueindex=1,ninp
        call index2cotyphome(trueindex,i,j,k)
	    mg(:,trueindex) = sqrt(2.0_dp) * sig_mar * abs2(:) + mu_mar(j)			! abscissas for marrige utility shock distribution
	    !if ((.not.chkstep).and.(.not.optimize) ) print*, "mg :", mg(:)
	    mg(:,trueindex) = sqrt(2.0_dp) * sig_mar * dble(abs2(:)) + mu_mar(j)		! abscissas for marrige utility shock distribution
        !mg(1:2) = 0.0_dp
	    !mg(3:5) = -8000.0_dp	
	    !mg=0.0_dp
	    !mg=-1.0_dp
	    !if (skriv) print*, "done with getgauss "
    end do 
    
	call gauher( abs3 , wgt3)				
	do i=1,nepsmove
		dum5(i)=abs3(nepsmove-i+1)
		dum6(i)=wgt3(nepsmove-i+1)
    end do 
	!if (skriv.and.(.not.chkstep).and.(.not.optimize)) print*, "abs2 ", abs2
    !if (skriv.and.(.not.chkstep).and.(.not.optimize)) print*, "dum3 ", dum3
    abs3=dum5
	wgt3=dum6
	ppso = wgt3 / sqrtpi							! weights for moveshock distribution
	!call rand2num(mu_mar,sig_mar,abs2,mg)
	moveshock_m(:) = sqrt(2.0_dp) * sigo_m * abs3(:) + mu_o			! abscissas for marrige utility shock distribution
	moveshock_f(:) = sqrt(2.0_dp) * sigo_f * abs3(:) + mu_o			! abscissas for marrige utility shock distribution
    !if ((.not.chkstep).and.(.not.optimize) ) print*, "mg :", mg(:)
	!moveshock(:) = sqrt(2.0_dp) * sig_o * dble(abs3(:)) + mu_o			! abscissas for marrige utility shock distribution
    if (nepsmove==1) then 
        moveshock_m=0.0_dp
        moveshock_f=0.0_dp
    end if
    bshock_m=moveshock_m
    bshock_f=moveshock_f
    moveshock_m=0.0_dp
    moveshock_f=0.0_dp
    

    
    
     if (skriv) print*, 'here is wgt3',ppso,sum(ppso)
    
    end subroutine getgauss
	
	subroutine getppmeet
	integer(i4b) :: hdif,i,j,w(2)
	real(dp):: udif
	ppmeetq=0.0_dp
	do j=1,nqs	
	!	w(1) = q2w( i ) 
		do i=1,nqs		
			if ( q2w(j) <= np1 .and. q2w(i) <= np1 .and. q2qq(i,j) > 0 ) then 
				ppmeetq(i,j)=1.0_dp
			end if 
		end do 
		ppmeetq(:,j)=ppmeetq(:,j)/sum(ppmeetq(:,j))
	end do 
	ppmeetx=0.0_dp
	do j=1,nxs	
	!	w(1) = q2w( i ) 
		do i=1,nxs		
			if ( x2xx(i,j) > 0 ) then 
				ppmeetx(i,j)=1.0
			end if 
		end do 
		ppmeetx(:,j)=ppmeetx(:,j)/sum(ppmeetx(:,j))
	end do 
	!		w(2) = q2w( j ) 
	!		if ( w(1) <= np1 .and. w(2) <= np1 ) then 
	!			if ( q2qq(i,j) > 0 ) then 
	!				    if (w(1) <= np .and. w(2) <= np ) then
	!					    udif = aw( w(1) , 1 ) - aw( w(2) , 2 )
	!				    else 
	!					    udif = 0.0_sp
	!				    end if 
	!				    hdif=abs ( ( w(1) <= np .and. w(2) == np+1 ) .or.  ( w(1) == np+1 .and. w(2) <= np )  )
	!				    ppmeetq(1,j,i)=max(0.0_dp,1.0_dp-omega(1)*udif**2-omega(2)*hdif )
	!				    ppmeetq(2,i,j)=max(0.0_dp,1.0_dp-omega(1)*udif**2-omega(2)*hdif )
	!			end if 
	!		 else 
	!			ppmeetq(:,j,i)=0.0_dp
	!		end if         
	!	end do qf
	! end do qm
	!do i=1,nqs
	! if ( q2w(i)>=np1 ) then
	! ppmeetq(1,:,i)=ppmeetq(1,:,i)/sum(ppmeetq(1,:,i))
	! ppmeetq(2,:,i)=ppmeetq(2,:,i)/sum(ppmeetq(2,:,i))
	!end if 
	! if (icheck==1) then 
	!	if ( q2w(i)>=np1 .and. abs( sum(ppmeetq(1,:,i))-1d0)>eps ) then ; print*, "ppmeetq for m doesn't add up ", sum(ppmeetq(1,:,i)) ; stop ; end if 
	!	if ( q2w(i)>=np1 .and. abs( sum(ppmeetq(2,:,i))-1d0)>eps ) then ; print*, "ppmeetq for f doesn't add up ", sum(ppmeetq(2,:,i)) ; stop ; end if 
	!	if ( q2w(i)>np1 .and. sum(ppmeetq(:,:,i)) /= 0.0_dp ) then ; print*, " w>np1 and ppmeetq is not 0 ", sum(ppmeetq(:,:,i)) ; stop ; end if 
	! end if 
	! end do 	
	!ppmeetx=0.0_dp
	!xm: do i=1,nxs			
	!	xf: do j=1,nxs		
	!		if ( x2xx(i,j) > 0 ) then 
	!			ppmeetx(i,j)=exp( 0.0_dp )
	!		end if 
	!	end do xf
	!end do xm
	!do i=1,nxs 
	!	ppmeetx(:,i)=ppmeetx(:,i)/sum(ppmeetx(:,i))
	!	if (icheck==1) then 		
	!		if ( abs( sum(ppmeetx(:,i))-1.0_dp) > eps ) then ; print*, "ppmeetx doesn't add up ", sum(ppmeetx(:,i)) ; stop ; end if 
	!	end if 
	!end do 		
	!if (skriv) print*, "done with ppmeet "
	end subroutine getppmeet

	subroutine checkgauss(npoint,lb,ub,cdf,expval)
	integer(i4b), intent(in) :: npoint
	real(sp) :: x0(npoint),w0(npoint)
	real(dp) :: x(npoint),w(npoint),dum
	real(dp), intent(in) :: lb,ub
	real(dp), intent(out) :: cdf(2),expval
	real(dp) :: sigma=1.0_dp,mu=0.0_dp
	integer(i4b) :: i
	dum=(6.28318_dp)**(-0.5_dp)*exp(-(0.6_dp)**2/2.0_dp)  / 0.72_dp			! dum=sqrt(2.0*pi)*exp(-(0.6)**2.0/2.0)  / 0.72
	call gauher( x0, w0)
	w	= w0 / sqrtpi		
	x	= sqrt(2.0_dp) * sigma * x0 + mu
	cdf=0.0_dp
	expval=0.0_dp
	do i=1,np
		if ( x(i) < lb ) then ; cdf(1) = cdf(1) + w(i) ; end if 
		if ( x(i) < ub ) then ; cdf(2) = cdf(2) + w(i) ; end if 
		if ( x(i)>lb .and. x(i)<ub ) then 
			expval = expval + w(i) * x(i)
		end if 
	end do
	expval=expval / ( cdf(2)-cdf(1) )  					!  / ( sqrtpi * (cdf(2)-cdf(1)) ) no need to divide by sqrtpi anymore since already do that with weights so it's already incorporated in both cdf and expval
	!write(*,'(/1x,a,f12.6,a,f12.6)') 'check value:',expval,'  should be:', dum
	end subroutine checkgauss

	function fnwge(dg,dtyp,dl,dw,de,dr)						
	integer(i4b), intent(in) :: dg,dtyp,dl,de,dr						! gender,typ,location,education,experience
	real(dp), intent(in) :: dw								! wage draw
	real(dp) :: fnwge
	if (dg==1) then 
		fnwge=exp(alf1t(dtyp)+alf10(dl)+alf11*one(de==2) + alf12*(dr-1) + alf13*((dr-1)**2) + dw ) 
	else if (dg==2) then 
		fnwge=exp(alf2t(dtyp)+alf20(dl)+alf21*one(de==2) + alf22*(dr-1) + alf23*((dr-1)**2) + dw ) 
	end if 
	end function fnwge

	function fnprof(dw0,de,dsex)
	integer(i4b), intent(in) :: dw0,de,dsex
	real(dp), dimension(3) :: fnprof
	fnprof=0.0_dp
	if ( dw0 <= np ) then 
		if ( de==5 .and. dsex==1 ) then 
			fnprof(1:2)=exp(psio(1:2)) !exp( psio(1) + psio(2) * abs(dsex==1) + psio(3) * abs(de==2) )	! offer 	 
		else if ( de==10 .and. dsex==1 ) then 
			fnprof(1:2)=exp(psio(3:4)) 
		else if ( de==5 .and. dsex==2 ) then 
			fnprof(1:2)=exp(psio(5:6)) 
		else if ( de==10 .and. dsex==2 ) then 
			fnprof(1:2)=exp(psio(7:8)) 
		end if 
		fnprof(3)=exp( 0.0_dp )		! nothing happens												
	else if (dw0 == np1) then 
		if ( de==5 .and. dsex==1 ) then 
			fnprof(1)=exp(psio(9)) !exp( psio(1) + psio(2) * abs(dsex==1) + psio(3) * abs(de==2) )	! offer 	 
		else if ( de==10 .and. dsex==1 ) then 
			fnprof(1)=exp(psio(10) )
		else if ( de==5 .and. dsex==2 ) then 
			fnprof(1)=exp(psio(11)) 
		else if ( de==10 .and. dsex==2 ) then 
			fnprof(1)=exp(psio(12)) 
		end if 
		fnprof(2)=0.0_dp		! 0 since you can't get laid off if you don't have a job! 
		fnprof(3)=exp(0.0_dp)		! nothing happens												
	else  
		print*, "in fnprof: dw0 > np1 which doesnt' make sense as that's a state variable " , dw0,de,dsex
		stop
	end if 
	fnprof(1:3)=fnprof/sum(fnprof)
	!fnprof=0.0_dp
	!fnprof(1)=1.0_dp						
	if (skriv) then 
		if ( abs(  sum(fnprof) - 1.0_dp  ) > eps) then ; print*, "error in getfnprof : offer does not add up " , sum(fnprof) ; stop ; end if 
	end if 
	end function fnprof


    
    
	function fnprloc(orig)
	integer(i4b), intent(in) :: orig		! origin location
	real(dp), dimension(nl) :: fnprloc
	integer(i4b) :: j
	real(dp), dimension(nl) :: temp
    fnprloc=0.0_dp
    temp=0.0_dp
	!ahu 030717 fnprloc(orig)=logit(psil(1)) !ahu 030717: putting psil(1) inside the exp instead because otherwise very high prloc from origin and low from others and 
                                             !            we get very low moving rates especially for married people. 
	do j=1,nl	
		!ahu 030717 if (j /= orig) then 
		!ahu 030717 	fnprloc(j)= exp( psil(2) * distance(j,orig) + psil(3) * popsize(j) ) 
		!ahu 030717 	sum_sans_orig = sum_sans_orig + fnprloc(j) 
		!ahu 030717 end if 
		temp(j)= exp( psil(1) * one(j==orig) )   ! + psil(2) * distance(j,orig) )    !+ psil(3) * popsize(j) ) 
    end do 
	do j=1,nl	
		!ahu 030717 if (j /= orig) then 
		!ahu 030717 	fnprloc(j)=(1.0_dp-fnprloc(orig) ) * fnprloc(j)/sum_sans_orig
		!ahu 030717 end if 
        fnprloc(j)=temp(j)/sum(temp(:))
	end do 
	if ( abs(  sum(fnprloc) - 1.0_dp  ) > eps) then ; print*, "error in getfnprloc : offer does not add up " , sum(fnprloc) ; stop ; end if 
	end function fnprloc

	function fnprhc(dr,dw)
	integer(i4b), intent(in) :: dr,dw		! experience and employment: w<=np work, w==np1 not work,  w=np2 nothing/can't be a state variable here so if you get this, there's something wrong
	real(dp), dimension(nexp) :: fnprhc
	integer(i4b) :: j
	if (skriv) then 
		if ( dw > np1 ) then ; print*, "in fnprof: dw0 > np1 which doesnt' make sense as that's a state variable " ; stop ; end if 
	end if 
	fnprhc=0.0_dp
	do j=1,nexp	
		if ( dw <= np ) then 
			if ( j-dr == +1 ) then  
				fnprhc(j)= psih(1)   !ahu jan19 011719 changing to logit
            else if (j==dr) then 
				fnprhc(j)=1.0_dp-psih(1)      !exp(0.0_dp)   !ahu jan19 011719 changing to logit
			!else if ( j-dr == -1 ) then  !ahu jan19 011519 getting rid of probdown
			!	fnprhc(j)=exp(  psih(1)   )
			else 
				fnprhc(j) = 0.0_dp
			end if 
		else if ( dw == np1 ) then 
			if ( j-dr == +1 ) then  
				fnprhc(j)=psih(2)    !ahu jan19 011719 changing to logit
            else if (j==dr) then 
				fnprhc(j)=1.0_dp-psih(2)      !exp(0.0_dp)   !ahu jan19 011719 changing to logit
			!else if ( j-dr == -1 ) then  ahu jan19 011519 getting rid of probdown
		    !		fnprhc(j)=exp(  psih(3)   )
			else 
				fnprhc(j) = 0.0_dp
			end if 
		end if 
	end do 	
	fnprhc(:)=fnprhc(:)/sum(fnprhc)
    !print*, dr,fnprhc(:)
    
	if (skriv) then 
		if ( abs(sum(fnprhc(:))-1.0_dp) > eps ) then ; print*, " error in fnprhc: prhc does not add up " , dw , sum(fnprhc(:)) ; stop ; end if 
	end if 
	end function fnprhc

	!function fnprkid(kid0)
	!integer(i4b), intent(in) :: kid0
	!real(dp), dimension(0:maxkid) :: fnprkid
	!integer(i4b) :: j
	!fnprkid=0.0_dp
	!do j=kid0,maxkid
	!	fnprkid(j)=exp(  pkid * (j-kid0) )
	!	if ( abs(j-kid0) > 1 ) then 
	!		fnprkid(j)=0.0_dp	!can only move one step up or down
	!	end if 
	!end do 						
	!fnprkid(0:maxkid)=fnprkid(0:maxkid)/sum(fnprkid(0:maxkid))
	!if (skriv) then 
	!	if ( abs(sum(fnprkid(0:maxkid))-1.0_dp)>eps ) then ; print*, "error in fnprkid: prkid does not add up " , kid0 , sum(fnprkid(0:maxkid)) ; stop ; end if 
	!end if 
	!end function fnprkid

	function fnmove(empo,kid,trueindex) 
	integer(i4b), intent(in) :: empo,kid,trueindex
	real(dp) :: fnmove
    integer(i4b) :: c,t,h
    call index2cotyphome(trueindex,c,t,h)			
	fnmove = cst(t)  + ecst * one(empo<=np) + kcst * one(empo==np1) !+ kcst * one(kid>1) !kid 1 is no kid, kid 2 is yes kid
	!fnmove = fnmove / div
	end function fnmove

	subroutine q2wloc(dq,dw,dl)
	! extract indeces w,l from q 
	integer(i4b), intent(in) :: dq		
	integer(i4b), intent(out) :: dw,dl
	integer(i4b), dimension(2) :: indeces	
		indeces=lin2ndim( (/ np2 , nl /) , dq )
		dw=indeces(1)
		dl=indeces(2)
		if (skriv) then  
			if ( dq > nqs ) then ; print*, "q2wl: q > nqs", dq, nqs,indeces ; stop ; end if  
			if ( dw > np2 ) then ; print*, "q2wl: w > np2" ; stop ; end if  
			if ( dl > nl  ) then ; print*, "q2wl: l > nl" ; stop ; end if  
		end if 
	end subroutine
	subroutine wloc2q(dq,dw,dl)
	! construct combined q from w,l
	integer(i4b), intent(out) :: dq		
	integer(i4b), intent(in) :: dw,dl		
    	dq = ndim2lin( (/ np2 , nl /),(/ dw,dl /) )
		if (skriv) then 		
			if ( dq > nqs ) then ; print*, "wl2q: q > nqs" ; stop ; end if  
			if ( dw > np2 ) then ; print*, "wl2q: w > np2" ; stop ; end if  
			if ( dl > nl  ) then ; print*, "wl2q: l > nl" ; stop ; end if  
		end if 
	end subroutine

	subroutine x2edexpkid(dx,de,dr, dkid)
	! extract indeces educ,experience from x
	integer(i4b), intent(in) :: dx		
	integer(i4b), intent(out) :: de,dr,dkid
	integer(i4b), dimension(3) :: indeces	
		indeces=lin2ndim( (/ neduc, nexp, nkid /) , dx )
		de=indeces(1)
		dr=indeces(2)
        dkid=indeces(3)
	end subroutine
	subroutine edexpkid2x(dx,de,dr,dkid)
	!construct combined x from educ,experience
	integer(i4b), intent(out) :: dx		
	integer(i4b), intent(in) :: de,dr,dkid
		dx=ndim2lin( (/ neduc, nexp, nkid /),(/ de,dr,dkid /) )
	end subroutine

	subroutine index2cotyphome(index,co,typ,home)
	! extract indeces cohort,type,educ,homeloc from combined index
	integer(i4b), intent(in) :: index		
	integer(i4b), intent(out) :: co,typ,home	
	integer(i4b), dimension(3) :: indeces	
	!if (groups) then 
		!indeces=lin2ndim((/nco,ntyp,nl/),index)
        !print*, 'this should not be called if groups!'
        !stop
		!co=myco !indeces(1)
		!typ=mytyp !indeces(2)
		!home=myhome !indeces(3)
	!else 
		indeces=lin2ndim((/ncop,ntypp,nhomep/),index)
		co=indeces(1)
		typ=indeces(2)
		home=indeces(3)
	!end if 
	end subroutine index2cotyphome
	subroutine cotyphome2index(index,co,typ,home)
	!construct combined index from co,typ,home
	integer(i4b), intent(out) :: index		! combined index
	integer(i4b), intent(in) :: co,typ,home 
	!if (groups) then 
	!	index=1 !ndim2lin((/nco,ntyp,nl/),(/co,typ,home/))
	!else 
		index=ndim2lin((/ncop,ntypp,nhomep/),(/co,typ,home/))
	!end if 
	end subroutine cotyphome2index

SUBROUTINE cholesky_m (a,n,p)
IMPLICIT NONE
      integer,intent(in)::n
      real(8),dimension(n,n),intent(in)::a
      real(8),dimension(n,n),intent(out)::p
      real(8),dimension(n,n)::aa
	real(8) sum
      integer i,j,k
	sum = 0.0d-0
      aa(1:n,1:n)=a(1:n,1:n)
      do 13 i = 1,n
         do 12 j = i,n
         sum=aa(i,j)
	   do 11 k = i-1,1,-1
	      sum = sum - aa(i,k)*aa(j,k)
11	   continue 
         if (i.eq.j) then
           if (sum.le.0.0d-0) then 
            print*, 'choldc failed'
            stop
           end if
           p(i,i) = dsqrt(sum)
           else
             aa(j,i) = sum/p(i,i)
	       p(j,i) = aa(j,i)
         end if
12       continue
13    continue
      return
END SUBROUTINE cholesky_m


end module share

module myaz 
	! placer=0 if being called before getdec_s for sep
	! placer=1 if being called from checknb for within marriage decisions
	! placer=2 if being called from checknb for whether to get married when meet
	! placer=3 if being called before getdec_s for sin
	use params
	use share

	implicit none 

contains										
	subroutine yaz_decs(dd,vcho) !qstar,v0,v_cond_u,vbar,val)
	integer(i4b), intent(in) :: dd(:)  !,qstar
	real(dp), intent(in) :: vcho(ncs)   ! v0,v_cond_u,vbar,val(:,:)
	integer(i4b) :: ia,trueindex,q,x,z,q0,g,j,iepsmove
	ia=dd(1) 
	trueindex=dd(2) 
	q=dd(3) 
	x=dd(4) 
	z=dd(5) 
	q0=dd(6)		
	g=dd(7) 
	j=dd(8) 
    iepsmove=dd(11)
	!kid=x2kid(x)
	!altq=dd(9)
	write(100,'(" ************************************************************************************************************************** ")' ) 	
	if (iter==1)  	write(100,'("in solve/getdec_s iteration 1")' ) 
	if (iter==2)  	write(100,'("in solve/getdec_s iteration 2")' ) 
	if (g==1)  	write(100,'("male: age: ",i4)' ) 	ia
	if (g==2)  	write(100,'("female: age: ",i4)' ) ia
    write(100,*)
	write(100,'(" ************************************************************************************************************************** ")' ) 	
	write(100,'(tr1,"alphakid nokid",tr2,"alphakid kid", tr2,"alphaed noed",tr4,"alphaed ed",tr9,"uhome",tr5,"move cost")')
	write(100,'(6f14.2)') alphakid(g,1),alphakid(g,2),alphaed(g,1),alphaed(g,2),uhome(g),movecost(q0,x,trueindex)
	write(100,'(9(tr10,"uloc"))')
	write(100,'(9f14.2)') uloc(:)
	write(100,'(1x,"moveshock(ieps)")')
	if (g==1)  	write(100,'(1x,f14.2)') moveshock_m(iepsmove)
	if (g==2)  	write(100,'(1x,f14.2)') moveshock_f(iepsmove)
    write(100,*)
    write(100,'(" ************************************************************************************************************************** ")' ) 	
	write(100,*)
    write(100,'(14x,tr2,"qs",tr2,tr2,"ws",tr2,"ls")') 
	write(100,'(6x,"current ",i6,2i4)') q0,q2w(q0),q2l(q0)
	write(100,'(6x,"draw    ",i6,2i4)') q,q2w(q),q2l(q)
	!write(100,'(6x,"optimal ",i6,2i4)') qstar,q2w(qstar),q2l(qstar)
    write(100,*)    
	!write(100,'(tr12,"v0",tr6,"v_cond_u",tr10,"vbar",6(tr4,"v(:,ofloc)") ) ')  
	!write(100,'(3f14.2,6f14.2)') v0,v_cond_u,vbar,val( 1:np1, q2l(q) )
	write(100,*)
    !write(100,'(tr12,"v0",tr6,"v_cond_u",tr10,"vbar",9(tr6,"v(np1,:)") ) ')  
	!write(100,'(12f14.2)') v0,v_cond_u,vbar,val( np1, 1:nl )
	write(100,'(tr12,"vcho")')  
	write(100,'(11f10.2)') vcho(:)
    write(100,'(" ************************************************************************************************************************** ",3/)' ) 	
	end subroutine yaz_decs


	subroutine yaz_checknb(dd,vec,transfers,def)         !     (dd,vec,transfers,cornersol,vsum,pc,def)
	integer(i4b), intent(in) :: dd(:)
	real(dp), intent(in) :: vec(5),transfers(2)
	logical, intent(in) :: def
    logical :: pc(2),criter(3),pc_alt(2),criter_alt(3),haveenoughtotransfer,haveenoughtotransfer_alt
	real(dp) :: dumv(np2,nl),utility(4),wage(4),vdif(2),asum,surplus
	integer(i4b) :: ia,index,trueindex,q,x,z,q0,g,j,i
	integer(i4b) :: a,b,c,qbar(2),iepsmove,fnum
	ia=dd(1) 
	trueindex=dd(2) 
	q=dd(3) 
	x=dd(4) 
	z=dd(5) 
	q0=dd(6)
	g=dd(7) 
	j=dd(8) ! alternative that is being evaluated in this call to checknb
	i=dd(9) ! altq i.e. the q that alternative j corresponds to. if being called by mar market, then this is just q as there is no choice to be made. 
	iepsmove=dd(11)
    if (groups) then 
        index=1
    else 
        index=trueindex
    end if
    !kid=maxval(xx2kid(:,x))
	if (whereami==1) write(200,'(" in solve/getdec_c/checknb ........ j  ")' ) 	
	if (whereami==5) write(200,'(" in solve/marriage market ")' ) 	
    if (whereami==4) write(400,'(" in simulation/getdec_c/checknb ........ j  ")' ) 	
    !if (j==1.or.whereamI==1.or.whereami==2) then 			
	!	write(200,'(" ************************************************************************************************************************** ")' ) 	
	!	write(200,'(tr3,"alpha nokid",tr5,"alpha kid",tr9,"uhome",tr10,"umar",tr5,"move cost",9(tr5,"uloc noed"))')
	!	write(200,'(14f14.2)') alpha(1,1),alpha(1,2),uhome(1),mg(z),movecost(xx2x(1,x),trueindex),uloc(:,1)
	!	write(200,'(14f14.2)') alpha(2,1),alpha(2,2),uhome(2),mg(z),movecost(xx2x(2,x),trueindex),uloc(:,1)
	!	write(200,'(" ************************************************************************************************************************** ")' ) 	
	!end if     
    if (whereamI==1) then 
        fnum=200
    else if (whereamI==5) then 
        fnum=200
    else if (whereamI==4) then 
        fnum=400
    else 
        print*, 'no whereamI so fnum not assigned. being called by somewhere not meant to be!'
        stop
    end if 
    write(fnum,*)
	write(fnum,'(6x,tr5,"age",tr6,"q0",tr7,"q",tr7,"z",tr7,"j",tr4,"altq",tr1,"iepsmve",tr1,"trueind",tr1,"sex",TR3,"X",tr3,"def")' )
	write(fnum,'(6x,8i8,i4,I4,L6)')	ia,q0,q,z,j,i,iepsmove,trueindex,g,X,def    ! altq is just the q that altrnative j corresponds to
	write(fnum,*)
    write(fnum,'(14x         ,tr7,"q",2(tr6,"qs",tr6,"ws",tr6,"ls")     )') 
	if (WhereamI==1) then
		write(fnum,'(6x,"current ",7i8)') q0,qq2q(1,q0),qq2w(1,q0),qq2l(1,q0),qq2q(2,q0),qq2w(2,q0),qq2l(2,q0)
	end if 
	write(fnum,'(6x,"draw    ",7i8)') q,qq2q(1,q),qq2w(1,q),qq2l(1,q),qq2q(2,q),qq2w(2,q),qq2l(2,q)
	if (whereamI==1.or.whereamI==4) then 
        write(fnum,'(6x,"alt     ",7i8)') i,qq2q(1,i),qq2w(1,i),qq2l(1,i),qq2q(2,i),qq2w(2,i),qq2l(2,i)
        ! males and females: outside options
		a=qq2q(1,q) 
		b=xx2x(1,x) 
		c=qq2q(1,q0)
		qbar(1) = decm0_s(iepsmove,a,b,c,ia,index)
		a=qq2q(2,q) 
		b=xx2x(2,x) 
		c=qq2q(2,q0)		
		qbar(2) = decf0_s(iepsmove,a,b,c,ia,index)
		write(fnum,'(3x,"qbar",2i8)') qbar(1),qbar(2)
        write(fnum,'(3x,"outside opt",7i8)') q2qq(qbar(1),qbar(2)),qbar(1),q2w(qbar(1)),q2l(qbar(1)),qbar(2),q2w(qbar(2)),q2l(qbar(2))
        !if (def) tmp(1) = (  ( vsum(1) - vec(1) )**0.5_dp ) * (  ( vsum(2) - vec(2) )**0.5_dp ) 
		!if (def) tmp(2) = vsum(1) - vec(1) + vsum(2)- vec(2) 
		! males: utility,wage,value func
		a=qq2q(1,i) 
		b=xx2x(1,x) 
		utility(1) = utils(1,a,b,trueindex) !utilm_s()
		utility(3) = utilc(1,i,x,trueindex) !utilm_c(i,x)
		wage(1)=ws(1,a,b,trueindex)    !wm_s(a,b)
        wage(3)=wc(1,i,x,trueindex)
		! females: utility,wage,value func
		a=qq2q(2,i) 
		b=xx2x(2,x) 
		utility(2) = utils(2,a,b,trueindex)
		utility(4) = utilc(2,i,x,trueindex)
		wage(2)=ws(2,a,b,trueindex)    !wf_s(a,b)
        wage(4)=wc(2,i,x,trueindex)
        if (wage(3)+wage(4) - vec(5) > 0.0_dp ) then
            print*, 'sum of wage3 and wage4 not equal to vec5!'
            stop
        end if
        !vdif = vec(3:4) + mg( dd(5) ) - vec(1:2) 	! dd(5) is z
		vdif = vec(3:4) - vec(1:2) 	
	    surplus=vec(3)-vec(1)+vec(4)-vec(2)+vec(5)
        pc(1:2)	= ( vdif + eps >= 0.0_dp )	!pc(1:2)    = ( vec(3:4) - vec(1:2) >= 0.0_dp )						        
        pc_alt(1:2)=( vdif >= 0.0_dp )	
        asum = sum(  one(.not. pc)  *   abs( vdif )   )
		criter(1) = ( vec(5) + eps >= vec(1) - vec(3) ) 
		criter(2) = ( vec(5) + eps >= vec(2) - vec(4) ) 
		criter(3) = ( vec(5) + eps >= vec(1) - vec(3) + vec(2) - vec(4) )     		
		criter_alt(1) = ( vec(5) >= vec(1) - vec(3) ) 
		criter_alt(2) = ( vec(5) >= vec(2) - vec(4) ) 
		criter_alt(3) = ( vec(5) >= vec(1) - vec(3) + vec(2) - vec(4) )
        haveenoughtotransfer=(  vec(5) + eps - asum  >= 0.0_dp  )
        haveenoughtotransfer_alt=(  vec(5) - asum  >= 0.0_dp  )
        if (nonneg) then 
            if ( maxval(one(pc)-one(pc_alt)) >0) then 
                write(fnum,'("pc with eps no match to pc without eps")')
                write(*,'("pc with eps no match to pc without eps")')
                stop 
            end if
            if ( maxval(one(criter)-one(criter_alt)) >0) then 
                write(fnum,'("criter with eps no match to criter without eps")')
                write(*,'("criter with eps no match to criter without eps")')
                stop 
            end if
            if ( one(haveenoughtotransfer).ne.one(haveenoughtotransfer_alt) ) then 
                write(fnum,'("vec(5)-asum with eps is no match to without eps ")')
                write(*,'("vec(5)-asum with eps is no match to without eps ")')
                stop         
            end if 
        
            !write(fnum,'("these utilities are not indexed now so be careful")')
		    !write(fnum,'(6x,"alt spec values:") ') 
            write(fnum,'("PC before any transfers (pc):",2L6)') pc
            write(fnum,'("Abs Val of Total Transfers Needed (asum):",F10.2)') asum
            write(fnum,'("Total Wages (wc):",2L6)') vec(5)
            if ( (.not.pc(1)).or.(.not.pc(2)) ) then 
                write(fnum,'("One or both PC do not hold")')
                if ( haveenoughtotransfer  ) then !haveenoughtotransfer=(  vec(5) + eps - asum  >= 0.0_dp  )
                    write(fnum,'("BUT they HAVE enough wages to make transfers!")')
                else 
                    write(fnum,'("AND they DO NOT HAVE enough wages to make transfers!")')
                end if 
            else
                write(fnum,'("Both PCs hold")')
            end if 
            if (surplus+eps>=0.0_dp.and. (.not.haveenoughtotransfer) ) then 
                write(fnum,'("Positive surplus but they are not able to make transfers!")' )
            end if 
            write(fnum,*)
            !write(fnum,'(6x,tr10,"asum",tr4,"w+eps-asum>=0.0dp",3(tr2,"crit")  )' ) 
		    !write(fnum,'(6x,f14.2,11x,L6,3L6)') asum,haveenoughtotransfer,criter(1:3)     !def  = ( vec(5) + eps - asum  >= 0.0_dp )
            write(fnum,'(6x,2(tr9,"trans"),tr3,"def" )')         
            write(fnum,'(2F14.2,L6)') transfers,def                 
            if (     ( minval(transfers) + eps2) >= 0.0_dp  .and. ( minval(transfers) + epstest ) >= 0.0_dp  ) then 
                write(fnum,*) "ohere minval"
            end if 
            if (      maxval(transfers) <=  ( vec(5)+eps2 ) .and.  maxval(transfers) <= ( vec(5)+epstest ) ) then 
                write(fnum,*) "ohere maxval"
            end if 
        end if !NONNEG
        write(fnum,'(6x,2(tr10,"vbar"),2(tr12,"vc"),tr5,"wcsum",2(tr4,"pc"),2(tr8,"us"),2(tr8,"uc"),2(tr8,"ws"),2(tr8,"wc"))' )    
		write(fnum,'(6x,4f14.2,F10.2,2L6,8F10.2)') vec,pc,utility(1:4),wage(1:4)
        write(fnum,*)
        write(fnum,'(6x,tr7,"surplus",tr2,"sur+eps>=0.0dp",tr2,"sur>=0.0dp",tr3,"def")') 
		write(fnum,'(6x,f14.2,10x,L6,6x,2L6)') surplus,(surplus+eps>=0.0_dp),(surplus>=0.0_dp),def
        if (def) then 
            write(fnum,'(6x,tr10,"vec1",tr1,"vec1+0.5*surpls",tr10,"vec2",tr1,"vec2+0.5*surpls")')
		    write(fnum,'(6x,f14.2,2x,f14.2,f14.2,2x,f14.2)') vec(1),vec(1)+0.5_dp*surplus,vec(2),vec(2)+0.5_dp*surplus
        end if 
    end if !whereamI=1 or 4
    
    if (whereamI==5) then 
        !NOTE that when this is being called from the marriage market, the index that corresponds to altq (i.e. i) is just set to q since there is no altq in marriage market
		! males: utility,wage,value func
		a=qq2q(1,i) 
		b=xx2x(1,x) 
		utility(1) = utils(1,a,b,trueindex) !utilm_s()
		utility(3) = utilc(1,i,x,trueindex) !utilm_c(i,x)
		wage(1)=ws(1,a,b,trueindex)    !wm_s(a,b)
        wage(3)=wc(1,i,x,trueindex)
        ! females: utility,wage,value func
		a=qq2q(2,i) 
		b=xx2x(2,x) 
		utility(2) = utils(2,a,b,trueindex)
		utility(4) = utilc(2,i,x,trueindex)
		wage(2)=ws(2,a,b,trueindex)    !wf_s(a,b)
        wage(4)=wc(2,i,x,trueindex)        
        !vdif = vec(3:4) + mg( dd(5) ) - vec(1:2) 	! dd(5) is z
		vdif = vec(3:4) - vec(1:2) 	
	    surplus=vec(3)-vec(1)+vec(4)-vec(2)+vec(5)
        pc(1:2)	= ( vdif + eps >= 0.0_dp )	!pc(1:2)    = ( vec(3:4) - vec(1:2) >= 0.0_dp )		
        write(fnum,'("Here is q,x",2I4)') q,x
        write(fnum,'(6x,2(tr10,"vbar"),2(tr12,"vc"),tr5,"wcsum",2(tr4,"pc"),2(tr8,"us"),2(tr8,"uc"),2(tr8,"ws"),2(tr8,"wc") )' )    
		write(fnum,'(6x,4f14.2,F10.2,2L6,8F10.2)') vec,pc,utility(1:4),wage(1:4)        
        write(fnum,*)
		write(fnum,'(6x,tr7,"surplus",tr2,"sur+eps>=0.0dp",tr2,"sur>=0.0dp",tr7,"surplus")') 
		write(fnum,'(6x,f14.2,10x,L6,6x,L6,F14.2)') surplus,(surplus+eps>=0.0_dp),(surplus>=0.0_dp),surplus
        write(fnum,'(6x,2(tr9,"trans"),tr3,"def" )')         
        write(fnum,'(6x,2F14.2,L6)') transfers,def
        if (     ( minval(transfers) + eps2) >= 0.0_dp  .and. ( minval(transfers) + epstest ) >= 0.0_dp  ) then 
            write(fnum,*) "ohere minval"
        end if 
        if (      maxval(transfers) <=  ( vec(5)+eps2 ) .and.  maxval(transfers) <= ( vec(5)+epstest ) ) then 
            write(fnum,*) "ohere maxval"
        end if 
        !ahu 041118: the below stuff was trying to figure out the eps2 problem. see notes for feb, march and april 2018 more details. 
                        !if (  minval(transfers) + epstest4 >= 0.0_dp .and. maxval(transfers) <= vec(5)+epstest4 ) then
                            !if (  minval(transfers) + epstest5 < 0.0_dp .or. maxval(transfers) > vec(5)+epstest5 ) then
                                    !write(fnum,*) "ohere45"                    
                            !end if 
                        !end if 
    end if !whereamI=5
	!move(:) = fnmove(kid) 
	!move( qq2l(1,q0) )= 0.0_dp
	!if (groups) then 
	!	a=myco
	!	b=mytyp
	!	c=myhome		
	!else 
	!	call index2cotyphome(k,a,b,c)	! don't need this if groups, since myco,mytyp,myhome gives co,typ,home already			
	!end if 
	!write(200,'(6x,"outside options:") ') 
	!ya=xx2x(1,x)
	!dumv(:,:) = reshape( vm0_s(:,ya) , (/ np2, nl /) )				! turn q index into its components (w,l)
	!ya = qq2w(1,q0) ; yb=qq2l(1,q0) ; yc=qq2l(1,q)				! w0,l0,l
	!write(200,'(6x,"best q,w,l    ",6i8)') qbar(1),q2w(qbar(1)),q2l(qbar(1))
	!write(200,'(6x,tr10,"vs0",tr10,"vsu",6(tr6,"vs(:,l)") )' )
	!write(200,'(8f14.2)') dumv(ya,yb),maxval(dumv(np1,1:nl) + move ),dumv(1:np1,yc) + move(yc)
	!write(200,*)
	!ya=xx2x(2,x)
	!dumv(:,:) = reshape( vf0_s(:,ya) , (/ np2, nl /) )				! turn q index into its components (w,l)
	!ya = qq2w(2,q0) ; yb=qq2l(2,q0) ; yc=qq2l(2,q)				! w0,l0,l
	!write(200,'(tr10,"vfs0",tr10,"vfsu",6(tr6,"vfs(:,l)") )' )
	!write(200,'(8f14.2)') dumv(ya,yb),maxval(dumv(np1,1:nl) + move ),dumv(1:np1,yc) + move(yc)
	!do ya=1,2	! gender
	!	yb=qq2q(ya,altq) 
	!	if (qq2w(ya,altq) /= q2w(yb)  )			ier(2) = 1 ! qq and q are not equal in terms of their w 
	!	if (qq2l(ya,altq) /= q2l(yb)  )			ier(3) = 1 ! qq and q are not equal in terms of their l 
	!end do 	
	!if ( decsingle(1)<0 .or. decsingle(4)<0 )		ier(8) = 1				! single dec rule qsbest is < 0 
	!if ( abs( w_c(altq,x) - vec(5) ) > 0.0_dp )		ier(9) = 1				! in write_checknb: wc is not equal to vec5 ",ii 
	!if ( def == -2)					ier(10) = 1
	!if ( def .and. ia==mxa .and. abs(tmp(2)) > 2.0_dp*eps .and. abs(mg(z)) < eps ) 
	!	write(*,*) tmp(2),mg(z)
	!	write(*,'(2l6)') ( abs(tmp(2)) > eps ), ( abs(mg(z)) < eps  ) 
	!end if 
	end subroutine yaz_checknb

	subroutine yaz_decision(dd,vmax)
	integer(i4b), intent(in) :: dd(:)
    real(8), intent(in) :: vmax(2)
	integer(i4b) :: q0,jmax,qmax,relmax,fnum
    if (whereamI==1) then           !in solve/getdec_c/checknb
        fnum=200
    else if (whereamI==5) then      !in solve/marriage market
        fnum=200
    else if (whereamI==4) then      !in simulation/getdec_c/checknb 
        fnum=400
    else 
        print*, 'no whereamI so fnum not assigned. being called by somewhere not meant to be!'
        stop
    end if
    write(fnum,*)
    write(fnum,'(1x,"****************************************************************************************************************** ")' ) 	
	if (whereami==1.or.whereami==4) then
		q0=dd(6)
		jmax=dd(8)
		qmax=dd(9)	
		relmax=dd(10)
		if (relmax>0) then 
			if ( qq2l(1,qmax) == qq2l(1,q0) ) then 
				write(fnum,'(1x,"decision: stay married and stay put. best j,q is: ",2i8,2F14.2,4i4 )') jmax,qmax !,vmax(1:2),q0,dd(3:5)
			else 
				write(fnum,'(1x,"decision: stay married and move. best j,q is: ",2i8,2F14.2,4i4 )') jmax,qmax !,vmax(1:2),q0,dd(3:5)
			end if 
		else if (relmax==0) then 
			write(fnum,'(1x,"decision: get divorced",4i4)') !q0,dd(3:5)
		end if 
	else if (whereami==5) then
		relmax=dd(10)
		if (relmax==1) then 
			write(fnum,'(1x,"decision: get married")') 
		else 
			write(fnum,'(1x,"decision: stay single and continue searching")') 
		end if 
	end if 
	write(fnum,'(1x,"****************************************************************************************************************** ",3/)' ) 	
	write(fnum,*)
    end subroutine yaz_decision

	subroutine yaz_getmom(dat,ndat)
	integer(i4b), intent(in) :: ndat						! number of observations in dat array    
	type(statevar), dimension(mnad:mxa,ndat), intent(in) :: dat ! data set. first entry is ia index, second observation number
	integer :: ia,j
	write(12,*)
	if (ndat==ndata) then
		write(12,'("actual data")')			
	else if (ndat==nsim) then 		
		write(12,'("simulated data")')	
	end if 
		write(12,*)
		do j=1,100
			write(12,'(tr6,"id",tr1,"age",tr2,"co",tr1,"sexr",&
			& tr1,"rel",tr1,"kid",tr1,"edr",&
			& tr1,"loc",tr1,"mxa",tr1,"mis",tr1,"hme",2(tr1,"emp"),2(tr5,"logw"),tr1,"lsp" )')	
			write(12,*)
			do ia=mna,mxa
				write(12,'(i8,12i4,2f9.2,i4)') j,&
				& ia,dat(ia,j)%co,dat(ia,j)%sexr,dat(ia,j)%rel,dat(ia,j)%kidr,dat(ia,j)%edr,&
				& dat(ia,j)%l,dat(ia,j)%endage,dat(ia,j)%nomiss,dat(ia,j)%hme,&
				& dat(ia,j)%hhr,dat(ia,j)%hhsp,dat(ia,j)%logwr,dat(ia,j)%logwsp,dat(ia,j)%lsp
			write(12,*)
			write(12,*)
			end do
		end do
	end subroutine yaz_getmom

	subroutine yaz_sim(gender,rel,q,x)
	integer(i4b), intent(in) :: gender,rel,q,x
		if (rel==0) then
			write(400,'(2x,tr3,"g",tr2,"qs",tr2,"ws",tr2,"ls",tr4,"xs",tr3,"eds",tr2,"exps",tr2,"kids")' ) 
			write(400,'(2x,4I4,4I6  )') gender,q,q2w(q),q2l(q),x,x2e(x),x2r(x),x2kid(x)      
		else if (rel==1) then 
			write(400,'(2x,tr6,"qc",tr2,"qm",tr2,"wm",tr2,"lm", tr6,"xc",tr4,"xm",tr3,"edm",tr2,"expm",tr2,"kidm"    )') 
			write(400,'(2x,I8,3I4,I8,4I6)') q,qq2q(1,q),qq2w(1,q),qq2l(1,q),x,xx2x(1,x),xx2e(1,x),xx2r(1,x),xx2kid(1,x)
			write(400,'(2x,tr6,"qc",tr2,"qf",tr2,"wf",tr2,"lf", tr6,"xc",tr4,"xf",tr3,"edf",tr2,"expf",tr2,"kidf"    )') 
			write(400,'(2x,I8,3I4,I8,4I6)') q,qq2q(2,q),qq2w(2,q),qq2l(2,q),x,xx2x(2,x),xx2e(2,x),xx2r(2,x),xx2kid(2,x)
        end if 
	end subroutine yaz_sim
	subroutine yaz_simmatch(meet,qmatch,xmatch,z)
	logical, intent(in) :: meet
	integer(i4b), intent(in) :: qmatch,xmatch,z
		if (meet) then
			write(400,'(2x,tr7,"z",tr2,"qs",tr2,"ws",tr2,"ls",tr2,"xs",tr3,"eds",tr2,"exps",tr2,"kids")' )
			write(400,'(2x,I8,3I4,I4,3I6)') z,qmatch,q2w(qmatch),q2l(qmatch),xmatch,x2e(xmatch),x2r(xmatch),x2kid(xmatch)  
		else 
			write(400,'("Did Not Meet Anyone")')            
		end if 
	end subroutine yaz_simmatch

    subroutine yaz_simdecmar(rel)
    integer(i4b), intent(in) :: rel
        if (rel==0) then 
            write(400,'("Relnext: Single")') 
        else if (rel==1) then 
            write(400,'("Relnext: Married")')
        else 
            write(400,'("Relnext: NOTHING! SOMETHING WRONG!")')
            print*, 'Rel is not 0 nor 1, something wrong!'
            stop
        end if 
    end subroutine yaz_simdecmar
    
	subroutine yaz_simpath(ia,nn,mm,r,dat)
	integer(i4b), intent(in) :: ia,nn,mm,r
	type(statevar) :: dat
	write(500,'(tr6,"nn",tr2,"mm",tr7,"r",tr2,"ia",tr2,"co",tr2,"sx",tr2,"hm",tr2,"ed",tr2,"ea",tr2,"rl",tr2,"kd",tr3,"l",tr2,"hr",tr2,"hp",tr1,"len",tr2,"ms",tr12,"wr",tr11,"wsp",tr1,"exp",tr2,"wr",tr1,"wsp")') 
	write(500,'(I8,I4,I8,13I4,2F14.2,I4,2F14.2)') nn,mm,r,ia,dat%co,dat%sexr,dat%hme,dat%edr,dat%endage,dat%rel,dat%kidr,dat%l,dat%hhr,dat%hhsp,dat%rellen,& 
    & dat%nomiss,dat%logwr,dat%logwsp,dat%expr,dat%wr,dat%wsp    !,dat%nn,dat%mm,dat%r
	end subroutine 
					
	
	subroutine yaz0
	integer(i4b) :: n,i,j,g,q0,x0,q,x
	real(dp) :: lb,ub,cdf(2),expv,ppcqx_sum_overqx
	if (skriv) then 
		print*, "here i am in skriv!" 
		write(50,*) 
		write(50,*) 
		do g=1,2
			if (g==1) then 
				write(50,'(" ---------------- male   wage grid ---------------- ")') 
			else 
				write(50,'(" ---------------- female wage grid ---------------- ")') 
			end if 
			write(50,'(tr3,"num",tr10,"wage",tr8,"weight",tr4,"sum=1?")')
			write(50,*)
			do i=1,np
				write(50,'(i6,2f14.3,f10.2)') i,wg(i,g),wgt(i),sum(wgt)
				write(50,*)
			end do
		end do 
		if (abs( sum(wgt) - 1.0_dp ) > 1.0d-6  ) then 
			print*, "sum of weight is not 1! " 
			stop 
		end if 
		write(50,'(2/," ---------------- mar grid ---------------- ")') 
		if (skriv) print*, "mar grid mg(:,1) ", mg(:,1)
		if (skriv) print*, "mar grid mg(:,2) ", mg(:,2)
		if (skriv) print*, "mar grid mg(:,3) ", mg(:,3)
		if (skriv) print*, "mar grid mg(:,4) ", mg(:,4)
		do i=1,nz
			write(50,'(1x,tr6,"z",tr9,"mg(z,.)",tr8,"mgt(z)",tr6,"sum=1.0?")')
			write(50,'(i8,3f14.3)') i,mg(i,1),mgt(i),sum(mgt)
			write(50,'(i8,3f14.3)') i,mg(i,2),mgt(i),sum(mgt)
			write(50,'(i8,3f14.3)') i,mg(i,3),mgt(i),sum(mgt)
			write(50,'(i8,3f14.3)') i,mg(i,4),mgt(i),sum(mgt)
        end do
		write(50,'(3/," ---------------- moveshock grid ---------------- ")') 
		!if (skriv) print*, "moveshock grid ", moveshock_m(:)
        !if (skriv) print*, "moveshock grid ", moveshock_f(:)
        do i=1,nepsmove
			write(50,'(1x,tr6,"i",tr5,"moveshock(i)",tr7,"ppso(i)",tr6,"sum=1.0?")')
			write(50,'(i8,3f14.3)') i,moveshock_m(i),ppso(i),sum(ppso)
            write(50,'(i8,3f14.3)') i,moveshock_f(i),ppso(i),sum(ppso)
        end do
		write(50,'(4/," ----------------  kidshock grid ---------------- ")') 
		if (skriv) print*, " kidshock grid ", kidshock(:)
		do i=1,nepskid
			write(50,'(1x,tr6,"i",tr5," kidshock(i)",tr7,"ppsk(i)",tr6,"sum=1.0?")')
			write(50,'(i8,f14.3)') i,kidshock(i)
		end do
        write(50,*) 
		write(50,*) "sum(wgt) - free" 
		write(50,*)  sum(wgt)
		write(50,*) 
		write(50,*) "1.0,1.0_sp,1.0_dp - free "
		write(50,*) 1.0,1.0_sp,1.0_dp
		lb=-3.0_dp ; ub=3.0_dp
		call checkgauss(np,lb,ub,cdf,expv)
		write(50,'(2/," ---------------- checkgauss(np,lb,ub,cdf,expv) ---------------- ")') 
		write(50,*) 
		write(50, '(1x,tr11,"lb",tr12,"ub",tr8,"cdf(1)",tr8,"cdf(2)",tr8,"expval" )' ) 
		write(50,'(5f14.3)') lb,ub,expv,cdf(1),cdf(2)
		write(50,'(3/," ---------------- fnprof(w,ed,g) ---------------- ")') 
		write(50,'(" raw parameters: ")') 
		write(50, '(1x,"wrking (w<=np)",5x,2(tr10,"m/hs"),2(tr9,"m/col"),2(tr10,"f/hs"),2(tr9,"f/col") )') 
		write(50,'(19x,8f14.3 )') psio(1:8)	
		write(50, '(1x,"not wrking (w=np1)",tr10,"m/hs",14x,tr9,"m/col",14x,tr10,"f/hs",14x,tr9,"f/col",14x )') 
		write(50,'(19x,f14.3,14x,f14.3,14x,f14.3,14x,f14.3,14x )') psio(9:12)	
		write(50,'(/," probabilities: ")') 
		do n=1,neduc		!ed
			do g=1,2	!sex
				write(50, '(1x,tr4,"sex",tr6,"ed",4x,"wrking (w<=np)",4x,tr5,"pr(offer)",tr4,"pr(layoff)",tr3,"pr(nothing)" )' ) 
				write(50,'(2i8,22x,3(f14.3) )') g,n,fnprof(np,n,g)	
				write(50, '(20x,"not wrking (w=np1)",2x,tr5,"pr(offer)",tr4,"pr(layoff)",tr3,"pr(nothing)" )' ) 
				write(50,'(38x,3(f14.3) )') fnprof(np1,n,g)	
				write(50,*) 
			end do 
		end do 
		write(50,'(/," ---------------- fnprloc parameters ---------------- ")') 
		!write(50,'(/,"iter psil(1) psil(2) psil(3) ",i6,f14.3)') iter,psil(:)
		write(50, '(/,6x,tr12,"ne",tr12,"ma",tr11,"enc",tr11,"wnc",tr12,"sa",tr11,"esc",tr11,"wsc",tr9,"mount",tr11,"pac" )' ) 
		write(50,'(6x,9f14.3)') popsize(1:nl)
		write(50,'(2/,4x,"ne",9(f14.3))') fnprloc(1)		
		write(50,'(6x,9(2x,i8,4x))') distance(:,1)
		write(50,'(/,4x,"ma",9(f14.3) )') fnprloc(2)
		write(50,'(6x,9(3x,i8,3x))') distance(:,2)
		write(50,'(3/,3x,"enc",9(f14.3) )') fnprloc(3)
		write(50,'(6x,9(3x,i8,3x))') distance(:,3)
		write(50,'(/,3x,"wnc",9(f14.3) )') fnprloc(4)
		write(50,'(6x,9(3x,i8,3x))') distance(:,4)
		write(50,'(/,4x,"sa",9(f14.3) )') fnprloc(5)
		write(50,'(6x,9(3x,i8,3x))') distance(:,5)
		write(50,'(/,3x,"esc",9(f14.3) )') fnprloc(6)
		write(50,'(6x,9(3x,i8,3x))') distance(:,6)
		write(50,'(/,3x,"wsc",9(f14.3) )') fnprloc(7)
		write(50,'(6x,9(3x,i8,3x))') distance(:,7)
		write(50,'(/,1x,"mount",9(f14.3) )') fnprloc(8)
		write(50,'(6x,9(3x,i8,3x))') distance(:,8)
		write(50,'(/,3x,"pac",9(f14.3) )') fnprloc(9)
		write(50,'(6x,9(3x,i8,3x))') distance(:,9)
		write(50,'(3/," ---------------- fnprhc(exp,w) ---------------- ")') 
		write(50, '(1x,tr7,"w",tr4,"exp",4(tr8,"fnprhc") )' ) 
        do n=1,np1
        do i=1,nexp
				if (n==1.or.n==np1) then
					write(50,'(2i8,4f14.3)') n,i,fnprhc(i,n)
					write(50,*) 
				end if 
			end do 
		end do 
		i=-1 ; n=-1 ; j=-1

		write(50,'(2/," ---------------- wage profiles given typ=1,loc=nloc ---------------- ")') 
		write(50, '(1x,tr3,"ed",tr3,"exp",2(tr11,"eps",tr10,"wage") )')
		do j=1,neduc
			do i=1,nexp
				do n=1,np
					write(50,'(2i6,4f14.3)') j,i,wg(n,1),fnwge(1,1,nl,wg(n,1),j,i),wg(n,2),fnwge(2,1,nl,wg(n,2),j,i)				!fnwge(dg,dtyp,dl,dw,de,dr)						
				end do 
			end do 
		end do 
		!write(50,'(" ---------------- ppsq(q,q0,x0,g) - males and females ---------------- ")') 
		!ppmq_check=0.0_dp
		!ppfq_check=0.0_dp
		!do n=1,nx
		!	do i=1,nq
		!		do j=1,nq				
		!			if ( pc0(i) ) then 	
		!				x0=xx2x(1,n)
		!				q0=qq2q(1,i)
		!				q=qq2q(1,j)
		!				ppmq_check(q,q0,x0) = ppmq_check(q,q0,x0) + wgt( qq2w(2,i) ) * ppcq(j,i,n)
		!				x0=xx2x(2,n)
		!				q0=qq2q(2,i)
		!				q=qq2q(2,j)
		!				ppfq_check(q,q0,x0) = ppfq_check(q,q0,x0) + wgt( qq2w(1,i) ) * ppcq(j,i,n)
		!			end if 
		!		end do 
		!	end do 
		!end do 
		do x0=1,nxs			
			do q0=1,nqs		
				!do q=1,nqs	
				!	write(50, '(1x,tr5,"x0",tr5,"ed0",tr4,"exp0")' ) 
				!	write(50,'(3i8)')	x0,x2e(x0),x2r(x0)	
				!	write(50, '(1x,tr5,"q0",tr6,"w0",tr6,"l0")' )
				!	write(50,'(3i8)')	q0,q2w(q0),q2l(q0)
				!	write(50, '(1x,tr6,"q" ,tr7,"w" ,tr7,"l",2(6x,"ppsq(q,q0,x0,g)"),2(tr6,"sum=1.0?") )') 
				!	write(50,'(3i8,2(7x,f14.3),2f14.3)') q,q2w(q),q2l(q),ppsq(q,q0,x0,1),ppsq(q,q0,x0,2),sum(ppsq(:,q0,x0,1)),sum(ppsq(:,q0,x0,2))
				!	write(50,'(3i8,2(7x,f14.3),2f14.3)') q,q2w(q),q2l(q),ppmq_check(q,q0,x0),ppfq_check(q,q0,x0),sum(ppmq_check(:,q0,x0)),sum(ppfq_check(:,q0,x0))
				!	write(50,*)
				!	write(50,*)
				!end do 
			   ! do g=1,2
				!	if ( q2w(q0)<=np1) then  
				!		if ( abs(  sum(ppsq(:,q0,x0,g)) - 1.0_dp) >  1.0d-6) then  ; 
				!			print*, "error in check: ppsq for w=1:np1 does not add up to 1 " , q0,x0,g,sum(ppsq(:,q0,x0,g)) 
				!			stop 
				!		end if 
				!	else if ( q2w(q0)>np1) then					
				!		if ( sum(ppsq(:,q0,x0,g)) > 1.0d-6 ) then	! q2w(q0)=np2 is not a state variable that we take in to account, so there's no proability attached to it 
				!			print*, "error in check: ppsq for w=np2 does not add up to 0 " , q0,x0,g,sum(ppsq(:,q0,x0,g)) 
				!			stop 
				!		end if 
				!	end if 
				!end do 
			end do 
		end do 
		write(50,'(2/," ---------------- ppcq(q,q0,x0) ---------------- ")') 
		do x0=1,nx		
			do q0=1,nq		
				!do q=1,nx	
				!	write(50,'(1x,tr5,"x0",2(tr5,"xs0",tr4,"eds0",tr3,"exps0")     )') 
				!	write(50,'(7i8)') x0,xx2x(1,x0),xx2e(1,x0),xx2r(1,x0),xx2x(2,x0),xx2e(2,x0),xx2r(2,x0)
				!	write(50,*)
				!	write(50,'(1x,tr5,"q0",2(tr5,"qs0",tr5,"ws0",tr5,"ls0")     )') 
				!	write(50,'(7i8)') q0,qq2q(1,q0),qq2w(1,q0),qq2l(1,q0),qq2q(2,q0),qq2w(2,q0),qq2l(2,q0)
				!	write(50,*)
				!	write(50,'(1x,tr6,"q",2(tr6,"qs",tr6,"ws",tr6,"ls"),6x,"ppcq(q,q0,x0)",tr6,"sum=1.0?" )') 
				!	write(50,'(7i8,5x,2f14.3)') q,qq2q(1,q),qq2w(1,q),qq2l(1,q),qq2q(2,q),qq2w(2,q),qq2l(2,q),ppcq(q,q0,x0),sum(ppcq(:,q0,x0)) 
				!	write(50,*)
				!	write(50,*)
				!end do 
				if ( qq2l(1,q0) /= qq2l(2,q0) ) then 
					print*, "error in check: locs not equal " 
					stop 
				end if 			 
				if (  qq2w(1,q0)<=np1 .and.  qq2w(2,q0)<=np1 ) then 
					if ( abs(  sum(ppcq(:,q0,x0)) - 1.0_dp  ) >  1.0d-6) then  
						print*, "error in check: ppcq for w=1:np1 does not add up to 1 " , q0,x0 , sum(ppcq(:,q0,x0)) 
						stop 
					end if 
				end if 
				if ( qq2w(1,q0)>np1 .or.  qq2w(2,q0)>np1 ) then 
					if ( sum(ppcq(:,q0,x0)) > 1.0d-6 ) then 
						print*, "error in check: ppcq for w=np2 does not add up to 0 " , q0,x0,sum(ppcq(:,q0,x0)) 
						stop 
					end if 
				end if
			end do 
		end do 

		write(50,'(2/," ---------------- ppsx(x,q0,x0) ---------------- ")') 
		do x0=1,nxs				
			do q0=1,nqs		
				!do x=1,nxs	
				!	write(50, '(1x,tr5,"x0",tr5,"ed0",tr4,"exp0")' ) 
				!	write(50,'(3i8)')	x0,x2e(x0),x2r(x0)	
				!	write(50, '(1x,tr5,"q0",tr6,"w0",tr6,"l0")' )
				!	write(50,'(3i8)')	q0,q2w(q0),q2l(q0)
				!	write(50, '(1x,tr6,"x" ,tr6,"ed" ,tr5,"exp" ,6x,tr1,"ppsx(x,q0,x0)",tr6,"sum=1.0?")') 
				!	write(50,'(3i8,6x,2f14.3)') x,x2e(x),x2r(x),ppsx( x, q0, x0 ),sum(ppsx(:,q0,x0)) 
				!	write(50,*)
				!	write(50,*)
				!end do 
				if (  q2w(q0)<=np1 ) then 
					if ( abs(  sum(ppsx(:,q0,x0)) - 1.0_dp  )   >   1.0d-6) then  
						print*, "error check_all: ppsx for w=1:np1 does not add up to 1 ", q0,x0,sum(ppsx(:,q0,x0)) 
						stop 
					end if 
				else if (  q2w(q0)>np1 ) then 
					if ( sum(ppsx(:,q0,x0)) > 1.0d-6 ) then 
						print*, "error in check_all: ppsx for w=np2 does not add up to 0 " , q0,x0,sum(ppsx(:,q0,x0)) 
						stop 
					end if 
				end if 
			end do 
		end do 
		write(50,'(2/," ---------------- ppcx(x,q0,x0) ---------------- ")') 
		do x0=1,nx		
			do q0=1,nq		
				!do x=1,nxs	
				!	write(50,'(1x,tr5,"x0",2(tr5,"xs0",tr4,"eds0",tr3,"exps0")     )') 
				!	write(50,'(7i8)') x0,xx2x(1,x0),xx2e(1,x0),xx2r(1,x0),xx2x(2,x0),xx2e(2,x0),xx2r(2,x0)
				!	write(50,*)
				!	write(50,'(1x,tr5,"q0",2(tr5,"qs0",tr5,"ws0",tr5,"ls0")     )') 
				!	write(50,'(7i8)') q0,qq2q(1,q0),qq2w(1,q0),qq2l(1,q0),qq2q(2,q0),qq2w(2,q0),qq2l(2,q0)
				!	write(50,*)
				!	write(50,'(1x,tr6,"x",2(tr6,"xs",tr5,"eds",tr4,"exps"),5x,tr1,"ppcx(x,q0,x0)",tr6,"sum=1.0?" )') 
				!	write(50,'(7i8,5x,2f14.3)') x,xx2x(1,x),xx2e(1,x),xx2r(1,x),xx2x(2,x),xx2e(2,x),xx2r(2,x),ppcx(x,q0,x0),sum(ppcx(:,q0,x0)) 
				!	write(50,*)
				!	write(50,*)
				!end do 
				if (  qq2w(1,q0)<=np1 .and.  qq2w(2,q0)<=np1 ) then 
					if ( abs( sum(ppcx(:,q0,x0)) - 1.0_dp  ) >  1.0d-6) then  
						print*, "error in getppcx: ppcx for w0=1:np1 does not add up ", q0 , sum(ppcx(:,q0,x0)) 
						stop 
					end if 
				end if 
				if ( qq2w(1,q0)>np1 .or.  qq2w(2,q0)>np1 ) then 
					if ( sum(ppcx(:,q0,x0)) > 1.0d-6 ) then 
						print*, "error in getppx: ppcx for w0=np2 is not 0 " , q0,x0,sum(ppcx(:,q0,x0)) 
						stop 
					end if 
				end if 
			end do 
		end do 
		
		if (icheck_probs) then 
			do x0=1,nx				
				do q0=1,nq			
					if ( maxval(qq2w(:,q0)) <= np1 ) then 
						ppcqx_sum_overqx=0.0_dp
						do x=1,nx
							do q=1,nq
								ppcqx_sum_overqx = ppcqx_sum_overqx + ppcq(q,q0,x0) * ppcx(x,q0,x0)      ! ppcq*ppcx is the joint probability of drawing q,x given q0,x0. ppcq(q,q0,x0) has no x in it because it's independent of x and ppcx doesn't have q in i tbecause is indeoendent of q .
							end do 
						end do 
						if ( abs(ppcqx_sum_overqx-1.0_dp) > eps ) then 
							print*, " pp does not sum to 1 ", ppcqx_sum_overqx
							stop 
						end if 
					end if 
				end do 
			end do 
		end if 
		
	end if 
	end subroutine yaz0

	subroutine  yaz1(index,age)
		integer(i4b), intent(in) :: index,age
		integer(i4b) :: q0,q,x,j,iepsmove
		real(dp) :: emp_m(2),emp_f(2) 
!		do x=1,nx
!			do q=1,nq				
!				if (age<mxa) then ; ageprime=age+1 ; else if (age==mxa) then ; ageprime=age ; end if 
!				write(300,'(tr4,"in",tr3,"age",tr5,"q",tr5,"x",tr7,"utilm_c",tr1,"emaxm_c(ia+1)",tr9,"vm0_c",tr3,"emaxm_c(ia)")')
!				write(300,'(4i6,4f14.2)') index,age,q,x,utilm_c(q,x),emaxm_c(q,x,ageprime),vm0_c(q,x,age),emaxm_c(q,x,age)
!				write(300,*)
!
!			end do 
!		end do 

		!if (age<mxa) then 
		!   j=age+1
		!    do x=1,nxs
		!	    do q=1,nqs				
		!		    write(300,'(tr4,"in",tr3,"age",tr5,"q",tr5,"x",tr8,"emax_s")')
		!		    write(300,'(4i6,2f14.2)') index,age,q,x,emaxm_s(q,x,j),emaxf_s(q,x,j)
		!		    write(300,*)
		!	    end do 
		!   end do 
		!end if 
		
		!print*, "hrtr id mr ",index,myindex

		emp_m=0.0_dp 
		emp_f=0.0_dp
		do x=1,nxs
		do q0=1,nqs	
			do q=1,nqs	
                do iepsmove=1,nepsmove
				if (q2w(q0)<=np1) then 
					j=decm_s(iepsmove,q,x,q0,age,index)
					emp_m(1)=emp_m(1)+1 
					emp_m(2)=emp_m(2)+one(j<=np)
					!write(300,'(tr2,"in",tr1,"age",tr3,"x",tr4,"q0",tr5,"q",tr3,"dec",tr4,"w0",tr5,"w",tr3,"dec",tr4,"l0",tr5,"l",tr3,"dec",tr6,"emax")')
					!write(300,'(3i4,9i6,f10.2)') index,age,x,q0,q,j,q2w(q0),q2w(q),q2w(j),q2l(q0),q2l(q),q2l(j),emaxm_s(q,x,age)
					j=decf_s(iepsmove,q,x,q0,age,index)
					emp_f(1)=emp_f(1)+1 
					emp_f(2)=emp_f(2)+one(j<=np)
					!write(300,'(3i4,9i6,f10.2)') index,age,x,q0,q,j,q2w(q0),q2w(q),q2w(j),q2l(q0),q2l(q),q2l(j),emaxf_s(q,x,age)
					if (icheck_eqvmvf .and. decm_s(iepsmove,q,x,q0,age,index)/=decf_s(iepsmove,q,x,q0,age,index)) then 
						print*, "decsingle not equal! " 
						stop 
					end if 
					!write(300,*)
				end if 
                end do !iepsmove
			end do 
		end do 
		end do 
		
		if (age==30) then 
		if (emp_m(1)>0.0_dp ) then
		 !   write(*,'("m: age,emp ",i4,f10.2,i4)') age,emp_m(2)/emp_m(1),iter
			empdec(age,1)=emp_m(2)/emp_m(1)
		end if 
		if (emp_f(1)>0.0_dp ) then 
		 !   write(*,'("f: age,emp ",i4,f10.2,i4)') age,emp_f(2)/emp_f(1),iter
			empdec(age,2)=emp_f(2)/emp_f(1)
		end if 
		end if 
	end subroutine yaz1

	subroutine check_eqvmvf(dd,vm_c,vf_c)
	integer(i4b), intent(in) :: dd(:)
	real(dp), dimension(nq,nx), intent(in) :: vm_c,vf_c
	real(dp) :: vec(4)
	integer(i4b) :: ia,k,q,x,z,q0,g,j,i
	integer(i4b) :: qr,xr,qp,xp
	ia=dd(1) 
	k=dd(2) 
	q=dd(3) 
	x=dd(4) 
	z=dd(5) 
	q0=dd(6)
	g=dd(7) 
	!j=dd(8) 
	if ( qq2q(1,q0)==qq2q(2,q0)  ) then 
	do xr=1,nxs
		do qr=1,nqs
			do xp=1,nxs
				do qp=1,nqs
					vec=pen
					q=q2qq(qp,qr) ; x=x2xx(xp,xr)
					if (q>0 .and. x>0) then 
						vec(1)=vm_c(q,x) 
						vec(2)=vf_c(q,x)
					end if 								
					i=q2qq(qr,qp) ; j=x2xx(xr,xp)
					if (i>0 .and. j>0) then 
						vec(3)=vm_c(i,j) 
						vec(4)=vf_c(i,j)
					end if 
					if ( abs(vec(1)-vec(4))>eps .and. abs(vec(2)-vec(3))>eps  ) then 
						write(*,'("not good",I4,4F14.2)') ia,vec(1:4)
						write(*,'(4i4)') qq2w(1,q0),qq2l(1,q0),qq2w(2,q0),qq2l(2,q0)
						write(*,'(4i4)') qq2w(1,q),qq2l(1,q),qq2w(2,q),qq2l(2,q)
						write(*,'(4i4)') q2w(qp),q2l(qp),q2w(qr),q2l(qr)
						write(*,'(6i4,2f14.2,4i4)') qr,xr,qp,xp,q,x,vec(1:2)
						write(*,*) ppc(q,q0),maxval(ppcq(q,q0,:))
						write(*,*)
						write(*,'(4i4)') qq2w(1,q0),qq2l(1,q0),qq2w(2,q0),qq2l(2,q0)
						write(*,'(4i4)') qq2w(1,i),qq2l(1,i),qq2w(2,i),qq2l(2,i)
						write(*,'(4i4)') q2w(qr),q2l(qr),q2w(qp),q2l(qp)
						write(*,'(6i4,2f14.2,4i4)') qp,xp,qr,xr,i,j,vec(3:4)
						write(*,*) ppc(i,q0),maxval(ppcq(i,q0,:))
						stop
					end if 
								
				end do 
			end do 
		end do 
	end do 
	end if 
	end subroutine
	
	SUBROUTINE yazsimtemp(dd)    
	integer(i4b), intent(in) :: dd(:)
	integer(i4b) :: ia,k,q,x,z,q0,g,j,altq,i
	integer(i4b) :: a,b,c,qbar(2),kid
	ia=dd(1) 
	k=dd(2) ! index
	q=dd(3) 
	x=dd(4) 
	z=dd(5) 
	q0=dd(6)
	g=dd(7) 
	j=dd(8) ! jmax
	i=dd(9) ! qmax
	kid=0
	if (whereamI==1) then 
		write(200,'(" -------------- SOL: DIV DIV DIV DIV DIV DIV DIV : JCHO,ICHO ",2I8, "--------------")') J,I
	else if (whereamI==4) then
		write(200,'(" -------------- SIM: DIV DIV DIV DIV DIV DIV DIV : JCHO,ICHO ",2I8, "--------------")') J,I
	end if 
	!if (insol) then 
	!	write(200,'(" -------------- SOL: MAR MAR MAR MAR MAR MAR MAR : JCHO,ICHO ",2I8, "--------------")') J,I
	!else 	
	!	write(200,'(" -------------- SIM: MAR MAR MAR MAR MAR MAR MAR : JCHO,ICHO ",2I8, "--------------")') J,I
	!end if 	
	10 FORMAT (/1x,TR5,'Q0',TR6,'X0',TR6,'IA',TR6,'IN',TR7,'Q',TR7,'X', /)
	20 FORMAT (/1x,TR5,'Q0',TR6,'X0',TR6,'IA',TR6,'IN',2(TR6,'W0'),2(TR6,'L0'),TR9,'EMAXC',TR9,'EMAXS' /)
	END SUBROUTINE yazsimtemp

	
end module myaz

	!else if (tag==4) then 
	!	write(200,'(" *************************************** check emax 1 ********************************************* ")') 
	!	write(200,10) 
	!	write(200,'(6i8,5f14.4)') q0,x0,ia,in,q,x,ppcq(q,q0,x0),ppcx(x,q0,x0)  !,val(1),ppcq(q,q0,x0)*ppcx(x,q0,x0)*val(1)
	!	write(200,*) 	
	!else if (tag==5) then 
	!	write(200,'(" *************************************** check emax 2 ********************************************* ")') 
	!	do q0=1,70
	!		x0=2
	!		write(200,20) 
	!		g=1 ; i=qq2q(g,q0) ; n=xx2x(g,x0) 
	!		write(200,'(8i8,2f14.2)') q0,x0,ia,in,qq2w(:,q0),qq2l(:,q0),emaxm_c(q0,x0,ia,in),emaxm_s(i,n,ia,in)
	!		g=2 ; i=qq2q(g,q0) ; n=xx2x(g,x0) 
	!		write(200,'(8i8,2f14.2)') q0,x0,ia,in,qq2w(:,q0),qq2l(:,q0),emaxf_c(q0,x0,ia,in),emaxf_s(i,n,ia,in)
	!		write(200,*) 
	!	end do 


! information about the value functions
! get vmsep/vfsep=values of being single for males
! this is the value of remaining single, either because you started the period single and you reject the partner you meet or because you leave a relationship at
! the start of the period. not the value of starting period single, as it does not include the value of potentially entering into a relationship		  			
!get each spouse's consumption transfers for each j alternative using foc to the nb problem to get:
!share(2,cho): spouses' respective consumption shares of total income (pi) for each alternative cho
!these share solutions are conditional on the nb problem being well-defined. otherwise they don't mean anything
!i check for whether the nb problem is well-defined in the getnb subroutine later because i wait for marie
! checknb: check if the nb problem is well-defined meaning that there exists some allocation in the utility possibility set that is mutually beneficial
module sol
	use params
	use share
	use myaz
	implicit none
	real(sp) :: begintime,time(5)   
contains		
	subroutine solve
	real(dp) :: vec(5),vmax(2),val(2),vsum(2),vcheck(2)
	real(dp), dimension(nqs,nxs) :: vm0_s,vf0_s,vm_s,vf_s,prob_s
	real(dp), dimension(nq,nx) :: vm_c,vf_c,prob
	real(dp), dimension(nepsmove,nqs,nxs,nqs) :: vmr,vfr
	real(dp) :: vsingle(2,nqs,nxs,nz) ,surplus,transfers(2),test
	integer(i4b) :: ia,i,n,i0,z,g,j,imax,dd(11),jmax,iepsmove,qmax,relmax,pp,ppp,index,trueindex,ed(2)
	integer(i4b) :: q,x,q0,x0,qm,xm,qf,xf
    integer(i4b) :: iapp !ahu 030518 del and remove later
	logical :: welldef
	!testing(1,1)=1 ; testing(1,2)=2 ; testing(1,3)=3 ; testing(2,1)=4 ; testing(2,2)=5 ; testing(2,3)=6
	!print*, "maxloc(testing,1),maxloc(testing,2)",maxloc(testing,1),maxloc(testing,2),"maxval",maxval(testing(2,:),1)   !,maxval(testing,2)
	!print*, nqs*nqs,nq*nq,count(pps(:,:,1)),count(ppc(:,:))
	begintime=secnds(0.0)
    !print*, 'Here is iter',iter
    
    if (groups) then 
        call cotyphome2index(myindex,myco,mytyp,myhome)
    else 
        myindex=0
    end if 
    !IF YOU WANT TO WRITE ALL THE BELOW, YOU HAVE TO COMMENT OUT THE OBJF PART WHERE IT SAYS IF ITER>1 SKRIV=.FALSE.
    if (skriv.and.iter==1) then 
        open(unit=99991, file='chkfnprof1.txt',status='replace')
    else if (skriv.and.iter==2) then
        open(unit=99991, file='chkfnprof2.txt',status='replace')
    else if (skriv.and.iter==3) then
        open(unit=99991, file='chkfnprof3.txt',status='replace')
    else if (skriv.and.iter==4) then
        open(unit=99991, file='chkfnprof4.txt',status='replace')
    else if (skriv.and.iter==5) then
        open(unit=99991, file='chkfnprof5.txt',status='replace')
    end if 
    if (skriv) then
        write(99991,'("Offer Employed:")') 
        write(99991,'("Males:")') 
        write(99991,'(15x,5x,"Get offer",5x,"Get ldoff",8x,"Nthing")') 
        write(99991,'("Not Educ",7x,3F14.6)') psio(1:2),zero  !fnprof(dw0,de,dsex) 
        write(99991,'("Not Educ",7x,3F14.6)') fnprof(1,1,1)  !fnprof(dw0,de,dsex) 
        write(99991,'("    Educ",7x,3F14.6)') psio(3:4),zero  !fnprof(dw0,de,dsex) 
        write(99991,'("    Educ",7x,3F14.6)') fnprof(1,2,1)  !fnprof(dw0,de,dsex) 
        write(99991,'("Females:")') 
        write(99991,'(15x,5x,"Get offer",5x,"Get ldoff",8x,"Nthing")') 
        write(99991,'("Not Educ",7x,3F14.6)') psio(5:6),zero  !fnprof(dw0,de,dsex) 
        write(99991,'("Not Educ",7x,3F14.6)') fnprof(1,1,2)  !fnprof(dw0,de,dsex) 
        write(99991,'("    Educ",7x,3F14.6)') psio(7:8),zero  !fnprof(dw0,de,dsex) 
        write(99991,'("    Educ",7x,3F14.6)') fnprof(1,2,2)  !fnprof(dw0,de,dsex) 
        write(99991,*) 
        write(99991,*) 
        write(99991,'("Offer Unemployed:")') 
        write(99991,'("Males:")') 
        write(99991,'(15x,5x,"Get offer",8x,"Nthing",8x,"Nthing")') 
        write(99991,'("Not Educ",7x,3F14.6)') psio(9),zero,zero  !fnprof(dw0,de,dsex) 
        write(99991,'("Not Educ",7x,3F14.6)') fnprof(np1,1,1)  !fnprof(dw0,de,dsex) 
        write(99991,'("    Educ",7x,3F14.6)') psio(10),zero,zero  !fnprof(dw0,de,dsex) 
        write(99991,'("    Educ",7x,3F14.6)') fnprof(np1,2,1)  !fnprof(dw0,de,dsex) 
        write(99991,'("Females:")') 
        write(99991,'(15x,5x,"Get offer",8x,"Nthing",8x,"Nthing")') 
        write(99991,'("Not Educ",7x,3F14.6)') psio(11),zero,zero  !fnprof(dw0,de,dsex) 
        write(99991,'("Not Educ",7x,3F14.6)') fnprof(np1,1,2)  !fnprof(dw0,de,dsex) 
        write(99991,'("    Educ",7x,3F14.6)') psio(12),zero,zero  !fnprof(dw0,de,dsex) 
        write(99991,'("    Educ",7x,3F14.6)') fnprof(np1,2,2)  !fnprof(dw0,de,dsex) 
        close(99991) 
    end if 
    
    call get_util_w
    if (onlysingles) then ; utilc=pen ; end if 
	insol=.true.
	!prob=0.0_dp
	decm0_s = ipen	; decf0_s = ipen  ; decm_s = ipen	; decf_s = ipen ; dec_mar=ipen ! dum is a dummy for yaz_checknb
    vm    = pen ; vf   = pen ; vm0_c = pen ; vf0_c = pen
    do trueindex=1,ninp
        if (groups) then 
            index=1
        else 
            index=trueindex
        end if
        ind: if ( (.not.groups) .or.  (myindex==trueindex) ) then !(myco==init(nn)%co.and.mytyp==typsim.and. myhome==init(nn)%hme)  ) then	  
		time(1)=secnds(0.0)
		emaxm_s=0.0_dp	; emaxf_s=0.0_dp ; emaxm_c=0.0_dp	; emaxf_c = 0.0_dp
		do ia=mxa,mna,-1
			!print*, "mysay,ia,trueindex ",mysay,ia,trueindex !ahu 0327
			vmr  = pen ; vfr = pen	
			time(1)=secnds(0.0)
			if (ia==mxa) then 
				vm0_s = utils(1,:,:,trueindex) + ws(1,:,:,trueindex)		! v0: value function without movecost 
				vf0_s = utils(2,:,:,trueindex) + ws(2,:,:,trueindex)		! v0: value function without movecost
				vm0_c(:,:,ia,index) = utilc(1,:,:,trueindex)	! v0: value function without movecost, umar, consumption
				vf0_c(:,:,ia,index) = utilc(2,:,:,trueindex)	! v0: value function without movecost, umar, consumption
                
			else 
				vm0_s = utils(1,:,:,trueindex) + ws(1,:,:,trueindex)		+ delta * emaxm_s(:,:,ia+1)	! v0: value function without movecost 
				vf0_s = utils(2,:,:,trueindex) + ws(2,:,:,trueindex)		+ delta * emaxf_s(:,:,ia+1)	! v0: value function without movecost 
				vm0_c(:,:,ia,index) = utilc(1,:,:,trueindex)	+ delta * emaxm_c(:,:,ia+1)	! v0: value function without movecost, umar, consumption
				vf0_c(:,:,ia,index) = utilc(2,:,:,trueindex)	+ delta * emaxf_c(:,:,ia+1)	! v0: value function without movecost, umar, consumption
			end if 		
            
			whereami=1
			if (skriv.and.trueindex==1.and.(ia<=19.or.ia==45)) then ; yaz=.true. ; else ; yaz=.false. ; end if !ahu 0327 trueindex==2
			!if (skriv) yaz=.true.
            dd = -1 ; dd(1:2) = (/ia,trueindex/) 
			dd(7)=1 ; call getdec_s(dd,vm0_s,decm0_s(:,:,:,:,ia,index),vm(:,:,:,:,ia,index)) 
			yaz=.false.
			dd(7)=2 ; call getdec_s(dd,vf0_s,decf0_s(:,:,:,:,ia,index),vf(:,:,:,:,ia,index))	

			if (onlysingles) then 	
				decm_s(:,:,:,:,ia,index)=decm0_s(:,:,:,:,ia,index)
				decf_s(:,:,:,:,ia,index)=decf0_s(:,:,:,:,ia,index)
				vmr=vm(:,:,:,:,ia,index)
				vfr=vf(:,:,:,:,ia,index)
			else 
				whereamI=1 ! for telling yaz about where we are
				vec=pen
				do q0=1,nq	
					vm_c=pen ; vf_c=pen
					prob=0.0_dp
					do x=1,nx	
						do q=1,nq
							if (skriv.and.(ia==18.or.ia==50).and.(q>33.and.q<=37).and.(q0>=32.and.q0<=35).and.x==2) then ; yaz=.true. ; else ; yaz=.false. ; end if  
                            !if (skriv.and.(q0>=32.and.q0<=35).and.x==2.and.(q>=33.and.q<=37).and.(ia==mxa.or.ia==47)) then ; yaz=.false. ; else ; yaz=.false. ; end if  
                            !if (skriv.and.(ia>=40).and.(q0==18).and.q==24.and.x==1.and.trueindex==1) then ; yaz=.true. ; else ; yaz=.false. ; end if  !ahu 0327 trueindex==2
							if ( ppc(q,q0) ) then
								val=0.0_dp
								umar: do z=nz,1,-1		
                                    moveshocks: do iepsmove=1,nepsmove
                                        dd = (/ia,trueindex,q,x,z,q0,-1,-1,-1,-1,iepsmove /) 	! (/ ia,index,q,x,z,q0,gender,jmax,qmax,relmax,iepsmove /)  	
									    call getdec_c(dd,vmax)			    ! dd is inout and dd(8:10) tells you jmax,qmax,relmax
									    if (yaz) then ; call yaz_decision(dd,vmax) ; end if	! write down decision !ahu 032718 del and remove later. I uncommented this write
									    val=val+ppso(iepsmove)*mgt(z)*vmax
                                    end do moveshocks
                                end do umar
								vm_c(q,x)=val(1) ; vf_c(q,x)=val(2)
							end if !pc0(q0)=.true. i.e. w(1) or w(2) are not np2 and pc
						end do !q
					end do !x
					!if (icheck_eqvmvf) then
					!	call check_eqvmvf(dd,vm_c,vf_c) 
					!end if 
					do x0=1,nx
                        if ( maxval(qq2w(:,q0)) <= np1 ) then !state variable part of the q space i.e. w <= np1
						    !prob=matmul( reshape(ppcq(:,q0,x0),(/nq,1/)) , reshape(ppcx(:,q0,x0),(/1,nx/)) )
						    !emaxm_c(q0,x0,ia)=sum(prob*vm_c)
						    !emaxf_c(q0,x0,ia)=sum(prob*vf_c)                    
                            emaxm_c(q0,x0,ia)=0.0_dp
						    emaxf_c(q0,x0,ia)=0.0_dp
                            do q=1,nq
                                do x=1,nx
						            emaxm_c(q0,x0,ia)=emaxm_c(q0,x0,ia)+ppcq(q,q0,x0)*ppcx(x,q0,x0)*vm_c(q,x)
						            emaxf_c(q0,x0,ia)=emaxf_c(q0,x0,ia)+ppcq(q,q0,x0)*ppcx(x,q0,x0)*vf_c(q,x)
                                end do 
                            end do 
                        end if !state variable part of the q space i.e. w <= np1
					end do	 !x0						

                end do !q0
				
                !timeline: when single, you first decide on loc and work. and then when the day comes to an end, you go to the marriage market in whatever location you chose for that period.
				vm_s=0.0_dp ; vf_s=0.0_dp
				do xm=1,nxs					
                    ed(1)=x2e(xm)   !ahu summer18 051418: adding ed dimension to nonlabinc
					do qm=1,nqs	
						!no need for this ahu040518 vsingle=0.0_dp
						do xf=1,nxs			
                            ed(2)=x2e(xf)   !ahu summer18 051418: adding ed dimension to nonlabinc
							do qf=1,nqs
                                if (skriv.and.(ia==18).and.(qm==18).and.xm==1) then ; yaz=.true. ; else ; yaz=.false. ; end if     !ahu 0327 trueindex==2								
								    !no need for this ahu040518 sex: do g=1,2
									!no need for this ahu040518 if (g==1) then ; qm=qr ; qf=qp ; xm=xr ; xf=xp ; end if ! determine the match and the joint q from the combination
									!no need for this ahu040518 if (g==2) then ; qm=qp ; qf=qr ; xm=xp ; xf=xr ; end if ! determine the match and the joint q from the combination
									if (ppmeetq(qm,qf)>0.0_dp .and. ppmeetx(xm,xf)>0.0_dp) then 
										q = q2qq(qm,qf) 
										x = x2xx(xm,xf) 
										q0=-1	
										if (q2w(qm)>np1.or.q2w(qf)>np1.or.q==0.or.x==0) stop   !if (ps0(qm) .and. ps0(qf) .and. q > 0 .and. x >0) then ! all w should be <= np1	and q,x should exist
										vec(1) = vm0_s(qm,xm)
                                        vec(2) = vf0_s(qf,xf)
										marshock: do z=1,nz  
											dd = (/ ia,trueindex,q,x,z,q0,-1,-1,q,-1,-1 /) ! g and q0 is just -1 here (/ ia,index,q,x,z,q0,gender,j,q,rel,iepsmove /) 
                                                                                ! when in the marriage market, the index that corresponds to altq (i.e. i in yaz for example or dim 9 in dd) is just set to q since there is no altq in marriage market
                                            vec(3) = vm0_c(q,x,ia,index) + mg(z,trueindex) 
                                            vec(4) = vf0_c(q,x,ia,index) + mg(z,trueindex) 
                                            vec(5) = wc(1,q,x,trueindex) +  wc(2,q,x,trueindex) + nonlabinc(ed(1)) + nonlabinc(ed(2))                                                   
                                            !call checknb(dd,vec,welldef,vsum )                                            
                                            surplus = vec(5) + vec(3) - vec(1) + vec(4) - vec(2)  
                                            transfers=pen
                                            if (surplus+eps>0.0_dp) then
                                                welldef=.TRUE.
                                                if (nonneg) then
		                                            transfers(1) = alf * surplus - ( vec(3)-vec(1) )                                                
		                                            transfers(2) = (1.0_dp-alf) * (vec(5) + vec(3) - vec(1) ) - alf*( vec(4)-vec(2) )           
		                                            if ( minval(transfers) + eps2 >= 0.0_dp .and. maxval(transfers) <= vec(5)+eps2 ) then ! if (minval(transfers)>0.0_dp.and.maxval(transfers)<vec(5) ) then 
                                                        welldef=.TRUE.
                                                    else
                                                        welldef=.FALSE.
                                                    end if
                                                end if
                                            else 
												welldef=.FALSE.
                                                transfers=pen
                                            end if 
                                            if (welldef) then
												dec_mar(z,q,x,ia,index)=1
                                                vsum(1:2)=vec(1:2)+0.5_dp*surplus
                                                val=vsum(1:2)                                                
                                            else 
                                                dec_mar(z,q,x,ia,index)=0
                                                vsum=pen
												val=vec(1:2) 
                                            end if 

                                            if (yaz) then ; whereamI=5 ; dd(10)=one(welldef) ; call yaz_checknb(dd,vec,transfers,welldef) ; end if 
                                            !!!if (skriv.and.surplus+eps>0.0_dp.and.welldef==.FALSE.) then  ; whereamI=5 ; dd(10)=one(welldef) ; call yaz_checknb(dd,vec,transfers,welldef) ; end if 
                                            !if (skriv.and.ia==40.and.q==107.and.x==39) then  ; whereamI=5 ; dd(10)=one(welldef) ; call yaz_checknb(dd,vec,transfers,welldef) ; end if 
                                                                
                                           !if (  icheck_eqvmvf.and.qr==qp.and.xr==xp.and.  (abs(vec(1)-vec(2)) > eps .or. abs(vsum(1)-vsum(2)) > eps) ) then 
											!	print*, "vm not eq to vf!", ia,qr,xr,vec(1:4),vsum
											!	stop 
											!end if 
											if (yaz) then ; whereamI=5 ; dd(10)=one(welldef) ; vmax=vsum ; call yaz_decision(dd,vmax) ; end if 
											!no need for this ahu040518 vsingle(g,qp,xp,z)=val(g)	
											vm_s(qm,xm)=vm_s(qm,xm) + mgt(z) * ppmeetq(qm,qf) * ppmeetx(xm,xf) * val(1)
											vf_s(qf,xf)=vf_s(qf,xf) + mgt(z) * ppmeetq(qm,qf) * ppmeetx(xm,xf) * val(2)
										end do marshock 
									end if 
							        !no need for this ahu040518 end do sex 
							        !if (icheck_eqvmvf) then 
							        !	do z=1,nz
							        !		if ( abs(vsingle(1,qp,xp,z) - vsingle(2,qp,xp,z))>eps ) then 
							        !			write(*,'("vsingle not equal!!!")')
							        !			stop
							        !		end if 
							        !	end do 
							        !end if 
							end do 
						end do 							
						!moving this after the loop ahu040518 vm_s(qr,xr) = pmeet*vm_s(qr,xr) + (1.0_dp-pmeet)*vm0_s(qr,xr)
						!moving this after the loop ahu040518 vf_s(qr,xr) = pmeet*vf_s(qr,xr) + (1.0_dp-pmeet)*vf0_s(qr,xr)
						!if (  icheck_eqvmvf.and.abs(vm_s(qr,xr)-vf_s(qr,xr)) > eps ) then 
						!	print*, "vm not equal to vf!", ia,qr,xr,vm_s(qr,xr),vf_s(qr,xr)
						!	stop 
						!end if 
					end do 
				end do
				vm_s(:,:) = pmeet*vm_s(:,:) + (1.0_dp-pmeet)*vm0_s(:,:) !ahu 040518
				vf_s(:,:) = pmeet*vf_s(:,:) + (1.0_dp-pmeet)*vf0_s(:,:) !ahu 040518
                !vm_s=vm0_s
                !vf_s=vf0_s
                !dec_mar=0
                
				yaz=.false.
				if (skriv.and.(ia==mxa.or.ia==29).and.trueindex==1) yaz=.false.
				dd = -1 ; dd(1:2) = (/ia,trueindex/) 							! (/ ia,index,q,x,z,q0,g,j,altq,rel,iepsmove /)
				dd(7)=1 ; call getdec_s(dd,vm_s,decm_s(:,:,:,:,ia,index),vmr(:,:,:,:)     ) 
				dd(7)=2 ; call getdec_s(dd,vf_s,decf_s(:,:,:,:,ia,index),vfr(:,:,:,:)     ) 			
			end if 	! only singles or not

			do x0=1,nxs
				do q0=1,nqs
					if (q2w(q0)<=np1) then !state variable part of the q space i.e. w <= np1
						do x=1,nxs 
                            do q=1,nqs
                                do iepsmove=1,nepsmove
                                    !prob_s=matmul( reshape(ppsq(:,q0,x0,1),(/nqs,1/)) , reshape(ppsx(:,q0,x0),(/1,nxs/)) )
						            !emaxm_s(q0,x0,ia)	= sum( prob_s * vmr(:,:,q0) )		
                                    !prob_s=matmul( reshape(ppsq(:,q0,x0,2),(/nqs,1/)) , reshape(ppsx(:,q0,x0),(/1,nxs/)) )
						            !emaxf_s(q0,x0,ia)	= sum( probf_s * vfr(:,:,:,q0) )
                                    emaxm_s(q0,x0,ia)	= emaxm_s(q0,x0,ia) + ppso(iepsmove) * ppsq(q,q0,x0,1) * ppsx(x,q0,x0) * vmr(iepsmove,q,x,q0) 
                                    emaxf_s(q0,x0,ia)	= emaxf_s(q0,x0,ia) + ppso(iepsmove) * ppsq(q,q0,x0,2) * ppsx(x,q0,x0) * vfr(iepsmove,q,x,q0) 	
                                end do 
                            end do 
                        end do
                    end if !state variable part of the q space i.e. w <= np1
				end do 
			end do 

			yaz=.false.			
			if (skriv) call yaz1(index,ia) !ahu 0327. this was trueindex and corrected it to index.  
		end do ! age 
        end if ind
	end do !index
	!if ( (.not.chkstep).and.(.not.optimize) ) print*, "Finished solve and mysay is: ", mysay
	if (onlysingles) then
		dec_mar=0
	end if 
	insol=.false.
	end subroutine solve

	subroutine getdec_c(dd,vmax) 
	integer(i4b), intent(inout) :: dd(:)
	real(dp), intent(out) :: vmax(2) 
	real(dp) :: mcost(2),vsum(2),vec(5),surplusj(nc),transfers(2),vcheck(2),val(2),nashprod(nc)
	integer(i4b) :: ia,index,q,x,z,q0,g,jmax,qmax,relmax,iepsmove,i,i0,n,trueindex,j,de(1),ed(2)
	logical :: welldef,defj(nc)
    !dd= (/ ia,index,q,x,z,q0,g,jmax,qmax,relmax,iepsmove /)  		
    !dd = (/ia,trueindex,q,x,z,q0,-1,-1,-1,-1,iepsmove /) 	! (/ ia,index,q,x,z,q0,gender,jmax,qmax,relmax,iepsmove /)  	
	ia=dd(1) 
	trueindex=dd(2) 
    if (groups) then 
        index=1
    else 
        index=trueindex
    end if
    q=dd(3) 
	x=dd(4) ; ed(:)=xx2e(:,x)     
	z=dd(5) 
	q0=dd(6)  
	iepsmove=dd(11)   
    vec=pen				! initialize
    !jmax=0				! initialize
    !qmax=0				! initialize
    !relmax=0            ! initialize
    !vmax=pen			! initialize
    !surplusmax=pen      ! initialize  
    surplusj=pen
    nashprod=pen        !ahu summer18 042318
    transfers=pen
    defj=.FALSE.
    i = qq2q(1,q) ; n=xx2x(1,x) ; i0 = qq2q(1,q0) 	
    vec(1) = vm(iepsmove,i,n,i0,ia,index) + divpenalty
    mcost(1)=movecost(i0,n,trueindex)    
    i = qq2q(2,q) ; n=xx2x(2,x) ; i0 = qq2q(2,q0) 	
    vec(2) = vf(iepsmove,i,n,i0,ia,index) + divpenalty	
    mcost(2)=movecost(i0,n,trueindex)    
    choice: do j=1,nc	
        i = ch(j,q,q0)	!alternative q
        if (i>0 ) then		
            !if (qq2l(1,i).ne.qq2l(2,i)) then ; print*, 'something wrong in dec_c' ; stop; end if 
            !if (qq2l(1,q0).ne.qq2l(2,q0)) then ; print*, 'something wrong in dec_c' ; stop; end if 
            vec(3) = vm0_c(i,x,ia,index)  + mg(z,trueindex) + one( qq2l(1,i) /= qq2l(1,q0)) * mcost(1) + one( qq2l(1,i) /= qq2l(1,q0)) * moveshock_m(iepsmove)  !fnmove(kid)     
            vec(4) = vf0_c(i,x,ia,index)  + mg(z,trueindex) + one( qq2l(2,i) /= qq2l(2,q0)) * mcost(2) + one( qq2l(2,i) /= qq2l(2,q0)) * moveshock_f(iepsmove)  !fnmove(kid)     
            !vec(5) = wc(1,i,x,trueindex) + wc(2,i,x,trueindex) + one( qq2w(1,q0)<=np )* ubc(1,i,x,trueindex) + one( qq2w(2,q0)<=np )* ubc(2,i,x,trueindex) + nonlabinc + nonlabinc 	 !ahu summer18 050318: added the ubc
            vec(5) = wc(1,i,x,trueindex) + wc(2,i,x,trueindex) + nonlabinc(ed(1)) + nonlabinc(ed(2)) 
            surplusj(j) = vec(5) + vec(3) - vec(1) + vec(4) - vec(2)  
            dd(8:9)=(/j,i/)
            if (surplusj(j)+eps>0.0_dp) then
                defj(j)=.TRUE.
                if (nonneg) then
                    transfers(1) = alf * surplusj(j) - ( vec(3)-vec(1) )                                                
                    transfers(2) = (1.0_dp-alf) * (vec(5) + vec(3) - vec(1) ) - alf*( vec(4)-vec(2) )                   
                    if ( minval(transfers) + eps2 >= 0.0_dp .and. maxval(transfers) <= vec(5)+eps2 ) then ! if (minval(transfers)>0.0_dp.and.maxval(transfers)<vec(5) ) then 
                        defj(j)=.TRUE.
                        !**********************************
                        !ahu summer18 042318: the below part has been added to see if it solves the weirdmarriage rates falling when mumar is very large problem
                        !but more importantly I dont remember why I had gotten rid of the nashproduct part and was just maxing surplus anyway
                        !ahu summer18 050718: the two are the same i.e. mazing surplus and nashprod are the same. surplus is just 2 times nashprod. 
                        !so I will go back to maxing surplus because htat is quicker than nashprod calculation. and also the cluster is very slow whenever it's nashprod.
                        !but could not figure out why exactly. it might be because the within paranthesis part get very close to 0 but not sure. 
                        !!!nashprod(j)=  ( ( vec(3) + transfers(1) - vec(1) ) ** 0.5_dp  )  * ( ( vec(4) + transfers(2) - vec(2) ) ** 0.5_dp  )
                        !!!IF (SKRIV) THEN !AHU SUMMER18 042618: JUST IF SKRIV'ING THE BELOW IN THE INTEREST OF TIME SINCE WE DON'T NEED TO CALCULATE VCHECK AND VAL FOR THE ACTUAL PROBLEM. IT'S JUST FOR CHECK. 
                        !!!if (    (vec(3) + transfers(1) - vec(1)) < -eps  .or. ( vec(4) + transfers(2) - vec(2) ) < -eps ) then 
                        !!!    print*, 'something is wrong and I dont want to know what it is anymore', vec,transfers, (vec(3) + transfers(1) - vec(1)),( vec(4) + transfers(2) - vec(2) )
                        !!!    stop
                        !!!end if 
                        !!!vcheck(1:2) =   vec(3:4) + transfers(1:2)      ! vsum is the value function after all transfers are made. i.e. vsum = wage + beta*EV_worker         ! vec(3) is just beta*EV i.e. what the worker has before transfers are made
                        !!!val(1:2)=vec(1:2)+0.5_dp*surplusj(j)            !ahu summer18 042318: note that if surplus is positive, this inevitably has to be positive (assuming vec(1:2) is positive of course, why wouldn't it be)
                        !!!if ( abs(vcheck(1)-val(1))>eps .or. abs(vcheck(2)-val(2))>eps ) then 
                        !!!    print*, 'vcheck not equal to val',vcheck,val
                        !!!    stop
                        !!!end if
                        !!!END IF !SKRIV
                        !**********************************
                    else
                        defj(j)=.FALSE.
                        !nashprod(j)=pen
                    end if
                else !nonneg=.FALSE.
                    defj(j)=.TRUE.
                    !ahu summer18 050718: if nonneg is false, you don't need to calucalte transfers or nashprod or anything but was calculating the 
                    !below just for check. i.e. to do the vcheck checking (does what they each get (with the transfers) equal half of surplus)
                    !and indeed it does. so I am commenting these out for computation speed purposes but you can always uncomment out to see for yourself. 
                    !transfers(1) = alf * surplusj(j) - ( vec(3)-vec(1) )                                                
                    !transfers(2) = (1.0_dp-alf) * (vec(5) + vec(3) - vec(1) ) - alf*( vec(4)-vec(2) )        
                    !**********************************
                    !ahu summer18 042318: the below part has been added to see if it solves the weirdmarriage rates falling when mumar is very large problem
                    !but more importantly I dont remember why I had gotten rid of the nashproduct part and was just maxing surplus anyway
                    !ahu summer18 050718: the two are the same i.e. mazing surplus and nashprod are the same. surplus is just 2 times nashprod. 
                    !so I will go back to maxing surplus because htat is quicker than nashprod calculation. and also the cluster is very slow whenever it's nashprod.
                    !but could not figure out why exactly. it might be because the within paranthesis part get very close to 0 but not sure. 
                    !nashprod(j)=  ( ( vec(3) + transfers(1) - vec(1) ) ** 0.5_dp  )  * ( ( vec(4) + transfers(2) - vec(2) ) ** 0.5_dp  )
                    !if (    ( vec(3) + transfers(1) - vec(1) ) <0.0001_dp  .or. ( vec(4) + transfers(2) - vec(2) ) < 0.0001_dp ) then 
                    !    print*, 'maybe',( vec(3) + transfers(1) - vec(1) ) , ( vec(4) + transfers(2) - vec(2) ) ,( ( vec(3) + transfers(1) - vec(1) ) ** 0.5_dp  )  , ( ( vec(4) + transfers(2) - vec(2) ) ** 0.5_dp  ),nashprod(j)
                    !    stop
                    !end if 
                    !IF (SKRIV) THEN !AHU SUMMER18 042618: JUST IF SKRIV'ING THE BELOW IN THE INTEREST OF TIME SINCE WE DON'T NEED TO CALCULATE VCHECK AND VAL FOR THE ACTUAL PROBLEM. IT'S JUST FOR CHECK. 
                    !if (    (vec(3) + transfers(1) - vec(1)) < -eps  .or. ( vec(4) + transfers(2) - vec(2) ) < -eps ) then 
                    !    print*, 'something is wrong and I dont want to know what it is anymore', vec,transfers, (vec(3) + transfers(1) - vec(1)),( vec(4) + transfers(2) - vec(2) )
                    !    stop
                    !end if 
                    !vcheck(1:2) =   vec(3:4) + transfers(1:2)       ! vsum is the value function after all transfers are made. i.e. vsum = wage + beta*EV_worker         ! vec(3) is just beta*EV i.e. what the worker has before transfers are made
                    !val(1:2)=vec(1:2)+0.5_dp*surplusj(j)            !ahu summer18 042318: note that if surplus is positive, this inevitably has to be positive (assuming vec(1:2) is positive of course, why wouldn't it be)
                    !if ( abs(vcheck(1)-val(1))>eps .or. abs(vcheck(2)-val(2))>eps ) then 
                    !    print*, 'vcheck not equal to val',vcheck,val
                    !    stop
                    !end if
                    !END IF !SKRIV
                    !*********************************                
                end if !nonneg
            else
                defj(j)=.FALSE.
                surplusj(j)=pen
                !nashprod(j)=pen
                transfers=pen
            end if 
            if (yaz) call yaz_checknb(dd,vec,transfers,defj(j))
            !if (skriv.and.surplusj(j)+eps>0.0_dp.and.defj(j)==.FALSE.) call yaz_checknb(dd,vec,transfers,defj(j))
            
        end if
        !ahu summer18 050718
        !if ( (nashprod(j)==pen.and.surplusj(j)/=pen)  .or. (nashprod(j)/=pen.and.surplusj(j)==pen)  ) then 
        !    print*, 'Here it is they are not equal',surplusj(j),nashprod(j)
        !    stop
        !end if 
    end do choice    
    jmax=0
    !ahu summer18 042318 de=maxloc(surplusj,MASK=defj)
    !ahu summer18 050718: the two are the same i.e. mazing surplus and nashprod are the same. surplus is just 2 times nashprod. 
    !so I will go back to maxing surplus because htat is quicker than nashprod calculation. and also the cluster is very slow whenever it's nashprod.
    !but could not figure out why exactly. it might be because the within paranthesis part get very close to 0 but not sure. 
    !de=maxloc(nashprod,MASK=defj)
    de=maxloc(surplusj,MASK=defj)
    jmax=de(1)
    if (jmax>0) then 
        qmax=ch(jmax,q,q0)
        relmax=1
        vmax(1:2)=vec(1:2)+0.5_dp*surplusj(jmax)
    else
        qmax=0
        relmax=0
        vmax(1:2)=vec(1:2)
    end if
    dd(8)=jmax
    dd(9)=qmax
    dd(10)=relmax 
    ! if no gains from marriage, then divorce or stay single 
    !if (relmax==0) then 
    !	vmax=vec(1:2)       !don't need vmax in sim
    !end if  
    end subroutine getdec_c

    ! Look at dropbox/familymig/v130814/Source2 and Source11 and temp_010413 for the old versions of this
	subroutine checknb( dd, vec , def ,vsum)   
	integer, intent(in) :: dd(:) 
	real(dp), intent(in) :: vec(5)        
	logical, intent(out) :: def
	real(dp), intent(out) :: vsum(2)
	real(dp) :: surplus,transfers(2)
	vsum = pen ; transfers=pen 
	def  = .FALSE.
    surplus = vec(5) + vec(3) - vec(1) + vec(4) - vec(2)  
	if ( surplus + eps >= 0.0_dp )  then
		transfers(1) = alf * surplus - ( vec(3)-vec(1) )                                                    ! wage
		transfers(2) = (1.-alf) * (vec(5) + vec(3) - vec(1) ) - alf*( vec(4)-vec(2) )                       ! firm payoff
        !if (transfers(1) < 0.0_dp) cornersol=(/ 0._dp,vec(5) /) 
		!if (transfers(2) < 0.0_dp) cornersol=(/ vec(5),0._dp /) 
        !if not corner if statement. but not sure if this is right. look at the other tries below. 
        !because the below checks for corner solution o rinterior solution (checking transfers>0 or <w afterwards is the same as 
        !by the way checking the condition for checking FOC at corners 0 and w. see notes p.3 . 
        !but before this you need to figure otu whether there are 
        !any feasible utility allocations through doing that checking: 
        !asum = sum(  abs(.not. pc)  *   abs( vdif )   )
	    !def  = ( w + eps - asum  >= 0.0_dp )
    
		if ( minval(transfers) + eps >= 0.0_dp .and. maxval(transfers) < vec(5) ) then ! if (minval(transfers)>0.0_dp.and.maxval(transfers)<vec(5) ) then 
            def=.TRUE.
		    vsum(1) = transfers(1) + vec(3)      ! vsum is the value function after all transfers are made. i.e. vsum = wage + beta*EV_worker         ! vec(3) is just beta*EV i.e. what the worker has before transfers are made
		    vsum(2) = transfers(2) + vec(4)      ! vsum = firmpayoff + beta*EV_firm     ! " 
            if ( vsum(1) + eps < vec(1) .or. vsum(2) + eps < vec(2) ) then
                print*, "Transfers positive and less than wages but someone is getting a bad deal "
		        write(*,'(2x,2(tr6,"vbar"),2(tr8,"vc"),tr8,"wc",tr6,"surp")' )    
		        write(*,'(2x,6f10.2)') vec,surplus
		        write(*,'(2x,2(tr5,"trans"),2(tr6,"vsum") )' )    
		        write(*,'(2x,4f10.2)') transfers,vsum
                write(*,*) vsum(1)-vec(1),vsum(2)-vec(2)
            end if 
        end if
	end if
	!if (yaz) then    !.and.(dd(1)==30.and.def) ) then    !.and.minval(vsum)<0.0_dp) then 
	!	call yaz_checknb(dd,vec,transfers,def)
	!end if 
	end subroutine checknb

	!if ( pc(1) .and. pc(2) ) then	
	!	def  = .true.				
	!else 
	!	asum = sum(  abs(.not. pc)  *   abs( vdif )   )
	!	def  = ( w + eps - asum  >= 0.0_dp )
	!end if 
	!if (def) then 
	!	vsum	= vec(1:2) + 0.5_dp * ( w + eps + sum(vdif) )
	!	if ( vsum(1) < vec(1) .or. vsum(2) < vec(2) ) then 
	!		print*, "error in checknb " ,vsum(1)-vec(1),vsum(2)-vec(2),( w - asum  >= 0.0_dp ),w,asum,pc,w + sum(vdif) 
	!		print*, "vdif(2),wf_s,wf_s+vdif(2),wf_s+vdif(2) ", vdif(2)  !,wagetemp(2),wagetemp(2) + vdif(2),wagetemp(2) + vec(4) - vec(2) 
	!		stop 
	!	end if
	!end if 
	!if (yaz) then    !.and.(dd(1)==30.and.def) ) then    !.and.minval(vsum)<0.0_dp) then 
	!	call yaz_checknb(dd,vec,vdif,pc,asum,vsum,def)
	!end if 
	!end subroutine checknb

	!vsum = penaltyval 
	!transfers = penaltyval
	!def  = .FALSE.
	!criter=.FALSE.
	!surplus = vec(5) + vec(3) - vec(1) + vec(4) - vec(2)  
	! CASE 1: NO CONSTRAINT ON TRANSFERS. I.E. WAGES AND FIRM SHARES CAN BE NEGATIVE. 
	!         When there are no limits on what can be transferred, the only criterion for NB to be well-defined is simply that the match surplus is positive.  
	!if (nonneg_constraint==0) then                      ! no nonneg constraints for wages nor firm payoff  
	!	def = ( surplus + eps >= 0.0 )                  ! When there are no limits on what can be transferred btw parties, the only criterion for NB to be well defined is that surplus is positive. 
		
	! CASE 2: NONNEGATIVITY CONSTRAINTS ON TRANSFERS: 
	!           So that transfers can only come from current period resources. Cannot borrow from the continuation values to pay the other party today. 
	!           This limits the set of of feasible allocations and therefore the number of times NB is welldefined is less in this case. Because now any divsion of total surplus can only be implemented by using current period resources, which might not be enough sometimes. 
	!else if (nonneg_constraint==2) then                 ! see notes for how the nonneg constraints mean that the match surplus (outputnet) needs to satisfy the following three criteria
	!	criter(1) = ( vec(5) + eps >= vec(1) - vec(3) ) 
	!	criter(2) = ( vec(5) + eps >= vec(2) - vec(4) ) 
	!	criter(3) = ( vec(5) + eps >= vec(1) - vec(3) + vec(2) - vec(4) ) 
	!	def = ( criter(1) .and. criter(2) .and. criter(3) ) 
	!end if 
	

	! Check interior opt conditions 
	! If NB is well defined, then take FOC to get optimal transfers (wage and firm payoffs)
	!if (def) then 
	!	transfers(1) = alpha * surplus - ( vec(3)-vec(1) )                                                      ! wage
	!	transfers(2) = (1.-alpha) * (vec(5) + vec(3) - vec(1) ) - alpha*( vec(4)-vec(2) )                       ! firm payoff
	!	if (transfers(1) < 0.) transfers=(/ 0.,vec(5) /) 
	!	if (transfers(2) < 0.) transfers=(/ vec(5),0. /) 
	!	vsum(1) = transfers(1) + vec(3)      ! vsum is the value function after all transfers are made. i.e. vsum = wage + beta*EV_worker         ! vec(3) is just beta*EV i.e. what the worker has before transfers are made
	!	vsum(2) = transfers(2) + vec(4)      ! vsum = firmpayoff + beta*EV_firm     ! " 
	!	if (writeval) then ! if want to check whether things look right: check whether vsum's and the below temp's are equal. they should be since they are the same way of calculating value functions after the transfers.        
	!   end if 
	!end if 
	

	subroutine getdec_s_old(dd,vs,qs,vs1)
	integer(i4b), intent(in) :: dd(:)
	real(dp), dimension(nqs,nxs), intent(in) :: vs
	integer(i4b), dimension(nepsmove,nqs,nxs,nqs), intent(out) :: qs
	real(dp), dimension(nepsmove,nqs,nxs,nqs), intent(out) :: vs1
	real(dp), dimension(np2,nl) :: dumv0,dumv1,dumv2,dumv
    real(dp) :: v0,v_cond_u,vbar,totmovecost(nl),moveshock(nepsmove)
	integer(i4b) :: q0,q,qbar,qstar,q_cond_u,l,l_cond_u,w,x,ss(size(dd,1)),iepsmove,iepskid,sex,index,trueindex

    trueindex=dd(2)
    sex=dd(7)
	qs = -1 ; vs1 = 0.0_dp
    if (groups) then 
        index=1
    else 
        index=trueindex
    end if
    if (sex==1) then 
        moveshock=moveshock_m
    else if (sex==2) then 
        moveshock=moveshock_f
    else 
        print*, 'decs something wrong'
        stop
    end if 
	do q0=1,nqs
		if ( q2w(q0)<=np1 ) then 
			do x=1,nxs
                dumv0(:,:) = reshape( vs(:,x) , (/ np2, nl /) )	                ! turn q index into its components (w,l)
                !dumv1(:,:) = reshape( ubs(sex,:,x,trueindex) , (/ np2, nl /) )	! turn q index into its components (w,l)    !ahu summer18 050318
                !dumv2 = dumv0 + dumv1 * one(q2w(q0) <= np)                      !!ahu summer18 050318: !if they were working the previous period, then they get to collect unemp benefit but not otherwise
                dumv2=dumv0
                
                moveshocks: do iepsmove=1,nepsmove
				    !Before drawing the rest of the shocks (ofloc and wagedraw), determine some max options conditional on unemployment and given status quo (no need to know the ofloc and wagedraw for this)
                    totmovecost(:)=movecost(q0,x,trueindex) + scst ; totmovecost(q2l(q0))=moveshock(iepsmove) !0.0_dp
                    do w=1,np1
					    dumv(w,:) = dumv2(w,:) + totmovecost(:) !ahu summer18 050318 turned dumv0 into dumv2
				    end do 
                    
				    l_cond_u=maxloc(dumv(np1,:),1)	! max location option conditional on unemployment 
				    q_cond_u=wl2q(np1,l_cond_u )    ! turn that into q
				    v_cond_u=dumv(np1,l_cond_u)		! max val conditional on unemployment
				    v0=dumv(q2w(q0),q2l(q0))		! value at status quo
				    if (v0>v_cond_u) then			! choice btw status quo (vs(q0,x)) and max unemployment option (vs(i,x) calculted above:
					    vbar=v0 ; qbar=q0
				    else 
					    vbar=v_cond_u	  ; qbar=q_cond_u
				    end if 					
				    if ( q2w(qbar)==np2) then ; print*, "in getdec_s and q2w(j) is np2 " ; stop ; end if 
				    if (qbar==0) then ; print*, "in getdec_s: j is 0 ", dd(1),dd(2) ; stop ; end if 
				    ofloc: do l=1,nl											
					    !r = locate( real(dumv(1:np,l)) , real(vs(j,x))   )	! res wage for each location l, above which you accept the offer from location l
					    wagedraw: do w=1,np2
						    q = wl2q(w,l)
						    if (w <= np) then 
							    qstar = qbar*one( dumv(w,l)<=vbar) + q*one(dumv(w,l)>vbar)
						    else if (w == np1) then 
							    qstar  = q_cond_u	! if you get laid off, the only things to choose from are unemployment option and the max thing to do is qu in that case which is calculated above 
						    else if (w == np2) then 
							    qstar  = qbar		! if nothing happens then choice is q0u which is the maximum btw status quo and the best unemployment option 
						    end if 		
						    if (q2w(qstar)==np2) then ; print*, "in getdec_s and q2w(qstar) is np2 " ; stop ; end if 
						    qs(iepsmove,q,x,q0)  =  qstar				
						    vs1(iepsmove,q,x,q0) =	dumv(q2w(qstar),q2l(qstar))
                            !if (     abs( vs(qstar,x) - dumv(q2w(qstar),q2l(qstar))+ totmovecost(q2l(qstar))    )   > eps ) then ; print*, "in getdec_s and vs/=dumv ",vs(qstar,x),dumv(q2w(qstar),q2l(qstar))-totmovecost(q2l(qstar)) ; stop ; end if  		
						    if (yaz.and.q2w(q0)==1.and.l==8.and.x==1) then
							    ss = dd  !(/ ia,index,q,x,z,q0,gender,j,altq,iepsmove /)  													
							    ss(3:6)= (/q,x,-1,q0/)
                                ss(11)=iepsmove
							    !call yaz_decs(ss,qstar,v0,v_cond_u,vbar,dumv)   !look here
						    end if 
                        end do wagedraw
				    end do ofloc
                end do moveshocks
			end do  !x 				
		end if		! w0<=np1 i.e. ps0(q0) is true
	end do			! q0
	end subroutine getdec_s_old


	subroutine getdec_s(dd,vs,qs,vs1)
	integer(i4b), intent(in) :: dd(:)
	real(dp), dimension(nqs,nxs), intent(in) :: vs
	integer(i4b), dimension(nepsmove,nqs,nxs,nqs), intent(out) :: qs
	real(dp), dimension(nepsmove,nqs,nxs,nqs), intent(out) :: vs1
	integer(i4b) :: q0,q,l,l0,w,x,i,j,iepsmove,sex,index,trueindex,jstar(1),age,ss(size(dd,1))
    real(dp) :: mcost,vcho(ncs),moveshock(nepsmove),bshock(nepsmove)

    trueindex=dd(2)
    sex=dd(7)
	qs = -1 ; vs1 = 0.0_dp
    if (groups) then 
        index=1
    else 
        index=trueindex
    end if
    if (sex==1) then 
        moveshock=moveshock_m
        bshock=bshock_m
    else if (sex==2) then 
        moveshock=moveshock_f
        bshock=bshock_f
    else 
        print*, 'decs something wrong'
        stop
    end if 
	do q0=1,nqs
        l0=q2l(q0)
		if ( q2w(q0)<=np1 ) then 
			do x=1,nxs
                mcost=movecost(q0,x,trueindex)                
                moveshocks: do iepsmove=1,nepsmove
				    ofloc: do l=1,nl											
					    wagedraw: do w=1,np2
						    q = wl2q(w,l)

                            vcho=pen
                            choice: do j=1,ncs	
                                i = chs(j,q,q0)	!alternative q
                                if (i>0 ) then		
                                    if (q2w(i)<=np) then
                                        vcho(j) = vs(i,x) + one(q2l(i)/=l0) * mcost + one( q2l(i)/=l0) * moveshock(iepsmove)  !fnmove(kid)  
                                    else if (q2w(i)==np1) then 
                                        vcho(j) = vs(i,x) + one(q2l(i)/=l0) * mcost + one( q2l(i)/=l0) * moveshock(iepsmove) + bshock(iepsmove)   
                                    end if                                         
                                end if 
                            end do choice
                            
                            				
						    vs1(iepsmove,q,x,q0) =	maxval(vcho)
                            jstar(1)=maxloc(vcho,1)
                            qs(iepsmove,q,x,q0)  =  chs(jstar(1),q,q0)
                            if ( vs1(iepsmove,q,x,q0) < pen+1.0_dp) then 
                                print*, 'There is something wrong in decs new new new',vs1(iepsmove,q,x,q0),dd(1),moveshock(iepsmove),mcost
                                print*, 'vcho',vcho
                                stop
                            end if 
                            
						    if (yaz .and.q2w(q0)==1.and.l==8.and.x==1) then
							    ss = dd  !(/ ia,index,q,x,z,q0,gender,j,altq,iepsmove /)  													
							    ss(3:6)= (/q,x,-1,q0/)
                                ss(11)=iepsmove
							    call yaz_decs(ss,vcho)   !look here
						    end if 
                            
                    	 end do wagedraw
				    end do ofloc
                end do moveshocks
			end do  !x 				
		end if		! w0<=np1 i.e. ps0(q0) is true
	end do			! q0
	end subroutine getdec_s

    
	subroutine get_util_w
	integer(i4b) :: q,x,w(2),l(2),kid(2),ed(2),expe(2),trueindex,trueco,truetyp,truehome,g,j,k
    real(dp) :: epsw(2) !RHO(2,2),CD(2,2),
    
    utils=pen
    utilc=pen
    ws=pen
    wc=pen   
    



    do trueindex=1,ninp    
    call index2cotyphome(trueindex,trueco,truetyp,truehome)
    xs: do x=1,nxs
        !call x2edexpkid(x,ed,exp,kid)    
		qs: do q=1,nqs 
            movecost(q,x,trueindex)=fnmove( q2w(q),x2kid(x),trueindex)
            do g=1,2
                w(g) = q2w(q)						! wage 
			    l(g) = q2l(q)						! location
			    if ( w(g) <= np ) then	
                    epsw(g)=wg(w(g),g) !sig_wge(g)*wg(w(g),g)
				    ws(g,q,x,trueindex)	= fnwge(g,truetyp, l(g),epsw(g), x2e(x), x2r(x)) 
			    !    ubs(g,q,x,trueindex)	= 0.0_dp                                                            !ahu summer18 050318
                else if ( w(g) == np1 ) then 
			    !    epsw(g)=0.0_dp                                                                              !ahu summer18 050318
                    ws(g,q,x,trueindex)	 = 0.0_dp
                !    ubs(g,q,x,trueindex)	= replacement_rate*fnwge(g,truetyp, l(g),epsw(g), x2e(x), x2r(x))   !ahu summer18 050318
                end if 
                
			    if ( w(g) <= np ) then						
				    utils(g,q,x,trueindex)	= uhome(g) * one(l(g)==truehome) + uloc(l(g)) + nonlabinc(x2e(x))
			    else if ( w(g) == np1 ) then 
				    utils(g,q,x,trueindex)	= uhome(g) * one(l(g)==truehome)  + uloc(l(g)) + alphaed(g,x2e(x)) + alphakid(g,x2kid(x))  + nonlabinc(x2e(x))
			    end if
                
            end do !gender
		end do qs
	end do xs
	xc: do x=1,nx
        ed(:)=xx2e(:,x)    
        expe(:)=xx2r(:,x)    
        kid(:)=xx2kid(:,x)    
        qc: do q=1,nq
			w(:) = qq2w(:,q)						! wage 
			l(:) = qq2l(:,q)						! location
            if (l(1).ne.l(2)) then ; print*, 'lm not equal to lf' ; stop ; end if 

            !******************************
            !ahu summer18 050318 
            !if (w(1)<=np) then 
            !    ubc(1,q,x,trueindex)	= 0.0_dp           
            !else if (w(1)==np1) then 
            !    epsw(1)=0.0_dp
            !    ubc(1,q,x,trueindex)	= replacement_rate*fnwge(1,truetyp, l(1),epsw(1), ed(1), expe(1) ) 
            !end if 
            !if (w(2)<=np) then 
            !    ubc(2,q,x,trueindex)	= 0.0_dp           
            !else if (w(2)==np1) then 
            !    epsw(2)=0.0_dp
            !    ubc(2,q,x,trueindex)	= replacement_rate*fnwge(2,truetyp, l(2),epsw(2), ed(2), expe(2) ) 
            !end if 
            !ahu summer18 050318 
            !******************************
            
            if ( w(1) <= np .and. w(2) <= np ) then		
                epsw(1)=wg(w(1),1) !CD(1,1)*wg(w(1),1)
                epsw(2)=wg(w(2),2) !CD(2,1)*wg(w(1),1) + CD(2,2)*wg(w(2),2)
				wc(1,q,x,trueindex)	= fnwge(1,truetyp, l(1),epsw(1), ed(1), expe(1) ) 
                wc(2,q,x,trueindex)	= fnwge(2,truetyp, l(2),epsw(2), ed(2), expe(2) )  
            else if ( w(1) <= np .and. w(2) == np1 ) then		
                epsw(1)=wg(w(1),1) !sig_wge(1)*wg(w(1),1)
				wc(1,q,x,trueindex)	= fnwge(1,truetyp, l(1),epsw(1), ed(1), expe(1) ) 
				wc(2,q,x,trueindex)	= 0.0_dp
            else if ( w(1) == np1 .and. w(2) <= np ) then		
                epsw(2)=wg(w(2),2) !sig_wge(2)*wg(w(2),2)
				wc(1,q,x,trueindex)	= 0.0_dp
				wc(2,q,x,trueindex)	= fnwge(2,truetyp, l(2),epsw(2), ed(2), expe(2) )                      
            else if ( w(1) == np1 .and. w(2) == np1 ) then		
				wc(1,q,x,trueindex)	= 0.0_dp
				wc(2,q,x,trueindex)	= 0.0_dp                 
			end if 
            
            
            do g=1,2
			    if ( w(g) <= np ) then						
				    utilc(g,q,x,trueindex)	= uhome(g) * one(l(g)==truehome)   + uloc(l(g))
			    else if ( w(g) == np1 ) then 
				    utilc(g,q,x,trueindex)	= uhome(g) * one(l(g)==truehome)   + uloc(l(g)) + alphaed(g,ed(g) ) + alphakid(g,kid(g))
			    end if
            end do   
            
            !if (skriv) write(88881,'(3I4,4F10.2)') q,x,k,w1(i(1),j(1),k),w2(i(2),j(2),k),w3(q,x,k),w4(q,x,k)
        end do qc
	end do xc
    end do !trueindex
    
    
    !Male and female wage shocks for each period and from each location
!    do it=1,nt
!	    do iloc=1,nloc
!		    do rn=1,nn
!			    up1(it,rn,iloc)=CD(1,1)*rv1(it,rn,iloc)
!			    up2(it,rn,iloc)=CD(2,1)*rv1(it,rn,iloc)+CD(2,2)*rv2(it,rn,iloc)
!		    end do 
!	    end do
!    end do 

	end subroutine get_util_w
    
    
end module sol


!headloc(ihead)=im; headstr(ihead)='labor market hours by gender/rel/ia';ihead=ihead+1
!ahu 061211: have to control for ia here because the two brs have different ia compositions
!ahu 061211: br 2 has no hours/kids/cohmar simultaneously in the biannual years so if you condition on all that you will just get something until they are ia 28 or something (depending on what the br grouping is)
!ahu 061211: and so if we don't control for ia, it looks as if br 2 females who are cohabiting have decreased their hours of work. but this is just a composition effect.
!ahu 061211: excluding ia 20 because, something looks weird. br 2 works too few hours at ia 20 (for females,coh,nokid). so then when i include them, it looks as if br 2 coh females with no kids work less in the later br. 

module mom
	use params
	use share
	use myaz 
	use sol, only: getdec_c
	implicit none
contains

FUNCTION random(iseed)
! When first call, iseed must be a large positive integer.
! iseed will be changed when exit and be used for next calling.
! The range of the generated random number is between 1 and -1
!
implicit none
integer, intent(inout) :: iseed
real :: random
!
iseed = mod(8121*iseed+28411, 134456) ! 0 =< iseed < 134456
random = real(iseed)/134456. ! 0 < random < 1
!
end FUNCTION random

	! read psid data, save into global structure psiddata, calculate moments
	! notes on data
	!   record total number of observations in ndataobs
	!	need ages of observations to be strictly increasing
	!	ids should go from 1 to ndata
	!	data entry should look like: idnum, age sex rel kids edm edf incm incf hhm hhf ddm ddf rellen with <0 being blank
	!	what can be missing? anything.either entire observation is missing (rel<0)
	!		or observation is there but no record of housework (if year \=81) (housework hours <0)
	!		if not working, wage will be missing
	! ahu 071712: you can see in familymig.do that everyone starts in the data at age 16 (i drop the other people, but that's not many people)
	! this is because i wanted their location at age 16, because that's my definition of home location
	! keep this in mind, if this ever changes 
	! only want their information after they have completed school (whether high school or college)	!ahu 071712 
	! in the simulation this is automatically taken care of by the fact that the simulation starts at age age0sim(edsim(r))
	subroutine read_actualdata(init,dat)
	type(initcond), dimension(ndata), intent(out) :: init
	type(statevar), dimension(mnad:mxa,ndata), intent(out) :: dat	!data set. first entry is ia index, second observation number
	integer(i4b) :: kk,id,age,cohort,sexr,rel,kid,edr,edsp,hhr,hhsp,rellen,loc,homeloc,minage,endage,nomiss,ierr,checkminage(ndata)
	real(dp) :: wr_perhour,wsp_perhour
	dat=ones 	            ! initialize
    init=ones_init      ! initialize
    checkminage=1
	open(unit=77,file=datafilename)
	do kk=1,ndataobs
		read(77,*) id, age, cohort, sexr, rel, kid, edr, edsp, wr_perhour, wsp_perhour, hhr, hhsp, rellen,loc,minage,endage,homeloc
		if (rel/=0.and.rel/=1.and.rel/=-1) then ; print*, "data has other relationship states! ",rel ; stop ; end if !ahu 102112: count cohabiting people as married
		!if (age==mna) hme=loc      !ahu 022517: changing home back to state grew up. 
                                    !because otherwise I have to drop those who I don't observe starting from age 18 and 
                                    !then get a different cohort composition than the original sample and the avg wage per loc's end up being much smaller 
                                    !than the original numbers. 
                                    !see more details on the reason in the explanations for ahu 022517 in familymig_2.do
		dat(age,id)%id=id           !initcond		
        dat(age,id)%co=cohort       !initcond

        dat(age,id)%sexr=sexr       !initcond
		dat(age,id)%hme=homeloc     !initcond
		dat(age,id)%endage=endage   !initcond     
		dat(age,id)%edr=edr         !initcond
		dat(age,id)%expr=-99        ! (there is no exp variable in the actual data so this is always -99)
		if (kid==0) then
            dat(age,id)%kidr=1 
        else if (kid==1) then
            dat(age,id)%kidr=2 
        else if (kid==-1) then 
            dat(age,id)%kidr=-99
        else 
            print*, 'something wrong with kid in data'
            stop
        end if 
        !kid  !min(kid,maxkid)      !initcond (it should be just 0 in the beginning but might not be in the actual data so just read it from the data here as initcond)
		!ahu 030217 if (age==mna) init(id)=dat(age,id)%initcond 
        if (age==minage) then
            checkminage(id)=0
            init(id)=dat(age,id)%initcond
        end if 
        
        !ahu jan 19 010219
        !initial conditions are the state variables of age 17,which are the state variables that agents use inorder to make decisions at the beginning of age 18
        !in order to have moving rates in the data at age 17 (because we do have sim rates at age 17 in simulation since we record initconditions at age 17 and then their decisions become the age 18 variables)
        !if (age==mna) then 
        !    dat(age-1,id)%initcond=init(id)
        !    dat(age-1,id)%rel=0
        !    dat(age-1,id)%l=loc
        !    dat(age-1,id)%hr=0
        !end if 

		dat(age,id)%l=loc
		call get_dathrwge(hhr,wr_perhour,dat(age,id)%hhr,dat(age,id)%wr,dat(age,id)%logwr)        
        
		dat(age,id)%rel=rel
		if (rel==1) then 
			dat(age,id)%rellen=rellen
		else if (rel==0) then 
			dat(age,id)%rellen=-99 !99
		end if 
		
		if (rel==1) then 
			call get_dathrwge(hhsp,wsp_perhour,dat(age,id)%hhsp,dat(age,id)%wsp,dat(age,id)%logwsp)
		else if (rel==0) then 
			dat(age,id)%hhsp=-99 !99
			dat(age,id)%wsp=-99.0_dp !99.0_dp
            dat(age,id)%logwsp=-99.0_dp
		end if 

		dat(age,id)%edsp=edsp    !for some reason, don't read edsp from the data yet. just set it to -99 and do read it later. ahu 021617: now I read it!  
		dat(age,id)%expsp=-99   !no experience variable in the data 
		dat(age,id)%kidsp=-99    !kidsp is just a simulation concept
				
		call getmiss(dat(age,id),nomiss)
		dat(age,id)%nomiss=nomiss
		
		!some checks:
		if (edr.ne.1.and.edr.ne.2) then
			print*, 'There is something wrong with edr in read_actual data'
			stop 
		end if 
		if (dat(age,id)%co<0.or.dat(age,id)%sexr<0) then ; print*, "cohort and sex are negative!", age,dat(age,id)%co,cohort,dat(age,id)%sexr,sexr ; stop ; end if 

        !why is this age<agestart-1 and not age<agestart
        !because for ed, agestart is 22 in sim the initial conditions are assigned to age 21 and then 
        !the move rates at age 21 for ed people in sim turn out to be very large because they move immediately from their starting 
        !home location to the best uloc location. In the data, this moment is not there because of the setting of dat=ones 
        !for ages age<agestart. In order to let the estimation to its thing and be able to compare that large sim moving rate 
        !at age 21 to the data, I am setting the dat to ones for ages 0-20 rather than 0-21. doing this is also more consistent because 
        !now (i.e. when age<agestart case) the simulation has age 21 for the ed people but not the data. 
        !I am not doing this for noed though since for noed people there is no age read from the data that is less than mna
        !check this
        if (age<agestart(edr)-1) then 
			dat(age,id)=ones
		end if
        if (age<mna) then 
            print*, 'There is something wrong with age in read_actual data'
            stop
        end if 
    enddo 
    if (sum(checkminage)>0) then !this would mean that we don't get age=minage for some people which is not right
        print*, 'something is wrong with checkminage',checkminage
        stop
    end if
    if (minval(init(:)%id)<0.or.minval(init(:)%co)<0.or.minval(init(:)%sexr)<0.or.minval(init(:)%hme)<0.or.minval(init(:)%endage)<0.or.minval(init(:)%edr)<0 ) then 
        print*, 'something is wrong with init everything' !because this would mean things did not get set at minage. either minage was not around (which can't be right) or something else. 
        stop
    end if
	close(77)
	end subroutine read_actualdata
	
	subroutine simulate(init,sim)
	type(initcond), dimension(ndata), intent(in) :: init
	type(statevar), dimension(mnad:mxa,nsim), intent(out) :: sim
	type(shock), allocatable, dimension(:,:) :: epsim
	integer(i4b) :: q0,x0,q,x,dec(3),draw(2)
	integer(i4b) :: relnext,qnext,xnext
	integer(i4b) :: i0,n0,i,n,z
	integer(i4b) :: rel0,index,trueindex,ia,r,g,endage
	integer(i4b) :: nn,mm,typsim,hh(2),l(2),nomiss
	integer(i4b) :: p,k,imax				! for random_seed
	real(dp) :: rand,vmax(2),logw(2),inc(2),wage(2),dum(2) !dum is just a dummy variable for yaz_checknb
	logical  :: welldef,newrel0,meet,checkgroups,defj(nc)
	integer(i4b) :: qmatch,xmatch,dd(11),iepskid,iepsmove,eddummy,expdummy,ww(2),ed(2),expe(2),kid(2)
	real(dp) :: vec(5),mcost(2),surplus,surplusmax,surplusj(nc),val(2),vcheck(2),transfers(2)
	integer(i4b) :: l0,j,jmax,qmax,relmax,de(1)
	!integer, allocatable :: newseed(:)
	!integer ::     seedo
	integer(i4b), dimension(12) :: seed_init !98765
    
     !seedo=98765
	!seedo=seed_init    
	allocate(epsim(mna:mxa,nsim))
	
	!if (iter==1) then
	    call random_seed (size=p)
	    !p=12
	    call random_seed (put = (/(k,k=1,p)/))
       !seed_init=3
       !call random_seed (put = seed_init )
	    if (skriv) then
	        print*, 'Here is p',p
	        print*, 'Here is k',(/(k,k=1,p)/)
	    end if
	!else     
	!    allocate(newseed(p))
	!    newseed=10
	!    call random_seed( put=newseed(1:p)  )
	!    deallocate(newseed)
	!end if 

    !call random_seed()
    !call random_seed(size=seed_size) 
    !print*, "seed size for random seed is:", seed_size
    !allocate(seedonzo(seed_size))
    !call random_seed(get=seedonzo)
    !print*, "system generated random seed is:"
    !print*, seedonzo
    !seedonzo=300000
    !call random_seed(put=seedonzo)
    !print*, "my generated random seed is:"
    !print*, seedonzo
    !call random_number(rhino)
    !print*, "rhino:", rhino 
    !deallocate(seedonzo)
    
    !idumo=-1
    !rhino=ran(idumo) 
    !print*,'here is rhino today', iam,rhino
    !rhino=ran(idumo) 
    !print*,'here is rhino tomorrow', iam,rhino
   
		
	sim=ones 	! initialize to smallest valid value
	r=0
	do nn=1,ndata			! person being simulated !ahu 031911 big change	
		do mm=1,nsimeach	! number of simulations for this person
			r=r+1
			do ia=mna,mxa
				call random_number(rand)
				epsim(ia,r)%q=rand !random(seedo)
                call random_number(rand)
				epsim(ia,r)%x=rand !random(seedo) 
				call random_number(rand)
				epsim(ia,r)%marie=rand !random(seedo) 
				call random_number(rand)
				epsim(ia,r)%meet=rand !random(seedo) 
				call random_number(rand)
				epsim(ia,r)%meetq=rand !random(seedo)
				call random_number(rand)
				epsim(ia,r)%meetx=rand !random(seedo) 
				call random_number(rand)
				epsim(ia,r)%iepsmove=rand !random(seedo) 
				!call minus1(sim(ia,r))		!initialize to smallest valid value
                call random_number(rand)
                epsim(ia,r)%typ=rand !random(seedo)
			end do 
		end do 
	end do 
	!print*, 'epsim',epsim(18,5)%q,epsim(18,5)%x
	!call random_number(rand) 
    !print*, 'rand',rand
	!if (skriv) print*, 'epsim',epsim(18,5)%q,epsim(18,5)%x
	!if (skriv) call random_number(rand) 
    !if (skriv) print*, 'rand',rand
    !if (skriv) print*, 'random(seedo)',random(seedo),random(seedo)
	!if (skriv) print*, 'random(seedo)',random(seedo),random(seedo)

    !if (skriv) print*, 'random(seedo)',random(seedo),random(seedo)
	!if (skriv) print*, 'random(seedo)',random(seedo),random(seedo)
	
    checkgroups=.true.
	r=0								! overall count of total number of simulations
    typsim=-1
	iddat: do nn=1,ndata			! person being simulated !ahu 031911 big change	
		idsim: do mm=1,nsimeach		! number of simulations for this person
			r=r+1
					!sim(mna,r)%initcond=init(nn)   !co, sex, hme, endage   !ahu0115del

			if (skriv.and.r==1347) then ; yaz=.TRUE.  ; else ; yaz=.FALSE. ; end if 

        
		    IF (init(nn)%edr==1) THEN ! low ed, pick type based on ptypehs(co)
			    typsim=multinom(ptypehs(:),epsim(MNA,r)%typ) 
		    ELSE IF (init(nn)%edr==2) THEN  ! high ed type, pick type based on ptypecol(co)  
                typsim=multinom(ptypecol(:),epsim(MNA,r)%typ) 
            ELSE 
                print*, 'something is wrong with type',init(nn)%edr,typsim,ptypehs,ptypecol,epsim(MNA,r)%typ
                stop
		    ENDIF
            if (ntypp==1.and.typsim.ne.1) then
                print*, 'something wrong with ntypp and type',ntypp,typsim
                stop
            end if 
            !typ=1
            	                    
            if (init(nn)%edr.ne.1.and.init(nn)%edr.ne.2) then ; print*, 'There is something wrong with init edr' ; stop ; end if  
			call cotyphome2index(trueindex,init(nn)%co,typsim,init(nn)%hme)
            !index is set to 1 if groups, because each processor has its own value function and so that they don't need to be declared with dimension ninp
            if (groups) then 
                index=1
            else 
                index=trueindex
            end if
			!if (skriv.and.trueindex==1) then ; yaz=.TRUE.  ; else ; yaz=.FALSE. ; end if !ahu 0327 trueindex 2
			!if (skriv) then ; yaz=.TRUE.  ; else ; yaz=.FALSE. ; end if !ahu 040918 del and remove later. the above yaz was the original yaz
            if (typsim<0) then 
                print*, 'typ did not get assigned'
                stop
            end if 
			ind: if ( (.not.groups) .or.  (myindex==trueindex) ) then !(myco==init(nn)%co.and.mytyp==typsim.and. myhome==init(nn)%hme)  ) then	  
                !if (checkgroups) then 
                !    write(*,'("here I am",7I4)') mysay,init(nn)%co,typsim,init(nn)%hme,myco,mytyp,myhome
                !    checkgroups=.false.
                !end if
                !write(*,'("Here I am", 6I4)') index,trueindex,myindex,init(nn)%co,typsim,init(nn)%hme

				if (init(nn)%edr.ne.1.and.init(nn)%edr.ne.2) then ; print*, 'There is something wrong with init edr' ; stop ; end if  
				rel0=0 
				newrel0=.false.
                q0 = wl2q(np1,init(nn)%hme)
				x0 = erkid2x( init(nn)%edr, 1, 1) !ed,exp which is 1 in the beginning and kidr which is 1 in the beginning (for kid, 1 means no kid) 
				g=init(nn)%sexr
				endage=min(init(nn)%endage,mxa)				
                age: do ia=agestart(init(nn)%edr),endage  !mna,endage
        			!if (skriv.and.trueindex==1.and.ia==18) then ; yaz=.TRUE.  ; else ; yaz=.FALSE. ; end if !ahu 0327 trueindex 2 !ahu 040918 del and remove later
                    !if (skriv.and.ia<=20) then ; yaz=.TRUE.  ; else ; yaz=.FALSE. ; end if !ahu 0327 trueindex 2 !ahu 040918 del and remove later
					call qx2hrwge(g,rel0,q0,x0,trueindex,hh,l,wage,logw)
					if (rel0==0) call x2edexpkid(x0,ed(g),expe(g),kid(g))
					if (rel0==1) then
						ed(:)=xx2e(:,x0)
						expe(:)=xx2r(:,x0)
						kid(:)=xx2kid(:,x0)
					end if
                    if (ed(g).ne.init(nn)%edr) then ; print*, 'something wrong with ed and init%ed' ; stop ; end if
					if (q0<=0) print*, "q0 is no good ",r,ia-1,init(nn)%hme,wl2q(np1,init(nn)%hme)                    
					if (yaz) then ; write(400,'(4/,2I8)') r,ia ; write(400,'("State Variables:")') ; call yaz_sim(g,rel0,q0,x0) ; end if 
                    if (yaz) then ; write(400,*) epsim(ia,r)%q,epsim(ia,r)%x,logw(g) ; end if !ahu 012019 del
					!!ag 110416: changed to have sim(ia-1,r) at the beginning of the sim loop rather than sim(ia,r) in order to not have 0 emp at age 18
					sim(ia-1,r)%initcond=init(nn)   !co, sex, hme, endage
                    sim(ia-1,r)%typ=typsim   !co, sex, hme, endage
                    if (sim(ia-1,r)%edr.ne.ed(g)) then ; print*, 'something wrong with ed' ; stop ; end if
					sim(ia-1,r)%expr=expe(g)
					sim(ia-1,r)%kidr=kid(g)                    
					sim(ia-1,r)%hhr = hh(g)
                    sim(ia-1,r)%wr = wage(g)
                    sim(ia-1,r)%logwr = logw(g)
                    sim(ia-1,r)%l = l(g)
					sim(ia-1,r)%rel=rel0
                    if (rel0>0) then                      ! r is male/sp is female or r is female/sp is male
						i = one(g==1) * 2 + one(g==2) * 1 ! r is male/sp is female or r is female/sp is male
						if (newrel0 .or. ia==agestart(init(nn)%edr) ) then	!agestart(simdat(mna,nn)%edr)   ) then		!if (newrelsimsimdat(ia,r) .or.(ia==minage)) then correct this in cohabitation also. cohabitation correction. 
							sim(ia-1,r)%rellen=1
						else
							sim(ia-1,r)%rellen=sim(ia-2,r)%rellen+1
						endif                        
						sim(ia-1,r)%edsp=ed(i)
						sim(ia-1,r)%expsp=expe(i)
						sim(ia-1,r)%kidsp=kid(i)                                            
                        sim(ia-1,r)%hhsp   = hh(i)
                        sim(ia-1,r)%wsp = wage(i)
                        sim(ia-1,r)%logwsp = logw(i)
						sim(ia-1,r)%lsp = l(i)  !just for checking purposes
                        if (l(g).ne.l(i)) then ; print*, 'lg and li not equal' ; stop ; end if 
					else if (rel0==0) then 
						sim(ia-1,r)%rellen=-99		
						sim(ia-1,r)%edsp=-99
						sim(ia-1,r)%expsp=-99
						sim(ia-1,r)%kidsp=-99                                            
                        sim(ia-1,r)%hhsp   = -99	
                        sim(ia-1,r)%wsp = -99.0_dp
						sim(ia-1,r)%logwsp = -99.0_dp
						sim(ia-1,r)%lsp = -99  !just for checking purposes
					endif
					sim(ia-1,r)%nn = nn
					sim(ia-1,r)%mm = mm
					sim(ia-1,r)%r = r
					call getmiss(sim(ia-1,r),nomiss)
					sim(ia-1,r)%nomiss=nomiss
					if (yaz) call yaz_simpath(ia-1,nn,mm,r,sim(ia-1,r))
					!if (ia==47 .and. sim(ia-1,r)%hhr ==1) then 
                    !    print*, 'I found it!',ia-1,sim(ia-1,r)%co,sim(ia-1,r)%sexr,sim(ia-1,r)%rel
                    !    stop
                    !end if 
                        
                    
					if (rel0==0) then
						q = multinom( ppsq(:,q0,x0,g) , epsim(ia,r)%q ) 
						x = multinom( ppsx(:,q0,x0)   , epsim(ia,r)%x ) 
						meet=( epsim(ia,r)%meet<=pmeet )
						z	= multinom( mgt			, epsim(ia,r)%marie)
						iepsmove = multinom( ppso(:)   , epsim(ia,r)%iepsmove ) 
						if (g==1) dec(1) = decm_s(iepsmove,q,x,q0,ia,index) 
						if (g==2) dec(1) = decf_s(iepsmove,q,x,q0,ia,index) 
						dec(2)=x 
						relnext=0 ; qnext=dec(1) ; xnext=dec(2)    ! next period's variabeles are these unless marriage market happens:
						qmatch	= multinom( ppmeetq(:, dec(1) )	, epsim(ia,r)%meetq) 
						xmatch	= multinom( ppmeetx(:, dec(2) )	, epsim(ia,r)%meetx) 
						if (yaz) then 
                        !!!    write(400,'("Trueindex:",I4)') trueindex
						    write(400,'("Draws:",3F10.2)')  epsim(ia,r)%q, epsim(ia,r)%x, epsim(ia,r)%marie
						    write(400,'("Draws:",3I10)')  q,x,z
						    write(400,'("Draws:")') ; call yaz_sim(g,rel0,q,x)
						    write(400,'("Single Dec Before Mar Mkt:")') ; call yaz_sim(g,rel0,qnext,xnext)
						!!!	write(400,'("Match:")') ;  call yaz_simmatch(meet,qmatch,xmatch,z)
                        end if                         
						if (meet) then 	
							if (g==1) then ; q = q2qq(dec(1),qmatch) ; x = x2xx(dec(2),xmatch) ; end if 
							if (g==2) then ; q = q2qq(qmatch,dec(1)) ; x = x2xx(xmatch,dec(2)) ; end if 
							relnext=dec_mar(z,q,x,ia,index)
							if (relnext==1) then 
								qnext=q ; xnext=x
							else if (relnext==0) then
								qnext=dec(1) ; xnext=dec(2)
							end if 
						    if (yaz) then 
                                write(400,'("HERE IS DECMAR:",6I8)') z,q,x,ia,index,dec_mar(z,q,x,ia,index)
							    write(400,'("Decision At Mar Mkt:")') ;  call yaz_simdecmar(relnext)
						    end if      !!!                   
                        end if !meet      
					else if (rel0==1) then 
						whereami=4		! for telling yaz where we are: Couples/Sim
						q	= multinom( ppcq(:,q0,x0)	, epsim(ia,r)%q) 
						x	= multinom( ppcx(:,q0,x0)	, epsim(ia,r)%x) 	
						z	= multinom( mgt		, epsim(ia,r)%marie)
						iepsmove = multinom( ppso(:)   , epsim(ia,r)%iepsmove ) 
                        if (yaz) then ; write(400,*) epsim(ia,r)%q,epsim(ia,r)%x,epsim(ia,r)%marie,q,x,z ; end if !ahu 012019 del
						!!!if (yaz) then 
                        !!!    write(400,'("Trueindex:",I4)') trueindex
                        !!!    write(400,'("Draws:")') ; call yaz_sim(g,rel0,q,x)
						!!!	write(400,'("z: ",I4)') z
						!!!end if                         
						dd=(/ ia,trueindex,q,x,z,q0,g,-1,-1,-1,iepsmove /)			    ! (/ ia,index,q,x,z,q0,g,jmax,qmax,relmax /)  							                        
                        call getdec_c(dd,vmax)					            ! jmax=dd(8) ; qmax=dd(9) ; relmax=dd(10)                        
                        relnext=dd(10)
						!!!!if (yaz) then ; call yaz_decision(dd,vmax) ; end if	    ! write down decision     
						if (relnext==1) then 
							qnext=dd(9) ; xnext=dd(4) 
						else if (relnext==0) then 
							i = qq2q(g,q) ; n=xx2x(g,x) ; i0 = qq2q(g,q0)	! translate couple q and x and q0 into singles
							if (g==1) dec(1) = decm0_s(iepsmove,i,n,i0,ia,index) 
							if (g==2) dec(1) = decf0_s(iepsmove,i,n,i0,ia,index) 
							dec(2)=n
							qnext=dec(1) ; xnext=dec(2)                   
						end if
					end if ! rel
					!!!if (yaz) then 
					!!!	write(400,'("Next: ")') ; call yaz_sim(g,relnext,qnext,xnext) 
					!!!end if 
					newrel0 = (rel0==0.and.relnext==1) 
					rel0 = relnext 
					q0 = qnext
					x0 = xnext
					relnext=-99 ; qnext=-99 ; xnext=-99 ; q=-99 ; x=-99 ; z=-99 ; qmatch=-99 ; xmatch=-99 ; dec=-99 ; meet=.FALSE.
					if (init(nn)%edr==2.and.ia<agestart(init(nn)%edr)) sim(ia,r)=ones
				end do	age
			end if ind
		end do idsim
	end do iddat
	deallocate(epsim)		
	end subroutine simulate

	subroutine qx2hrwge(g,rel,q,x,trueindex,hh,l,wage,logw)
	integer(i4b), intent(in) :: g,rel,q,x,trueindex
	integer(i4b), dimension(2) :: ed,expe
	integer(i4b), intent(out) :: hh(2),l(2)
	real(dp), intent(out) :: wage(2),logw(2) 	
	integer(i4b) :: i,w(2)
	hh=-99
    wage=-99.0_dp
	logw=-99.0_dp
	l=-99
    if (rel == 0) then			
		w(g)=q2w(q) 
		l(g)=q2l(q) 
		ed(g)=x2e(x) 
		expe(g)=x2r(x) 
		if ( w(g)<=np ) then 
			hh(g)=1
            wage(g) = ws(g,q,x,trueindex)   !fnwge( g,typ,l(g) ,wg(w(g),g) ,ed(g) ,expe(g))
			logw(g) = log( wage(g) )        !log ( fnwge( g,typ,l(g) ,wg(w(g),g) ,ed(g) ,expe(g))  )			
		else
			hh(g)=0
			wage(g) = -99.0_dp
            logw(g) = -99.0_dp
		endif
		if ( w(g)<=0.or.w(g)>np1 )  then ; print*, "error in read_dat: w<=0 or w>np1 !!" ; stop ; end if 
	else if (rel > 0) then 		
		w(:)=qq2w(:,q)
		l(:)=qq2l(:,q)
		ed(:)=xx2e(:,x)
		expe(:)=xx2r(:,x)
		do i=1,2
			if ( w(i)<=np ) then 
				hh(i)=1
				wage(i) = wc(i,q,x,trueindex)   !fnwge(i,typ,l(i) ,wg(w(i),i) ,ed(i) ,expe(i)) 		
                logw(i) = log( wage(i) )        !log ( fnwge(i,typ,l(i) ,wg(w(i),i) ,ed(i) ,expe(i)) )			
			else
				hh(i)=0
                wage(i) = -99.0_dp
				logw(i) = -99.0_dp
			endif
			if ( w(i)<=0.or.w(i)>np1 )  then ; print*, "error in read_dat: w<=0 or w>np1 !!" ; stop ; end if 
		end do 
	end if 
	end subroutine qx2hrwge
				
	subroutine getmiss(dat,nomiss)
	type(statevar), intent(in) :: dat ! data set. first entry is ia index, second observation number
	integer(i4b),intent(out) :: nomiss 
	nomiss=1
	if (dat%co<0) nomiss=0
	if (dat%sexr<0) nomiss=0
	if (dat%hme<0) nomiss=0		
	if (dat%endage<0) nomiss=0		
	if (dat%edr<0) nomiss=0
	!if (dat%expr<0) nomiss=0   !expr is alwyays missing in the data since there is no experience variable
	if (dat%rel==1.and.dat%kidr<0) nomiss=0
	if (dat%l<0) nomiss=0
	if (dat%hhr<0) nomiss=0
	if (dat%logwr<0.0_dp) nomiss=0
	if (dat%rel<0.0_dp) nomiss=0
	if (dat%rel==1.and.dat%rellen<0) nomiss=0
	if (dat%rel==1.and.dat%hhsp<0) nomiss=0    
	if (dat%rel==1.and.dat%logwsp<0.0_dp) nomiss=0
	!if (dat%edsp<0) nomiss=0   !edsp is always missing in the data because for now it is not read from the data
	!if (dat%expsp<0) nomiss=0  !expsp is alwyays missing in the data since there is no experience variable
	if (dat%kidsp<0) nomiss=0   !kidsp is always missing in the data since kidsp is just a simulation construct
	
	end subroutine getmiss 

	subroutine get_dathrwge(hr,inc_perhour,dhr,dw,dlogw)
	integer(i4b), intent(in) :: hr
	real(dp), intent(in) :: inc_perhour
	integer(i4b), intent(out) :: dhr
	real(dp), intent(out) :: dw,dlogw	
	!if (hr>0.and.wge>0) then 
        !note that the employment is decided according to whether hours is more than h_fulltime which is 1000 but annual wages is calculated using wge*h_wmult where h_wmult is 2000. 
        !This is how you did it in the original version. I do the same thing so that the wage numbers are consistent with the previous version. See page 15 last paragraph in the original text.
	!	dhr=one(hr>=h_fulltime)
	!	dwge=wge*h_wmult !ahu 021817: 1) got rid of the minmax thing 2) changed h_fulltime to h_wmult in the way annual wages is calculated      !min(max(minw,wge),maxw)*h_fulltime
	!	dwge=log(dwge)
	!	dwge=one(hr>=h_fulltime)*dwge
	!else if (hr==0.and.wge==0) then 
	!	dhr=hr 
	!	dwge=wge
	!else if (hr==-1.and.wge==-1) then 
	!	dhr=hr 
	!	dwge=wge
	!else 
	!	print*, "error in get_dathrwge ", hr,wge
	!	print*, "by construction, it should be that it's both 0, both -1 or both positive "
	!	stop
	!end if	
    
	if (hr>=0) then 
        !note that the employment is decided according to whether hours is more than h_fulltime which is 1000 but annual wages is calculated using wge*h_wmult where h_wmult is 2000. 
        !This is how you did it in the original version. I do the same thing so that the wage numbers are consistent with the previous version. See page 15 last paragraph in the original text.
		dhr=one(hr>=h_fulltime)
		if (inc_perhour>=minw.and.inc_perhour<=maxw) then
            dw=inc_perhour*h_wmult    
            dlogw=log(inc_perhour*h_wmult) !ahu 021817: 1) got rid of the minmax thing 2) changed h_fulltime to h_wmult in the way annual wages is calculated      !min(max(minw,wge),maxw)*h_fulltime            
        else 
            dw=-99.0_dp
            dlogw=-99.0_dp
        end if
    else if (hr<0) then 
        dhr=-99
        dw=-99.0_dp
        dlogw=-99.0_dp
	else 
		print*, "error in get_dathrwge ", hr,inc_perhour
		print*, "by construction, it should be that it's both 0, both -1 or both positive "
		stop
	end if	
    
    end subroutine get_dathrwge	
	
	subroutine get_mom(dat,ndat,mom,cnt,var,name,headstr,headloc,weights)
	integer(i4b), intent(in) :: ndat ! number of observations in dat array    
	type(statevar), dimension(MNAD:MXA,ndat), intent(in) :: dat ! data set. first entry is ia index, second observation number
	real(dp), dimension(nmom), intent(out) :: mom	 ! conditional mom
	integer(i4b), dimension(nmom), intent(out) :: cnt	 ! number of observations contributing to each moment
	real(dp), dimension(nmom), intent(out) :: var		 ! unconditional variance of each conditional moemnt
	character(len=namelen), dimension(nmom), intent(out) :: name ! names of mom
	character(len=120),dimension(nmom), intent(out) :: headstr ! headers for different sections of mom
	integer(i4b), dimension(nmom), intent(out) :: headloc	 ! location of headers for different sections of mom
	real(dp), dimension(nmom), intent(out) :: weights		 ! some real assoicated to each moment, maybe used as weights
	integer(i4b) :: ia,co,im,ihead,g,i,j,jj,ii,ddd
    integer(i4b) :: minsex,maxsex,maxrelo
	logical,dimension(MNAD:MXA,ndat) :: coho,cosex,cosexrel,corel
	integer(i4b), dimension(MNAD:MXA,ndat) :: norelchg,move,emph,empw,edh,edw,dur,dee,deue
	real(dp), dimension(MNAD:MXA,ndat) :: logwh,logww
    integer(i4b), dimension(ndat) :: nummove,cohogen,sexgen    !nummove_ma,nummove_si !integer(i4b), dimension(MNAD:MXA,ndat) :: nummov,nummove_mar,nummove_sin
    real(dp) :: wmovebyrel,decilegrid(ndecile)
    
    !initiate
	mom=-99.0_dp
	cnt=9999
	var=-99.0_dp
	headloc=-99 
	weights=0.0_dp 
    maxsex=-1
    maxrelo=-1
    coho=.FALSE.
    cosex=.FALSE.    
    cosexrel=.FALSE.
    corel=.FALSE.
    norelchg=-99
    move=-99
    emph=-99 
    empw=-99 
    edh=-99 
    edw=-99 
    dur=-99
    dee=-99
    deue=-99
    logwh=-99.0_dp
    logww=-99.0_dp
    nummove=-99 
    cohogen=-99 
    sexgen=-99 
    wmovebyrel=-99.0_dp
    calcvar=0   !declared globally
    calcorr=0   !declared globally
    mominfo=-1  !declared globally
	im=1
	ihead=1
    !decilegrid=0.0_dp
    !dur=0

    headloc(ihead)=im
	if (skriv) call yaz_getmom(dat,ndat) 
	
    do ddd=1,ndecile
        decilegrid(ddd)=8.6_dp+0.25_dp*(ddd-1)
	end do
    !print*, decilegrid
    
	WHERE ((dat(MNAD:MXAD,:)%rel>=0) .AND. dat(MNA:MXA,:)%rel>=0  )
		norelchg(MNAD:MXAD,:)=one(  dat(MNAD:MXAD,:)%rel==dat(MNA:MXA,:)%rel   ) 
	ENDWHERE
	WHERE ((dat(MNAD:MXAD,:)%l>0) .AND. (dat(MNA:MXA,:)%l>0))
		move(MNAD:MXAD,:)=one(dat(MNAD:MXAD,:)%l/=dat(MNA:MXA,:)%l)
	ENDWHERE
	WHERE ((dat(MNAD:MXA,:)%rel==1) .AND.  (dat(MNAD:MXA,:)%sexr==1)  )
		emph(MNAD:MXA,:)=dat(MNAD:MXA,:)%hhr 
		empw(MNAD:MXA,:)=dat(MNAD:MXA,:)%hhsp
		edh(MNAD:MXA,:)=dat(MNAD:MXA,:)%edr 
		edw(MNAD:MXA,:)=dat(MNAD:MXA,:)%edsp
		logwh(MNAD:MXA,:)=dat(MNAD:MXA,:)%logwr 
		logww(MNAD:MXA,:)=dat(MNAD:MXA,:)%logwsp
    ENDWHERE
	WHERE ((dat(MNAD:MXA,:)%rel==1) .AND.  (dat(MNAD:MXA,:)%sexr==2)  )
		emph(MNAD:MXA,:)=dat(MNAD:MXA,:)%hhsp
		empw(MNAD:MXA,:)=dat(MNAD:MXA,:)%hhr
		edh(MNAD:MXA,:)=dat(MNAD:MXA,:)%edsp 
		edw(MNAD:MXA,:)=dat(MNAD:MXA,:)%edr
		logwh(MNAD:MXA,:)=dat(MNAD:MXA,:)%logwsp 
		logww(MNAD:MXA,:)=dat(MNAD:MXA,:)%logwr
    ENDWHERE


    !dee for wdif conditionoing on ee transitions 
    WHERE (dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%hhr==1 .AND. dat(MNA:MXAD,:)%logwr>=0 .AND. dat(MNA+1:MXA,:)%logwr>=0  ) 
        dee(MNA:MXAD,:)=1
    ENDWHERE
    
    !deue for wdif conditioning on eue transitions
    WHERE ( dat(MNA:MXAD-1,:)%hhr==1 .AND. dat(MNA+1:MXAD,:)%hhr==0  .AND. dat(MNA+2:MXA,:)%hhr==1 .AND. dat(MNA:MXAD-1,:)%logwr>=0   .AND. dat(MNA+2:MXA,:)%logwr>=0  ) 
        deue(MNA:MXAD-1,:)=1
    ENDWHERE
 
	WHERE ((dat(MNAD:MXA,:)%hhr==0)   )
		dur(MNAD:MXA,:)=1
    ENDWHERE



    !ddd=1
    !do i=5,10
    !    print*, 'Here it is ', d1*one( (dat(25,i)%logwr>decilegrid(ddd) .and. dat(25,i)%logwr<decilegrid(ddd+1) ) )
    !end do     
    
    do i=1,ndat
        do ia=MNAD,MXAD
	        if (        (dat(ia,i)%hhr==0)    .AND. (dat(ia+1,i)%hhr==0)   ) then
		        dur(ia+1,i)=dur(ia,i)+1
            end if 
        end do 
    end do 
    
    do i=1,ndat
        !Just generating cohort and sex of someone because don't have initcond in this routine
        cohogen(i)=   maxval(dat(MNAD:MXA,i)%co)
        sexgen(i)=   maxval(dat(MNAD:MXA,i)%sexr)	                
    
        !Total number of moves overall
        !nummove(i)=sum(move(MNA:MXAI,i),  MASK=( move(MNA:MXAI,i)>0  .and. norelchg(MNA:MXAI,i)==1  )   )
        nummove(i)=sum(move(MNA:MXAD,i),  MASK=( move(MNA:MXAD,i)>=0  .and. norelchg(MNA:MXAD,i)==1  )   )

        !do ia=MNA,MXAI
        !    nummov(ia,i)=sum(move(MNA:ia,i),  MASK=( move(MNA:ia,i)>0  )   )
        !end do        
        !nummove_mar: Total number of moves that occurred when married, up to ia
        !nummove_sin: Total number of moves that occurred when single, up to ia
        !nummove_ma(i)=sum(move(MNA:MXAI,i),  MASK=( move(MNA:MXAI,i)>0.and.dat(MNA:MXAI,i)%rel==1)  )
        !nummove_si(i)=sum(move(MNA:MXAI,i),  MASK=( move(MNA:MXAI,i)>0.and.dat(MNA:MXAI,i)%rel==0)  )
        !**************************************
        !ahu jan19 010119: commenting out the below and not doing the nummove by rel moments 
        !this is because for example in data nummove-0 is 0.84 while both nummove_mar and _sin are 0.92 something. 
        !I think the norelchg requirement is the reason. With that requirement it is not clear what these moments mean and 
        !they might be hindering the matching of the move by age moments. For example, there are times when nummove=0 is understated by a whole lot in sim
        !whereas movey age is overstated 
        !do ia=MNA,MXAI
        !    nummove_mar(ia,i)=sum(move(MNA:ia,i),  MASK=( move(MNA:ia,i)>0.and.dat(MNA:ia,i)%rel==1 .and. norelchg(MNA:ia,i)==1 )  )
        !    nummove_sin(ia,i)=sum(move(MNA:ia,i),  MASK=( move(MNA:ia,i)>0.and.dat(MNA:ia,i)%rel==0 .and. norelchg(MNA:ia,i)==1 )  )
        !end do
        !if (iter==1) then
        !    if ( nummove_mar(MXAI,i) /= nummove_mar(MXAI-1,i) .OR. minval(nummove_mar(:,i))<0 ) then
        !        print*, 'something wrong with nummove_mar'
        !        stop
        !    end if 
        !    if ( nummove_sin(MXAI,i) /= nummove_sin(MXAI-1,i) .OR. minval(nummove_sin(:,i))<0 ) then
        !        print*, 'something wrong with nummove_sin'
        !        stop
        !    end if 
        !end if 
        !**************************************

    end do 


    ddd=1
	if (skriv.and.ndat==nsim .and. iter==1) then
	open(unit=94632, file='dursim1.txt',status='replace')
    do j=1,ndat
        do ia=mnad,mxa
            if (dat(ia,j)%hme==1) then 
                write(94632,'(6i6,F10.2,3I6)' ) j,dat(ia,j)%nn,dat(ia,j)%mm,ia,dat(ia,j)%L,dat(ia,j)%hhr,dat(ia,j)%logwr,dat(ia,j)%EXPR,dat(ia,j)%HME,dat(ia,j)%sexr   !, d1*one( (dat(ia,j)%logwr>decilegrid(ddd) .and. dat(ia,j)%logwr<decilegrid(ddd+1) ) ), decilegrid(ddd),decilegrid(ddd+1)   !,dat(ia,j)%nn,dat(ia,j)%mm,dat(ia,j)%r
	        end if 
        end do 
	end do
    close(94632)
    end if 

    ddd=1
	if (skriv.and.ndat==nsim .and. iter==2) then
	open(unit=94632, file='dursim2.txt',status='replace')
    do j=1,ndat
        do ia=mnad,mxa
            if (dat(ia,j)%hme==1) then 
                write(94632,'(6i6,F10.2,3I6)' ) j,dat(ia,j)%nn,dat(ia,j)%mm,ia,dat(ia,j)%L,dat(ia,j)%hhr,dat(ia,j)%logwr,dat(ia,j)%EXPR,dat(ia,j)%HME,dat(ia,j)%sexr   !, d1*one( (dat(ia,j)%logwr>decilegrid(ddd) .and. dat(ia,j)%logwr<decilegrid(ddd+1) ) ), decilegrid(ddd),decilegrid(ddd+1)   !,dat(ia,j)%nn,dat(ia,j)%mm,dat(ia,j)%r
	        end if 
        end do 
	end do
    close(94632)
    end if 

!		if (dat(ia,j)%expr>-99.and.dat(ia,j)%expr<0) then 
	!			print*, 'dat exp is negative',ia,j,dat(ia,j)%expr,dat(ia,j)%hme,dat(ia,j)%nn,dat(ia,j)%mm,dat(ia,j)%r
	!			stop
	!		end if
    
	!if ( iter==1) then
	!do ia=mna,mxa
	!	do j=1,ndat
            !The below check does give you an error. Despite the fact that everyone starts from age 18 and there is no missing cohort variable in the data (all is 1920-49).
            !Why?
            !This is because, for those people who are ED, the agestart is 22. So in read_actualdata, after reading these people's initcond's from their age 18 (and for all of them I have all those initconds), 
            !I set all the variables from 18 to 21 to -99, including cohort (after reading cohort info into init). Hence for such people, you
            !will have a cohort variable value of -99 at age 18-21. But starting from 22, you will have the cohort value. 
            !For some, there are some ages for which there is no observation in the PSID. For example, for idnum who is ED, the person is observed from age 18-20
            !but then there is nothing until 24. So for this person, the cohort values (as well as other variable values) would be all filled in with -99 until 24. 
            !SO instead of conditioning the nummove moments on dat(mna,:)%co=co, I condition them on coho(mna,:).			
            !(I generate coho with		coho(mna:mxai,:)= (  maxval(dat(mna:mxai,:)%co)==co  )			
            !This solves the problem. 
            !if (dat(ia,j)%co<1.or.dat(ia,j)%co>nco ) then
                !print*, 'something wrong with dat%co A',ia,j,dat(ia,j)%co,ndat
                !stop
            !end if
            !if ( maxval(dat(:,j)%co) /= dat(ia,j)%co  ) then
                !print*, 'something wrong with dat%co B',ia,j,dat(ia,j)%co,ndat
                !stop
            !end if
    !    end do 
	!end do
	!end if 
    
    !if (onlysingles) then ! if doing only singles, condition all mom on singles 
	!	nomiss(mna:mxai-1,:) = (  nomiss(mna:mxai-1,:) .and. dat(mna:mxai-1,:)%rel==0 .and. dat(mna+1:mxai,:)%rel==0 ) 
	!end if 

    
	cohort: do co=1,nco
			coho(MNAD:MXA,:)= (  dat(MNAD:MXA,:)%co==co  )		
            corel(MNAD:MXAD,:)= (dat(MNAD:MXAD,:)%co==co  .and. dat(MNAD:MXAD,:)%rel==1 .and. norelchg(MNAD:MXAD,:)==1 )
			!cohogen(:)=  maxval(dat(mna:mxai,:)%co)  		
            
			    headloc(ihead)=im
			    headstr(ihead)='EVERYONE'
			    ihead=ihead+1
    
                !ahu summer18 041118: the below getmar by gender and ia was added just to figure out the eps2 problem (why marriage rates were so sensitive to eps2 and 
                !why they were so different by gender). I figured it out now (i.e. the gender disparity in marriage rates go away when I set fem's psio equal to male's
                !but when I was looking at these getmar rates I also noticed the following: 
                !if I am recording age17 rel as 0 and when they make their decision at age 18 I record the rel for age18 as potentiall ymarried
                !but that is not consistent with data is it?
                !ahu jan19 010219: so I am still writing the age 17 (mad) mar rate. age 17 mar rate does not exit in the data since we don't record age 17 rel there. 
                !so the weight on this moment is 0 but then it's wrel for age=mna and age=19
                !do ia=mnad,mnad
		        !    call condmom(im,( dat(ia,:)%rel==0 .AND. dat(ia+1,:)%rel>=0   .AND. dat(ia,:)%sexr==1 ), d1*one(dat(ia+1,:)%rel==1),mom,cnt,var)
		        !    write(name(im),'("getmarbyia,m  ",tr1,i4)') ia
                !    weights(im)=0.0_dp
                !    im=im+1
		        !    call condmom(im,( dat(ia,:)%rel==0 .AND. dat(ia+1,:)%rel>=0   .AND. dat(ia,:)%sexr==2 ), d1*one(dat(ia+1,:)%rel==1),mom,cnt,var)
		        !    write(name(im),'("getmarbyia,f  ",tr1,i4)') ia
                !    weights(im)=0.0_dp
                !    im=im+1
                !end do            

                !do ia=MNA,19 
		        !    call condmom(im,( dat(ia,:)%rel==0 .AND. dat(ia+1,:)%rel>=0   .AND. dat(ia,:)%sexr==1 ), d1*one(dat(ia+1,:)%rel==1),mom,cnt,var)
		        !    write(name(im),'("getmarbyia,m  ",tr1,i4)') ia
                !    weights(im)=wrel
                !    im=im+1
		        !    call condmom(im,( dat(ia,:)%rel==0 .AND. dat(ia+1,:)%rel>=0   .AND. dat(ia,:)%sexr==2 ), d1*one(dat(ia+1,:)%rel==1),mom,cnt,var)
		        !    write(name(im),'("getmarbyia,f  ",tr1,i4)') ia
                !    weights(im)=wrel
                !    im=im+1
                !end do            

            
                call condmom(im,( coho(MNA:MXA,:) .AND. dat(MNA:MXA,:)%rel>=0 ), d1*one(dat(MNA:MXA,:)%rel==1),mom,cnt,var)
			    write(name(im),'("mar ",tr10)')	
                weights(im)=wrel ; if (onlysingles) weights(im)=0.0_dp   !forget about that if statement usually. just putting there to get im to go up by 1 for the next loop
                im=im+1

                !call condmom(im,( coho(MNA:MXA,:) .AND. dat(MNA:MXA,:)%rel>=0  .AND. dat(MNA:MXA,:)%edr==1 ), d1*one(dat(MNA:MXA,:)%rel==1),mom,cnt,var)
			    !write(name(im),'("mar ned",tr7)')	
                !weights(im)=0.0_dp
                !im=im+1

                !call condmom(im,( coho(MNA:MXA,:) .AND. dat(MNA:MXA,:)%rel>=0  .AND. dat(MNA:MXA,:)%edr==2 ), d1*one(dat(MNA:MXA,:)%rel==1),mom,cnt,var)
			    !write(name(im),'("mar  ed",tr7)')	
                !weights(im)=0.0_dp
                !im=im+1
            
            
                !call condmom(im,( coho(MNA:MXA,:) .AND. dat(MNA:MXA,:)%rel>=0 ), d1*one(dat(MNA:MXA,:)%rel==0),mom,cnt,var)  
                !write(name(im),'("sin ",tr10)')              
                !weights(im)=wrel
                !im=im+1
            
                !Note about conditioning on age:
                !The max endage in data is 47. 
                !The way sim is done, for those whose endage is 47, the last age where variables get recorded is ia-1=46. 
                !This is because dat(ia-1,.) is recorded for each ia. So for the last age 47, the variables for 46 gets written
                !But then there is nothing after age 46, despite the fact that we do have people whose endage is 46 (namely 47). 


			    !call condmom(im,( coho(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%rel==1  .AND. dat(MNA+1:MXA,:)%rel>=0 .AND. move(MNA:MXAD,:)==0 ), d1*one(dat(MNA+1:MXA,:)%rel==0),mom,cnt,var)
			    !write(name(im),'("getdiv | nomv",tr1,i4)') 
                !weights(im)=wrel
                !im=im+1

			    !call condmom(im,( coho(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%rel==1  .AND. dat(MNA+1:MXA,:)%rel>=0 .AND. move(MNA:MXAD,:)==1 ), d1*one(dat(MNA+1:MXA,:)%rel==0),mom,cnt,var)
			    !write(name(im),'("getdiv |   mv",tr1,i4)') 
                !weights(im)=wrel
                !im=im+1
                                
                
                !do ii=1,2
                !    do jj=1,2
                !    
                !        call condmom(im,(  corel(MNA:MXAD,:) .AND. edh(MNA:MXAD,:)==ii  .AND. edw(MNA:MXAD,:)==jj  .AND. emph(MNA:MXAD,:)==1  .AND. empw(MNA:MXAD,:)==1  .AND. logwh(MNA:MXAD,:)>=0 .AND. logww(MNA:MXAD,:)>=0 ),   d1*logwh(MNA:MXAD,:)  ,mom,cnt,var)	
    		    !        write(name(im),'("corr1 ",tr4,2i4)')  ii,jj
                !        weights(im)=0.0_dp
                !        calcorr(im)=1
                !        im=im+1
                !        call condmom(im,(  corel(MNA:MXAD,:) .AND. edh(MNA:MXAD,:)==ii  .AND. edw(MNA:MXAD,:)==jj  .AND. emph(MNA:MXAD,:)==1  .AND. empw(MNA:MXAD,:)==1  .AND. logwh(MNA:MXAD,:)>=0 .AND. logww(MNA:MXAD,:)>=0 ),   d1*logww(MNA:MXAD,:)  ,mom,cnt,var)	
    		    !        write(name(im),'("corr2 ",tr4,2i4)')  ii,jj
                !        weights(im)=0.0_dp
                !        calcorr(im)=5
                !        im=im+1
                !        call condmom(im,(  corel(MNA:MXAD,:) .AND. edh(MNA:MXAD,:)==ii  .AND. edw(MNA:MXAD,:)==jj  .AND. emph(MNA:MXAD,:)==1  .AND. empw(MNA:MXAD,:)==1  .AND. logwh(MNA:MXAD,:)>=0 .AND. logww(MNA:MXAD,:)>=0 ),   d1*logwh(MNA:MXAD,:)*logww(MNA:MXAD,:)  ,mom,cnt,var)	
    		    !        write(name(im),'("corr3 ",tr4,2i4)')  ii,jj
                !        weights(im)=wwage
                !        calcorr(im)=5
                !        im=im+1
                !        call condmom(im,(  corel(MNA:MXAD,:) .AND. edh(MNA:MXAD,:)==ii  .AND. edw(MNA:MXAD,:)==jj  .AND. emph(MNA:MXAD,:)==1  .AND. empw(MNA:MXAD,:)==1  .AND. logwh(MNA:MXAD,:)>=0 .AND. logww(MNA:MXAD,:)>=0 ),   d1*(logwh(MNA:MXAD,:)-mom(im-3))*(logww(MNA:MXAD,:)-mom(im-2))  ,mom,cnt,var)	
    		    !        write(name(im),'("wrngcorr ",tr4,2i4)')  ii,jj
                !        weights(im)=0.0_dp
                !        im=im+1

                 !   end do 
                !end do 
                
		        !headloc(ihead)=im
			    !headstr(ihead)='MARRIED MOVE'
			    !ihead=ihead+1
                
			    !call condmom(im,( corel(MNA:MXAD,:) .AND. emph(MNA:MXAD,:)==1  .AND. empw(MNA:MXAD,:)==1 .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    		    !write(name(im),'("move | ee ",tr5)')  
                !weights(im)=wmovemar   !ahu 122818 changed from wmove to wmovemar2 
                !im=im+1
			    !!call condmom(im,( corel(mna:mxai-1,:) .AND. dat(MNA:MXAI-1,:)%hhr==1 .AND. dat(MNA:MXAI-1,:)%hhsp==1  .AND. dat(MNA:MXAI-1,:)%sexr==1 .AND. move(mna:mxai-1,:)>=0 ),   d1* move(mna:mxai-1,:) ,mom,cnt,var)	

			    !call condmom(im,( corel(MNA:MXAD,:) .AND. emph(MNA:MXAD,:)==1 .AND. empw(MNA:MXAD,:)==0 .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    		    !write(name(im),'("move | eu ",tr5)')  
                ! weights(im)=wmovemar   !ahu 122818 changed from wmove to wmovemar2
                !im=im+1
			    !!call condmom(im,( corel(mna:mxai-1,:) .AND. dat(MNA:MXAI-1,:)%hhr==1 .AND. dat(MNA:MXAI-1,:)%hhsp==0  .AND. dat(MNA:MXAI-1,:)%sexr==1 .AND. move(mna:mxai-1,:)>=0 ),   d1* move(mna:mxai-1,:) ,mom,cnt,var)	

			    !call condmom(im,( corel(MNA:MXAD,:) .AND. emph(MNA:MXAD,:)==0 .AND. empw(MNA:MXAD,:)==1 .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    		    !write(name(im),'("move | ue ",tr5)')  
                ! weights(im)=wmovemar   !ahu 122818 changed from wmove to wmovemar2
                !im=im+1
			    !!call condmom(im,( corel(mna:mxai-1,:) .AND. dat(MNA:MXAI-1,:)%hhr==0 .AND. dat(MNA:MXAI-1,:)%hhsp==1  .AND. dat(MNA:MXAI-1,:)%sexr==1 .AND. move(mna:mxai-1,:)>=0 ),   d1* move(mna:mxai-1,:) ,mom,cnt,var)	
            
			    !call condmom(im,( corel(MNA:MXAD,:) .AND. emph(MNA:MXAD,:)==0 .AND. empw(MNA:MXAD,:)==0 .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    		    !write(name(im),'("move | uu ",tr5)')  
                ! weights(im)=wmovemar   !ahu 122818 changed from wmove to wmovemar2
                !im=im+1
			    !!call condmom(im,( corel(mna:mxai-1,:) .AND. dat(MNA:MXAI-1,:)%hhr==0 .AND. dat(MNA:MXAI-1,:)%hhsp==0  .AND. dat(MNA:MXAI-1,:)%sexr==1 .AND. move(mna:mxai-1,:)>=0 ),   d1* move(mna:mxai-1,:) ,mom,cnt,var)	
            

			    !call condmom(im,(  corel(MNA:MXAD,:) .AND. edh(MNA:MXAD,:)==2  .AND. edw(MNA:MXAD,:)==2 .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    		    !write(name(im),'("move|eded ",tr4)')  
                ! weights(im)=wmovemar   !ahu 122818 changed from wmove to wmovemar2
                !im=im+1
			    !!call condmom(im,( corel(mna:mxai-1,:) .AND. dat(MNA:MXAI-1,:)%edr==2 .AND. dat(MNA:MXAI-1,:)%edsp==2  .AND. dat(MNA:MXAI-1,:)%sexr==1 .AND. move(mna:mxai-1,:)>=0 ),   d1* move(mna:mxai-1,:) ,mom,cnt,var)	

			    !call condmom(im,(  corel(MNA:MXAD,:) .AND. edh(MNA:MXAD,:)==2  .AND. edw(MNA:MXAD,:)==1 .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    		    !write(name(im),'("move|ednoed ",tr2)')  
                ! weights(im)=wmovemar  !ahu 122818 changed from wmove to wmovemar2
                !im=im+1
			    !!call condmom(im,( corel(mna:mxai-1,:) .AND. dat(MNA:MXAI-1,:)%edr==2 .AND. dat(MNA:MXAI-1,:)%edsp==1  .AND. dat(MNA:MXAI-1,:)%sexr==1 .AND. move(mna:mxai-1,:)>=0 ),   d1* move(mna:mxai-1,:) ,mom,cnt,var)	
            
			    !call condmom(im,(  corel(MNA:MXAD,:) .AND. edh(MNA:MXAD,:)==1  .AND. edw(MNA:MXAD,:)==2 .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    		    !write(name(im),'("move|noeded ",tr2)')  
                ! weights(im)=wmovemar   !ahu 122818 changed from wmove to wmovemar2
                !im=im+1
			    !!call condmom(im,( corel(mna:mxai-1,:) .AND. dat(MNA:MXAI-1,:)%edr==1 .AND. dat(MNA:MXAI-1,:)%edsp==2  .AND. dat(MNA:MXAI-1,:)%sexr==1 .AND. move(mna:mxai-1,:)>=0 ),   d1* move(mna:mxai-1,:) ,mom,cnt,var)	          
			
			    !call condmom(im,(  corel(MNA:MXAD,:) .AND. edh(MNA:MXAD,:)==1  .AND. edw(MNA:MXAD,:)==1 .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    		    !write(name(im),'("move|noednoed ")')  
                ! weights(im)=wmovemar   !ahu 122818 changed from wmove to wmovemar2
                !im=im+1
			    !!call condmom(im,( corel(mna:mxai-1,:) .AND. dat(MNA:MXAI-1,:)%edr==1 .AND. dat(MNA:MXAI-1,:)%edsp==1  .AND. dat(MNA:MXAI-1,:)%sexr==1 .AND. move(mna:mxai-1,:)>=0 ),   d1* move(mna:mxai-1,:) ,mom,cnt,var)	            
        
            
            
        !************************
        !ahu jan19 010119: commenting out the below and not doing the nummove by rel moments 
        !this is because for example in data nummove-0 is 0.84 while both nummove_mar and _sin are 0.92 something. 
        !I think the norelchg requirement is the reason. With that requirement it is not clear what these moments mean and 
        !they might be hindering the matching of the move by age moments. For example, there are times when nummove=0 is understated by a whole lot in sim
        !whereas movey age is overstated 

            !call condmom(im,(  cohogen(:)==co ) ,   d1* one( nummove_mar(MXAI,:)==0 ) ,mom,cnt,var)	
    		!write(name(im),'("nummove_mar=0 ",tr1)')  
            !weights(im)=wmove
            !im=im+1

            !call condmom(im,(  cohogen(:)==co ),   d1* one( nummove_mar(MXAI,:)==1 ) ,mom,cnt,var)	
    		!write(name(im),'("nummove_mar=1 ",tr1)')  
            !weights(im)=wmove
            !im=im+1
            
            !call condmom(im,(  cohogen(:)==co ),   d1* one( nummove_mar(MXAI,:)==2 ) ,mom,cnt,var)	
    		!write(name(im),'("nummove_mar=2 ",tr1)')  
            !weights(im)=wmove
            !im=im+1
            
            !call condmom(im,(  cohogen(:)==co ),   d1* one( nummove_mar(MXAI,:)>=3 ) ,mom,cnt,var)	
    		!write(name(im),'("nummove_mar>=3 ")')  
            !weights(im)=wmove
            !im=im+1

            !call condmom(im,(  cohogen(:)==co ) ,   d1* one( nummove_sin(MXAI,:)==0 ) ,mom,cnt,var)	
    		!write(name(im),'("nummove_sin=0 ",tr1)')  
            !weights(im)=wmove
            !im=im+1

            !call condmom(im,(  cohogen(:)==co ),   d1* one( nummove_sin(MXAI,:)==1 ) ,mom,cnt,var)	
    		!write(name(im),'("nummove_sin=1 ",tr1)')  
            !weights(im)=wmove
            !im=im+1
            
            !call condmom(im,(  cohogen(:)==co ),   d1* one( nummove_sin(MXAI,:)==2 ) ,mom,cnt,var)	
    		!write(name(im),'("nummove_sin=2 ",tr1)')  
            !weights(im)=wmove
            !im=im+1
            
            !call condmom(im,(  cohogen(:)==co ),   d1* one( nummove_sin(MXAI,:)>=3 ) ,mom,cnt,var)	
    		!write(name(im),'("nummove_sin>=3 ")')  
            !weights(im)=wmove
            !im=im+1
            !********************
    
            
        
            
            if (onlysingles) then 
                maxrelo=0
            else 
                maxrelo=1
            end if 
            if (onlymales.and.(.not.onlyfem)) then 
                minsex=1 ; maxsex=1
            else if ( (.not.onlymales).and.onlyfem) then 
                minsex=2 ; maxsex=2
            else if ( (.not.onlymales).and.(.not.onlyfem)) then 
                minsex=1 ; maxsex=2
            else 
                print*, 'Something is wrong in the neighborhood'
                stop
            end if 
            sex: do g=minsex,maxsex
			rel: do j=0,maxrelo
                if ( onlysingles ) then !  (.not.onlysingles).or.(onlysingles.and.j==0) ) then 
                    cosexrel(MNAD:MXAD,:)= (dat(MNAD:MXAD,:)%co==co .and. dat(MNAD:MXAD,:)%sexr==g )			                    
		        else 
                    cosexrel(MNAD:MXAD,:)= (dat(MNAD:MXAD,:)%co==co .and. dat(MNAD:MXAD,:)%sexr==g  .and. dat(MNAD:MXAD,:)%rel==j .and. norelchg(MNAD:MXAD,:)==1 )			
                end if 
                
				headloc(ihead)=im
				if (g==1.and.j==0) headstr(ihead)='SINGLE MALES'
				if (g==1.and.j==1) headstr(ihead)='MARRIED MALES'
				if (g==2.and.j==0) headstr(ihead)='SINGLE FEMALES'
				if (g==2.and.j==1) headstr(ihead)='MARRIED FEMALES'
                if (j==1) wmovebyrel=wmovemar
                if (j==0) wmovebyrel=wmovesin
				ihead=ihead+1
                
                !ahu jan19 010219: so I am still writing the age 17 (mad) mar rate. age 17 mar rate does not exit in the data since we don't record age 17 rel there. 
                !so the weight on this moment is 0 but then it's wmovebyrel
				ia=MNAD
					CALL condmom(im,( cosexrel(ia,:) .AND. move(ia,:)>=0 ),d1*move(ia,:),mom,cnt,var)
					WRITE(name(im),'("move by age",tr3,I4)') ia
					weights(im)=0.0_dp ; if (onlysingles.and.j==1) weights(im)=0.0_dp
					im=im+1
					CALL condmom(im,( cosexrel(ia,:) .AND. move(ia,:)>=0  .AND. dat(ia,:)%edr==1 ),d1*move(ia,:),mom,cnt,var)
					WRITE(name(im),'("mv|ned by a",tr3,I4)') ia
					weights(im)=0.0_dp
					im=im+1

                do ia=MNA,MXAD,5
					CALL condmom(im,( cosexrel(ia,:) .AND. move(ia,:)>=0 ),d1*move(ia,:),mom,cnt,var)
					WRITE(name(im),'("move by age",tr3,I4)') ia
					weights(im)=wmovebyrel ; if (onlysingles.and.j==1) weights(im)=0.0_dp
					im=im+1
				end do            

				do ia=MNA,19
					    CALL condmom(im,( cosexrel(ia,:) .AND. move(ia,:)>=0  .AND. dat(ia,:)%edr==1 ),d1*move(ia,:),mom,cnt,var)
					    WRITE(name(im),'("mv|ned by a",tr3,I4)') ia
					    weights(im)=wmovebyrel
					    im=im+1
                end do            
				do ia=21,23
					    CALL condmom(im,( cosexrel(ia,:) .AND. move(ia,:)>=0  .AND. dat(ia,:)%edr==2 ),d1*move(ia,:),mom,cnt,var)
					    WRITE(name(im),'("mv| ed by a",tr3,I4)') ia
					    weights(im)=wmovebyrel
					    im=im+1
                end do            

                
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. move(MNA:MXAD,:)==1 ),   d1*one( dat(MNA+1:MXA,:)%l==dat(MNA+1:MXA,:)%hme  ),mom,cnt,var)		
				write(name(im),'("%hme-mvs",tr3)')  !added this ahu 121718
				weights(im)=wmove 
                im=im+1 


				call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0  .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    			write(name(im),'("move | u ",tr5)')  
                weights(im)=wmovebyrel ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1
                
				call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==1  .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    			write(name(im),'("move | e ",tr5)')  
                weights(im)=wmovebyrel ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1
                
               
                
               
        		!do jj=1,2
                !do ia=mnad,MXAD,5
                 !   call condmom(im,( cosexrel(ia,:) .AND. dat(ia,:)%hhr==0 .AND. dat(ia+1,:)%hhr>=0 .AND. move(ia,:)==1  .AND. dat(ia,:)%edr==jj ),   d1*one( dat(ia+1,:)%hhr==1 ),mom,cnt,var)		
				 !   write(name(im),'("eumv",tr3,2i4)')  jj,ia
				 !   weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                 !   im=im+1 
                !end do 
                !end do 
  
      		!do jj=1,2
            !    do ia=mnad,MXAD,5
            !        call condmom(im,( cosexrel(ia,:) .AND. dat(ia,:)%hhr==1 .AND. dat(ia+1,:)%hhr>=0 .AND. move(ia,:)==1  .AND. dat(ia,:)%edr==jj ),   d1*one( dat(ia+1,:)%hhr==1 ),mom,cnt,var)		
		!		    write(name(im),'("eemv",tr3,2i4)')  jj,ia
		!		    weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
         !           im=im+1                 
         !       end do 
         !       end do 
  
 
                
          !      do jj=1,2
          !          call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0 .AND. move(MNA:MXAD,:)==0  .AND. dat(MNA:MXAD,:)%edr==jj ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
		!		    write(name(im),'("e | u stay edu",tr3,i4)')  jj
	!			    weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
    !                im=im+1 

     !               call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0 .AND. move(MNA:MXAD,:)==1  .AND. dat(MNA:MXAD,:)%edr==jj ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
		!		    write(name(im),'("e | u move edu",tr3,i4)')  jj
		!		    weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
        !            im=im+1 

         !           call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%hhr>=0 .AND. move(MNA:MXAD,:)==0  .AND. dat(MNA:MXAD,:)%edr==jj ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
		!		    write(name(im),'("e | e stay edu",tr3,i4)')  jj
		!		    weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
         !           im=im+1 
                
          !          call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%hhr>=0 .AND. move(MNA:MXAD,:)==1  .AND. dat(MNA:MXAD,:)%edr==jj ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
			!	    write(name(im),'("e | e move edu",tr3,i4)')  jj
			!	    weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
             !       im=im+1                 
             !   end do 
                
                
                
                
                
                
                
                
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0 .AND. move(MNA:MXAD,:)==0 ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
				write(name(im),'("e | u stay",tr3)')  
				weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 

                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0 .AND. move(MNA:MXAD,:)==1 ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
				write(name(im),'("e | u move",tr3)')  
				weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 

                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%hhr>=0 .AND. move(MNA:MXAD,:)==0 ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
				write(name(im),'("e | e stay",tr3)')  
				weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%hhr>=0 .AND. move(MNA:MXAD,:)==1 ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
				write(name(im),'("e | e move",tr3)')  
				weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 

                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%hhr>=0  ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 .AND. move(MNA:MXAD,:)==0),mom,cnt,var)		
			    write(name(im),'("e-stay | e ",tr3)')  
			    weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%hhr>=0  ),   d1*one( dat(MNA+1:MXA,:)%hhr==0 .AND. move(MNA:MXAD,:)==0),mom,cnt,var)		
			    write(name(im),'("u-stay | e ",tr3)')  
			    weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%hhr>=0  ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 .AND. move(MNA:MXAD,:)==1),mom,cnt,var)		
			    write(name(im),'("e-move | e ",tr3)')  
			    weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                
                 call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%hhr>=0  ),   d1*one( dat(MNA+1:MXA,:)%hhr==0 .AND. move(MNA:MXAD,:)==1),mom,cnt,var)		
			    write(name(im),'("u-move | e ",tr3)')  
			    weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 

                 call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0  ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 .AND. move(MNA:MXAD,:)==0),mom,cnt,var)		
			    write(name(im),'("e-stay | u ",tr3)')  
			    weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                
               call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0  ),   d1*one( dat(MNA+1:MXA,:)%hhr==0 .AND. move(MNA:MXAD,:)==0),mom,cnt,var)		
                write(name(im),'("u-stay | u ",tr3)')  
			    weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0  ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 .AND. move(MNA:MXAD,:)==1),mom,cnt,var)		
                write(name(im),'("e-move | u ",tr3)')  
			    weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0  ),   d1*one( dat(MNA+1:MXA,:)%hhr==0 .AND. move(MNA:MXAD,:)==1),mom,cnt,var)		
                write(name(im),'("u-move | u ",tr3)')  
			    weights(im)=wtrans  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 

              !  do ia=mna,mxad,8
              !      call condmom(im,( cosexrel(ia,:) .AND. dee(ia,:)==1  .AND. move(ia,:)==0 ),   d1*( dat(ia+1,:)%logwr-dat(ia,:)%logwr ),mom,cnt,var)		
              !      write(name(im),'("wdif | stay ia ",tr2,i6)')  ia
              !      weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
	          !      im=im+1 
              !  end do   
              !  do ia=mna,mxad,8
              !      call condmom(im,( cosexrel(ia,:) .AND. dee(ia,:)==1  .AND. move(ia,:)==1 ),   d1*( dat(ia+1,:)%logwr-dat(ia,:)%logwr ),mom,cnt,var)		
              !      write(name(im),'("wdif | move ia ",tr2,i6)')  ia
              !      weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
	          !      im=im+1 
              !  end do   

                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dee(MNA:MXAD,:)==1  .AND. move(MNA:MXAD,:)==1 .and. dat(MNA+1:MXA,:)%l/=dat(MNA+1:MXA,:)%hme ),   d1*( dat(MNA+1:MXA,:)%logwr-dat(MNA:MXAD,:)%logwr ),mom,cnt,var)		
                write(name(im),'("wdif | hmemve=0 ",tr2)')  
                weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dee(MNA:MXAD,:)==1  .AND. move(MNA:MXAD,:)==1 .and. dat(MNA+1:MXA,:)%l==dat(MNA+1:MXA,:)%hme ),   d1*( dat(MNA+1:MXA,:)%logwr-dat(MNA:MXAD,:)%logwr ),mom,cnt,var)		
                write(name(im),'("wdif | hmemve=1 ",tr2)')  
                weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 


                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dee(MNA:MXAD,:)==1  .AND. move(MNA:MXAD,:)==0 ),   d1*( dat(MNA+1:MXA,:)%logwr-dat(MNA:MXAD,:)%logwr ),mom,cnt,var)		
                write(name(im),'("wdif | stay ",tr2)')  
                weights(im)=wdifww  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				calcvar(im)=1
                im=im+1 
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dee(MNA:MXAD,:)==1 .AND. move(MNA:MXAD,:)==0 ),   d1*( dat(MNA+1:MXA,:)%logwr-dat(MNA:MXAD,:)%logwr )**2,mom,cnt,var)		
                write(name(im),'("wdif2 | stay ",tr2)')  
                weights(im)=wdifww  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				calcvar(im)=5
                im=im+1 
                !call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dee(MNA:MXAD,:)==1 .AND. move(MNA:MXAD,:)==0 ),   d1*( dat(MNA+1:MXA,:)%logwr-dat(MNA:MXAD,:)%logwr - mom(im-2) )**2,mom,cnt,var)		
                !write(name(im),'("wdif2p | stay ",tr2)')  
                !weights(im)=0.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !im=im+1 
                
                 

                
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dee(MNA:MXAD,:)==1  .AND. move(MNA:MXAD,:)==1 ),   d1*( dat(MNA+1:MXA,:)%logwr-dat(MNA:MXAD,:)%logwr ),mom,cnt,var)		
                write(name(im),'("wdif | move ",tr2)')  
                weights(im)=wdifww  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				calcvar(im)=1
                im=im+1 
                call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dee(MNA:MXAD,:)==1 .AND. move(MNA:MXAD,:)==1 ),   d1*( dat(MNA+1:MXA,:)%logwr-dat(MNA:MXAD,:)%logwr )**2,mom,cnt,var)		
                write(name(im),'("wdif2 | move ",tr2)')  
                weights(im)=wdifww  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				calcvar(im)=5
                im=im+1 
                !call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dee(MNA:MXAD,:)==1 .AND. move(MNA:MXAD,:)==1 ),   d1*( dat(MNA+1:MXA,:)%logwr-dat(MNA:MXAD,:)%logwr - mom(im-2) )**2,mom,cnt,var)		
                !write(name(im),'("wdif2p | move ",tr2)')  
                !weights(im)=100.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !im=im+1 

                
                call condmom(im,( cosexrel(MNA:MXAD-1,:) .AND. deue(MNA:MXAD-1,:)==1 .AND. dat(MNA+1:MXAD,:)%l==dat(MNA:MXAD-1,:)%l .AND. dat(MNA+2:MXA,:)%l==dat(MNA:MXAD-1,:)%l),   d1*( dat(MNA+2:MXA,:)%logwr-dat(MNA:MXAD-1,:)%logwr ),mom,cnt,var)		
                write(name(im),'("wdif | eue,s ",tr2)')  
                weights(im)=wdifww  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				calcvar(im)=1
                im=im+1 
                call condmom(im,( cosexrel(MNA:MXAD-1,:) .AND. deue(MNA:MXAD-1,:)==1  .AND. dat(MNA+1:MXAD,:)%l==dat(MNA:MXAD-1,:)%l .AND. dat(MNA+2:MXA,:)%l==dat(MNA:MXAD-1,:)%l),   d1*( dat(MNA+2:MXA,:)%logwr-dat(MNA:MXAD-1,:)%logwr )**2,mom,cnt,var)		
                write(name(im),'("wdif2 | eue,s ",tr2)')  
                weights(im)=wdifww  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				calcvar(im)=5
                im=im+1 
                !call condmom(im,( cosexrel(MNA:MXAD-1,:) .AND. deue(MNA:MXAD-1,:)==1  .AND. dat(MNA+1:MXAD,:)%l==dat(MNA:MXAD-1,:)%l .AND. dat(MNA+2:MXA,:)%l==dat(MNA:MXAD-1,:)%l),   d1*( dat(MNA+2:MXA,:)%logwr-dat(MNA:MXAD-1,:)%logwr - mom(im-2))**2,mom,cnt,var)		
                !write(name(im),'("wdif2p | eue,s ",tr2)')  
                !weights(im)=100.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !im=im+1 


                call condmom(im,( cosexrel(MNA:MXAD-1,:) .AND. deue(MNA:MXAD-1,:)==1   .AND. dat(MNA+1:MXAD,:)%l==dat(MNA:MXAD-1,:)%l .AND. dat(MNA+2:MXA,:)%l/=dat(MNA:MXAD-1,:)%l .AND. dat(MNA+2:MXA,:)%l>0 ),   d1*( dat(MNA+2:MXA,:)%logwr-dat(MNA:MXAD-1,:)%logwr ),mom,cnt,var)		
                write(name(im),'("wdif | eue,m ",tr2)')  
                weights(im)=wdifww  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				calcvar(im)=1
                im=im+1 
                call condmom(im,( cosexrel(MNA:MXAD-1,:) .AND. deue(MNA:MXAD-1,:)==1   .AND. dat(MNA+1:MXAD,:)%l==dat(MNA:MXAD-1,:)%l .AND. dat(MNA+2:MXA,:)%l/=dat(MNA:MXAD-1,:)%l .AND. dat(MNA+2:MXA,:)%l>0 ),   d1*( dat(MNA+2:MXA,:)%logwr-dat(MNA:MXAD-1,:)%logwr )**2,mom,cnt,var)		
                write(name(im),'("wdif2 | eue,m ",tr2)')  
                weights(im)=wdifww  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				calcvar(im)=5
                im=im+1 
                !call condmom(im,( cosexrel(MNA:MXAD-1,:) .AND. deue(MNA:MXAD-1,:)==1   .AND. dat(MNA+1:MXAD,:)%l==dat(MNA:MXAD-1,:)%l .AND. dat(MNA+2:MXA,:)%l/=dat(MNA:MXAD-1,:)%l .AND. dat(MNA+2:MXA,:)%l>0 ),   d1*( dat(MNA+2:MXA,:)%logwr-dat(MNA:MXAD-1,:)%logwr -mom(im-2))**2,mom,cnt,var)		
                !write(name(im),'("wdif2p | eue,m ",tr2)')  
                !weights(im)=100.0_dp  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !im=im+1 
                
                
                
                
                
                

				CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==1 .AND. dat(mna:mxa,:)%logwr>=0 ) ,d1*dat(mna:mxa,:)%logwr,mom,cnt,var)
				WRITE(name(im),'("w|noed",tr1)') 
				weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                calcvar(im)=1
                im=im+1
				CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==1 .AND. dat(mna:mxa,:)%logwr>=0 ) ,d1*  (dat(mna:mxa,:)%logwr**2),mom,cnt,var)
				WRITE(name(im),'("wvar|noed",tr1)') 
				weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                calcvar(im)=5
                im=im+1
				!CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==1 .AND. dat(mna:mxa,:)%logwr>=0 ) ,d1*  (dat(mna:mxa,:)%logwr-mom(im-2))**2,mom,cnt,var)
				!WRITE(name(im),'("wrng|noed",tr1)') 
				!weights(im)=0.0_dp
                !im=im+1

             
				CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==2 .AND. dat(mna:mxa,:)%logwr>=0 ) ,d1*dat(mna:mxa,:)%logwr,mom,cnt,var)
				WRITE(name(im),'("w|  ed",tr1)') 
				weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				calcvar(im)=1
                im=im+1
				CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==2 .AND. dat(mna:mxa,:)%logwr>=0 ) ,d1*  (dat(mna:mxa,:)%logwr**2),mom,cnt,var)
				WRITE(name(im),'("wvar|ed",tr1)') 
				weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp  
                calcvar(im)=5
                im=im+1
				!CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==2 .AND. dat(mna:mxa,:)%logwr>=0 ) ,d1*  (dat(mna:mxa,:)%logwr-mom(im-2))**2,mom,cnt,var)
				!WRITE(name(im),'("wrng|ed",tr1)') 
				!weights(im)=0.0_dp
                !im=im+1

                do ddd=1,ndecile-1
                    CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==1 .AND. dat(mna:mxa,:)%logwr>=0 ) ,d1*one( (dat(mna:mxa,:)%logwr>decilegrid(ddd) .and. dat(mna:mxa,:)%logwr<decilegrid(ddd+1) ) ),mom,cnt,var)
				    WRITE(name(im),'("wdecile|ned",tr1,i4)') ddd
				    weights(im)=wwaged ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                    im=im+1
                end do
                do ddd=1,ndecile-1
                    CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==2 .AND. dat(mna:mxa,:)%logwr>=0 ) ,d1*one( (dat(mna:mxa,:)%logwr>decilegrid(ddd) .and. dat(mna:mxa,:)%logwr<decilegrid(ddd+1) ) ),mom,cnt,var)
				    WRITE(name(im),'("wdecile| ed",tr1,i4)') ddd
				    weights(im)=wwaged ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                    im=im+1
                end do
   

                
				    CALL condmom(im,(   cosexrel(18:19,:) .AND.  dat(18:19,:)%hhr==1 .AND. dat(18:19,:)%edr==1 .AND. dat(18:19,:)%logwr>=0) ,d1*dat(18:19,:)%logwr,mom,cnt,var)
				    WRITE(name(im),'("w|1819 ",tr1,i4)') 
				    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                    calcvar(im)=1
                    im=im+1
				    CALL condmom(im,(   cosexrel(18:19,:) .AND.  dat(18:19,:)%hhr==1 .AND. dat(18:19,:)%edr==1 .AND. dat(18:19,:)%logwr>=0) ,d1*  (dat(18:19,:)%logwr**2),mom,cnt,var)
				    WRITE(name(im),'("wvar|1819 ",tr1,i4)') 
				    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                    calcvar(im)=5
                    im=im+1
				    !CALL condmom(im,(   cosexrel(18:19,:) .AND.  dat(18:19,:)%hhr==1 .AND. dat(18:19,:)%edr==1 .AND. dat(18:19,:)%logwr>=0 ) ,d1*  (dat(18:19,:)%logwr-mom(im-2))**2,mom,cnt,var)
				    !WRITE(name(im),'("wrng|1819 ",tr1,i4)') 
				    !weights(im)=0.0_dp
                    !im=im+1

                    
                !do i=1,nl
				!    CALL condmom(im,(   cosexrel(18,:) .AND.  dat(18,:)%hhr==1 .AND. dat(18,:)%edr==1 .AND. dat(18,:)%logwr>=0 .AND. dat(18,:)%l==i) ,d1*dat(18,:)%logwr,mom,cnt,var)
				!    WRITE(name(im),'("w|18 l",tr1,i4)') i
				!    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                !    calcvar(im)=1
                !    im=im+1
				!    CALL condmom(im,(   cosexrel(18,:) .AND.  dat(18,:)%hhr==1 .AND. dat(18,:)%edr==1 .AND. dat(18,:)%logwr>=0  .AND. dat(18,:)%l==i) ,d1*  (dat(18,:)%logwr**2),mom,cnt,var)
				!    WRITE(name(im),'("wvar|18 l",tr1,i4)') i
				!    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                !    calcvar(im)=5
                !    im=im+1
                !end do 
                
                    
                do i=1,nl
				    CALL condmom(im,(   cosexrel(18:19,:) .AND.  dat(18:19,:)%hhr==1 .AND. dat(18:19,:)%edr==1 .AND. dat(18:19,:)%logwr>=0 .AND. dat(18:19,:)%l==i) ,d1*dat(18:19,:)%logwr,mom,cnt,var)
				    WRITE(name(im),'("w|1819 l",tr1,i4)') i
				    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                    calcvar(im)=1
                    im=im+1
				    CALL condmom(im,(   cosexrel(18:19,:) .AND.  dat(18:19,:)%hhr==1 .AND. dat(18:19,:)%edr==1 .AND. dat(18:19,:)%logwr>=0  .AND. dat(18:19,:)%l==i) ,d1*  (dat(18:19,:)%logwr**2),mom,cnt,var)
				    WRITE(name(im),'("wvar|1819 l",tr1,i4)') i
				    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                    calcvar(im)=5
                    im=im+1
				    !CALL condmom(im,(   cosexrel(18:19,:) .AND.  dat(18:19,:)%hhr==1 .AND. dat(18:19,:)%edr==1 .AND. dat(18:19,:)%logwr>=0  .AND. dat(18:19,:)%l==i ) ,d1*  (dat(18:19,:)%logwr-mom(im-2))**2,mom,cnt,var)
				    !WRITE(name(im),'("wrng|1819 l",tr1,i4)') i 
				    !weights(im)=0.0_dp
                    !im=im+1
                end do 
                

                !ia=18
                !do i=1,nl
				!    CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%logwr>=0 .AND. dat(ia,:)%l==i) ,d1*dat(ia,:)%logwr,mom,cnt,var)
				!    WRITE(name(im),'("w|noed l 18",tr1,i4)') i
				!    weights(im)=0.0_dp ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                !    im=im+1
                !end do 
                
                !ia=18
                !do i=1,nl
				!    CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%logwr>=0 .AND. dat(ia,:)%l==i) ,d1*dat(ia,:)%logwr,mom,cnt,var)
				!    WRITE(name(im),'("w|ed l  18",tr1,i4)') i
				!    weights(im)=0.0_dp ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                !    im=im+1
                !end do 

                
                do i=1,nl
				    CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==1 .AND. dat(mna:mxa,:)%logwr>=0 .AND. dat(mna:mxa,:)%l==i) ,d1*dat(mna:mxa,:)%logwr,mom,cnt,var)
				    WRITE(name(im),'("w|noed l",tr1,i4)') i
				    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                    calcvar(im)=1
                    im=im+1
				    CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==1 .AND. dat(mna:mxa,:)%logwr>=0  .AND. dat(mna:mxa,:)%l==i) ,d1*  (dat(mna:mxa,:)%logwr**2),mom,cnt,var)
				    WRITE(name(im),'("wvar|noed l",tr1,i4)') i
				    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                    calcvar(im)=5
                    im=im+1
				    !CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==1 .AND. dat(mna:mxa,:)%logwr>=0  .AND. dat(mna:mxa,:)%l==i ) ,d1*  (dat(mna:mxa,:)%logwr-mom(im-2))**2,mom,cnt,var)
				    !WRITE(name(im),'("wrng|noed l",tr1,i4)') i 
				    !weights(im)=0.0_dp
                    !im=im+1
                end do 
                

                do i=1,nl
				    CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==2 .AND. dat(mna:mxa,:)%logwr>=0 .AND. dat(mna:mxa,:)%l==i) ,d1*dat(mna:mxa,:)%logwr,mom,cnt,var)
				    WRITE(name(im),'("w|ed l",tr1,i4)') i
				    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                    calcvar(im)=1
                    im=im+1
				    CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==2 .AND. dat(mna:mxa,:)%logwr>=0  .AND. dat(mna:mxa,:)%l==i) ,d1*  (dat(mna:mxa,:)%logwr**2),mom,cnt,var)
				    WRITE(name(im),'("wvar|ed l",tr1,i4)') i
				    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                    calcvar(im)=5
                    im=im+1
				    !CALL condmom(im,(   cosexrel(mna:mxa,:) .AND.  dat(mna:mxa,:)%hhr==1 .AND. dat(mna:mxa,:)%edr==2 .AND. dat(mna:mxa,:)%logwr>=0  .AND. dat(mna:mxa,:)%l==i ) ,d1*  (dat(mna:mxa,:)%logwr-mom(im-2))**2,mom,cnt,var)
				    !WRITE(name(im),'("wrng|ed l",tr1,i4)') i 
				    !weights(im)=0.0_dp
                    !im=im+1
                end do 

                
                !do i=1,nl
				!    CALL condmom(im,(   cosexrel(18:21,:) .AND.  dat(18:21,:)%hhr==1 .AND. dat(18:21,:)%edr==1 .AND. dat(18:21,:)%logwr>=0  .AND. dat(18:21,:)%l==i) ,d1*  (dat(18:21,:)%logwr),mom,cnt,var)
				!    WRITE(name(im),'("w|1821 l",tr1,i4)') i
				!    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                !    im=im+1
                !    !CALL condmom(im,(   cosexrel(18:21,:) .AND.  dat(18:21,:)%hhr==1 .AND. dat(18:21,:)%edr==1 .AND. dat(18:21,:)%logwr>=0  .AND. dat(18:21,:)%l==i) ,d1*  (dat(18:21,:)%logwr**2-mom(im-1)**2),mom,cnt,var)
				!    !WRITE(name(im),'("w2|1821 l",tr1,i4)') i
				!    !weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                !    !im=im+1
				!    !CALL condmom(im,(   cosexrel(18:21,:) .AND.  dat(18:21,:)%hhr==1 .AND. dat(18:21,:)%edr==1 .AND. dat(18:21,:)%logwr>=0  .AND. dat(18:21,:)%l==i) ,d1*  (dat(18:21,:)%logwr**3-mom(im-1)**3),mom,cnt,var)
				!    !WRITE(name(im),'("w3|1821 l",tr1,i4)') i
				!    !weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp            
                !    !im=im+1
                !end do 

                
                call condmom(im,( cosexrel(mna:mxa,:) .AND. dat(mna:mxa,:)%hhr>=0 ), d1*one( dat(mna:mxa,:)%hhr==1 ),mom,cnt,var)		
                write(name(im),'("e ",tr13)')			
                weights(im)=whour ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                
                call condmom(im,( cosexrel(mna:mxa,:) .AND. dat(mna:mxa,:)%hhr>=0 .AND. dat(mna:mxa,:)%edr==1 ),   d1*one( dat(mna:mxa,:)%hhr==1 ),mom,cnt,var)	
				write(name(im),'("e | noed",tr6)')  
				weights(im)=whour  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                
                call condmom(im,( cosexrel(mna:mxa,:) .AND. dat(mna:mxa,:)%hhr>=0 .AND. dat(mna:mxa,:)%edr==2 ),   d1*one( dat(mna:mxa,:)%hhr==1 ),mom,cnt,var)		
				write(name(im),'("e |   ed",tr6)')  
				weights(im)=whour  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 

                !Note about conditioning on age:
                !The max endage in data is 47. 
                !The way sim is done, for those whose endage is 47, the last age where variables get recorded is ia-1=46. 
                !This is because dat(ia-1,.) is recorded for each ia. So for the last age 47, the variables for 46 gets written
                !But then there is nothing after age 46, despite the fact that we do have people whose endage is 46 (namely 47).      
				!If one of the conditioning statements is norelchg, then there is nothing after age 45. 
                !Since any age 46 no relchg would need a age 47 rel. 
                !This is why emp and wage by age cond on cosexrel only goes until 45. 
                do ia=MNAd,25 
					CALL condmom(im,( cosexrel(ia,:) .AND. dat(ia,:)%hhr>=0 ) ,d1*one(dat(ia,:)%hhr==1),mom,cnt,var)
					WRITE(name(im),'("emp by age",tr4,I2)') ia
					weights(im)=whour ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                    if (ia<mna) weights(im)=0.0_dp
                    im=im+1
				end do       

                !do ia=MNAD,25 
			!		CALL condmom(im,( cosexrel(ia,:) .AND. dat(ia,:)%hhr>=0 .and. dat(ia,:)%edr==1) ,d1*one(dat(ia,:)%hhr==1),mom,cnt,var)
			!		WRITE(name(im),'("emp a,ned",tr4,I2)') ia
			!		weights(im)=whour ; if (onlysingles.and.j==1) weights(im)=0.0_dp
             !       if (ia<mna) weights(im)=0.0_dp
			!		im=im+1
			!	end do            
             !   do ia=MNAD,25 
				!	CALL condmom(im,( cosexrel(ia,:) .AND. dat(ia,:)%hhr>=0 .and. dat(ia,:)%edr==2) ,d1*one(dat(ia,:)%hhr==1),mom,cnt,var)
			!		WRITE(name(im),'("emp a,ed",tr4,I2)') ia
			!		weights(im)=whour ; if (onlysingles.and.j==1) weights(im)=0.0_dp
             !       if (ia<agestart(college)) weights(im)=0.0_dp
              !      im=im+1
			!	end do            

 
               !do ia=mna,45 !mxai-1
				!	CALL condmom(im,( cosexrel(ia,:) .AND. dat(ia,:)%hhr>=0  .AND. dat(ia,:)%edr==1 ) ,d1*one(dat(ia,:)%hhr==1),mom,cnt,var)
				!	WRITE(name(im),'("e|ned by age",tr2,I2)') ia
				!	weights(im)=whour ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				!	im=im+1
				!end do            

               !do ia=mna,45 !mxai-1
				!	CALL condmom(im,( cosexrel(ia,:) .AND. dat(ia,:)%hhr>=0  .AND. dat(ia,:)%edr==2 ) ,d1*one(dat(ia,:)%hhr==1),mom,cnt,var)
				!	WRITE(name(im),'("e| ed by age",tr2,I2)') ia
				!	weights(im)=whour ; if (onlysingles.and.j==1) weights(im)=0.0_dp
				!	im=im+1
                !end do

 

            
				do ia=agestart(NOCOLLEGE),mxad,2
					CALL condmom(im,( cosexrel(ia,:) .AND.    dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%logwr>=0 ) ,d1*dat(ia,:)%logwr,mom,cnt,var)
					WRITE(name(im),'("w|noed by age",tr1,I2)') ia
                    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp
					im=im+1
					!CALL condmom(im,( cosexrel(ia,:) .AND.    dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%logwr>=0 ) ,d1*  (dat(ia,:)%logwr-mom(im-1))**2   ,mom,cnt,var)
					!WRITE(name(im),'("wvar|noed by age",tr1,I2)') ia
                    !weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp
					!im=im+1
                end do            
				
				do ia=agestart(COLLEGE),mxad,2
					CALL condmom(im,( cosexrel(ia,:) .AND.   dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%logwr>=0 ) ,d1*dat(ia,:)%logwr,mom,cnt,var)
					WRITE(name(im),'("w|  ed by age",tr1,I2)') ia
					weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp
					im=im+1
					!CALL condmom(im,( cosexrel(ia,:) .AND.    dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%logwr>=0 ) ,d1*  (dat(ia,:)%logwr-mom(im-1))**2   ,mom,cnt,var)
					!WRITE(name(im),'("wvar|ed by age",tr1,I2)') ia
                    !weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp
					!im=im+1
                end do            

                !do ia=MNA,MXAD
                !    call condmom(im,( cosexrel(ia,:) .AND. dat(ia,:)%hhr==1 .AND. dat(ia+1,:)%hhr==1 .AND. dat(ia,:)%logwr>=0 .AND. dat(ia+1,:)%logwr>=0  .AND. move(ia,:)==0 ),   d1*( dat(ia+1,:)%logwr-dat(ia,:)%logwr ),mom,cnt,var)		
				!    write(name(im),'("wdif | stay ",tr2)')  
				!    weights(im)=wwage  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !    im=im+1 
                !    call condmom(im,( cosexrel(ia,:) .AND. dat(ia,:)%hhr==1 .AND. dat(ia+1,:)%hhr==1 .AND. dat(ia,:)%logwr>=0 .AND. dat(ia+1,:)%logwr>=0  .AND. move(ia,:)==1 ),   d1*( dat(ia+1,:)%logwr-dat(ia,:)%logwr ),mom,cnt,var)		
				!    write(name(im),'("wdif | move ",tr2)')  
				!    weights(im)=wwage  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !    im=im+1 
                !end do 

             
                !headloc(ihead)=im ; headstr(ihead)=' ' ; ihead=ihead+1		            
            	
                !ahu 122818 commenting out the loc moment
			    do i=1,nl
                    call condmom(im,( cosexrel(MNA:MXA,:) .AND. dat(MNA:MXA,:)%hhr>=0 .AND. dat(MNA:MXA,:)%l>0 ),   d1*one( dat(MNA:MXA,:)%l==i ),mom,cnt,var)		
				    write(name(im),'("loc",tr11,i2)') i			
				    weights(im)=wmovebyrel ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                    im=im+1 
                end do 
            
                !do i=1,nl
                !    call condmom(im,( cosexrel(MNA:MXA,:) .AND. dat(MNA:MXA,:)%hhr>=0 .AND. dat(MNA:MXA,:)%l==i ),   d1*one( dat(MNA:MXA,:)%hhr==1 ),mom,cnt,var)		
				!    write(name(im),'("e|loc",tr9,i4)') i			
				!    weights(im)=whour  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !    im=im+1
                !end do 

                do i=1,nl
                    call condmom(im,( cosexrel(MNA:MXA,:) .AND. dat(MNA:MXA,:)%hhr==1 .AND. dat(MNA:MXA,:)%l==i .AND. dat(MNA:MXA,:)%logwr>=0 ),   d1*dat(MNA:MXA,:)%logwr ,mom,cnt,var)		
				    write(name(im),'("w|loc",tr9,i4)') i			
				    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                    im=im+1 
                end do 
      
                !do i=1,nl
                !    call condmom(im,( cosexrel(mna:mxai,:) .AND. dat(mna:mxai,:)%hhr>=0 .AND. dat(mna:mxai,:)%l==i  .AND. dat(mna:mxai,:)%edr==1 ),   d1*one( dat(mna:mxai,:)%hhr==1 ),mom,cnt,var)		
				!    write(name(im),'("e|loc noed",tr4,i4)') i			
				!    weights(im)=whour  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !    im=im+1 
                !end do 
            
                !do i=1,nl
                !    call condmom(im,( cosexrel(mna:mxai,:) .AND. dat(mna:mxai,:)%hhr==1 .AND. dat(mna:mxai,:)%l==i  .AND. dat(mna:mxai,:)%edr==1 .AND. dat(mna:mxai,:)%logwr>=0 ),   d1*dat(mna:mxai,:)%logwr ,mom,cnt,var)		
				!    write(name(im),'("w|loc noed",tr4,i4)') i			
				!    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !    im=im+1 
                !end do 

                !do i=1,nl
                !    call condmom(im,( cosexrel(mna:mxai,:) .AND. dat(mna:mxai,:)%hhr>=0 .AND. dat(mna:mxai,:)%l==i  .AND. dat(mna:mxai,:)%edr==2 ),   d1*one( dat(mna:mxai,:)%hhr==1 ),mom,cnt,var)		
				!    write(name(im),'("e|loc   ed",tr4,i4)') i			
				!    weights(im)=whour  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !    im=im+1 
                !end do 
            
                !do i=1,nl
                !    call condmom(im,( cosexrel(mna:mxai,:) .AND. dat(mna:mxai,:)%hhr==1 .AND. dat(mna:mxai,:)%l==i  .AND. dat(mna:mxai,:)%edr==2 .AND. dat(mna:mxai,:)%logwr>=0 ),   d1*dat(mna:mxai,:)%logwr ,mom,cnt,var)		
				!    write(name(im),'("w|loc   ed",tr4,i4)') i			
				!    weights(im)=wwage ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                !    im=im+1 
                !end do 
            
                if (j==1) then !only do kid by age for married. for singles, it looks weird in the data (.30, .8, .16,.19) 
                    do ia=MNA,MXAD,8
					    CALL condmom(im,( cosexrel(ia,:) .AND. dat(ia,:)%kidr>=1 ),d1*one( dat(ia,:)%kidr==2 ),mom,cnt,var)
					    WRITE(name(im),'("kid  by age",tr3,I4)') ia
					    weights(im)=whour ; if (onlysingles.and.j==1) weights(im)=0.0_dp
					    im=im+1
				    end do            
                end if 
				call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%kidr==1  .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    			write(name(im),'("move | nokid ",tr1)')  
                weights(im)=wmovebyrel ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1
                
				call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%kidr==2  .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)	
    			write(name(im),'("move | kid ",tr3)')  
                weights(im)=wmovebyrel ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1
                
                call condmom(im,( cosexrel(MNA:MXA,:) .AND. dat(MNA:MXA,:)%kidr==1 .AND. dat(MNA:MXA,:)%hhr>=0 ),   d1*one( dat(MNA:MXA,:)%hhr==1 ),mom,cnt,var)		
				write(name(im),'("e | nokid",tr5)') 
				weights(im)=whour  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 
                
                call condmom(im,( cosexrel(MNA:MXA,:) .AND. dat(MNA:MXA,:)%kidr==2 .AND. dat(MNA:MXA,:)%hhr>=0 ),   d1*one( dat(MNA:MXA,:)%hhr==1 ),mom,cnt,var)		
				write(name(im),'("e |   kid",tr5)') 
				weights(im)=whour  ; if (onlysingles.and.j==1) weights(im)=0.0_dp
                im=im+1 

                
             call condmom(im,(  cohogen(:)==co .and. sexgen(:)==g ) ,   d1* one( nummove(:)==0 ) ,mom,cnt,var)	
    		    write(name(im),'("nummove=0 ",tr5)')  
                weights(im)=wmove
                im=im+1

                call condmom(im,(  cohogen(:)==co  .and. sexgen(:)==g ),   d1* one( nummove(:)==1 ) ,mom,cnt,var)	
    		    write(name(im),'("nummove=1 ",tr5)')  
                weights(im)=wmove
                im=im+1
            
                call condmom(im,(  cohogen(:)==co  .and. sexgen(:)==g ),   d1* one( nummove(:)==2 ) ,mom,cnt,var)	
    		    write(name(im),'("nummove=2 ",tr5)')  
                weights(im)=wmove
                im=im+1
            
                call condmom(im,(  cohogen(:)==co  .and. sexgen(:)==g ),   d1* one( nummove(:)>=3 ) ,mom,cnt,var)	
    		    write(name(im),'("nummove>=3 ",tr4)')  
                weights(im)=wmove
                im=im+1

                !headloc(ihead)=im; headstr(ihead)=' ';ihead=ihead+1		
			    do i=1,nl
                    call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%l==i  .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)		
				    write(name(im),'("mvfr | loc",tr4,i4)') i
				    weights(im)=wmove 
                    im=im+1 
                end do

			    do i=1,nl
                    call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA+1:MXA,:)%l==i .AND. move(MNA:MXAD,:)>=0 ),   d1* move(MNA:MXAD,:) ,mom,cnt,var)		
				    write(name(im),'("mvto | loc",tr4,i4)') i
				    weights(im)=wmove
                    im=im+1 
                end do 
   
       
            end do rel
            end do sex
                
    
            if (onlymales.and.(.not.onlyfem)) then 
                minsex=1 ; maxsex=1
            else if ( (.not.onlymales).and.onlyfem) then 
                minsex=2 ; maxsex=2
            else if ( (.not.onlymales).and.(.not.onlyfem)) then 
                minsex=1 ; maxsex=2
            else 
                print*, 'Something is wrong in the neighborhood'
                stop
            end if 
            
            do g=minsex,maxsex
                cosex(MNAD:MXA,:)= (dat(MNAD:MXA,:)%co==co .and. dat(MNAD:MXA,:)%sexr==g  )

                !if (.not.onlysingles) then
                
                    headloc(ihead)=im
			        if (g==1) headstr(ihead)='ALL MALES'
			        if (g==2) headstr(ihead)='ALL FEMALES'
			        ihead=ihead+1

                    !call condmom(im,( cohogen(:)==co .AND. sexgen(:)==g  ),   d1* one( nummove(:)==0 ) ,mom,cnt,var)	
    		        !write(name(im),'("nummove=0 ",tr5)')  
                    !weights(im)=wmove 
                    !im=im+1

                    !call condmom(im,(  cohogen(:)==co .AND. sexgen(:)==g ),   d1* one( nummove(:)==1 ) ,mom,cnt,var)	
    		        !write(name(im),'("nummove=1 ",tr5)')  
                    !weights(im)=wmove 
                    !im=im+1
            
                    !call condmom(im,( cohogen(:)==co .AND. sexgen(:)==g ),   d1* one( nummove(:)==2 ) ,mom,cnt,var)	
    		        !write(name(im),'("nummove=2 ",tr5)')  
                    !weights(im)=wmove 
                    !im=im+1
            
                    !call condmom(im,( cohogen(:)==co .AND. sexgen(:)==g ),   d1* one( nummove(:)>=3 ) ,mom,cnt,var)	
    		        !write(name(im),'("nummove>=3 ",tr4)')  
                    !weights(im)=wmove 
                    !im=im+1
                
			        do i=1,nl            
                        call condmom(im,( cosex(MNA:MXAD,:) .AND. dat(MNA+1:MXA,:)%l==i .AND. move(MNA:MXAD,:)==1 ),   d1*one( dat(MNA+1:MXA,:)%l==dat(MNA+1:MXA,:)%hme  ),mom,cnt,var)		
				        write(name(im),'("%hme-mvs to",tr3,i4)') i
				        weights(im)=wmove 
                        im=im+1 
			        end do  	

                    
                    do i=1,5
                        call condmom(im,( cosex(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0  .AND. dur(MNA:MXAD,:)==i),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
				        write(name(im),'("e|u by dur",tr5,i2)') i
				        weights(im)=whour
                        im=im+1 
                    end do 

                    
			        do i=1,5
                        call condmom(im,( cosex(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%logwr>=0  .AND. dur(MNA:MXAD,:)==i ),   d1*dat(MNA+1:MXA,:)%logwr ,mom,cnt,var)		
				        write(name(im),'("w|u by dur",tr5,i2)') i
				        weights(im)=wwage
                        im=im+1 
                    end do 
 
                    
                   do i=1,5
                        call condmom(im,( cosex(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0  .AND. dur(MNA:MXAD,:)==i .AND. dat(MNA:MXAD,:)%edr==1 ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
				        write(name(im),'("e|u by dur ned",tr5,i2)') i
				        weights(im)=whour
                        im=im+1 
                    end do 

                   do i=1,5
                        call condmom(im,( cosex(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0  .AND. dur(MNA:MXAD,:)==i .AND. dat(MNA:MXAD,:)%edr==2 ),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
				        write(name(im),'("e|u by dur  ed",tr5,i2)') i
				        weights(im)=whour
                        im=im+1 
                    end do 

                    
                    
			        do i=1,5
                        call condmom(im,( cosex(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%logwr>=0  .AND. dur(MNA:MXAD,:)==i  .AND. dat(MNA:MXAD,:)%edr==1),   d1*dat(MNA+1:MXA,:)%logwr ,mom,cnt,var)		
				        write(name(im),'("w|u by dur ned",tr5,i2)') i
				        weights(im)=wwage
                        im=im+1 
                    end do 
 

			        do i=1,5
                        call condmom(im,( cosex(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%logwr>=0  .AND. dur(MNA:MXAD,:)==i  .AND. dat(MNA:MXAD,:)%edr==2),   d1*dat(MNA+1:MXA,:)%logwr ,mom,cnt,var)		
				        write(name(im),'("w|u by dur  ed",tr5,i2)') i
				        weights(im)=wwage
                        im=im+1 
                    end do 
                    
                    ia=MNA
                    do i=1,nl
                        call condmom(im,( cosex(ia,:) .AND. dat(ia,:)%hhr==1 .AND. dat(ia,:)%l==i .AND. dat(ia,:)%logwr>=0 ),   d1*dat(ia,:)%logwr ,mom,cnt,var)		
				        write(name(im),'("w|loc 18",tr9,i4)') i			
				        weights(im)=0.0_dp
                        im=im+1 
                    end do 
                    
                    ia=MNA
                    do i=1,nl
                        call condmom(im,( cosex(ia:ia+3,:) .AND. dat(ia:ia+3,:)%hhr==1 .AND. dat(ia:ia+3,:)%l==i .AND. dat(ia:ia+3,:)%logwr>=0 ),   d1*dat(ia:ia+3,:)%logwr ,mom,cnt,var)		
				        write(name(im),'("w|loc 18:21",tr9,i4)') i			
				        weights(im)=wwage
                        im=im+1 
                    end do 
  



                    !ahu summer18: before the below moments were conditioned on cosexrel instead of just cosex. 
                    !I remove the rel conditioning because sometimes these seem to have noone in the cells and they lead to jumpiness 
                    !See notes for 042118. 
			        !ia=MNAd
                    !call condmom(im,( cosex(ia,:) .AND. dat(ia,:)%hhr==0 .AND. dat(ia+1,:)%hhr>=0 ),   d1*one( dat(ia+1,:)%hhr==1 ),mom,cnt,var)		
				    !write(name(im),'("e|u by ia",tr5,i2)') ia
				    !weights(im)=0.0_dp
                    !im=im+1 
                    !call condmom(im,( cosex(ia,:) .AND. dat(ia,:)%hhr==0 .AND. dat(ia+1,:)%hhr==1 .AND. dat(ia+1,:)%logwr>=0  ),   d1*dat(ia+1,:)%logwr ,mom,cnt,var)		
				    !write(name(im),'("w|u by ia",tr5,i2)') ia
				    !weights(im)=0.0_dp 
                    !im=im+1 

			        !do ia=MNA,MXAD,8
                    !    call condmom(im,( cosex(ia,:) .AND. dat(ia,:)%hhr==0 .AND. dat(ia+1,:)%hhr>=0 ),   d1*one( dat(ia+1,:)%hhr==1 ),mom,cnt,var)		
				    !    write(name(im),'("e|u by ia",tr5,i2)') ia
				    !    weights(im)=0.0_dp  
                    !    im=im+1 

                    !    call condmom(im,( cosex(ia,:) .AND. dat(ia,:)%hhr==0 .AND. dat(ia+1,:)%hhr==1 .AND. dat(ia+1,:)%logwr>=0  ),   d1*dat(ia+1,:)%logwr ,mom,cnt,var)		
				    !    write(name(im),'("w|u by ia",tr5,i2)') ia
				    !    weights(im)=0.0_dp
                    !    im=im+1 
                    !end do 

                !end if !not onlysingles  
            end do !g for sex
 
            
                
                
                
                
            
            if (extramoments) then
			!IF (.not.onlysingles) THEN
            
			    headloc(ihead)=im
			    headstr(ihead)='EVERYONE: EXTRA MOMENTS'
			    ihead=ihead+1

                !do ia=mna,mxai
			    !    call condmom(im,( coho(ia,:) .AND. dat(ia,:)%rel>=0  .AND. dat(ia,:)%edr==1 ), d1*one(dat(ia,:)%rel==1),mom,cnt,var)
			    !    write(name(im),'("mar by ia,ned",tr1,i4)') ia
                !    weights(im)=0.0_dp
                !    im=im+1
			    !    call condmom(im,( coho(ia,:) .AND. dat(ia,:)%rel>=0  .AND. dat(ia,:)%edr==2 ), d1*one(dat(ia,:)%rel==1),mom,cnt,var)
			    !    write(name(im),'("mar by ia, ed",tr1,i4)') ia
                !    weights(im)=0.0_dp
                !    im=im+1
                !end do            
                !do ia=mna,mxai-1
			    !    call condmom(im,( coho(ia,:) .AND. dat(ia,:)%rel==0 .AND. dat(ia+1,:)%rel>=0   .AND. dat(ia,:)%edr==1 ), d1*one(dat(ia+1,:)%rel==1),mom,cnt,var)
			    !    write(name(im),'("getmarbyia,ned",tr1,i4)') ia
                !    weights(im)=0.0_dp
                !    im=im+1
			    !    call condmom(im,( coho(ia,:) .AND. dat(ia,:)%rel==0 .AND. dat(ia+1,:)%rel>=0   .AND. dat(ia,:)%edr==2 ), d1*one(dat(ia+1,:)%rel==1),mom,cnt,var)
			    !    write(name(im),'("getmarbyia, ed",tr1,i4)') ia
                !    weights(im)=0.0_dp
                !    im=im+1
                !end do                       
            
                !do ia=mna,mxai
			    !    call condmom(im,( coho(ia,:) .AND. dat(ia,:)%rel>=0 ), d1*one(dat(ia,:)%rel==1),mom,cnt,var)
			    !    write(name(im),'("mar by ia",tr5,i4)') ia
                !    weights(im)=wrel
                !    im=im+1
                !end do            
                !do ia=mna,mxai-1
			    !    call condmom(im,( coho(ia,:) .AND. dat(ia,:)%rel==0 .AND. dat(ia+1,:)%rel>=0 ), d1*one(dat(ia+1,:)%rel==1),mom,cnt,var)
			    !    write(name(im),'("get mar by ia",tr1,i4)') ia
                !    weights(im)=wrel
                !    im=im+1
                !end do            
                !do ia=mna,mxai-1
			    !    call condmom(im,( coho(ia,:) .AND. dat(ia,:)%rel==1 .AND. dat(ia+1,:)%rel>=0 ), d1*one(dat(ia+1,:)%rel==0),mom,cnt,var)
			    !    write(name(im),'("get div by ia",tr1,i4)') ia
                !    weights(im)=wrel
                !    im=im+1
                !end do            
                
                do i=1,ntypp
                    call condmom(im,( coho(MNA:MXA,:) .AND. dat(MNA:MXA,:)%rel>=0 .AND. dat(MNA:MXA,:)%typ==i ), d1*one(dat(MNA:MXA,:)%rel==1),mom,cnt,var)
			        write(name(im),'("mar by typ ",tr3,i4)') i
                    weights(im)=0.0_dp
                    im=im+1
                end do 

                
                
                do i=1,ntypp
                    call condmom(im,( coho(MNA:MXA,:) .AND. dat(MNA:MXA,:)%rel>=0 .AND. dat(MNA:MXA,:)%rel==1 ), d1*one(dat(MNA:MXA,:)%typ==i),mom,cnt,var)
			        write(name(im),'("typ | mar ",tr4,i4)') i
                    weights(im)=0.0_dp
                    im=im+1
                end do 

                do i=1,ntypp
                    call condmom(im,( coho(MNA:MXA,:) .AND. dat(MNA:MXA,:)%rel>=0 .AND. dat(MNA:MXA,:)%typ==i .and. dat(MNA:MXA,:)%edr==1 ), d1*one(dat(MNA:MXA,:)%rel==1),mom,cnt,var)
			        write(name(im),'("mar|ned by typ ",i4)') i
                    weights(im)=0.0_dp
                    im=im+1
                end do 

                  do i=1,ntypp
                    call condmom(im,( coho(MNA:MXA,:) .AND. dat(MNA:MXA,:)%rel>=0 .AND. dat(MNA:MXA,:)%typ==i .and. dat(MNA:MXA,:)%edr==2 ), d1*one(dat(MNA:MXA,:)%rel==1),mom,cnt,var)
			        write(name(im),'("mar| ed by typ ",i4)') i
                    weights(im)=0.0_dp
                    im=im+1
                end do 

                
                do i=1,ntypp
                    call condmom(im,( coho(MNA:MXA,:) .AND. dat(MNA:MXA,:)%rel>=0 .AND. dat(MNA:MXA,:)%rel==1  .and. dat(MNA:MXA,:)%edr==1 ), d1*one(dat(MNA:MXA,:)%typ==i),mom,cnt,var)
			        write(name(im),'("typ | mar,noed ",tr1,i4)') i
                    weights(im)=0.0_dp
                    im=im+1
                end do 

                do i=1,ntypp
                    call condmom(im,( coho(MNA:MXA,:) .AND. dat(MNA:MXA,:)%rel>=0 .AND. dat(MNA:MXA,:)%rel==1  .and. dat(MNA:MXA,:)%edr==2 ), d1*one(dat(MNA:MXA,:)%typ==i),mom,cnt,var)
			        write(name(im),'("typ | mar,  ed ",tr1,i4)') i
                    weights(im)=0.0_dp
                    im=im+1
                end do 

                

                
            if (onlysingles) then 
                maxrelo=0
            else 
                maxrelo=1
            end if 
            
            if (onlymales) then 
                maxsex=1
            else 
                maxsex=2
            end if 

            do g=1,maxsex
			    do j=0,MAXRELO
                if ( onlysingles ) then !  (.not.onlysingles).or.(onlysingles.and.j==0) ) then 
                    cosexrel(MNAD:MXAD,:)= (dat(MNAD:MXAD,:)%co==co .and. dat(MNAD:MXAD,:)%sexr==g )			                    
		        else 
                    cosexrel(MNAD:MXAD,:)= (dat(MNAD:MXAD,:)%co==co .and. dat(MNAD:MXAD,:)%sexr==g  .and. dat(MNAD:MXAD,:)%rel==j .and. norelchg(MNAD:MXAD,:)==1 )			
                end if 

				headloc(ihead)=im
				if (g==1.and.j==0) headstr(ihead)='SINGLE MALES: EXTRA MOMENTS'
				if (g==1.and.j==1) headstr(ihead)='MARRIED MALES: EXTRA MOMENTS'
				if (g==2.and.j==0) headstr(ihead)='SINGLE FEMALES: EXTRA MOMENTS'
				if (g==2.and.j==1) headstr(ihead)='MARRIED FEMALES: EXTRA MOMENTS'
                if (j==1) wmovebyrel=wmovemar
                if (j==0) wmovebyrel=wmovesin
				ihead=ihead+1

                
                
              do i=1,ntypp
                    do jj=1,6
                        call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0  .AND. dur(MNA:MXAD,:)==jj  .AND. dat(MNA:MXAD,:)%typ==i .and. dat(MNA:MXAD,:)%edr==1),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
				        write(name(im),'("e|u typ,durned",tr1,2i4)') i,jj
				        weights(im)=0.0_dp 
                        im=im+1 
                    end do 
                end do 

                do i=1,ntypp
                    do jj=1,6
                        call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr>=0  .AND. dur(MNA:MXAD,:)==jj  .AND. dat(MNA:MXAD,:)%typ==i .and. dat(MNA:MXAD,:)%edr==2),   d1*one( dat(MNA+1:MXA,:)%hhr==1 ),mom,cnt,var)		
				        write(name(im),'("e|u typ,dur ed",tr1,2i4)') i,jj
				        weights(im)=0.0_dp 
                        im=im+1 
                    end do 
                end do 
                
                do i=1,ntypp
			        do jj=1,6
                        call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%logwr>=0  .AND. dur(MNA:MXAD,:)==jj   .AND. dat(MNA:MXAD,:)%typ==i .and. dat(MNA:MXAD,:)%edr==1),   d1*dat(MNA+1:MXA,:)%logwr ,mom,cnt,var)		
				        write(name(im),'("w|u typ,durned",tr1,2i4)') i,jj
				        weights(im)=0.0_dp
                        im=im+1 
                    end do
                end do 
                

                do i=1,ntypp
			        do jj=1,6
                        call condmom(im,( cosexrel(MNA:MXAD,:) .AND. dat(MNA:MXAD,:)%hhr==0 .AND. dat(MNA+1:MXA,:)%hhr==1 .AND. dat(MNA+1:MXA,:)%logwr>=0  .AND. dur(MNA:MXAD,:)==jj   .AND. dat(MNA:MXAD,:)%typ==i .and. dat(MNA:MXAD,:)%edr==2),   d1*dat(MNA+1:MXA,:)%logwr ,mom,cnt,var)		
				        write(name(im),'("w|u typ,dur ed",tr1,2i4)') i,jj
				        weights(im)=0.0_dp
                        im=im+1 
                    end do
                end do 
  
                do i=1,ntypp
				    CALL condmom(im,(   cosexrel(MNA:MXAD,:) .AND.  dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA:MXAD,:)%edr==1 .AND. dat(MNA:MXAD,:)%logwr>=0  .AND. dat(MNA:MXAD,:)%typ==i ) ,d1*dat(MNA:MXAD,:)%logwr,mom,cnt,var)
				    WRITE(name(im),'("w |ned by typ",tr1,I4)') i
				    weights(im)=0.0_dp
				    im=im+1
                end do
                  
                do i=1,ntypp
				    CALL condmom(im,(   cosexrel(MNA:MXAD,:) .AND.  dat(MNA:MXAD,:)%hhr==1 .AND. dat(MNA:MXAD,:)%edr==2 .AND. dat(MNA:MXAD,:)%logwr>=0 .AND. dat(MNA:MXAD,:)%typ==i ) ,d1*dat(MNA:MXAD,:)%logwr,mom,cnt,var)
				    WRITE(name(im),'("w | ed by typ",tr1,I4)') i
				    weights(im)=0.0_dp
				    im=im+1
                end do
  
				do ia=mnaD,25,3
                    do i=1,ntypp
					    CALL condmom(im,( cosexrel(ia,:) .AND. move(ia,:)>=0 .AND. dat(ia,:)%typ==i  .AND. dat(ia,:)%edr==1 ),d1*move(ia,:),mom,cnt,var)
					    WRITE(name(im),'("mv|ned by a,tp",2I4)') ia,i
					    weights(im)=0.0_dp
					    im=im+1
                    end do
                end do            

				do ia=mnaD,25,3
                    do i=1,ntypp
					    CALL condmom(im,( cosexrel(ia,:) .AND. move(ia,:)>=0 .AND. dat(ia,:)%typ==i  .AND. dat(ia,:)%edr==2 ),d1*move(ia,:),mom,cnt,var)
					    WRITE(name(im),'("mv| ed by a,tp",2I4)') ia,i
					    weights(im)=0.0_dp
					    im=im+1
                    end do
                end do            

                
        
                
				!do ia=agestart(NOCOLLEGE),45,6 !mxai-1
                !    if ( j==0) then 
    		!			CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummove_sin(ia,:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
	        !        else if (j==1) then
    	!				CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummove_mar(ia,:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
         !           end if                    
          !          WRITE(name(im),'("inedmvrel=0 ",I2)') ia ; mominfo(0,im)=11 ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=1  ; mominfo(4,im)=0 ; mominfo(5,im)=ia
			!		weights(im)=wwagebymove ; if (onlysingles.and.j==1) weights(im)=0.0_dp
			!		im=im+1
		!		end do            
            
		!		do ia=agestart(NOCOLLEGE),45 !mxai-1
         !           if ( j==0) then 
    		!			CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummove_sin(ia,:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
            !       else if (j==1) then
    	!				CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummove_mar(ia,:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
         !           end if                    
          !          WRITE(name(im),'("inedmvrel>0 ",I2)') ia ; mominfo(0,im)=11  ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=1  ; mominfo(4,im)=1 ; mominfo(5,im)=ia
			!		weights(im)=wwagebymove ; if (onlysingles.and.j==1) weights(im)=0.0_dp
			!		im=im+1
		!		end do            

		!		do ia=agestart(COLLEGE),45 !mxai-1
         !           if ( j==0) then 
    		!			CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummove_sin(ia,:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
	         !       else if (j==1) then
    			!		CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummove_mar(ia,:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    end if                    
                !    WRITE(name(im),'("i edmvrel=0 ",I2)') ia ; mominfo(0,im)=11  ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=2 ; mominfo(4,im)=0 ; mominfo(5,im)=ia
			!		weights(im)=wwagebymove ; if (onlysingles.and.j==1) weights(im)=0.0_dp
		!			im=im+1
		!		end do            
				
		!		do ia=agestart(COLLEGE),45 !mxai-1
         !           if ( j==0) then 
    		!			CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummove_sin(ia,:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
	         !       else if (j==1) then
    			!		CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummove_mar(ia,:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    end if                    
                !    WRITE(name(im),'("i edmvrel>0 ",I2)') ia ; mominfo(0,im)=11  ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=2  ; mominfo(4,im)=1 ; mominfo(5,im)=ia
			!		weights(im)=wwagebymove ; if (onlysingles.and.j==1) weights(im)=0.0_dp
		!			im=im+1
		!		end do            
                
				!do ia=agestart(NOCOLLEGE),45 !mxai-1
                !    CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummove(:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    WRITE(name(im),'("inedmvrel=0 ",I2)') ia ; mominfo(0,im)=8 ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=1  ; mominfo(4,im)=0 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            
            
				!do ia=agestart(NOCOLLEGE),45 !mxai-1
                !    CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummove(:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    WRITE(name(im),'("inedmvrel>0 ",I2)') ia ; mominfo(0,im)=8 ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=1  ; mominfo(4,im)=1 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            

				!do ia=agestart(COLLEGE),45 !mxai-1
                !    CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummove(:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    WRITE(name(im),'("i edmvrel=0 ",I2)') ia ; mominfo(0,im)=8 ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=2 ; mominfo(4,im)=0 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            
				
				!do ia=agestart(COLLEGE),45 !mxai-1
                !    CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummove(:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    WRITE(name(im),'("i edmvrel>0 ",I2)') ia ; mominfo(0,im)=8 ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=2  ; mominfo(4,im)=1 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            
                

                
                
                
                
				!do ia=agestart(NOCOLLEGE),45 !mxai-1
                !    CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummov(ia,:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    WRITE(name(im),'("inedmvrel=0 ",I2)') ia ; mominfo(0,im)=9 ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=1  ; mominfo(4,im)=0 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            
            
				!do ia=agestart(NOCOLLEGE),45 !mxai-1
                !    CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummov(ia,:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    WRITE(name(im),'("inedmvrel>0 ",I2)') ia ; mominfo(0,im)=9 ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=1  ; mominfo(4,im)=1 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            

				!do ia=agestart(COLLEGE),45 !mxai-1
                !    CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummov(ia,:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    WRITE(name(im),'("i edmvrel=0 ",I2)') ia ; mominfo(0,im)=9 ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=2 ; mominfo(4,im)=0 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            
				
				!do ia=agestart(COLLEGE),45 !mxai-1
                !    CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummov(ia,:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    WRITE(name(im),'("i edmvrel>0 ",I2)') ia ; mominfo(0,im)=9 ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=2  ; mominfo(4,im)=1 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            
                
                

                            
                
                
                
				!do ia=agestart(NOCOLLEGE),45 !mxai-1
                !    if ( j==0) then 
    			!		CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummove_si(:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
	            !    else if (j==1) then
    			!		CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummove_ma(:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    end if                    
                !    WRITE(name(im),'("inedmvrel=0 ",I2)') ia ; mominfo(0,im)=10 ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=1  ; mominfo(4,im)=0 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            
            
				!do ia=agestart(NOCOLLEGE),45 !mxai-1
                !    if ( j==0) then 
    			!		CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummove_si(:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !   else if (j==1) then
    			!		CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==1 .AND. dat(ia,:)%wr>=0 .AND. nummove_ma(:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    end if                    
                !    WRITE(name(im),'("inedmvrel>0 ",I2)') ia ; mominfo(0,im)=10  ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=1  ; mominfo(4,im)=1 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            

				!do ia=agestart(COLLEGE),45 !mxai-1
                !    if ( j==0) then 
    			!		CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummove_si(:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
	            !    else if (j==1) then
    			!		CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummove_ma(:)==0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    end if                    
                !    WRITE(name(im),'("i edmvrel=0 ",I2)') ia ; mominfo(0,im)=10  ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=2 ; mominfo(4,im)=0 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do            
				
				!do ia=agestart(COLLEGE),45 !mxai-1
                !    if ( j==0) then 
    			!		CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummove_si(:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
	            !    else if (j==1) then
    			!		CALL condmom(im,(   cosexrel(ia,:) .AND.  dat(ia,:)%hhr==1 .AND. dat(ia,:)%edr==2 .AND. dat(ia,:)%wr>=0 .AND. nummove_ma(:)>0 ) ,d1*dat(ia,:)%wr,mom,cnt,var)
                !    end if                    
                !    WRITE(name(im),'("i edmvrel>0 ",I2)') ia ; mominfo(0,im)=10  ; mominfo(1,im)=g ; mominfo(2,im)=j ; mominfo(3,im)=2  ; mominfo(4,im)=1 ; mominfo(5,im)=ia
				!	weights(im)=wwage
				!	im=im+1
				!end do                          



                
                
                end do !rel
            end do !sex 
            
            

            
          
            
            end if !extramoments
        
	enddo cohort

    
    !headloc(ihead)=im; headstr(ihead)='what proportion of people does each location have?';ihead=ihead+1
	!headloc(ihead)=im; headstr(ihead)='proportion of college graduates in each location (all ages)';ihead=ihead+1
	!headloc(ihead)=im; headstr(ihead)='among all moves, what is the % that is from location j';ihead=ihead+1
	!headloc(ihead)=im; headstr(ihead)='among all moves, what is the % that is	to location j';ihead=ihead+1
	!headloc(ihead)=im; headstr(ihead)='among all moves to loc j, what is the % that is and is not a back-to-home move?';ihead=ihead+1
	!headloc(ihead)=im; headstr(ihead)='after the first move, what proportion is return to home? (all ages)';ihead=ihead+1		
	!headloc(ihead)=im; headstr(ihead)='among all people in loc j, what is the % who moved?';ihead=ihead+1		

    !if (iwritegen==1) then ; print*, 'here is im-1 in get_mom',im-1 ; end if 
	!if ( (.not.chkstep).and.(.not.optimize) ) print*, 'here is im-1 in get_mom',im-1 
	end subroutine get_mom
	end module mom

	
	

module objf
	use params
	use sol, only: solve
	use mom
	implicit none 
	!include 'mpif.h'
	real(dp) :: q_save(numit),qcont_save(nmom,numit)
	real(dp), dimension(npars,numit) :: par_save,realpar_save
	real(dp), dimension(nmom,numit) :: momdat_save,momsim_save,vardat_save
	integer(i4b), dimension(nmom,numit) :: cntdat_save,cntsim_save
	character(len=namelen), dimension(nmom) :: name
	character(len=120), dimension(nmom) :: header
	integer(i4b), dimension(nmom) :: headerloc
contains
	subroutine objfunc(parvec,objval)
	! puts everything together: takes the parameter vector, computes msm objective function at that value
	real(8), dimension(npars), intent(in) :: parvec	
	real(8), intent(out) :: objval					
	real(8), dimension(npars) :: realparvec
	type(initcond), dimension(ndata) :: init
	type(statevar), dimension(:,:), allocatable :: dat
	real(dp), dimension(nmom), save :: momdat,vardat    !deljan03
	integer(i4b), dimension(nmom), save :: cntdat       !deljan03
	real(dp), dimension(nmom) :: momsim,varsim,mymom,myvar,msm_wgt,momwgt,qcont
	integer(i4b), dimension(nmom) :: cntsim,mycnt
	integer(i4b), parameter :: datcountbar=10 !ahu jan19 010219 changing from 20 to 10 in order for emp at age 18 to count (thereis only 12 in that cell) because it identifies offer rates
	real(dp) :: time(10),mutemp1,mutemp2,mutemp3
    real(4) :: timing(6)
	integer(i4b) :: i,t,mycommrank,mpierr   
    
    !initiate
	objval=-99.0_dp
    realparvec=-99.0_dp
    momsim=-99.0_dp
    varsim=-99.0_dp
    mymom=-99.0_Dp
    myvar=-99.0_dp
    msm_wgt=-99.0_dp 
    momwgt=-99.0_dp 
    qcont=-99.0_dp    
    cntsim=9999
    mycnt=9999
    
	time(1)=secnds(0.0)
    
    if (groups) then 
        nindex=nin
    else 
        nindex=ninp
    end if 
    allocate( decm0_s(nepsmove,nqs,nxs,nqs,mna:mxa,nindex),decf0_s(nepsmove,nqs,nxs,nqs,mna:mxa,nindex))
    allocate(decm_s(nepsmove,nqs,nxs,nqs,mna:mxa,nindex),decf_s(nepsmove,nqs,nxs,nqs,mna:mxa,nindex))
	allocate(vm(nepsmove,nqs,nxs,nqs,mna:mxa,nindex),vf(nepsmove,nqs,nxs,nqs,mna:mxa,nindex))
    allocate(dec_mar(nz,nq,nx,mna:mxa,nindex))
	allocate(vm0_c(nq,nx,mna:mxa,nindex),vf0_c(nq,nx,mna:mxa,nindex))
      
	call getpars(parvec,realparvec) 
    parsforcheck=parvec !jusr for checking where it says emax is negative. can get rid of later.
    if (iter>1) skriv=.false.
    !if (mysay==0.and.iter==3) then 
    !    skriv=.true.
    !    print*, 'here mysay,iter ',mysay, iter
    !else 
    !    skriv=.false.
    !end if
    !if (iter==1.and.iwritegen==1) then  !ahu 121118
    !    open(unit=98799, file='parameters.txt',status='replace')
    !end if 
	!if (iwritegen==1) then ; write(98799,'("iter ",i6)') iter ; end if  !ahu 121118
	!if (iwritegen==1) then !ahu 121118
    !    do i=1,npars
    !        write(98799,*) parvec(i)
    !    end do 
    !    write(98799,*)
    !end if
    !if (iter==1.and.iwritegen==1) then  !ahu 121118
    !    open(unit=987991, file='paros.txt',status='replace')
    !    do i=1,npars
    !        write(987991,'(1a15,f14.4)') parname(i),realparvec(i)
	!    end do 
    !    close(987991)
    !end if
    
    
	if (iter==1) then 
		best=huge(1.0_dp)
		momdat_save=0.0_dp
		vardat_save=0.0_dp
		cntdat_save=0
		momsim_save=0.0_dp
		cntsim_save=0
		qcont_save=0.0_dp
		q_save=0.0_dp
		par_save=0.0_dp
		realpar_save=0.0_dp
	end if 		
	if (iter<=numit) then
        !initiate
        momdat=-99.0_dp ; vardat=-99.0_dp ; cntdat=9999
		call getones                !ones
		call getdistpop	            !distance and popsize	
		call getq2q					! trans btw couple and single state space
		call getx2x					! trans btw couple and single state space
		call getch_single			! choice set cond on state variable and shock for singles
		call getch_couple			! choice set cond on state variable and shock for singles
		allocate(dat(mnad:mxa,ndata))
		call read_actualdata(init,dat)
		!  calculate moments from data, store in datamoments
		!  momentname,momentheaders,headerlocs,weights will be filled in when calculate moments from simulations
		!  so that they're not all floating around as globals. loaded into temporary variables here
		call get_mom(dat,ndata,momdat,cntdat,vardat,name,header,headerloc,momwgt)
        !print*, name(70),momdat(70),cntdat(70)
        do i=1,nmom
            if (calcvar(i)==1) then 
                if ( cntdat(i) > 0) then
                    mutemp1=momdat(i)       !/cntdat(i)
                    mutemp2=momdat(i+1)     !/cntdat(i+1)
                    momdat(i)= mutemp1   
                    momdat(i+1)= mutemp2  - mutemp1**2
                end if 
            else if (calcorr(i)==1) then 
                if ( cntdat(i) > 0) then
                    mutemp1=momdat(i)   !/cntdat(i)
                    mutemp2=momdat(i+1) !/cntdat(i+1)
                    mutemp3=momdat(i+2) !/cntdat(i+2)
                    momdat(i)= mutemp1
                    momdat(i+1)= mutemp2                    
                    momdat(i+2)= mutemp3 - mutemp1 * mutemp2   
                end if 
            end if
        end do 
		deallocate(dat)
	end if 
	call getgauss
	call getppsq 
	call getppcq
	call getppsx 
	call getppcx
	call getppmeet    
    
    
	if (skriv) call yaz0	
    timing(1)=secnds(0.0)
    call solve		
    timing(2)=secnds(timing(1))
    timing(3)=secnds(0.0)
    allocate(dat(mnad:mxa,nsim)) !ag 110416: this is allocated mna-1 rather than mna because simulation is changed to have sim(ia-1,r) at the beginning of the sim loop rather than sim(ia,r) in order to not have 0 emp at age 18
	call simulate(init,dat)
    timing(4)=secnds(timing(3))
    timing(5)=secnds(0.0)    
    if (groups) then 
		call get_mom(dat,nsim,mymom,mycnt,myvar,name,header,headerloc,momwgt)
        !deljan03
        !if ( mysay==0.and.iter==3) then 
        !    do i=1,nmom
        !        write(*,'("i,mymom,momdat,mycnt,q ",I4,2F10.2,I8,F10.2)') i,mymom(i),momdat(i),mycnt(i),q
        !    end do
        !end if        
        !deljan03
	else
		call get_mom(dat,nsim,momsim,cntsim,varsim,name,header,headerloc,momwgt)
	end if 
	deallocate(dat)
    timing(6)=secnds(timing(5))
	if (groups) then 
		call mpi_comm_rank(comm,mycommrank,mpierr)
		call mpi_allreduce(mycnt,cntsim,nmom,mpi_integer,mpi_sum,comm,mpierr)
		call mpi_allreduce(mymom*mycnt,momsim,nmom,mpi_real8,mpi_sum,comm,mpierr)
        !deljan03
        !if ( mysay==0.and.(iter==3.or.iter==2)) then         
        !    do i=1,nmom
        !        write(*,'("mysay,iter,i,momsim,momdat,cntsim,q ",2I4,I8,2F10.2,I8,F10.2)') mysay,iter,i,momsim(i),momdat(i),cntsim(i),q
        !    end do
        !end if 
        !deljan03        
        !print*, 'mygroup,mysay,mycnt,cntsim',mygroup,mysay,mycnt(112),cntsim(112)
	end if 

    !allocate(Iamtrying(mna:mxa))
    !Iamtrying=2
    !Iamtrying(mxa)=1
    !print*, 'Here it is',Iamtrying(1),Iamtrying(mxa)
    !deallocate(Iamtrying)
    
	do i=1,nmom
		!if (vardatamom(im)>0d0.or.countdatamom(im)>=datacountbar) !this "or" does not make any sense! !cohabitation correction 
		if (vardat(i)>0.0_dp .and. cntdat(i)>=datcountbar ) then
			msm_wgt(i)=vardat(i)**(-1) !1.0_dp ahu 041219    !AHU JAN19 012919
		else 
			msm_wgt(i)=0.0_dp
		end if 
		if (groups) then 
            if (calcvar(i)==0 .and. calcorr(i)==0 ) then
                if ( cntsim(i) > 0) then
				    momsim(i)=momsim(i)/cntsim(i)		!else ; simom(i)=0.0_dp  
                end if 
            else if (calcvar(i)==1) then 
                if ( cntsim(i) > 0) then
                    mutemp1=momsim(i)/cntsim(i)
                    mutemp2=momsim(i+1)/cntsim(i+1)
                    momsim(i)= mutemp1   
                    momsim(i+1)= mutemp2  - mutemp1**2
                end if 
            else if (calcorr(i)==1) then 
                if ( cntsim(i) > 0) then
                    mutemp1=momsim(i)/cntsim(i)
                    mutemp2=momsim(i+1)/cntsim(i+1)
                    mutemp3=momsim(i+2)/cntsim(i+2)
                    momsim(i)= mutemp1
                    momsim(i+1)= mutemp2                    
                    momsim(i+2)= mutemp3 - mutemp1 * mutemp2   
                end if 
            end if
		end if 
	end do
	qcont=momwgt*msm_wgt*(momdat-momsim)**2
	objval=sum(qcont) 
    !if (iter==1) print*, 'my name is ',mysay,' and iwritegen is ',iwritegen
	if (iwritegen==1) then ; write(*,'("iter,obj: ",i6,f20.2,3f14.2)') iter,objval,timing(2),timing(4),timing(6) ; end if  
	!ahu 0317 write(*,'("iter,obj: ",3i6,f20.2,3f14.2)') mygroup,mysay,iter,q,timing(2),timing(4),timing(6)  
    
	! save the moments and objective function values from the first iteration, for comparison to the later ones: 
	t=min(numit,iter)       ! ahu 030517: will always have numit at most 2 (i.e.1 or 2). if you want more comparisons (i.e. numit>2) you have to change this. 
                            ! if numit is 1 and this is coded as t=min(2,iter), then we get out of bounds run time error for momdat_save(.,t) etc.
                            ! so be careful. but setting t=min(numit,iter) should solve that problem and also never having t=iter case as in the if statement below.
    !if (optimize .or. chkstep) then 
	!	t=min(numit,iter)
	!else 
	!	t=iter
	!end if 
	!if (t>numit) then ; print*, "error: iter>numit!!!" ; stop ; end if 
	momdat_save(:,t)=momdat
	vardat_save(:,t)=vardat
	cntdat_save(:,t)=cntdat
	momsim_save(:,t)=momsim
	cntsim_save(:,t)=cntsim
	qcont_save(:,t)=qcont
	q_save(t)=objval
	par_save(:,t)=parvec 
	realpar_save(:,t)=realparvec
	if (iwritegen==1) then
		i=maxloc(abs(par_save(:,t)-par_save(:,1)),1)
	    write(63,'(i4,". ",1a20,2f20.2,4f14.4)') i,parname(i),q_save(1),q_save(t),par_save(i,1),par_save(i,t),realpar_save(i,1),realpar_save(i,t)
    end if 
	if ((.not.optimize).or.(optimize.and.objval<best)) then	
		best=objval
		if (iwritegen==1) call writemoments(objval) 
	end if 
    
    deallocate(decm0_s,decf0_s)
    deallocate(decm_s,decf_s)
    deallocate(vm,vf)
    deallocate(dec_mar)
    deallocate(vm0_c,vf0_c)
    
	iter=iter+1	
	end subroutine objfunc

	! subroutine to be called by parallel simplex optimization whenever it's time to check if have new best point
	! note that called by master. master will have current vale of 'best' from the last time this was called.
	subroutine writebest(parvector)
		real(dp), dimension(npars), intent(in) ::parvector ! transformed vector of parameters
		integer :: i
		!if (qwrite<best) then
			write(61,*) 'Found a better point'
			do i=1,npars ; write(61,*) parvector(i) ; end do
			open(unit=66,file='bestpar.txt',status='replace')
			do i=1,npars ; write(66,*) parvector(i) ; end do
			close(66)
		!end if 
	end subroutine

	subroutine writemoments(objval)
	real(8), intent(in) :: objval
	integer(i4b) :: i,t,ihead,j,k,trueindex
	open(unit=60, file=momentfile,status='replace')
    !open(unit=61 change this 61 to another number since bestval is also 61 maybe among other things, file=momentonlyfile,status='replace')
	do i=1,npars
		!write(60,'(1a15,4f12.4)') parname(i),realpar_save(i,1:4)
        write(60,'(1a15,2f10.2)') parname(i),realpar_save(i,1:numit)
	end do 
    write(60,*)
    write(60,'(tr2,"np",tr1,"np1",tr1,"np2",tr2,"nl",tr1,"neduc",tr2,"nexp ",tr2,"nkid",tr5,"nqs",tr6,"nq",tr6,"nx",tr5,"nxs")') 
	write(60,'(4i4,3(2x,i4),4i8)') np,np1,np2,nl,neduc,nexp,nkid,nqs,nq,nx,nxs
	write(60,*) 
	write(60,'(tr2,"nz",tr2,"nh",tr1,"ncs",tr2,"nc",tr5,"ndata",tr3,"nsimech",tr6,"nsim",tr2,"ndataobs",tr6,"nmom")') 
	write(60,'(4i4,5i10)') nz,nh,ncs,nc,ndata,nsimeach,nsim,ndataobs,nmom
	write(60,*) 
	write(60,'("wage grid w:")')    !     tr6,"m(1)",tr6,"m(2)",tr6,"m(3)",tr6,"m(4)",tr6,"m(5)",tr4,"h(1)",tr4,"h(2)")') 
	write(60,*) wg(:,1)   !       ,mg(:),hgrid(:)
	write(60,*) 
    write(60,*) wg(:,2)
	write(60,*) 
	write(60,'("wage grid weights wgt:")')    
	write(60,*) wgt(:)    
    write(60,*)
    write(60,'("moveshock grid:")')    
	write(60,*) moveshock_m(:)          
	write(60,*) moveshock_f(:)          
    write(60,*)
    write(60,'("ppso:")')    
	write(60,*) ppso(:)    
    write(60,*)
    write(60,'("mar grid:")')    
	!write(60,*) mg(:,1)          
	!write(60,*) mg(:,2)          
	!write(60,*) mg(:,3)          
	!write(60,*) mg(:,4)  
    !do trueindex=1,ninp
    !    call index2cotyphome(trueindex,i,j,k)
	!    write(60,*) "trueindex,co,typ,home",trueindex,i,j,k
    !    write(60,*) mg(:,trueindex) 
    !end do 
   ! write(60,*)
    write(60,*)
    write(60,'("mar grid weights wgt:")')    
	write(60,*) mgt(:)    
    write(60,*)
    write(60,'("hgrid:")')    
	write(60,*) hgrid(:)          
    write(60,*)
    write(60,'("wgts:  ",1("move",tr4,"hour",tr4,"wage",tr4),tr1,"rel",tr5,"kid")') 
	write(60,'(3x,f8.2,5f8.2)') wmove,whour,wwage,wrel,wkid
	write(60,*) 
	write(60,'(tr2,"groups",tr3,"nhome",tr2,"nhomep",tr2,"onlysingles",tr2,"optimize",tr3,"chkstep",tr5,"skriv",tr1,"numit")') 
	write(60,'(2x,L6,2(3x,I4),7x,L6,3(4x,L6),I6)') groups,nhome,nhomep,onlysingles,optimize,chkstep,skriv,numit
	write(60,'(tr2,"nonneg",tr2,tr10,"eps2",tr11,"eps",tr5,"nonlabinc")') 
	write(60,*) nonneg,eps2,eps,nonlabinc
    write(60,*)
    write(60,'("objective function:")') 
	write(60,*) q_save(:)
	write(60,*) 
    write(60, '(35x,tr7,"sim",tr7,"dat",tr7,"obj",tr7,"dif",5x,tr2,"countsim",tr2,"countdat",tr4,"vardat" )' ) 
    ihead=1   
    do i=1,nmom
		if (headerloc(ihead)==i) then
			write(60,*)
            write(60,*)
			write(60,'(a120)') header(ihead)
			ihead=ihead+1
		end if
		do t=1,numit
            if (condmomcompare) then
                if (t<=2) then
    			    !write(60,'(1i5,". ",1a23,4f10.4,5x,2i10,f10.4)')	i,name(i),momsim_save(i,t),momdat_save(i,t),qcont_save(i,t),qcont_save(i,t)-qcont_save(i,1),cntsim_save(i,t),cntdat_save(i,t),vardat_save(i,t)
                else 
                    !write(60,'(1i5,". ",1a23,4f10.4,5x,2i10,f10.4)')	i,name(i),momsim_save(i,t),momdat_save(i,t),qcont_save(i,t),qcont_save(i,t)-qcont_save(i,3),cntsim_save(i,t),cntdat_save(i,t),vardat_save(i,t)
                end if 
            else 
                write(60,'(2i5,". ",1a23,2F14.4,2f14.4,5x,2i10,f14.4)')	i,t,name(i),momsim_save(i,t),momdat_save(i,t),qcont_save(i,t),qcont_save(i,t)-qcont_save(i,1),cntsim_save(i,t),cntdat_save(i,t),vardat_save(i,t)
                !write(61,'(8i5,2f20.4)')	i,t,mominfo(0:5,i),momsim_save(i,t),momdat_save(i,t)
            end if 
        end do
		!write(60,*)
	end do
	close(60)
    !close(61)
	end subroutine writemoments
end module objf

!msm_weights(im)=(countdatamom(im)**2)*vardatamom(im)**(-1) ! weighting vector (main diagonal of diaginal weighting matrix)
!making a slight modification to the above. multiplying by (n1/n)**2 rather than n1**2 (where n1 is the countdatamom of first moment here). 
!otherwise the weights blow up, as countdatamom is usually in the thousands.   
!ahu 073112 msm_weights(im)=(real(countdatamom(im))/real(ndata))*vardatamom(im)**(-1) ! weighting vector (main diagonal of diaginal weighting matrix)
!ahu 081912 msm_weights(im)=(1d0/real(ndata))*vardatamom(im)**(-1) !ahu 073112
!ahu 061813 msm_wgt(i)=1.0_dp !(real(countdatmom(i))/real(ndata))*vardatmom(i)**(-1) 
!ahu 061713 msm_wgt(i)= (real(countdatmom(i))/real(ndataobs))  *  ( vardatmom(i)**(-1) ) !ahu 061413. now using ndataobs instead of ndaata. need to check this stuff. still! 

!	if (iwritegen==1 .and. optimize .and. (obj<best.or.chkobj==2)) then
!		write(61,*) 'found a better point', obj
!		do i=1,npars ; write(61,'(f15.10)') parvec(i) ; end do
!		open(unit=66,file='parbest.txt',status='replace')
!		do i=1,npars ; write(66,'(f15.10)') parvec(i) ; end do
!		close(66)
!		best=obj	
!	end if 

		!if (datmom(i)<0.01_dp) then 
		!		datmom(i)=1000.0_dp *datmom(i)
		!		simom(i)=1000.0_dp *simom(i)
		!else if (datmom(i)>=0.01_dp.and.datmom(i)<=0.1_dp) then 
		!		datmom(i)=100.0_dp *datmom(i)
		!		simom(i)=100.0_dp *simom(i)
		!else if (datmom(i)>0.1_dp.and.datmom(i)<=1.0_dp) then 
		!		datmom(i)=10.0_dp *datmom(i)
		!		simom(i)=10.0_dp *simom(i)
		!else if (datmom(i)>4.0_dp) then 
		!		datmom(i)=0.1_dp *datmom(i)
		!		simom(i)=0.1_dp *simom(i)
		!end if 
!what are all these compile options?
!#mpif90 -O3 -fPIC -unroll -ip -axavx -xsse4.2 -openmp -vec-report -par-report -openmp-report -o train.x program.f90
!mpif90 -O3 -fPIC -unroll -ip -axavx -xsse4.2 -openmp -vec -par -openmp -o train.x program.f90
!#mpif90 train.x program.f90
	
program main 
	use params !, only: myid,iter,parname,npars,stepmin
	use objf
	use pnelder_mead  
    
	!use alib, only: logitinv
	implicit none	
	!include 'mpif.h'
	real(8), dimension(npars) :: pars1,pars2,pars3
	integer, parameter :: nj=10,nj2=2*nj
	integer :: i,j,k,pp,ierror,k1,k2
	! declarations for simulated annealing: at temperature t, a new point that is worse by an amount will be accepted with probability exp(-q/t)
	real(8) :: pars(npars),qval,incr,realpars(npars),realpars1(npars),val
	real(sp) :: q1val(nj2),step(nj2),lb,ub
	integer, parameter :: maxfcn=8000	!ahu 121918		! max number of function calls
	integer :: iwriteminim,ind(1)
	real(8), parameter :: stopcr=0.01_dp			! convergence criterion
	integer, parameter :: nloop=npars,iquad=0			
	real(8), parameter :: simp=0.0_dp
	real(8) :: var(npars)
	integer :: ifault,track(npars)
	!ahu 121818: the below are no longer declared as parameters. their value is set below in the program. 
    real(8) :: tstart !=15. 			! starting temperature (set to zero to turn off simulated annealing)
	real(8) :: tstep !=0.8			! fraction temperature reduced at each step
	integer :: tfreq !=30			! number of function calls between temperature reductions
	integer :: saseed !=1			! seed for random numbers
	!ahu 121818: the above are no longer declared as parameters. their value is set below in the program. 
    
    ! for the new sa routine that does grouping
	integer, dimension(0:ninp-1) :: myhomes != (/ 1,2,3,4,5,6,7,8,9 /) !,1,2,3,4,5,6,7,8,9 /)              ! types !mytyps = (/1,1,2,2/)
	integer, dimension(0:ninp-1) :: mytyps  != 1 !(/ 1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2 /)              ! types 
	integer, dimension(0:ninp-1) :: mycos != 1
	!integer, dimension(0:ninp-1) :: myindexs != (/ 1,2,3,4,5,6,7,8,9 /)  !,10,11,12,13,14,15,16,17,18 /)    ! types    !mytyps = (/1,1,2,2/)
	! keep track of time 
	real(4):: begintime,runtime
	real(8) :: temp
	integer :: numgroup,numworld,iam,mygrank0 !mygrank,ngroups,mygroup,nprocs_world,iam
	integer :: mpi_group_world,mygsize
	integer :: mpierr,mpistat(mpi_status_size)

	call mpi_init(mpierr)
	call mpi_comm_rank(mpi_comm_world,iam,mpierr)
	call mpi_comm_size(mpi_comm_world,numworld,mpierr)
	print*, "numworld,Iam ", numworld,iam
    mysay=iam
	conditional_moments=.true.		

   
	if (groups) then 	
		if (mod(numworld,ninp)>0) then ; print*, "numworld needs to be a multiple of ninp " ; end if 

		numgroup=int(numworld/ninp)		!number of groups  36/18=2 
		mygroup=mod(iam,numgroup) ! which group each process belongs to: myid mygroup: 0 0 / 1 1 / 2 0 / 3 1 / 4 0 / 5 1 / ..... / 34 0 / 35 1 
		mygrank=int(iam/numgroup) !id within group: myid mygroup: 0 0 / 1 0 / 2 1 / 3 1 / 4 2 / 5 2 / 6 3 / 7 3 / 8 4 / 9 4 / ..../ 34 17 / 35 17 
        !ahu 0317: BEWARE OF DOING THINGS LIKE BELOW. IF OYU SET THE MYGROUP THE WAY IT IS DONE BELOW THEN THE FUNCTION_DISTRIBUTE 
        !WILL NOT WORK PROPERLY. WHY? BEACAUSE MPI_BCAST DOES NOT DO WHAT IT SHOULD DO IN THIS CASE. 
        !BECAUSE THEN FOR I=1,NPROCS WHERE NPROCS IS THE NUMBER OF GROUPS, FOR I=1, THE ROOT PROCESS IS 0 AND FOR I=2, THE ROOT PROCESS IN BCAST IS 1. 
        !IF YOU DO BELLOW, WHEN BCAST SAYS SEND VALUE FROM ROOT PROCESS 1 TO EVERYONE, IT DOES NOT TAKE ROOT PROCESS 1 TO BE THE PROCEESSSES IN GROUP 2 
        !BUT IT JUST TAKES IT TO BE THE PROCESSOR WITH IAM=1. SO THEN WHEN YOU'RE GOING THROUGH I=1,NPROCS IN THE BCAST PART OF FUNCTION_DISTRIBUTE
        !YOU ARE NOT ACTUALLY GOING THROUGH GROUPS. 
        !BUT IF YOU DO THE ABOVE SETTING OF MYGROUP, THEN THE TWO ARE EQUIVALENT SINCE THE IAM'S ALSO CORRESPOND TO GROUP NUMBERS. (JUST DUE TO THE WAY MYGROUP IS SET)
        !numgroup=int(numworld/ninp)		!number of groups  36/18=2
        !mygroup=int(iam/ninp) ! which group each process belongs to: myid mygroup: 0 0 / 1 0 / 2 0 / 3 0 / 4 0 /.../17 0 / 18 1 /...../35 1 
		!mygrank=mod(iam,ninp) !id within group: myid mygroup: 0 0 / 1 1 / 2 2 / 3 3 / 4 4 / 5 5 / 6 6 / 7 7 / 8 8 ..../ 17 17 / 18 0 / 19 1 / ..../35 17 
       
        call mpi_comm_split(mpi_comm_world,mygroup,mygrank,comm,mpierr)
        !ahu 0317 call mpi_comm_split(mpi_comm_world,mygroup,iam,comm,mpierr) !ahu 0317
        !print*, "after split ", iam
        !call MPI_Comm_rank(comm, mygrank,mpierr) !ahu 0317
        !print*, "after rank ", iam
        !call MPI_Comm_size(comm, mygsize,mpierr) !ahu 0317
        !print*, "after size ", iam
        !if (mygrank0.ne.mygrank) then 
        !    print*, 'The two ways of calculating mygrank are not equal'
        !    stop
        !end if 
        write(*,'("iam,numgroup,mygroup,mygrank,mygsize:")') !ahu 0317
        write(*,'(5i4)') iam,numgroup,mygroup,mygrank,mygsize !ahu 0317
        
        pp=0
        do i=1,ncop
            do j=1,ntypp
                do k=1,nhomep
                    mycos(pp)=i
                    mytyps(pp)=j
                    myhomes(pp)=k
                    !myindexs(pp)=pp
                    pp=pp+1
                end do 
            end do 
        end do 
        if ( (pp-1).ne.(ncop*ntypp*nhomep-1)) then
            print*, 'something wrong with pp',pp,ncop*ntypp*nhomep
            stop
        end if
        if (iam==0) then 
            write(*,'("mycos,mytyps,myhomes,myindexs")') 
            if (ntypp==1) then 
                write(*,'(9I4)') mycos
                write(*,'(9I4)') mytyps
                write(*,'(9I4)') myhomes
                !write(*,'(9I4)') myindexs
            else if (ntypp==2) then
                write(*,'(18I4)') mycos
                write(*,'(18I4)') mytyps
                write(*,'(18I4)') myhomes
                !write(*,'(18I4)') myindexs
            end if
        end if
		
		!myindex = myindexs(mygrank)
		myco   = mycos(mygrank)
		mytyp  = mytyps(mygrank)
		myhome = myhomes(mygrank)
	else 
		numgroup=0 ; mygroup=0 ; mygrank=0 ; myco=0 ; mytyp=0 ; myhome=0
    end if
	begintime=secnds(0.0)
    iter=1
	iwritegen=0
	if (iam==0) iwritegen=1
	if (iam==0.and.optimize) then 
		open(unit=61, file='bestval.txt',status='replace')
	end if 
	if (iam==0.and.iwritegen==1) then						! ahu april13: to check how much objval changes with each stepsize and make sure that the objval changes by similar amounts when changing each parameter. otherwise the simplex does weird things. and also to check how much the pminim routine changes objval with each iteration during estimation but the latter is not as important. 
		open(unit=63, file='chkobj.txt',status='replace')	
	end if 
	if (iam==0.and.chkstep) then 
		open(unit=64, file='chkstep.txt',status='replace')
		open(unit=65, file='step.txt',status='replace')
	end if 
	if (iam==0.and.comparepars) then 
		open(unit=64, file='chkstep.txt',status='replace')
	end if     
	skriv=.false. ; if (iam==24.and.iter==1) skriv=.false.  !ahu 0327 iam=9
    if (.not.groups) skriv=.true. !ahu 0327
    iwritemom=0 ; if (iam==0) iwritemom=1 
	if (skriv) then 	
		open(unit=12, file='chkdat.txt',status='replace')		
		open(unit=40,file='chkq.txt',status='replace') 
		open(unit=50,file='chk0.txt',status='replace') 
		open(unit=100,file='chk1.txt',status='replace')
		open(unit=200,file='chk2.txt',status='replace')
		!open(unit=300,file='chk3.txt',status='replace')		
        open(unit=400, file='chk4.txt',status='replace')		
		open(unit=500, file='chksimpath.txt',status='replace')		
        open(unit=88881, file='chkwage.txt',status='replace') 
        open(unit=56789, file='chktemp.txt',status='replace')
	end if 
	!call cohab_stderr(parvector,stepsize,stderrs)

!041618: STARTING NEW ESTIMATION NOW AFTER A 1 YEAR HIATUS! THE BELOW ARE AFTER TRIALS OF EPS2 PROBLEMS AND TRYING TO FIGURE OUT MOVE FOR MAR RATES ETC.
    !    nonlabinc=0.0_dp   !MAKE IT SO THAT THIS IS SET AT PARAMS
    !    nonneg=.TRUE.      !MAKE IT SO THAT THIS IS SET AT PARAMS
    !    eps2=eps           !MAKE IT SO THAT THIS IS SET AT PARAMS
    
!open(unit=2,file='bestpar041818.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
!        pars1(12)=-0.1_dp     !pmeet
!open(unit=2,file='bestpar090618.txt',status='old',action='read') ; read(2,*) pars	; close(2)
!open(unit=2,file='bestpar110618.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
!open(unit=2,file='bestpar112618.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
!open(unit=2,file='bestpar121018.txt',status='old',action='read') ; read(2,*) pars	; close(2)
!open(unit=2,file='parnew_121118.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
!open(unit=2,file='bestpar121518.txt',status='old',action='read') ; read(2,*) pars	; close(2)
!open(unit=2,file='par121718.txt',status='old',action='read') ; read(2,*) pars	; close(2)
!open(unit=2,file='bestpar121718s.txt',status='old',action='read') ; read(2,*) pars	; close(2)
!pars(22:23)=-2.3_dp
!pars(29)=-3.0_dp !alphaed(m ed)
nonneg=.TRUE.
nonlabinc=(/ 300.0_dp,1100.0_dp /) 

!open(unit=2,file='bestpar121818_ntyp1_sigo.txt',status='old',action='read') ; read(2,*) pars	; close(2)
!open(unit=2,file='bestpar121918_1.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
!open(unit=2,file='bestpar121918_2.txt',status='old',action='read') ; read(2,*) pars	; close(2)
!open(unit=2,file='bestpar122118_ntypp1.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
!open(unit=2,file='bestpar122118_ntypp4.txt',status='old',action='read') ; read(2,*) pars2	; close(2)
!open(unit=2,file='parnew122118.txt',status='old',action='read') ; read(2,*) pars	; close(2)
!open(unit=2,file='bestpar122318_xtramom.txt',status='old',action='read') ; read(2,*) pars	; close(2)
!pars(20)=-1.0_dp !pkid because not iterating on pkid when onlysingles because the kid moments by age for singles looks weird in the data (see in get_mom the note)

!open(unit=2,file='bestpar122318_wgt0.txt',status='old',action='read') ; read(2,*) pars	; close(2)
!pars(20)=-1.0_dp !pkid because not iterating on pkid when onlysingles because the kid moments by age for singles looks weird in the data (see in get_mom the note)
!pars(75)=-0.05_dp
!pars(81)=-0.01_dp
!pars(87)=0.01_dp
!pars(93)=0.03_dp


!open(unit=2,file='bestpar122818.txt',status='old',action='read') ; read(2,*) pars	; close(2)
pars(21)=-1.2_dp    !pmeet
pars(75)=pars(93)
pars(93)=pars(81)
!pmeet
pars(21)=-1.6_dp
!psih(1)
pars(16)=-1.0_dp 
pars(17)=1.0_dp
pars(18)=1.0_dp
pars(19)=-1.0_dp
!mumar
pars(75)=0.00001_dp
pars(81)=0.0005_dp
pars(87)=0.5_dp
pars(93)=1.0_dp
!ptype
pars(70:71)=0.0_dp 
pars(76:77)=0.0_dp
pars(82:83)=0.0_dp
pars(88:89)=0.0_dp

pars(29)=pars(27)

 !   pars(90)=-1.0_dp

!open(unit=2,file='bestpar010119.txt',status='old',action='read') ; read(2,*) pars2	; close(2)


!open(unit=2,file='bestpar122318_wgt1.txt',status='old',action='read') ; read(2,*) pars2	; close(2)
!pars2(20)=-1.0_dp !pkid because not iterating on pkid when onlysingles because the kid moments by age for singles looks weird in the data (see in get_mom the note)


!open(unit=2,file='bestpar011119.txt',status='old',action='read') ; read(2,*) pars2	; close(2)


    if (icheck_eqvmvf) then
		pars(3)=pars(2)
		pars(8)=pars(7)
		pars(10)=pars(9)
		pars(34:45)=pars(22:33)
		pars(47)=pars(46)
		pars(59:60)=pars(57:58)
		pars(53:56)=pars(49:52)
	end if 	
	if (icheck_eqvcvs) then 
		pars(1)=-huge(0.0)       ! sig_mar
		pars(6)=-huge(0.0)       ! divpenalty
		pars(npars)=0.0_dp          ! mu_mar
	end if 
    
    
	!call getsteps(pars,parname,stepmin)
    !stepmin=0.0 !ahu 0317
    !stepmin(2:15)=0.5 !ahu 0317
    !stepmin(22:45)=0.0_dp !ahu 041818 not iterating on the wage function parameters except for the type ones
    !open(unit=1111,file='step110218.txt',status='old',action='read') ; read(1111,*) stepmin	; close(64) 	
    !pars(13)=3.0_dp !psil1
    !pars(14)=0.0_dp !psil2
    !pars(15)=0.0_dp !psil3
    !pars(74)=-1.0_dp
    
    !pars(16)=-3.0_dp  !psi1
    !pars(17)=0.5_dp   !psi2
    !pars(18)=-3.0_dp !psi3
    !pars(19)=0.5_dp !psi4
    !pars(52)=0.2_dp
    !pars(53)=-4.0_dp
    pars(74)=-1.2   !cst
    pars(75)=1.0_dp !mumar

!**********
pars1=pars
pars1(13)=2.5_dp
pars1(14)=0.0_dp !psil2
pars1(15)=0.0_dp !psil3
pars1(1)=0.5_dp
pars1(2)=-2.0_dp
pars1(3)=0.5_dp
pars1(4)=-2.0_dp
pars1(5)=0.5_dp
pars1(6)=-1.0_dp
pars1(7)=0.5_dp
pars1(8)=-1.0_dp
pars1(42)=pars1(42)+0.2_dp
pars1(43:44)=pars1(43:44)+0.3_dp
pars1(45:47)=pars1(45:47)+0.2_dp
pars1(48)=pars1(48)+0.2_dp
pars1(49)=pars1(49)+0.1_dp
pars1(50)=pars1(50)+0.1_dp
pars1(74)=-1.6   !cst(1)
pars1(80)=pars1(74)
pars1(86)=pars1(74)
pars1(92)=pars1(74)
pars1(75)=0.5_dp !mumar
pars1(81)=1.0_dp     
pars1(87)=1.0_dp  
pars1(93)=1.0_dp  
pars1(72:73)=0.0_dp !alf1t alf2t
pars1(78:79)=-2.4_dp     
pars1(84:85)=-1.8_dp    
pars1(90:91)=-1.2_dp    
pars=pars1
!************
pars(70:71)=0.0_dp 
pars(76:77)=0.0_dp
pars(82:83)=0.0_dp
pars(88:89)=0.0_dp
pars(72:73)=0.0_dp !alf1t alf2t
pars(78)=-0.2_dp     
pars(79)=-2.0_dp     
pars(84)=-2.0_dp    
pars(85)=-0.2_dp
pars(90)=-1.2_dp    
pars(91)=-1.2_dp
pars(75)=0.3_dp !mumar
pars(81)=0.3_dp !mumar
pars(87)=0.3_dp !mumar
pars(93)=0.3_dp !mumar
!************


pars(72:73)=0.0_dp !alf1t alf2t
pars(78)=3.0_dp     
pars(79)=-2.0_dp     
pars(84)=-2.0_dp    
pars(85)=3.0_dp
pars(90)=4.0_dp    
pars(91)=4.0_dp

    pars(66)=-4.5_dp
pars(78)=3.0_dp     
pars(79)=-2.0_dp     
pars(84)=-2.0_dp    
pars(85)=3.0_dp
pars(90)=4.0_dp    
pars(91)=4.0_dp
    
    
pars=pars2
pars(42:50)=pars(42:50)-0.4_dp
pars(78)=2.0_dp     
pars(79)=-2.0_dp     
pars(84)=-2.0_dp    
pars(85)=2.0_dp
pars(90)=2.0_dp    
pars(91)=2.0_dp
pars(52)=0.0_dp

pars(70:71)=0.0_dp 
pars(76:77)=0.0_dp
pars(82:83)=0.0_dp
pars(88:89)=0.0_dp

    pars(66)=-3.0_dp

!open(unit=2,file='bestpar011219.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    !call objfunc(pars,qval) ; realpars=realpartemp
    pars(54:62)=pars(54:62)-0.5_dp
    pars(64)=-1.0_dp
    pars(52)=-1.0_dp

!open(unit=2,file='bestpar011219_2.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
    pars1(64)=-1.0_dp
    pars1(52)=-1.0_dp
    pars1(16)=-3.0_dp  !psi1
    pars1(17)=0.5_dp   !psi2
    pars1(18)=0.5_dp !psi3
    pars1(19)=-3.0_dp !psi4
    pars1(66)=-2.0_dp
    pars=pars1


!open(unit=2,file='bestpar011319.txt',status='old',action='read') ; read(2,*) pars	; close(2)
pars(52)=-1.0_dp
pars(1)=0.5_dp
pars(2)=-2.0_dp
pars(3)=0.5_dp
pars(4)=-2.0_dp
pars(5)=0.5_dp
pars(6)=-1.0_dp
pars(7)=0.5_dp
pars(8)=-1.0_dp
pars(9:10)=1.5_dp
!for the second estimation I'm sending now: 
!pars(78:79)=pars(78:79)-2.0_dp
!pars(84:85)=pars(84:85)-2.0_dp
!pars(90:91)=pars(90:91)-2.0_dp
!open(unit=2,file='bestpar011419.txt',status='old',action='read') ; read(2,*) pars	; close(2)
pars(16)=-1.0_dp
pars(52)=-2.0_dp
!fore the first estimation: in migit
!pars(78:79)=-2.0_dp
!pars(84:85)=-1.0_dp
!pars(90:91)=0.0_dp
!for the second estimation I'm sending now: in migit2
pars(78:79)=0.0_dp
pars(84:85)=1.0_dp
pars(90:91)=2.0_dp

!open(unit=2,file='bp011519_4.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(18)=0.0_dp             !ahu jan19 011519 getting rid of probdown
    pars(19)=0.0_dp 			!ahu jan19 011519 getting rid of probdown
    !pars1=pars
    !pars1(52)=-2.0_dp
    !pars1(2)=0.1_dp
    !pars1(17)=-5.0_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp
!open(unit=2,file='bp011719.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(16)=-2.0_dp
    pars(17)=-3.0_dp
    pars(66)=-0.5_dp
    pars(74)=-3.0_dp   !cst(1)
    pars(2)=-1.0_Dp
    pars(4)=-1.0_dp 
!open(unit=2,file='bp011819_2.txt',status='old',action='read') ; read(2,*) pars1	; close(2) 
!open(unit=2,file='bp011919_2.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
    !pars1(16)=-20.0_dp
    !pars1(17)=-20.0_dp
    !PARS1(66)=-20.0_dp
    !pars1(13)=0.0_dp
!open(unit=2,file='bp012119_1.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(1)=1.0_dp
    pars(3)=1.0_dp
    pars(17)=-20.0_dp
    pars(66)=0.0_dp !sigma needs to be high in order to match the wvar at age 18 for L moments
    pars(16)=-3.0_dp
    pars(52)=-3.00_dp
!24.07 25.57 26.99
!open(unit=2,file='bp012519.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
!open(unit=2,file='bp012619.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    !mult1=20000.0_dp    
    pars(27)=-5.0_dp
    pars(51)=-100.0_dp
    !pars(33:41)=pars1(33:41)/3.0_dp
    !VERY IMPORTANT DISCOVERIES FOR RETARDED PEOPLE: 
    !pars(72)=0.5_dp
    !pars(42:50)=pars(42:50)-0.5_dp
    pars(22:23)=3000.0_dp  !when uhome is too low then all the moves happen at beginning and then nothing afterwards. changing mvecost does not help. so it has to be around 5000 currently 
    !if on average wage differences across locations is about 2K-5K then it makes sense that this is how much uhome you would need to prevent mass moves at age 17
    !because uhome gets summed up and discounted the same way as wage differences so the avg wage difference should be the same as uhome or similar in the ballpark
    pars(24)=0.0_dp    !ecst NO MORE ITERATING ON THIS SINCE NOT IDENT PROBABLY
    pars(25)=0.0_dp    !kcst NO MORE ITERATING ON THIS SINCE NOT IDENT PROBABLY    
    pars(10)=-1.0_dp
    pars(1)=-1.0_dp
    pars(2)=-3.0_dp
    pars(3)=3.0_dp
    pars(4)=-100.0_DP   !NO MORE OFLOC LAYOFF NONSENSE
    pars(8)=-100.0_DP !NO MORE OFLOC LAYOFF NONSENSE
    pars(9)=1.0_dp
    pars(33:41)=0.0_dp
    pars(42)=9.2_dp !when this is too high then that affects moving things a lot especially in beginning.the age 18:19 loc 1 wage has few people anyway
    pars(74)=0.0_dp !-200.0_dp + I*20.0_DP
    pars(66)=-3.0_dp
    pars(69)=6000.0_dp !+ 3000.0_dp*(I-1)   !sigo !0.0_dp !8000.0_dp !1000.0_dp + 700.0_dp*I   !sigo
    pars(24)=0.0_dp !0.0_dp - 3000.0_dp*(j-1)
    pars(13)=2.5_dp
    pars(69)=6000.0_dp
    !do i=1,3
    !do j=1,3
    !pars(13)=2.5_dp+0.5_dp*(j-1)
    !pars(69)=6000.0_dp+2000.0_dp*(i-1)
    !pars(74)=0.0_dp-2000.0_dp*(j-1)
    
    
    pars(33)=-2000.0_dp !changed from -9K since you don't need it that negative large when pars42 is no longer that high
    pars(35)=-1000.0_dp
    pars(36)=-300.0_dp
    pars(37)=2000.0_dp
    pars(38)=2000.0_dp
    pars(39)=-1000.0_dp
    pars(40)=2000.0_dp
    pars(41)=-2000.0_dp
    pars(51)=-0.8_dp    
    pars(16)=0.1_dp
    pars(52)=-2.8_dp
    
    !open(unit=2,file='bp031219.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
    !open(unit=2,file='bp031319.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(42)=0.0_dp
    pars(43)=-0.1_dp
    pars(44)=0.0_dp
    pars(45:49)=-0.1_dp
    pars(50)=0.1_dp
    pars(72:73)=8.75_dp !9.00_dp !8.75_dp
    !pars(76:77)=-1.0_dp
    pars(78:79)=9.9_dp !9.40_dp !9.9_dp
    open(unit=2,file='bp040219_2.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(22)=5000.0_dp
    pars(69)=7000.0_dp
    pars(13)=2.5_dp
    pars(1)=pars(1)+0.2_dp
    pars(2)=-2.0_dp    
    !NOW FEMALES 
    pars(5:8)=pars(1:4)
    pars(11:12)=pars(9:10)
    pars(23)=pars(22)
    pars(54:65)=pars(42:53)
    pars(67)=pars(66)
    pars(73)=pars(72)
    pars(79)=pars(78)
    !pars(28)=pars(27)
    !pars(32)=pars(31)
    !open(unit=2,file='bp040419_1.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(28)=pars(28)-1.0_dp
    pars(32)=pars(32)-1.0_dp
    !pars(23)=7000.0_dp 
    !open(unit=2,file='bp040419_2.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(11)=-1.0_dp    !in order to bring up eu stay
    pars(69)=10800.0_dp !in order to bring down eu move
    pars(6)=-1.3_dp     !in order to bring down ee stay

    !COMPARE MALES BEST PARAMS TO FEMALES BEST PARAMS
    open(unit=2,file='bp040219_2.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(22)=5000.0_dp
    pars(69)=7000.0_dp
    pars(13)=2.5_dp
    pars(1)=pars(1)+0.2_dp
    pars(2)=-2.0_dp    
    !NOW FEMALES 
    pars(5:8)=pars(1:4)
    pars(11:12)=pars(9:10)
    pars(23)=pars(22)
    pars(54:65)=pars(42:53)
    pars(67)=pars(66)
    pars(73)=pars(72)
    pars(79)=pars(78)
    !AG 0CT 9, 2019
    call getpars(pars,realpars)
    !call objfunc(pars,qval) ; realpars=realpartemp  
    pars(28)=pars(27)
    pars(32)=pars(31)   !ok I DIDN'T have alphakid's equal to each othe rin that estimation where I first added females. but that was intentional. 
    pars(68)=pars(69) !sigo trying to see whether fem will look same as male
    call getpars(pars,realpars)
    !call objfunc(pars,qval) ; realpars=realpartemp  

    !open(unit=2,file='bp040519_1.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    !CHANGES
    pars(15)=0.66_dp !this is ro. It was par(68) before. 
    pars(22)=16476.0_dp
    pars(68)=10475.0_dp
    !open(unit=2,file='bp040519_2.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    !pars(14)=-1000.0_dp
    !open(unit=2,file='bp040519_3.txt',status='old',action='read') ; read(2,*) pars1	; close(2)
    !pars1(14)=-1000.0_dp  
    !open(unit=2,file='bp040819_2.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(2)=-0.11_dp       
    pars(6)=-1.55_dp     
    pars(14)=0.0_dp
    pars(22)=6298.69_dp        
    pars(23)=10220.54_dp       
    pars(68)=1977.5_dp       
    pars(69)=5914.89_dp  
    !open(unit=2,file='bp041019_1.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(13)=pars(13)+0.4_dp
    pars(24)=-500.0_dp
    pars(25)=-1500.0_dp
    pars(66:67)=pars(66:67)+1.0_dp
    pars(7)=0.5_dp
    
    !pars(84:85)=pars(72:73)
    !pars(90:91)=pars(78:79)
    !open(unit=2,file='bp041019_2.txt',status='old',action='read') ; read(2,*) pars1	; close(2)

    !open(unit=2,file='bp041019_3.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(33:41)=pars(33:41)*2.0_dp
    pars(22:23)=pars(22:23)*1.5_dp
    pars(7)=-2.0_dp
    pars(66:67)=pars(66:67)-1.0_dp

    !open(unit=2,file='bp041119_1.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    !pars(74)=-1000.0_dp
    !pars(80)=-1000.0_dp
    !pars(86)=-1000.0_dp
    !pars(92)=-1000.0_dp
    
    !open(unit=2,file='bp041019_3.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    pars(7)=-2.0_dp
    pars(74)=-1200.0_dp
    pars(80)=-1200.0_dp
    pars(86)=-1200.0_dp
    pars(92)=-1200.0_dp
    pars(13)=-2.08_dp
    call getpars(pars,realpars)
    !call objfunc(pars,qval) ; realpars=realpartemp  
    
    !ahu 101119
     open(unit=2,file='bp040219_2.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    call getpars(pars,realpars)
    !call objfunc(pars,qval) ; realpars=realpartemp  
    pars(22)=5000.0_dp
    pars(69)=7000.0_dp
    pars(13)=2.5_dp
    pars(1)=pars(1)+0.2_dp
    pars(2)=-2.0_dp    
    call getpars(pars,realpars)
    !call objfunc(pars,qval) ; realpars=realpartemp  
   
     open(unit=2,file='bp041019_3.txt',status='old',action='read') ; read(2,*) pars	; close(2)
    call getpars(pars,realpars)
    call objfunc(pars,qval) ; realpars=realpartemp  

    
    
    
    stepmin=stepos !ahu 121118    
    tstart=0.0_dp !*qval !10.0_dp !
    tstep=0.0_dp !0.7_dp !0.8_dp
    tfreq=COUNT(stepmin /= zero)
    saseed=1
    !call objfunc(pars,qval) ; realpars=realpartemp  
    
  
    if (iam==0) print*, 'Here is qval,tstart,tstep,tfreq', qval,tstart,tstep,tfreq
    
    
    !do i=1,3
    !do j=1,3
    !pars(7)=pars(7)-1.0_dp
    !pars(11)=pars(11)+0.5_dp
    !pars(13)=2.5_dp-0.4_dp*i
    !pars(69)=4800.0_dp+3000.0_dp*j
    !pars(6)=pars(6)+0.5_dp
    !pars1(22)=pars1(22)+3500.0_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp 
    !end do 
    !end do 
    
    !do i=1,3
    !pars1(68)=pars1(68)+2500.0_dp
    !if (iam==0) print*, 'heres',i,pars1(22),pars1(68)
    !call objfunc(pars1,qval) ; realpars=realpartemp 
    !end do 
    

    
    !pars(69)=0.0_dp 
    !call objfunc(pars,qval) ; realpars=realpartemp    !this happens for just pars33's without the other changes too. so loc 1 is special. 

    !do i=1,3
    !do j=1,3
    !pars(22)=5000.0_dp+3000.0_dp*(i-1)
    !pars(69)=7000.0_dp+6000.0_dp*(j-1)
    !pars(13)=2.5_dp-0.3_dp*(j-1)
    !call objfunc(pars,qval) ; realpars=realpartemp    !this happens for just pars33's without the other changes too. so loc 1 is special. 
    !end do 
    !end do 
    

    !pars(2)=-2.0_dp    
    !call objfunc(pars,qval) ; realpars=realpartemp    !this happens for just pars33's without the other changes too. so loc 1 is special. 
    !pars(2)=-1.5_dp    
    !call objfunc(pars,qval) ; realpars=realpartemp    !this happens for just pars33's without the other changes too. so loc 1 is special. 

    !pars(1)=pars(1)+0.2_dp
    !pars(2)=-2.0_dp    
    !call objfunc(pars,qval) ; realpars=realpartemp    !this happens for just pars33's without the other changes too. so loc 1 is special. 
    !pars(1)=pars(1)+0.2_dp
    !pars(2)=-1.5_dp    
    !call objfunc(pars,qval) ; realpars=realpartemp    !this happens for just pars33's without the other changes too. so loc 1 is special. 


    !do j=1,2
    !pars(69)=6000.0_dp-2000.0_dp*j
    !call objfunc(pars,qval) ; realpars=realpartemp    
    !end do

    
    !pars(22)=5000.0_dp
    !pars(13)=3.5_dp
    !call objfunc(pars,qval) ; realpars=realpartemp    !this happens for just pars33's without the other changes too. so loc 1 is special. 
    
    

    !pars=pars1
    !pars(33)=pars1(33)/2.0_dp
    !pars(69)=3000.0_dp
    !call objfunc(pars,qval) ; realpars=realpartemp    this happens for just pars33's without the other changes too. so loc 1 is special. 
    !pars(69)=6000.0_dp
    !call objfunc(pars,qval) ; realpars=realpartemp    
    !pars=pars1
    !pars(33)=pars1(33)
    !pars(69)=3000.0_dp
    !call objfunc(pars,qval) ; realpars=realpartemp    
    !pars(69)=6000.0_dp
    !call objfunc(pars,qval) ; realpars=realpartemp    
    !pars=pars1
    !pars(33)=pars1(33)*2.0_dp
    !pars(69)=3000.0_dp
    !call objfunc(pars,qval) ; realpars=realpartemp    
    !pars(69)=6000.0_dp
    !call objfunc(pars,qval) ; realpars=realpartemp    

    
    
    !pars(33:41)=pars1(33:41)/10.0_dp
    !pars(69)=0.0_dp
    !call objfunc(pars,qval) ; realpars=realpartemp    
    !pars1(69)=3000.0_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp    
    !pars1(69)=6000.0_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp    

    
    
    !pars1(22)=1500.0_dp
    !pars1(69)=3000.0_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp   
    !pars1(41)=-1000.0_dp
    !pars1(38)=3000.0_dp
    !pars1(33:37)=1000.0_dp
    !pars1(38:41)=-1000.0_dp
    !pars1(33:41)=0.0_dp
    !pars1(22)=5000.0_dp
    !pars1(69)=6000.0_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp   
    !pars1(33:37)=10000.0_dp
    !pars1(38:41)=-10000.0_dp
    !pars1(69)=10000.0_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp   
    !pars1(69)=15000.0_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp   
    !pars1(69)=30000.0_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp   

    !pars1(33:41)=0.0_dp
    !pars1(22)=-10.0_dp
    !pars1(69)=0.5_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp   
    !pars1(33:41)=0.0_dp
    !pars1(22)=-3.0_dp
    !pars1(69)=0.5_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp   
    !pars1(33:41)=0.0_dp
    !pars1(22)=-2.0_dp
    !pars1(69)=0.5_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp   
    !pars1(33:41)=0.0_dp
    !pars1(22)=-1.0_dp
    !pars1(69)=0.5_dp
    !call objfunc(pars1,qval) ; realpars=realpartemp   

    

    
	if (optimize) then 
		! call simplex: the call to minim (the simplex routine) is set up to work with starting vector parvector
		!if (iam==0) then ; iwriteminim=1 ; else ; iwriteminim=-1 ; end if 
		!open(unit=64,file='step11_10.txt',status='old',action='read') ; read(64,*) stepmin	; close(64) 			
		!open(unit=64,file='step111416.txt',status='old',action='read') ; read(64,*) stepmin	; close(64) 			
        !open(unit=64,file='stepp.txt',status='old',action='read') ; read(64,*) stepmin	; close(64) 
        !stepmin=0.5_dp

        
        iwriteminim=1
		if (groups) then 
			call pminim(pars, stepmin, npars, qval, maxfcn, iwriteminim, stopcr, nloop, iquad, simp, var, objfunc, writebest,ifault,mygroup,numgroup,tstart, tstep	, tfreq, saseed)
		else 
			call pminim(pars, stepmin, npars, qval, maxfcn, iwriteminim, stopcr, nloop, iquad, simp, var, objfunc, writebest,ifault,iam,numworld,tstart, tstep	, tfreq, saseed)
		end if 
		if (iam==0) then ; print*, "out of minim now and here is ifault ", ifault ; end if 	
	else 
		!conditional_moments=.false.		
		conditional_moments=.true.	       

        !pars(6)=-0.1_dp
        !pars(68)=0.9_dp
        !pars(69)=1.3_dp
        !pars(78)=-100.0_dp
        !nonneg=.FALSE.
        !nonlabinc=(/ 300.0_dp,1100.0_dp /) 
        
        !pars(7)=-4.0_dp      !alphaed(m,noed)
        !pars(9)=-4.0_dp      !alphaed(m,ed)
        !call objfunc(pars,q) ; realpars=realpartemp        
        !pars(2)=0.8_dp
        !call objfunc(pars,q) ; realpars=realpartemp

        !sig_o=4000.0_dp
        !call objfunc(pars,qval) ; realpars=realpartemp
        !sig_o=7000.0_dp
        !call objfunc(pars,qval) ; realpars=realpartemp
        

        !pars(24)=1.5_dp
        !call objfunc(pars,q) ; realpars=realpartemp
        !pars1=pars
        !pars1(1)=1.0_dp
        !pars1(2)=-1.0_dp
        !call objfunc(pars1,q) ; realpars=realpartemp

        !nonneg=.FALSE.
        !nonlabinc=(/ 0.0_dp,0.0_dp /) 

        !mom11418_2_pmeet14:
        !pars(12)=-1.8_dp     !pmeet
        !pars(4)=0._dp     !cst(1)
        !pars(5)=0._dp     !kcst
        !pars(75)=0._dp    !cst(ntypp) 
        !pars(76)=0._dp    !ecst
        !nonneg=.TRUE.
        !nonlabinc=(/ 300.0_dp,1100.0_dp /) 
        !pars(68:69)=0.001_dp
        !call objfunc(pars,q) ; realpars=realpartemp
        !pars(68:69)=0.01_dp
        !call objfunc(pars,q) ; realpars=realpartemp
        !pars(68:69)=0.05_dp
        !call objfunc(pars,q) ; realpars=realpartemp
        !pars(68:69)=0.1_dp
        !call objfunc(pars,q) ; realpars=realpartemp
        !pars(68:69)=0.15_dp
        !call objfunc(pars,q) ; realpars=realpartemp
        !pars(68:69)=0.2_dp
        !call objfunc(pars,q) ; realpars=realpartemp

        !mom11418_3_pmeet14_alphaedhigh:
        !pars(4)=0._dp     !cst(1)
        !pars(5)=0._dp     !kcst
        !pars(75)=0._dp    !cst(ntypp) 
        !pars(76)=0._dp    !ecst
        !pars(68:69)=0.001_dp
        !call objfunc(pars,q) ; realpars=realpartemp
        !pars(68:69)=0.01_dp
        !call objfunc(pars,q) ; realpars=realpartemp
        !pars(68:69)=0.05_dp
        !call objfunc(pars,q) ; realpars=realpartemp
        !pars(68:69)=0.1_dp
        !call objfunc(pars,q) ; realpars=realpartemp
        !pars(68:69)=0.15_dp
        !call objfunc(pars,q) ; realpars=realpartemp

        !if (iam==0) then 
		!    open(unit=2225, file='chksimplex.txt',status='replace')
        !end if 
        !do i=1,npars
        !    pars1=pars
        !    pars1(i)=pars(i)+stepmin(i)
        !    call objfunc(pars1,val) ; realpars1=realpartemp
        !    if (iam==0) then 
        !        write(2225,*)
        !        write(2225,*)
        !        write(2225,'(tr3,"i",tr3,"j",tr2,"iter",2x,tr20,tr13,"q",tr9,"q1(j)",tr6,"pars",tr5,"pars1",5x,tr6,"realpars",5x,tr5,"realpars1",5x,tr3,"step(j)",5x,tr2,"abs(q1(j)-q)")')
        !        write(2225,'(2i4,i6,". ",1a20,2f14.2,2F10.2,2(5x,f14.2),(5x,f10.2),(5x,f14.2) )') i,0,iter-1,parname(i),q,val,pars(i),pars1(i),realpars(i),realpars1(i),stepmin(i),abs(val-q)			
        !    end if
        !end do
        !close(2225)
        
        

        !call random_seed (size=p)
	    !p=12
	    !call random_seed (put = (/(k,k=1,p)/))
	    !if (skriv) then
	    !    print*, 'Here is p',p
	    !    print*, 'Here is k',(/(k,k=1,p)/)
     !			call random_number(rand)
	!		print*, 'rand: ', rand
    ! 			call random_number(rand)
!			print*, 'rand: ', rand
 !       end if
	!else     
	!    allocate(newseed(p))
	!    newseed=10
	!    call random_seed( put=newseed(1:p)  )
	!    deallocate(newseed)
	!end if 
!		call objfunc(pars,q) ; realpars=realpartemp
 
        
        !open(unit=2,file='bestpar110516.txt',status='old',action='read') ; read(2,*) pars2	; close(2) 		
        !pars(4)=-13.7901
		!call objfunc(pars,q) ; realpars=realpartemp
        if (comparepars) then
            if (iam==0) then 
                write(64,*)
                write(64,*)
                write(64,'(tr3,"i",tr3,"j",tr2,"iter",2x,tr20,tr13,"q",tr9,"q1(j)",tr6,"pars",tr5,"pars1",5x,tr6,"realpars",5x,tr5,"realpars1",5x,tr3,"step(j)",5x,tr2,"abs(q1(j)-q)")')
            end if
            do i=1,npars
                !if (abs(stepmin(i)) >0.0_dp) 
                    pars1=pars
                    pars1(i)=pars2(i)
                    call objfunc(pars1,val) ; realpars1=realpartemp
                    j=1 ; q1val(j)=val !j is just a nuissance index here which is kept just to be consistent with the chkstep output
                    if (iam==0) then 
                    	write(64,'(2i4,i6,". ",1a20,2f14.2,2F10.2,2(5x,f14.2),(5x,f10.2),(5x,f14.2) )') i,j,iter-1,parname(i),qval,q1val(j),pars(i),pars1(i),realpars(i),realpars1(i),step(j),abs(q1val(j)-qval)
                    end if 				
                !end if 
            end do 
        end if 
        
		if (chkstep) then
            lb=0.4_sp ; ub=1.25_sp ; incr=0.1_dp
            do i=1,npars
                !if (  parname(i)=='cst(1)'.or.parname(i)=='cst(2)'.or.parname(i)=='ecst' ) then
                !    stepmin(i)=0.2_dp
                !else 
                !    stepmin(i)=0.0_dp
                !end if 
                if ( abs(stepmin(i)) > 0.0_dp ) then	
                !if (  parname(i)=='uloc'.or.  & 
                 ! & parname(i)=='alf13'.or.parname(i)=='alf22'.or.i==47.or.i==48 .or. parname(i)=='mu_o') then
                    !if (i==4) then !i==40.or.i==41.or.i==42.or.i==50.or.i==53.or.i==54.or.i==56.or.i==57.or.i==59.or.i==60.or.i==62.or.i==63.or.i>=65) then
					if (iam==0) then 
						write(64,*)
						write(64,*)
						write(64,'(tr3,"i",tr3,"j",tr2,"iter",2x,tr20,tr13,"q",tr9,"q1(j)",tr6,"pars",tr5,"pars1",5x,tr6,"realpars",5x,tr5,"realpars1",5x,tr3,"step(j)",5x,tr2,"abs(q1(j)-q)")')
					end if 
					step=pen 
					q1val=pen 
					k=0
					incr=0.2_dp
					jloop: do j=1,nj2
						if (parname(i)=='cst(1)'.or.parname(i)=='cst(2)') then
                            step(j)=(j-nj)*0.2_dp
						else if (parname(i)=='ecst') then
                            step(j)=(j-nj)*0.2_dp
						else if (parname(i)=='kcst') then
                            step(j)=(j-nj)*0.25_dp
						else if (parname(i)=='divpenalty') then
                            step(j)=(j-nj)*0.25_dp
						else if (parname(i)=='alphaed(m,1)') then
                            step(j)=(j-nj)*1.0_dp
						else if (parname(i)=='alphaed(m,2)') then
                            step(j)=(j-nj)*1.0_dp
						else if (parname(i)=='alphaed(f,2)') then
                            step(j)=(j-nj)*0.3_dp
						else if (parname(i)=='psio') then
                            step(j)=(j-nj)*0.3_dp
						else if (parname(i)=='psil') then
                            step(j)=(j-nj)*0.3_dp
						else if (parname(i)=='psih') then
                            step(j)=(j-nj)*0.3_dp
                        else if (parname(i)=='uloc') then 
							step(j)=(j-nj)*0.06_dp
                        else if (parname(i)=='alf11'.or.parname(i)=='alf21') then 
							step(j)=(j-nj)*0.1_dp
                        else if (parname(i)=='alf20'.and.i==47) then
                            step(j)=(j-nj)*0.05_dp
						else if (parname(i)=='alf20'.and.i==48) then
                            step(j)=(j-nj)*0.05_dp
						else if (parname(i)=='alf13') then
                            step(j)=(j-nj)*0.2_dp*abs(pars(i))
						else if (parname(i)=='alf22') then
                            step(j)=(j-nj)*0.2_dp*abs(pars(i))
                        !else if (i>=50.and.i<=67) then
						!	step(j)=(j-nj)*0.25_dp   
                        else 
                            step(j)=(j-nj)*incr*abs(pars(i))
						end if 						
						pars1=pars						
						pars1(i)=pars(i)+step(j)
						call objfunc(pars1,val) ; realpars1=realpartemp
						q1val(j)=val
						!if ( abs(q1(j)-q) < incr) incr=0.1_dp
						if (iam==0) then 
							write(64,'(2i4,i6,". ",1a20,2f14.2,2F10.2,2(5x,f14.6),(5x,f10.2),(5x,f14.2) )') i,j,iter-1,parname(i),qval,q1val(j),pars(i),pars1(i),realpars(i),realpars1(i),step(j),abs(q1val(j)-qval)
						end if 												
					end do jloop
					call sort2(q1val,step)
					j=0
					do while (lb+j*0.1_sp<=0.95_sp)
						k=locate(q1val,(lb+j*0.1_sp)*real(qval)) 
						if (iam==0) write(64,'("first try ",i6,3f14.4,i6)') j,q1val(1),q1val(nj2),(lb+j*0.1_sp)*real(qval),k
						if (k>0.and.k<nj2) exit 
						j=j+1
					end do
					j=0
					if (k==0) then 
						do while (ub-j*0.1_sp>=1.05_sp)
							k=locate(q1val,(ub-j*0.1_sp)*real(qval)) 
							if (iam==0) write(64,'("second try ",i6,3f14.4,i6)') j,q1val(1),q1val(nj2),(ub-j*0.1_sp)*real(qval),k
							if (k>0.and.k<nj2) exit 
							j=j+1
						end do 
					end if 					
					if (iam==0) write(64,'("and now it is done ",i6)') k
					if (k>0) then ; stepmin(i)=step(k) ; else ; stepmin(i)=-99.0 ; end if 
					if (iam==0) then 
						!write(64,*) "here is the best bumps for the initial simplex"
						write(64,*)
						write(64,'("lb,ub,q1min,q1max",4x,4f14.4)') lb*qval,ub*qval,q1val(1),q1val(nj2)
						write(64,*)
						if (k>0) then 
							write(64,'(2i6,4f14.4,4(5x,f14.4) )') i,k,qval,q1val(k),pars(i),pars1(i),realpars(i),realpars1(i),step(k),abs(q1val(k)-qval)
						end if 
						write(64,*) 
					end if 												

				end if 	
				if (iam==0) write(65,'(f14.4)') stepmin(i)
			end do 
		end if 
	end if 
	runtime=secnds(begintime)
	if (iam==0) then ; write(*,'("run time: ", f14.2)') runtime ; end if 
	if (groups) then 
		call mpi_finalize(ierror)   
	end if 
end program main 
!		if (groups) then
!			do i=0,ninp-1
!				ranks(i)=i
!			enddo
!			call mpi_comm_group(mpi_comm_world,mpi_group_world,mpierr)
!			call mpi_group_incl(mpi_group_world,ninp,ranks,group,mpierr)
!			call mpi_comm_create(mpi_comm_world,group,comm,mpierr)
 !       end if 

		!splitkey=mod(myid,nprocs/ninp)
		!call mpi_comm_split(mpi_comm_world,splitkey,myid,comm,mpierr)

 	!call mpi_bcast(stepmin,npars,mpi_real8,0,mpi_comm_world,mpierr)
	!if (iam==15) then 
	!	print*, "here is stepmin(6:8) "  , mygroup,iam,stepmin(6:8)
	!end if 
	
	!print*, "here everyone is done now ", mygroup,iam 
	!print*, 1.0_dp/(1.0_dp+exp(pars(64))+exp(pars(65))),exp(pars(64))/(1.0_dp+exp(pars(64))+exp(pars(65))),exp(pars(65))/(1.0_dp+exp(pars(64))+exp(pars(65)))
	!print*, 1.0_dp/(1.0_dp+exp(pars(66))+exp(pars(67))),exp(pars(66))/(1.0_dp+exp(pars(66))+exp(pars(67))),exp(pars(67))/(1.0_dp+exp(pars(66))+exp(pars(67)))	