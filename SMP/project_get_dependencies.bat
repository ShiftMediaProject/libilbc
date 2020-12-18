@ECHO OFF

REM Check if git is installed and available
IF "%MSVC_VER%"=="" (
    git status >NUL 2>&1
    IF ERRORLEVEL 1 (
        ECHO A working copy of git was not found. To use this script you must first install git for windows.
        GOTO exitOnError
    )
)

REM Store current directory and ensure working directory is the location of current .bat
SET CURRDIR="%CD%"
cd "%~dp0"

REM Initialise error check value
SET ERROR=0

REM Init the required submodules
IF "%MSVC_VER%"=="" (
    cd ..\
    git submodule update --init
    CD "%CURRDIR%" >NUL
)

REM Directly exit if an AppVeyor build
IF NOT "%APPVEYOR%"=="" (
    GOTO return
)
    
REM Check if this was launched from an existing terminal or directly from .bat
REM  If launched by executing the .bat then pause on completion
ECHO %CMDCMDLINE% | FINDSTR /L %COMSPEC% >NUL 2>&1
IF %ERRORLEVEL% == 0 IF "%~1"=="" PAUSE

:return
EXIT /B %ERROR%