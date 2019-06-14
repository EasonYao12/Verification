!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!! TO DO THE Neighborhood Method                        !!!!!!
!!!!!! FORECAST DATA(MAPLE) AND OBSERVATION DATA(QPESUMS).  !!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      implicit none
      integer,parameter :: xgrid=921,ygrid=881,tgrid=25
      integer :: i,j,k,a,b,c,d,thr
      !!!! Decide the Search Distance and Threshold !!!
      integer :: length(10)=(/1,3,5,7,10,17,21,30,35,40/) 
      real*8    :: thrs2(11)=(/0,15,20,25,30,35,38.5,40,43,45,47/)
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      integer,parameter :: leng=size(length),nthr=size(thrs2)
      character(len=256) :: fstfilepath,obsfilepath
      character(len=256) :: fstfilename,obsfilename
      character(len=1) :: x(xgrid,ygrid)   !carefully!
      integer :: fstbin(xgrid,ygrid)
      real :: fstdbz_idl(xgrid,ygrid),fstdbz_fortran(xgrid,ygrid,tgrid),&
              &obsdbz(xgrid,ygrid,tgrid)
      real :: fss(nthr,leng,tgrid),ref(nthr,leng,tgrid),UNDEF
      character(len=255) :: filename1,filename2
!----------------------------
      fstfilepath='fstdatafile/'
      obsfilepath='obsdatafile/'


  filename1='20180824130000_FSS.dat'
  filename2='20180824130000_FSS_REF.dat'

      open(10,file=trim(fstfilepath)//'fstdata.list',form='formatted')
      open(20,file=trim(obsfilepath)//'obsdata.list',form='formatted')

      DO k=1,tgrid     !'k' means 'filenumber'
        read(10,'(a256)',end=110) fstfilename
        read(20,'(a256)',end=220) obsfilename
      

!This fstdata(MAPLE) format can refer to ./maple_ncu/src/bil_to_grd.f90 
      open(30,file=trim(fstfilepath)//trim(fstfilename),&
           &form='unformatted',access='direct',recl=xgrid)
        do j=1,ygrid
          read(30,rec=j) (x(i,j),i=1,xgrid)
        enddo

      do j=1,ygrid
        do i=1,xgrid
          fstbin(i,j)=ichar(x(i,j))
          if (fstbin(i,j) .eq. 255) then
            fstdbz_idl(i,j)=-999.
          else
            fstdbz_idl(i,j)=fstbin(i,j)/2.-33.
          endif
        enddo
      enddo

!Idl:'j' is from North to South ;Fortran:'j' is from South to North
      do j=1,ygrid
        do i=1,xgrid
          fstdbz_fortran(i,j,k)=fstdbz_idl(i,ygrid-j+1)
        enddo
      enddo

!This obsdata(QPESUMS) format can refer to./maple_ncu/src/dbz_to_bil.f90
!2016-08-30
!There are some non-existence obs data file,so using 'err' to jump
!out this kind of file ,and store the NAN value(-999.) for 'skill_scores'
      open(40,file=trim(obsfilepath)//trim(obsfilename),&
           &form='unformatted',status='old')!,err=1000)
        read(40,end=440) ((obsdbz(i,j,k),i=1,xgrid),j=1,ygrid)
440   continue

!2016-05-13
!Carefully,the value '-99' in obs data means low value data
!like '0 dBZ',so we need to transform it as the first "if" below
!Besides,the value '-999' in obs data means no data.(no radar
!cover areas)
      do j=1,ygrid
        do i=1,xgrid
          if (obsdbz(i,j,k).eq.-99.) then
            obsdbz(i,j,k)=0.
          endif
        enddo
      enddo
      UNDEF=-999.
      end do
call FSS_SCORE(fstdbz_fortran,obsdbz,xgrid,ygrid,tgrid,length,leng,thrs2,nthr,UNDEF,fss,ref)

      open(60,file=trim(filename1),form='unformatted',&
      &access='direct',recl=nthr*leng*4)
      do k=1,tgrid
      write(60,rec=k) ((fss(i,j,k),i=1,nthr),j=1,leng)
      end do
      close(60)

      open(70,file=trim(filename2),form='unformatted',&
      &access='direct',recl=nthr*leng*4)
      do k=1,tgrid
      write(70,rec=k) ((ref(i,j,k),i=1,nthr),j=1,leng)
      end do
      close(70)





220   continue
110   continue
      close(50)
      close(40)
      close(30)
      close(20)
      close(10)

!----------------------------
      
      stop
      end

       subroutine FSS_SCORE(fst,obs,lon,lat,h,length,nleng,thrs2,nthr,UNDEF,fss,ref)
       implicit none
       integer :: thr,i,j,k,l,dbz,search_length,tim
       integer :: lon,lat,h,nleng,nthr,length(nleng)
       real    :: obs(lon,lat,h),fst(lon,lat,h),UNDEF,thrs2(nthr)
       real    :: fss(nthr,nleng,h),fst_ratio(lon,lat),obs_ratio(lon,lat)
       real    :: thrs
       integer :: tot_fst,tot_obs,sum1,m,tmp
       real    :: Dx,N,ref(nthr,nleng,h),tmp1


       do tim=1,h
       print*,'time = ',tim
       do thr=1,nleng
       search_length=length(thr)
       do dbz=1,nthr
       thrs=thrs2(dbz)
       fst_ratio=0.
       obs_ratio=0.
!$omp parallel do reduction(+:sum1,tot_obs,tot_fst)
!+omp private(i,j,l,k,sum1,tot_fst,tot_obs,fst_ratio,obs_ratio,fss)
       do j = 1+search_length,lat-search_length
        do i = 1+search_length,lon-search_length

        tot_fst=0
        tot_obs=0
        sum1=0

         do l=j-search_length,j+search_length
          do k=i-search_length,i+search_length
            if ((float(i-k)**2+float(j-l)**2).le.float(search_length)**2) then
             sum1 = sum1 +1
             if (fst(k,l,tim) .ge. thrs ) tot_fst=tot_fst+1
             if (obs(k,l,tim) .ge. thrs ) tot_obs=tot_obs+1
            end if 
          end do
         end do
!           if (tot_fst .gt. 0) fst_ratio(i,j)=float(tot_fst)/float(sum1)
!           if (tot_obs .gt. 0) obs_ratio(i,j)=float(tot_obs)/float(sum1)
           if (tot_fst .gt. 0) fst_ratio(i,j)=float(tot_fst)/float(sum1)
           if (tot_obs .gt. 0) obs_ratio(i,j)=float(tot_obs)/float(sum1)
        end do
       end do
!$omp end parallel do

         fss(dbz,thr,tim)=1-sum((obs_ratio-fst_ratio)**2)/   &
     &                (sum(obs_ratio**2)+sum(fst_ratio**2))
       tmp=0 
       m=0 
       tmp1=0
       do j = 1+search_length,lat-search_length
        do i = 1+search_length,lon-search_length
        m=m+1
        if (obs(i,j,tim) .ge. thrs ) tmp=tmp+1
        end do
       end do

       if ( tmp .gt. 0 ) tmp1=float(tmp)/float(m)

       
       ref(dbz,thr,tim)=(1.+tmp1)/2.

       end do ! length
       end do ! threshold
       end do

       return
       end subroutine FSS_SCORE
