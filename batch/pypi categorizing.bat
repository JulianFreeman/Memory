@echo off
color 0a

echo.请检查批处理所在的目录层级类似于
echo.┣━━ ipython
echo.┃   ┣━━ backcall-0.2.0-py2.py3-none-any.whl
echo.┃   ┣━━ colorama-0.4.4-py2.py3-none-any.whl
echo.┃   ┣━━ decorator-5.0.9-py3-none-any.whl
echo.┃   ┗━━ ipython-7.27.0-py3-none-any.whl
echo.┣━━ numpy
echo.┃   ┗━━ numpy-1.21.1-cp39-cp39-win_amd64.whl
echo.┗━━ pypi categorizing.bat
echo.
echo.文件一经整理无法撤销，请按任意键继续……
pause >nul

if not exist "simple\" (
    mkdir simple
)
setlocal enabledelayedexpansion
rem 只遍历最外层文件夹
for /f %%d in ('dir /ad /b') do (
    rem 去掉simple
    if "%%d" neq "simple" (
        rem 只遍历文件
        for /f %%f in ('dir %%d /a-d /b') do (
            rem 这里只处理whl文件
            if "%%~xf" == ".whl" (
                for /f "tokens=1 delims=-" %%n in ("%%~nf") do (
                    rem 取实际的名字，去掉版本号等信息
                    set PkgName=%%n
                    rem 包的名字都是把文件名的_换成-的，否则pip检索不到
                    set PkgName=!PkgName:_=-!
                    rem 把.也换成-
                    set PkgName=!PkgName:.=-!
                    rem 创夹，移动
                    mkdir simple\!PkgName!
                    echo.正在移动 %%d\%%f
                    move /y %%d\%%f simple\!PkgName!\
                )
            ) else (
                rem 压缩包的文件有可能命名不规范
                echo.请自行处理 %%d\%%f
            )
        )
    )
)
setlocal disabledelayedexpansion

echo.
echo.文件处理完成。
pause
