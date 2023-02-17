@echo off
color 0a
title �ļ�У��


:home
echo ##############################
echo.
echo 1. ����У��ֵ�ļ�У�������ļ�
echo.
echo 2. �������ļ�����У��ֵ�ļ�
echo.
echo 3. �˳�
echo.
echo ##############################
echo.
choice /c 123 /n /m "������ѡ����ţ�"
if %errorlevel% equ 1 (
    goto :check_existed
) else if %errorlevel% equ 2 (
    goto :generate
) else (
    goto :end
)


:print_hash_algo
echo.
echo Certutil ֧�ֵ��㷨�����¼��֣���ѡ������һ�֣�
echo ------------------------------------------------------------
echo   MD2     MD4     MD5     SHA1   SHA256  SHA384  SHA512
echo    ^|       ^|       ^|       ^|        ^|       ^|      ^|
echo    v       v       v       v        v       v      v
echo    1       2       3       4        5       6      7
echo ------------------------------------------------------------
choice /c 1234567 /n /m "��ѡ���ɢ���㷨������ţ���"
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
set /p fvf=�뽫У��ֵ�ļ���ק���ˣ�
if "%fvf%" == "" (
    echo ��û��ָ���ļ���������ָ����
    goto :check_existed
)
call :print_hash_algo

rem ��ȡУ��ֵ�ļ�����·��
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
choice /c YN /n /m "�ļ�У����ϣ�����ʹ�ã�Y�����˳���N����"
if %errorlevel% equ 1 (
    cls
    goto :home
) else (
    goto :end
)


:generate
echo.
set /p wtv=�뽫Ҫ����У��ֵ���ļ�����һ���ļ����£�Ȼ�󽫸��ļ�����ק���ˣ�
if "%wtv%" == "" (
    echo ��û��ָ���ļ��У�������ָ����
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
choice /c YN /n /m "%hash% У��ֵ�ļ�������ϣ�����ʹ�ã�Y�����˳���N����"
if %errorlevel% equ 1 (
    cls
    goto :home
) else (
    goto :end
)


:end
exit /b
