@echo off
::检查是否为管理员权限，不是进行提权
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

echo --------------------------------------网络检测简单自测-------------------------------------
echo.
echo.
echo ######################################请选择要执行的操作###################################
echo ---------------------------------------1、输出到终端 --------------------------------------
echo ---------------------------------------2、输出到文件 --------------------------------------
echo ---------------------------------------3、重启打印机服务 ----------------------------------
echo ---------------------------------------4、重启网卡服务 ------------------------------------
echo ---------------------------------------5、重置winsock 注意需要重启系统 --------------------

echo.
echo.
echo 请选择要执行的操作:

set /p num=
if %num%==1 goto CONSOLE
if %num%==2 goto FILE
if %num%==3 goto REPRINT
if %num%==4 goto renetwork
if %num%==5 goto rewinsock

:FILE
echo ---------------------------------------请稍等正在检测--------------------------------------
echo --------------------------------------网络信息--------------------------------------------- >>%USERPROFILE%\Desktop\1.txt
ipconfig /all >>%USERPROFILE%\Desktop\1.txt

echo --------------------------------------与核心通信------------------------------------------- >>%USERPROFILE%\Desktop\1.txt
ping -n 5 192.168.1.2  >>%USERPROFILE%\Desktop\1.txt

echo ---------------------------------------与路由通信------------------------------------------ >>%USERPROFILE%\Desktop\1.txt
ping -n 5 192.168.1.1 >>%USERPROFILE%\Desktop\1.txt

echo ---------------------------------------与设备出口通信-------------------------------------- >>%USERPROFILE%\Desktop\1.txt
ping -n 5 114.255.81.251 >>%USERPROFILE%\Desktop\1.txt

echo ---------------------------------------与114通信------------------------------------------- >>%USERPROFILE%\Desktop\1.txt
ping -n 5 114.114.114.114 >>%USERPROFILE%\Desktop\1.txt

echo ----------------------------------------与dns通信------------------------------------------ >>%USERPROFILE%\Desktop\1.txt
ping -n 5 172.30.16.13 >>%USERPROFILE%\Desktop\1.txt

echo ---------------------------------------当前的DNS信息--------------------------------------- >>%USERPROFILE%\Desktop\1.txt
ipconfig /all |find "DNS 服务器"  >>%USERPROFILE%\Desktop\1.txt
ipconfig /flushdns >>%USERPROFILE%\Desktop\1.txt

echo ----------------------------------------查看当前wifi信息------------------------------------ >>%USERPROFILE%\Desktop\1.txt
netsh wlan show interface  >>%USERPROFILE%\Desktop\1.txt

echo ----------------------------------------查看常用网站---------------------------------------- >>%USERPROFILE%\Desktop\1.txt
for %%t in (baidu.com,taobao.com,163.com,shimo.im) do (
echo.
echo "%%t"
ping -n 2 %%t
) >>%USERPROFILE%\Desktop\1.txt

echo ----------------------------------------查看路由-------------------------------------------- >>%USERPROFILE%\Desktop\1.txt
route print |find "0.0.0.0" >>%USERPROFILE%\Desktop\1.txt

echo ---------------------------------------检测完成请查看1.txt----------------------------------
pause && exit

:CONSOLE
echo --------------------------------------网络信息----------------------------------------------
ipconfig /all

echo --------------------------------------与核心通信--------------------------------------------
ping -n 5 192.168.1.2 

echo ---------------------------------------与路由通信-------------------------------------------
ping -n 5 192.168.1.1

echo ---------------------------------------与设备出口通信---------------------------------------
ping -n 5 114.255.81.251

echo ---------------------------------------与114通信--------------------------------------------
ping -n 5 114.114.114.114

echo ---------------------------------------当前的DNS信息并刷新----------------------------------
nslookup www.baidu.com
ipconfig /all |find "DNS 服务器"
ipconfig /flushdns

echo ----------------------------------------与dns通信-------------------------------------------
ping -n 5 172.30.16.13

echo ----------------------------------------查看当前wifi信息------------------------------------
netsh wlan show interface 

echo ----------------------------------------查看路由--------------------------------------------
route print |find "0.0.0.0"

echo ----------------------------------------查看常用网站----------------------------------------
for %%t in (baidu.com,taobao.com,163.com,shimo.im) do (
echo.
echo "%%t"
ping -n 2 %%t
)

echo ---------------------------------------检测完成请查看---------------------------------------
pause && exit

:REPRINT
net stop spooler
net start spooler
pause && exit

:renetwork
echo 正在关闭网卡................................................................................

for /f "skip=3 tokens=4 delims= " %%i in ('netsh interface show interface ^|find "已连接"') do (
echo 正在关闭网卡%%i
netsh interface set interface %%i admin=disabled
)
echo 正在启动网卡...............................................................................
for /f "skip=3 tokens=4 delims= " %%i in ('netsh interface show interface') do (
echo 正在启动网卡%%i
netsh interface set interface %%i admin=enabled
)

pause && exit


:rewinsock
netsh winsock reset
set re=Y
echo 是否现在重启Y/N默认为Y
set /p re=
if /i "%re%" EQU "Y" (
echo 正在重新启动...............................................
shutdown -r -t 5)else echo 稍后请自行重启............................................
pause && exit

:reboot
shutdown -r -t 5 