@echo off
echo ========================================================
echo  Syncing Quarto Freeze Folders from Submodules to Root
echo ========================================================

:: 1. Geospatial
echo Syncing Geospatial...
robocopy "classes\R\geospatial\_freeze" "_freeze\classes\R\geospatial" /E /NFL /NDL /NJH /NJS

:: 2. Finance / ECM
echo Syncing Finance ECM...
robocopy "classes\R\finc_ecm\_freeze" "_freeze\classes\R\finc_ecm" /E /NFL /NDL /NJH /NJS

:: 3. Networks
:: echo Syncing Networks...
:: robocopy "classes\R\networks\_freeze" "_freeze\classes\R\networks" /E /NFL /NDL /NJH /NJS

:: 4. Econometrics (Stata)
echo Syncing Econometrics...
robocopy "classes\STATA\econometrics2\_freeze" "_freeze\classes\STATA\econometrics2" /E /NFL /NDL /NJH /NJS

echo ========================================================
echo  Done! Run 'quarto preview' now.
echo ========================================================
pause