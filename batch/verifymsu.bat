@echo off
color 0a
title MSU �ļ�У��

echo ================У�鿪ʼ================
echo.
set passed=0
set failed=0
setlocal enabledelayedexpansion
for /f "usebackq delims=" %%d in (`dir . /ad /b`) do (
    for /f "usebackq delims=" %%f in (`dir "%%d" /a-d /b`) do (
        if "%%~xf" == ".msu" (
            for /f "tokens=2 delims=_" %%n in ("%%~nf") do (
                set checked=0
                for /f "usebackq skip=1 delims=" %%v in (`certutil -hashfile "%%d\%%f" sha1`) do (
                    if !checked! == 0 (
                        if "%%n" == "%%v" (
                            echo ͨ����%%d\%%f
                            set /a passed+=1
                        ) else (
                            echo ʧ�ܣ�%%d\%%f
                            set /a failed+=1
                        )

                        set checked=1
                    ) else (
                        set checked=0
                    )
                )
            )
        )
    )
)

setlocal disabledelayedexpansion
echo.
echo ͨ����%passed% ����ʧ�� %failed% ����
echo ================У�����================
pause
