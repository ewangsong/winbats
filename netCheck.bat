@echo off
::����Ƿ�Ϊ����ԱȨ�ޣ����ǽ�����Ȩ
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

echo --------------------------------------��������Բ�-------------------------------------
echo.
echo.
echo ######################################��ѡ��Ҫִ�еĲ���###################################
echo ---------------------------------------1��������ն� --------------------------------------
echo ---------------------------------------2��������ļ� --------------------------------------
echo ---------------------------------------3��������ӡ������ ----------------------------------
echo ---------------------------------------4�������������� ------------------------------------
echo ---------------------------------------5������winsock ע����Ҫ����ϵͳ --------------------

echo.
echo.
echo ��ѡ��Ҫִ�еĲ���:

set /p num=
if %num%==1 goto CONSOLE
if %num%==2 goto FILE
if %num%==3 goto REPRINT
if %num%==4 goto renetwork
if %num%==5 goto rewinsock

:FILE
echo ---------------------------------------���Ե����ڼ��--------------------------------------
echo --------------------------------------������Ϣ--------------------------------------------- >>%USERPROFILE%\Desktop\1.txt
ipconfig /all >>%USERPROFILE%\Desktop\1.txt

echo --------------------------------------�����ͨ��------------------------------------------- >>%USERPROFILE%\Desktop\1.txt
ping -n 5 192.168.1.2  >>%USERPROFILE%\Desktop\1.txt

echo ---------------------------------------��·��ͨ��------------------------------------------ >>%USERPROFILE%\Desktop\1.txt
ping -n 5 192.168.1.1 >>%USERPROFILE%\Desktop\1.txt

echo ---------------------------------------���豸����ͨ��-------------------------------------- >>%USERPROFILE%\Desktop\1.txt
ping -n 5 114.255.81.251 >>%USERPROFILE%\Desktop\1.txt

echo ---------------------------------------��114ͨ��------------------------------------------- >>%USERPROFILE%\Desktop\1.txt
ping -n 5 114.114.114.114 >>%USERPROFILE%\Desktop\1.txt

echo ----------------------------------------��dnsͨ��------------------------------------------ >>%USERPROFILE%\Desktop\1.txt
ping -n 5 172.30.16.13 >>%USERPROFILE%\Desktop\1.txt

echo ---------------------------------------��ǰ��DNS��Ϣ--------------------------------------- >>%USERPROFILE%\Desktop\1.txt
ipconfig /all |find "DNS ������"  >>%USERPROFILE%\Desktop\1.txt
ipconfig /flushdns >>%USERPROFILE%\Desktop\1.txt

echo ----------------------------------------�鿴��ǰwifi��Ϣ------------------------------------ >>%USERPROFILE%\Desktop\1.txt
netsh wlan show interface  >>%USERPROFILE%\Desktop\1.txt

echo ----------------------------------------�鿴������վ---------------------------------------- >>%USERPROFILE%\Desktop\1.txt
for %%t in (baidu.com,taobao.com,163.com,shimo.im) do (
echo.
echo "%%t"
ping -n 2 %%t
) >>%USERPROFILE%\Desktop\1.txt

echo ----------------------------------------�鿴·��-------------------------------------------- >>%USERPROFILE%\Desktop\1.txt
route print |find "0.0.0.0" >>%USERPROFILE%\Desktop\1.txt

echo ---------------------------------------��������鿴1.txt----------------------------------
pause && exit

:CONSOLE
echo --------------------------------------������Ϣ----------------------------------------------
ipconfig /all

echo --------------------------------------�����ͨ��--------------------------------------------
ping -n 5 192.168.1.2 

echo ---------------------------------------��·��ͨ��-------------------------------------------
ping -n 5 192.168.1.1

echo ---------------------------------------���豸����ͨ��---------------------------------------
ping -n 5 114.255.81.251

echo ---------------------------------------��114ͨ��--------------------------------------------
ping -n 5 114.114.114.114

echo ---------------------------------------��ǰ��DNS��Ϣ��ˢ��----------------------------------
nslookup www.baidu.com
ipconfig /all |find "DNS ������"
ipconfig /flushdns

echo ----------------------------------------��dnsͨ��-------------------------------------------
ping -n 5 172.30.16.13

echo ----------------------------------------�鿴��ǰwifi��Ϣ------------------------------------
netsh wlan show interface 

echo ----------------------------------------�鿴·��--------------------------------------------
route print |find "0.0.0.0"

echo ----------------------------------------�鿴������վ----------------------------------------
for %%t in (baidu.com,taobao.com,163.com,shimo.im) do (
echo.
echo "%%t"
ping -n 2 %%t
)

echo ---------------------------------------��������鿴---------------------------------------
pause && exit

:REPRINT
net stop spooler
net start spooler
pause && exit

:renetwork
echo ���ڹر�����................................................................................

for /f "skip=3 tokens=4 delims= " %%i in ('netsh interface show interface ^|find "������"') do (
echo ���ڹر�����%%i
netsh interface set interface %%i admin=disabled
)
echo ������������...............................................................................
for /f "skip=3 tokens=4 delims= " %%i in ('netsh interface show interface') do (
echo ������������%%i
netsh interface set interface %%i admin=enabled
)

pause && exit


:rewinsock
netsh winsock reset
set re=Y
echo �Ƿ���������Y/NĬ��ΪY
set /p re=
if /i "%re%" EQU "Y" (
echo ������������...............................................
shutdown -r -t 5)else echo �Ժ�����������............................................
pause && exit

:reboot
shutdown -r -t 5 