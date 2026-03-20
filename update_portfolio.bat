@echo off
:: Usage: .\update_portfolio.bat [submodule]
:: Example: .\update_portfolio.bat geospatial
:: Leave blank to skip submodule update and just re-render
::
:: Correct workflow:
::   1. Work + render in 7Programming
::   2. git push from 7Programming
::   3. Run this script from Portfolio

set SUBMODULE=%1
set size=0

echo ========================================================
echo  Portfolio Update
echo ========================================================

:: 1. Update submodule if specified
if not "%SUBMODULE%"=="" (
    echo [1/5] Checking submodule for local changes...
    if "%SUBMODULE%"=="geospatial"     git -C classes/R/geospatial status --porcelain > tmp_status.txt
    if "%SUBMODULE%"=="networks"       git -C classes/R/networks status --porcelain > tmp_status.txt
    if "%SUBMODULE%"=="finc_ecm"       git -C classes/R/finc_ecm status --porcelain > tmp_status.txt
    if "%SUBMODULE%"=="econometrics2"  git -C classes/STATA/econometrics2 status --porcelain > tmp_status.txt

    for /f %%i in ("tmp_status.txt") do set size=%%~zi
    del tmp_status.txt
    if %size% gtr 0 (
        echo.
        echo WARNING: classes/%SUBMODULE% has local changes.
        echo Make sure you have committed and pushed from 7Programming first.
        echo Run 'git -C classes/R/%SUBMODULE% status' to see what's dirty.
        echo.
        pause
    )

    echo [1/5] Updating submodule: %SUBMODULE%...
    if "%SUBMODULE%"=="geospatial"     git submodule update --remote classes/R/geospatial
    if "%SUBMODULE%"=="networks"       git submodule update --remote classes/R/networks
    if "%SUBMODULE%"=="finc_ecm"       git submodule update --remote classes/R/finc_ecm
    if "%SUBMODULE%"=="econometrics2"  git submodule update --remote classes/STATA/econometrics2
) else (
    echo [1/5] No submodule specified, skipping update.
)

:: 2. Sync images to docs/images
echo [2/5] Syncing images to docs/images...
robocopy "images" "docs\images" /E /NFL /NDL /NJH /NJS

:: 3. Sync freeze folders
echo [3/5] Syncing freeze folders...
robocopy "classes\R\geospatial\_freeze"        "_freeze\classes\R\geospatial"        /E /NFL /NDL /NJH /NJS
robocopy "classes\R\finc_ecm\_freeze"          "_freeze\classes\R\finc_ecm"          /E /NFL /NDL /NJH /NJS
robocopy "classes\R\networks\_freeze"          "_freeze\classes\R\networks"          /E /NFL /NDL /NJH /NJS
robocopy "classes\STATA\econometrics2\_freeze" "_freeze\classes\STATA\econometrics2" /E /NFL /NDL /NJH /NJS

:: 4. Render site
echo [4/5] Rendering site...
quarto render
if %errorlevel% neq 0 (
    echo.
    echo ERROR: quarto render failed. Fix errors before committing.
    pause
    exit /b 1
)

:: 5. Stage, commit, push
echo [5/5] Committing and pushing to origin/test...
if not "%SUBMODULE%"=="" (
    git add docs\ _freeze\ classes\ _quarto.yml images\
    git commit -m "update %SUBMODULE% to latest"
) else (
    git add docs\ _freeze\ _quarto.yml images\
    git commit -m "rebuild site"
)
git push origin test

echo ========================================================
echo  Done. Site pushed to origin/test.
echo ========================================================
pause
