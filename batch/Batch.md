##### 例1：`echo`

```batch
echo hello world
```

`echo`用来输出，但是这个只在cmd下管用，在powershell下字符串有空格的话得加引号。

**`type`命令可以查看文件内容。**

##### 例2：`timeout`

```batch
timeout /t 5
```

等待5秒。任意键终止。

```batch
timeout /t 5 /nobreak
```

等待5秒，不能任意键终止（Ctrl+C终止）。`5`是`/t`的参数，必须跟在`/t`后面，不能换位置。

以上写法会在控制台显示倒数提示，如果要去掉提示，用`nul`。

```batch
timeout /t 5 /nobreak > nul
or
timeout /t 5 > nul
```

有些控制台可以用`sleep 5`来暂停5秒，但Win10应该是不支持了。

##### 例3：`@echo off`

像上面这样写命令，运行时会有路径，像下面这样：

```batch
C:\Users\Ju\Desktop>echo hello world
hello world
```

想要去掉路径，可以在文件开头加一句`@echo off`。

实际上在命令前加一个`@`就可以不显示路径了，但这样每一行命令都加的话太麻烦，可以用`echo off`关掉所有路径，但是`echo off`本身还会带有路径，所以用`@`把这一句关掉，就可以整体关掉了。

##### 例4：`pause`

`pause`暂停脚本，等待输入。如果不想显示提示文本，使用`pause > nul`。

`exit`可以直接退出脚本。

##### 例5：`del`

```batch
del /p file.txt
```

删除前提示。默认不提示。见帮助。

##### 例6：`help`

`help [command]`可以查看命令帮助。直接输入`help`可以输出所有支持的命令。

`[command] /?`可以查看该命令的帮助。

##### 例7：`set /a`

```batch
set /a 5+5
```

`set /a`把后面的参数当时表达式，用来计算。实际上`set`要复杂很多，查看一下帮助吧。

##### 例8：`~`

有些文件夹名太长，可以用`~`代替，但具体使用限制略多。

```batch
C:\cd progra~1
C:\PROGRA~1>
```

**注意**：

* 首先只有名称超过（是**超过**，等于也不行）**8**个字符的文件夹才能用`~`代替名称
* 其次要代替名称必须先输入前**6**个字符，必须是6个，多了少了都不行
* 再者只有当同文件夹中有两个及以上以`progra`开头的文件夹名称，且都超过8个字符时，上述命令才起作用

`~1`是指进入找到的第一个符合上述三个条件的文件夹，同理`~2`进入第二个。如果越界，就报错。

##### 例9：`&&`

```batch
echo hello && echo world
```

`&&`会将两个命令连接在一行上，类似于一般语言中的`;`。注意，`echo`会换行。

##### 例10：`|`

```batch
echo y | del /p file.txt
```

管道`|`会把前语句的输出当作后语句的输入传递。

##### 例11：`set`功能之赋值

```batch
rem 等号两边不能有空格
set str=batcher
echo %str%

rem 如果字符串内有特殊字符，需要把赋值语句用引号引起来
set "txt=bat&cher"
rem 输出也需要用引号，否则该语句相当于
rem echo bat & cher
rem &之前的语句可以正常执行，但之后的cher就不是一个正确的语句了
echo "%txt%"

rem 给变量制空可以清除变量，即该变量已经不存在了
set txt=
echo %txt%
```

##### 例12：`set`功能之数学运算

```batch
rem 此时a的类型到底是字符串还是数字？
set a=100
set b=200
rem 等号右侧的变量可以省略百分号
set /a c=%a%+%b%
set /a c=a+b

rem 八进制和十六进制转十进制
set /a 012
set /a 0xa

rem 取余操作需要用两个百分号
rem 命令行下该操作无效，只能在文件中有效
set /a r=10%%3

rem 逻辑运算用到特殊字符时需要加引号
set /a "e=1<<10"
set /a e=1"<<"10
rem 以上两种效果等同

rem 局限：数字最大位数只支持32位，不支持浮点数运算
```

##### 例13：`set`功能之交互输入

```batch
rem 简单的获取输入
set /p input=Enter Something:
echo %input%

rem 读取文件的第一行并赋值
set /p line=<text.txt
rem 程序会把text.txt当做文件去找，并把读取的第一行赋值给line
rem 此时文件名加不加引号都行

rem 输出字符串不换行
rem 感觉这个用法很牵强
@echo off
for %%i in (hello world) do (
    set /p =%%i<nul
)
rem 这个是利用了set /p会把等号后面的内容当做交互显示信息输出的特点
rem 而输入的内容会赋值给等号前面的变量，
rem 在这个例子中，因为不需要赋值的变量，所以等号前面没有内容，
rem 又因为也不需要输入什么东西，所以加一个<nul来取消输入
rem 这样就相当于显示了一个hello紧接着又显示了一个world，没有换行
rem 咋说，就很牵强
```

##### 例14：`set`功能之字符串截取

```batch
rem 标准模板是 set sub=%str:~x,y%
rem str是要截取的字符串
rem x表示从哪里开始截取，为正则从左往右数，为负则从右往左数
rem y为正表示从左往右截取多少位，为负表示先从左往右取到最后，然后抛弃最后的|y|位
rem 若没有y则表示截取到字符串末尾
set num=12345
set n=%num:~0,3% & rem n=123
set n=%num:~0,-1% & rem n=1234
set n=%num:~-4,3% & rem n=234
set n=%num:~-4,-2% & rem n=23
set n=%num:~1% & rem n=2345
set n=%num:~-2% & rem n=45
```

##### 例14：`set`功能之字符串替换

```batch
rem 标准模板是 set StrNew=%StrOld:SubOld=SubNew%
set old=hello
set new=%old:he=sha% & rem new=shallo
set bra=%new:o=% & rem bra=shall

rem 转换大小写
@echo off
setlocal enabledelayedexpansion
set up=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
set word=hello
for %%i in (%up%) do (
    set word=!word:%%i=%%i!
)
echo %word%
pause
```

##### 例15：`if`功能之判断上一条语句执行结果

```batch
@echo off
echo bbs.bathome.net | findstr "bat"
rem 第一个左括号左边必须有空格
if %errorlevel% equ 0 (
    echo yes found
rem else的右边必须有空格，左边建议有空格，这个else不能换行
) else (
    echo no found
)
pause

@echo off
echo bbs.bathome.net | findstr "bat"
rem if errorlevel 1的意思是errorlevel是否大于等于1
if errorlevel 1 (
    echo no found
) else (
    echo yes found
)
pause
```

##### 例16：`if`功能之判断文件是否存在

```batch
rem if exist无法判断一个名称是文件夹还是文件，所以需要区分
@echo off
rem 判断文件夹是否存在时文件夹名称后加一个反斜线就可表示判断的是文件夹
if exist "C:\Program Files\" (
    echo dir exist
) else (
    echo dir not exist
)
pause

rem 判断文件时就复杂些，需要先排除文件夹
@echo off
if not exist "C:\abc\" (
    if exist "C:\abc" (
        echo file exist
    ) else (
        echo file not exist
    )
)
pause

rem 但是如果在文件夹存在的情况下怎么判断同名文件也存在呢？
```

##### 例17：`if`功能之比较字符串

```batch
rem 数字比较和字符串比较与其它语言类似，不举例
if "A" == "a" echo not i yes
rem 加i可以忽略字母大小写
if /i "A" == "a" echo i yes

rem 比较操作符
rem equ, neq, lss, leq, gtr, geq
```

##### 例18：变量延迟扩展

```batch
@echo off
rem 在使用复合语句时需要开启变量延迟扩展
rem 估计是复合语句中变量并不是立刻更新
setlocal enabledelayedexpansion
set car=before
if "%car%" == "before" (
    set car=after
	rem 这里需要用双叹号变量才会更新，双百分号不行
	if "!car!" == "after" (
	    echo yes
	) else (
	    echo no
	)
)
pause
```

##### 例19：技巧之删除重复元素

```batch
rem 这个脚本效率低
rem 如果元素中有等号，则不能正确处理
@echo off
for %%i in (a b d c b a e) do (
    rem if not defined如果没有定义
    if not defined _%%i (
	    echo %%i
		set "_%%i=1"
	)
)
pause
```

##### 例20：`for /f`

```batch
@echo off
rem demo.txt 是一个文件名，for /f 会按行遍历文件内容
rem 注意，for /f 一定是按行处理文件的，不会变
for /f %%i in (demo.txt) do (
   echo.%%i
)
pause
```

```batch
@echo off
rem 依然是按照行来分割，
rem 但是，对于每一行，再用delims指定的分隔符分割成数列，然后默认只返回第一列
rem 即每一行都只打印了第一个分隔符之前的内容
for /f "delims=，" %%i in (demo.txt) do (
   echo.%%i
)
pause
```

```batch
@echo off
rem 因为默认只返回分割的第一列，所以就有tokens
rem 它可以指定要返回哪一列
for /f "tokens=3 delims=，" %%i in (demo.txt) do (
   echo.%%i
)
pause
```

```batch
@echo off
rem 同时也可以指定返回多列，用逗号分隔，比如
for /f "tokens=1,3 delims=，" %%i in (demo.txt) do (
   echo.%%i
   rem 但是后面的列需要将形式变量i按序向后增加以显示其他列
   echo.%%j
)
rem 也可以指定范围，比如 tokens=1-3
pause
```

```batch
@echo off
rem *的意思是，从*之前的数字所代表的那一列之后，就不再用分隔符分隔，而作为整体一列
for /f "tokens=1,* delims=，" %%i in (demo.txt) do (
   echo.%%i
   echo.%%j
)
pause
```

```batch
@echo off
rem skip可以跳过开头的n行，需要是正整数
for /f "skip=1" %%i in (demo.txt) do (
   echo %%i
)
pause
```

```batch
@echo off
rem eol可以指定忽略以某一个字符开头的行，默认是分号
for /f "eol=," %%i in (demo.txt) do (
   echo %%i
)
pause
```

```batch
@echo off
rem 如果文件名中有空格或&，需要用引号的同时加一个usebackq
rem 关于该参数的其他用法，见帮助
for /f "usebackq" %%i in ("de mo.txt") do (
   echo %%i
)
pause
```

##### 例21：延迟变量扩展

对于 `Batch` 来说，语句执行的规则是**自上而下，逐条执行**。但何为**条**？

复合语句也算一条语句。那些 `if` 和 `for` 的结构整体都算一条语句，用 `&&` 和 `||` 以及管道符等连接的都是一条语句。

所谓**扩展**就是语句在执行之前，先把语句中的变量替换掉，也就是那些用双百分号围起来的变量。替换之后再执行语句。

所以如下例：

```batch
@echo off
set num=0
rem 下面的实际是一条语句
rem 所以它的执行过程是，先把%num%替换掉，然后再执行
rem 但在替换num时，num还是0，所以最终输出的结果就是0，而非1
set /a num=num+1 & echo %num%
pause
```

要解决这个问题就需要用到变量延迟扩展，实际就是告诉批处理，这个变量待会再扩展，照顾一下其它代码可能对其进行的更改。

```batch
@echo off
set num=0
rem 在适当的地方加入这一句，开启延迟扩展
setlocal EnableDelayedExpansion
rem 然后变量使用双感叹号围起来，而非双百分号，这样输出就是符合期望的了
set /a num=num+1 & echo !num!
pause
```

##### 例22：`for /l`

```batch
@echo off
rem for /l 实际就是固定次数的循环
rem 三个数字的含义分别是 起始值，步长，终止值
rem 三者必须是整数，其中步长必须大于0
rem 其它两个可正可负可为零
rem 但必须确保有一个有效的有序数列
for /l %%i in (1,1,5) do (
    rem 循环5次
    echo %%i
)
pause
```

