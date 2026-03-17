@echo off
:: Usage: update_portfolio.bat [submodule]
:: Example: update_portfolio.bat geospatial
:: Leave blank to skip submodule update and just re-render

set SUBMODULE=%1

echo ========================================================
echo  Portfolio Update
echo ========================================================

:: 1. Update submodule if specified
if not "%SUBMODULE%"=="" (
    echo [1/4] Updating submodule: %SUBMODULE%...
    if "%SUBMODULE%"=="geospatial"     git submodule update --remote classes/R/geospatial
    if "%SUBMODULE%"=="networks"       git submodule update --remote classes/R/networks
    if "%SUBMODULE%"=="finc_ecm"       git submodule update --remote classes/R/finc_ecm
    if "%SUBMODULE%"=="econometrics2"  git submodule update --remote classes/STATA/econometrics2
) else (
    echo [1/4] No submodule specified, skipping update.
)

:: 2. Sync freeze folders
echo [2/4] Syncing freeze folders...
robocopy "classes\R\geospatial\_freeze"      "_freeze\classes\R\geospatial"      /E /NFL /NDL /NJH /NJS
robocopy "classes\R\finc_ecm\_freeze"        "_freeze\classes\R\finc_ecm"        /E /NFL /NDL /NJH /NJS
robocopy "classes\R\networks\_freeze"        "_freeze\classes\R\networks"        /E /NFL /NDL /NJH /NJS
robocopy "classes\STATA\econometrics2\_freeze" "_freeze\classes\STATA\econometrics2" /E /NFL /NDL /NJH /NJS

:: 3. Render site
echo [3/4] Rendering site...
quarto render

:: 4. Stage, commit, push
echo [4/4] Committing and pushing to origin/test...
if not "%SUBMODULE%"=="" (
    git add docs\ _freeze\ classes\
    git commit -m "update %SUBMODULE% to latest"
) else (
    git add docs\ _freeze\
    git commit -m "rebuild site"
)
git push origin test

echo ========================================================
echo  Done. Site pushed to origin/test.
echo ========================================================
pause
