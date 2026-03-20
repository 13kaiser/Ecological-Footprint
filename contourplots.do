***************************************************************************
***************************************************************************
*																		  *
*                          		 DO FILE                                  *
*                              										      *
*                 		Interaction Plots                                 * 
*             	      												      *
*						      										      *
***************************************************************************
***************************************************************************


***************************************************************************
* Author: Dr. Micha Kaiser												  *
***************************************************************************

* LAST UPDATE: 20 March 2026

*Note copy data file to your folder
set scheme tufte
set scheme cblind1
clear
cd "[YOUR_DIRECTORY]/ContPlots"
use "total_econ_pnorm"
twoway  contour _margin _at19 _at8,    xlabel(-4(1)4, labsize(vsmall))  ylabel(3(2)21,  angle(horizontal) labsize(vsmall)) xtitle("SES", size(small))      ytitle("Personal norms", size(small))           ztitle("Predicted Global Footprint / gha", size(vsmall))                   title("") name(fig3c, replace)
cd "[YOUR_DIRECTORY]/Figures"
graph export contplot_pnorms.png, width(4000) replace

clear
cd "[YOUR_DIRECTORY]/ContPlots"
use "total_econ_biov"
twoway  contour _margin _at18 _at8,   xlabel(-4(1)4, labsize(vsmall))  ylabel(3(2)21, angle(horizontal) labsize(vsmall)) xtitle("SES", size(small))      ytitle("Biospheric values", size(small))           ztitle("Predicted Global Footprint / gha", size(vsmall))                   title("Predicted GHA", size(small))  name(fig3a, replace)
cd "[YOUR_DIRECTORY]/Figures"
graph export contplot_biov.png, width(4000) replace
cd "[YOUR_DIRECTORY]/ContPlots"

clear
use "total_econ_suffort"
twoway  contour _margin _at17 _at8,   xlabel(-4(1)4, labsize(vsmall))  ylabel(5(5)35, angle(horizontal) labsize(vsmall)) xtitle("SES", size(small))      ytitle("Sufficiency orientation", size(small))           ztitle("Predicted Global Footprint / gha", size(vsmall))                   title("Predicted GHA", size(small))  name(fig3b, replace)
cd "[YOUR_DIRECTORY]/Figures"
graph export contplot_suffort.png, width(4000) replace


clear
use "total_econ_clmtimp"
twoway  contour _margin _at20 _at8,   xlabel(-4(1)4, labsize(vsmall))  ylabel(1(1)7, angle(horizontal) labsize(vsmall)) xtitle("SES", size(small))      ytitle("Climate  concern", size(small))           ztitle("Predicted Global Footprint / gha", size(vsmall))                   title("")  name(fig3d, replace)
cd "[YOUR_DIRECTORY]/Figures"
graph export contplot_clmtimp.png, width(4000) replace


cd "[YOUR_DIRECTORY]/Figures"
graph combine fig3a fig3b ///
              fig3c fig3d, ///
    cols(2) ///
    imargin(0.5 0.5 0.5 0.5) ///
    graphregion(margin(0.5 0.5 0.5 0.5) color(white)) ///
    name(Figure1, replace)
graph export "Figure3.tif", replace width(4000)	


// Interaction for ghas without transport

clear
cd "[YOUR_DIRECTORY]/ContPlots"
use "total_econ_pnorm_wotrans"

twoway  contour _margin _at19 _at8,   xlabel(-4(1)4)  ylabel(3(2)21, angle(horizontal)) xtitle("SES")      ytitle("Personal Norms")           ztitle("Predicted Global Footprint / gha")                   title("Predicted GHA")
cd "[YOUR_DIRECTORY]/Figures"
graph export contplot_pnorms_wotrans.png, width(4000) replace

clear
cd "[YOUR_DIRECTORY]/ContPlots"
use "total_econ_biov_wotrans"

twoway  contour _margin _at18 _at8,   xlabel(-4(1)4)  ylabel(3(2)21, angle(horizontal)) xtitle("SES")      ytitle("Biospheric values")           ztitle("Predicted Global Footprint / gha")                   title("Predicted GHA") 
cd "[YOUR_DIRECTORY]/Figures"
graph export contplot_biov_wotrans.png, width(4000) replace

cd "[YOUR_DIRECTORY]/ContPlots"
clear
use "total_econ_suffort_wotrans"
twoway  contour _margin _at17 _at8,   xlabel(-4(1)4)  ylabel(5(5)35, angle(horizontal)) xtitle("SES")      ytitle("Sufficiency orientation")           ztitle("Predicted Global Footprint / gha")                   title("Predicted GHA")
cd "[YOUR_DIRECTORY]/Figures"
graph export contplot_suffort_wotrans.png, width(4000) replace