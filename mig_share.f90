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
    !ag090122 agsept2022 bshock_m=moveshock_m
    !ag090122 agsept2022 bshock_f=moveshock_f
	bshock_m=0.0_dp
	bshock_f=0.0_dp
    !moveshock_m=0.0_dp
    !moveshock_f=0.0_dp

    

    
    
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

