!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!! TO DO THE CONTINUOUS and CATEGORICAL VERIFICATION    !!!!!!
!!!!!! FORECAST DATA(MAPLE) AND OBSERVATION DATA(QPESUMS).  !!!!!!
!!!!!! THE SKILL SCORES FUNCTION IN SUBROUTINE CAN REFER TO !!!!!!
!!!!!! THE PAPER WRITTEN BY GERMANN AND ZAWADZKI(2002).     !!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      implicit none
      integer,parameter :: xgrid=921,ygrid=881
      integer :: i,j,k,a,b,c,d
      integer :: na
      character(len=256) :: fstfilepath,obsfilepath
      character(len=256) :: fstfilename,obsfilename
      character(len=1) :: x(xgrid,ygrid)   !carefully!
      integer :: fstbin(xgrid,ygrid)
      real :: fstdbz_idl(xgrid,ygrid),fstdbz_fortran(xgrid,ygrid),&
              &obsdbz(xgrid,ygrid)
      real :: pod,far,csi,ets,ks,w,scc,rmse
!----------------------------
!To find the fst/obs data filepath & filename
! Remember to modify the file dir
      fstfilepath='/home/miayao/maple_ncu/categorical_verification&
      &/fstdatafile/'
      obsfilepath='/home/miayao/maple_ncu/categorical_verification&
      &/obsdatafile/'

      open(10,file=trim(fstfilepath)//'fstdata.list',form='formatted')
      open(20,file=trim(obsfilepath)//'obsdata.list',form='formatted')

      DO k=1,40     !'k' means 'filenumber'
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
          fstdbz_fortran(i,j)=fstdbz_idl(i,ygrid-j+1)
        enddo
      enddo

!This obsdata(QPESUMS) format can refer to./maple_ncu/src/dbz_to_bil.f90
!There are some non-existence obs data file,so using 'err' to jump
!out this kind of file ,and store the NAN value(-999.) for 'skill_scores'
      open(40,file=trim(obsfilepath)//trim(obsfilename),&
           &form='unformatted',status='old',err=1000)
        read(40,end=440) ((obsdbz(i,j),i=1,xgrid),j=1,ygrid)
440   continue

!2016-05-13
!Carefully,the value '-99' in obs data means low value data
!like '0 dBZ',so we need to transform it as the first "if" below
!Besides,the value '-999' in obs data means no data.(no radar
!cover areas)
      do j=1,ygrid
        do i=1,xgrid
          if (obsdbz(i,j).eq.-99.) then
            obsdbz(i,j)=0.
          endif
        enddo
      enddo

      call skill_scores(fstdbz_fortran,obsdbz,pod,far,csi,ets,ks,a,b,c,d,w)
      go to 2000
1000  pod = -999.0 ; far=-999.0 ; csi=-999.0 ; ets=-999.0 ; ks=-999.0;&
     &a=-999 ; b=-999 ; c=-999 ; d=-999 ; w=-999
2000  continue
      call continuous_scores(fstdbz_fortran,obsdbz,scc,rmse)


!To store the different type of skill scores in each TXT file for plotting
      open(50,file='pod.txt',form='formatted')
      write(50,'(f11.6)') pod
      open(60,file='far.txt',form='formatted')
      write(60,'(f11.6)') far
      open(70,file='csi.txt',form='formatted')
      write(70,'(f11.6)') csi
      open(80,file='ets.txt',form='formatted')
      write(80,'(f11.6)') ets
      open(90,file='ks.txt',form='formatted')
      write(90,'(f11.6)') ks
      open(100,file='scc.txt',form='formatted')
      write(100,'(f11.6)') scc
      open(110,file='rmse.txt',form='formatted')
      write(110,'(f11.6)') rmse
      
      ENDDO

220   continue
110   continue
      close(110);close(100)
      close(90);close(80);close(70);close(60);close(50)
      close(40)
      close(30)
      close(20)
      close(10)

!----------------------------

      stop
      end

      !----------------------------
      !Rainfall threshold can be changed to verify different kinds of
      !intensity of rainfall events
      subroutine skill_scores(fst,obs,pod,far,csi,ets,ks,a,b,c,d,w)
      implicit none
      integer :: i,j,k,a,b,c,d
      integer,parameter :: nx=921,ny=881
      real,parameter :: th=40.  !th:rainfall threshold(unit:dBZ)
!================================================
      real :: fst(nx,ny),obs(nx,ny),w
      real :: pod,far,csi,ets,ks

      !----------------------------
      a=0;b=0;c=0;d=0!a:hits,b;misses,c:false alarms,d:correct negatives
      pod=0. ; far=0. ; csi=0. ; ets=0. ; ks=0. ; w=0.!w:random hits

      do j=1,ny
        do i=1,nx
          if (fst(i,j).ne.-999. .and. obs(i,j).ne.-999.) then
            if (fst(i,j).ge.th .and. obs(i,j).ge.th) then
              a=a+1
            elseif (fst(i,j).lt.th .and. obs(i,j).ge.th) then
              b=b+1                  
            elseif (fst(i,j).ge.th .and. obs(i,j).lt.th) then
              c=c+1
            elseif (fst(i,j).lt.th .and. obs(i,j).lt.th) then
              d=d+1
            endif
          endif          
        enddo
      enddo

      pod=float(a)/float(a+b)
      far=float(c)/float(a+c)
      csi=float(a)/float(a+b+c)
      w=float(a+b)/float(a+b+c+d)*float(a+c)  !must write in this way
      ets=(a-w)/(a+b+c-w)
      ks=(float(a)/float(a+b))-(float(c)/float(c+d))

      return
      end

      subroutine continuous_scores(fst,obs,scc,rmse)
      implicit none
      integer :: i,j,k
      real,parameter  :: nx=921,ny=881
      real    ::fst(nx,ny),obs(nx,ny),avg_obs,avg_fst
      real    :: scc,rmse,a,b,c,d,e,tot
  
      a=0.
      b=0.
      c=0.
      d=0.
      tot=0.
      avg_obs=0.
      avg_fst=0.

      do j=1,ny
        do i=1,nx
          if (fst(i,j) .ne. -999. .and. obs(i,j) .ne. -999. )then
!         if (fst(i.j) .gt. 0.    .and. obs(i,j) .gt. 0.    ) then
          avg_obs=avg_obs+obs(i,j)
          avg_fst=avg_fst+obs(i,j)
          tot = tot+1
          end if 
!         end if 
        end do
       end do
       avg_obs=avg_obs/tot
       avg_fst=avg_fst/tot
       tot=0.




      do j=1,ny
        do i=1,nx
          if (fst(i,j) .ne. -999. .and. obs(i,j) .ne. -999. ) then
          ! for SCC
          a = a + (fst(i,j)-avg_fst)*(obs(i,j)-avg_obs)
          b = b + (fst(i,j)-avg_fst)**2
          c = c + (obs(i,j)-avg_obs)**2
          
          ! for RMSE
          d = d + (fst(i,j)-obs(i,j))**2
          tot = tot+1
          end if 
        end do
      end do

      scc=a/sqrt(b*c)
      rmse=sqrt(d/tot)
      
      return
      end
