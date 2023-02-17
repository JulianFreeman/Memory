@echo off
color 0a
title 文件校验


:home
echo ##############################
echo.
echo 1. 根据校验值文件校验已有文件
echo.
echo 2. 对已有文件生成校验值文件
echo.
echo 3. 退出
echo.
echo ##############################
echo.
choice /c 123 /n /m "请输入选项序号："
if %errorlevel% equ 1 (
    goto :check_existed
) else if %errorlevel% equ 2 (
    goto :generate
) else (
    goto :end
)


:print_hash_algo
echo.
echo Certutil 支持的算法有如下几种，请选择其中一种：
echo ------------------------------------------------------------
echo   MD2     MD4     MD5     SHA1   SHA256  SHA384  SHA512
echo    ^|       ^|       ^|       ^|        ^|       ^|      ^|
echo    v       v       v       v        v       v      v
echo    1       2       3       4        5       6      7
echo ------------------------------------------------------------
choice /c 1234567 /n /m "我选择的散列算法（填序号）："
echo.

if %errorlevel% equ 1 (
    set hash=MD2
) else if %errorlevel% equ 2 (
    set hash=MD4
) else if %errorlevel% equ 3 (
    set hash=MD5
) else if %errorlevel% equ 4 (
    set hash=SHA1
) else if %errorlevel% equ 5 (
    set hash=SHA256
) else if %errorlevel% equ 6 (
    set hash=SHA384
) else if %errorlevel% equ 7 (
    set hash=SHA512
)
goto :eof


:check_existed
echo.
set /p fvf=请将校验值文件拖拽至此：
if "%fvf%" == "" (
    echo 您没有指定文件，请重新指定。
    goto :check_existed
)
call :print_hash_algo

rem 获取校验值文件所在路径
for %%i in ("%fvf%") do (
    set pof=%%~dpi
)
set passed=0
set failed=0
setlocal enabledelayedexpansion
for /f "usebackq tokens=1,* delims=* " %%i in ("%fvf%") do (
    set checked=0
    for /f "usebackq skip=1 delims=" %%v in (`certutil -hashfile "%pof%\%%j" %hash%`) do (
        if !checked! == 0 (
            if "%%i" == "%%v" (
                set "flag=-->"
                set sign=PASSED
                set /a passed+=1
            ) else (
                set "flag=   "
                set sign=FAILED
                set /a failed+=1
            )

            echo !flag! ******** %%j ********
            echo !flag! %%i *recorded
            echo !flag! %%v *computed
            echo !flag! ******** !sign! ********

            set checked=1
        ) else (
            set checked=0
        )
    )
    echo.
)

setlocal disabledelayedexpansion
echo PASSED: %passed%
echo FAILED: %failed%
echo.
choice /c YN /n /m "文件校验完毕，继续使用（Y）或退出（N）："
if %errorlevel% equ 1 (
    cls
    goto :home
) else (
    goto :end
)


:generate
echo.
set /p wtv=请将要生成校验值的文件放在一个文件夹下，然后将该文件夹拖拽至此：
if "%wtv%" == "" (
    echo 您没有指定文件夹，请重新指定。
    goto :generate
)
call :print_hash_algo

set total=0
set OutFileName=CHECKSUM.txt
setlocal enabledelayedexpansion
for /f "usebackq delims=" %%f in (`dir %wtv% /a-d /b`) do (
    set checked=0
    for /f "usebackq skip=1 delims=" %%v in (`certutil -hashfile "%wtv%\%%f" %hash%`) do (
        if !checked! == 0 (
            echo %%v *%%f
            echo %%v *%%f >>%wtv%\%OutFileName%
            set /a total+=1

            set checked=1
        ) else (
            set checked=0
        )
    )
)

setlocal disabledelayedexpansion
echo.
echo TOTAL: %total%
echo.
choice /c YN /n /m "%hash% 校验值文件生成完毕，继续使用（Y）或退出（N）："
if %errorlevel% equ 1 (
    cls
    goto :home
) else (
    goto :end
)


:end
exit /b
