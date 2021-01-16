@ECHO OFF
SETLOCAL
:Config
SET ADSName=AMPInstance1-ADS
:SOF
MODE COn lines=30 cols=50
TITLE CMD - Main Menu
COLOR 0b
SET M=
SET Status=Online
ECHO #################################################
ECHO #                                               #
ECHO #                   AMP - CMD                   #
ECHO #                                               #
ECHO #################################################
ECHO.
ECHO -------------------------------------------------
TASKLIST /FI "IMAGENAME eq AMPService.exe" 2>NUL | find /I /N "AMPService.exe">NUL
IF "%ErrorLevel%"=="1" SET Status=Offline
ECHO ADS Status: %Status%
ECHO -------------------------------------------------
ECHO Please Select The Action You Would Like To Take.
ECHO -------------------------------------------------
ECHO.
ECHO 1.^) Stop Instances
ECHO 2.^) Update Instances
ECHO 3.^) Start Instances
ECHO 4.^) View %ADSName% In CMD
ECHO.
ECHO w.^) WatchDog Mode
ECHO e.^) Exit
ECHO.
ECHO -------------------------------------------------
SET /p M=^>
IF "%M%"=="1" (
ampinstmgr stopall
TIMEOUT 3 >nul
)
IF "%M%"=="2" ampinstmgr upgradeall
IF "%M%"=="3" ampinstmgr startall
IF "%M%"=="4" ampinstmgr view %ADSName%
IF "%M%"=="w" GOTO WatchDog
IF "%M%"=="e" GOTO EOF
GOTO SOF
:WatchDog
>DELETE.txt ECHO DELETE ME
TITLE CMD - ADS Runtime Checker
CLS
ECHO [%TIME%] Testing....
TASKLIST /FI "IMAGENAME eq AMPService.exe" 2>NUL | find /I /N "AMPService.exe">NUL
IF NOT "%ERRORLEVEL%"=="0" GOTO StartAMP
COLOR 02
ECHO [%TIME%] Found!
TIMEOUT 10 >nul
IF EXIST DELETE.txt (
GOTO WatchDog
)
GOTO SOF
:StartAMP
COLOR 0c
ECHO [%TIME%] Not Found Starting Instances.....
ampinstmgr startall
ECHO Done.
TIMEOUT 10 >nul
IF EXIST DELETE.txt (
GOTO WatchDog
)
GOTO SOF
:EOF
pause