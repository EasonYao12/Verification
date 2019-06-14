;More introduction plz see "2017-01-16~01-25.docx"
;1.ac_rain: accumulated rain of "whole n hours"?å ±nå°æ??„ç´¯ç©é??¨é?
;2.ac_rain_hrly:accumulated rain of "the n hour"?å ±ç¬¬nå°æ??„ç´¯ç©é??¨é?
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;load "./shapefile_utils.ncl"

begin
;========


;Basic setting
;------------------
Case_name="201009_FANAPI"
fTime="20100920070000"
fTime_c = stringtocharacter(fTime)
type_ZR = "alldata" 
dtemp = "30"
vec = 48 
tmp=False
;------------------



thrs_echo   =(/0,15,20,25,30,35,40,45/)
length_echo =(/1,3,5,7,10,17,21,30,35,40/)
nthrs_echo  = 8
nleng_echo  = 10
tgrid       = 25

fss_echo       = new((/tgrid,nleng_echo,nthrs_echo/),float,-999.)
fss_ref_echo   = new((/tgrid,nleng_echo,nthrs_echo/),float,-999.)
fss_echo!0     = "min_echo"
fss_echo!1     = "search_length"
fss_echo!2     = "threshold"
copy_VarMeta(fss_echo,fss_ref_echo)


fName = Case_name+"/"+fTime+"/"+fTime+"_FSS.dat" ;forecast accumulated rainfall
setfileoption("bin","ReadByteOrder","LittleEndian")
do t = 0,tgrid-1
  fss_echo(t,:,:) = fbindirread(fName,t,(/nleng_echo,nthrs_echo/),"float")
end do


fName = Case_name+"/"+fTime+"/"+fTime+"_FSS_REF.dat" ;forecast accumulated rainfall
setfileoption("bin","ReadByteOrder","LittleEndian")
do t = 0,tgrid-1
  fss_ref_echo(t,:,:) = fbindirread(fName,t,(/nleng_echo,nthrs_echo/),"float")
end do
;===========


;===========
 outfile= Case_name+"/"+fTime+"/"+fTime+"_fss_echo_index.nc"
 system("if [ -e "+outfile+" ]; then rm "+outfile+" ; fi ") ; shell
 fout=addfile(outfile,"c")
 fout->NTHRS_ECHO   = nthrs_echo
 fout->THRES_ECHO   = thrs_echo
 fout->NLENG_ECHO   = nleng_echo
 fout->LENGTH_ECHO  = length_echo
 fout->NH_ECHO      = tgrid
 fout->FSS_ECHO     = fss_echo
 fout->FSS_REF_ECHO = fss_ref_echo(0,0,:)



;===========
;===========
line_cols=(/"purple","blue","green","orange","red","cyan","violet","yellowgreen"/)

;========
if ( tmp ) then 

type	="png"
res1	= True
res1@gsnDraw=False
res1@gsnFrame=False
res1@gsnMaximize  = True
res1@pmLegendDisplayMode = "nocreate"
res1@xyLineColors        =line_cols
res1@xyDashPatterns      =0.1
res1@xyLineThicknessF    = 10.
res1@pmLegendHeightF     = 0.15
res1@pmLegendWidthF      = 0.15
res1@pmLegendOrthogonalPosF = -1.15
res1@pmLegendParallelPosF   = 0.70
res1@lgLabelFontHeightF     = 0.02
res1@lgPerimOn              = False
res1@gsnCenterString     = "TH = "+ thrs_echo(num_th_echo)+" dBZ"
;res@gsnCenterString     = "total: "+nrows1+" times"
;res1@tiMainString           = Case_name
res1@tiXAxisString          = "Hour"
res1@tiYAxisString          = "FSS"
res1@tmXBMode               = "explicit"
res1@tmXBValues             = (/ 0 , 6 , 12 , 18 , 24/)
res1@tmXBLabels             = (/"0","1","2","3","4"/)
;res@tmYLMode               = "explicit"
;res@tmYLValues             = (/0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0/)
;res@tmYLLabels             = (/"0.0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0"/)
res1@trXMaxF	           = 24
res1@trXMinF	  	   = 0
res1@trYMaxF                = 1.
res1@trYMinF                = 0.2
res1@tmXMajorGrid                = True  ; Turn on grid lines
res1@tmXMajorGridLineDashPattern = 2     ; Dashed lines
res1@tmXMajorGridThicknessF      = 1.
res1@tmYMajorGrid                = True  ; Turn on grid lines
res1@tmYMajorGridLineDashPattern = 2     ; Dashed lines
res1@tmYMajorGridThicknessF      = 1.

res1@pmLegendDisplayMode = "Never"
  res1@gsnYRefLine	     = fss_ref_echo(0,0,num_th_echo)
  res1@gsnYRefLineThicknesses = 5
  res1@gsnYRefLineDashPattern = 1
;;legend
  res1@pmLegendDisplayMode    = "nocreate"      ; turn on legend
  res1@pmLegendSide           = "Top"         ; Change location of 
  res1@pmLegendParallelPosF   =  1.19         ; move units right
  res1@pmLegendOrthogonalPosF = -0.47         ; move units down
  res1@pmLegendWidthF         = 0.18          ; Change width and
  res1@pmLegendHeightF        = 0.20          ; height of legend.
  res1@lgPerimOn              = True         ; turn on/off box around the legend
  res1@lgBoxLinesOn           = False         ; turn on/off around the Legend 'items'
  res1@lgBoxMajorExtentF      = 0.7
  res1@lgBoxMinorExtentF      = 0.2
  res1@lgLabelPosition        = "Right"       ; position of legend label 
  res1@lgLabelJust	     = "centerright"
  res1@lgLabelFontHeightF     = 0.020         ; size of legend label
  res1@xyExplicitLegendLabels = "L="+length_echo(:)+" (grids)"


  x=fspan(0,tgrid,tgrid)
  plot1=new((/3/),graphic)
  wks_type    = "png"
  wks_type@wkWidth  = 3000 ;page resolution:3000*3000
  wks_type@wkHeight = 3000
  wks1     =gsn_open_wks(wks_type,Case_name+"_"+fTime+"_FSS_echo")


  do num_th=0,2
  res1@gsnCenterString     = "TH = "+ thrs_echo(num_th)+" dBZ"
  res1@gsnYRefLine	     = fss_ref_echo(0,0,num_th_echo)
  plot1(num_th)	=gsn_csm_xy(wks1,x,transpose(fss_echo(:,:,(num_th))),res1)
;  print(avg_fss_hr(:,0,(num_th*2)))
  end do 
  
  resP1  = True
  resP1@gsnMaximize    = True   ; Maximize in frame
  resP1@gsnFrame       = False  ; Don't advance frame.
  resP1@gsnPanelBottom = 0.13   ; Leave room for labelbar

  ; Main title
  resP1@gsnPanelMainString       = Case_name+" at ~Z80~"+fTime
  resP1@gsnPanelMainFontHeightF  = 0.025



  gsn_panel(wks1,plot1,(/1,3/),resP1)
  frame(wks1)



end if 
;========
end

