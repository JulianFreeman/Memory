@echo off
color 0a

echo.�������������ڵ�Ŀ¼�㼶������
echo.�ǩ��� ipython
echo.��   �ǩ��� backcall-0.2.0-py2.py3-none-any.whl
echo.��   �ǩ��� colorama-0.4.4-py2.py3-none-any.whl
echo.��   �ǩ��� decorator-5.0.9-py3-none-any.whl
echo.��   ������ ipython-7.27.0-py3-none-any.whl
echo.�ǩ��� numpy
echo.��   ������ numpy-1.21.1-cp39-cp39-win_amd64.whl
echo.������ pypi categorizing.bat
echo.
echo.�ļ�һ�������޷��������밴�������������
pause >nul

if not exist "simple\" (
    mkdir simple
)
setlocal enabledelayedexpansion
rem ֻ����������ļ���
for /f %%d in ('dir /ad /b') do (
    rem ȥ��simple
    if "%%d" neq "simple" (
        rem ֻ�����ļ�
        for /f %%f in ('dir %%d /a-d /b') do (
            rem ����ֻ����whl�ļ�
            if "%%~xf" == ".whl" (
                for /f "tokens=1 delims=-" %%n in ("%%~nf") do (
                    rem ȡʵ�ʵ����֣�ȥ���汾�ŵ���Ϣ
                    set PkgName=%%n
                    rem �������ֶ��ǰ��ļ�����_����-�ģ�����pip��������
                    set PkgName=!PkgName:_=-!
                    rem ��.Ҳ����-
                    set PkgName=!PkgName:.=-!
                    rem ���У��ƶ�
                    mkdir simple\!PkgName!
                    echo.�����ƶ� %%d\%%f
                    move /y %%d\%%f simple\!PkgName!\
                )
            ) else (
                rem ѹ�������ļ��п����������淶
                echo.�����д��� %%d\%%f
            )
        )
    )
)
setlocal disabledelayedexpansion

echo.
echo.�ļ�������ɡ�
pause
