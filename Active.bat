@ECHO OFF&PUSHD %~DP0 &TITLE 激活工具（Windows和Office）编写人：王松 2019.6.21 V1.1

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

set slmgrPath=%SystemRoot%\system32\slmgr.vbs
set kmserver=kms.03k.org

echo 请添加服务器地址，默认为kms.03k.org，默认请回车：

set /p kmserver=

if not defined server (echo 使用%kmserver%服务器激活 ) else ( echo 使用%kmserver%进行激活)


echo 注意！！！ 注意！！！ 此脚本只支持VL版本，非VL不支持
echo.
echo.
echo ######################################请选择要执行的操作#################################
echo --------------------------------------1、激活Windows ------------------------------------
echo --------------------------------------2、激活Office -------------------------------------
echo --------------------------------------3、转换office VL并激活 ----------------------------
echo --------------------------------------4、激活Window和Office -----------------------------
echo.
echo.
echo 请选择要执行的操作:

set /p num=
if %num%==1 goto windows
if %num%==2 goto office
if %num%==3 goto turnoffice
if %num%==4 goto windows

:windows
echo 卸载密钥
cscript /nologo %slmgrPath% /upk 
echo 清除注册表密钥
cscript /nologo %slmgrPath% /cpky 
echo 清除密钥管理服务器
cscript /nologo %slmgrPath% /ckms 
echo 安装密钥             
cscript /nologo %slmgrPath% /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
echo 更改密钥服务器地址         
cscript /nologo %slmgrPath% /skms %kmserver% 
echo 进行激活  
cscript  /nologo %slmgrPath% /ato  
if  %num%==4 goto office 
pause && exit

:office
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16"
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16"
cscript   ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP
cscript   ospp.vbs /sethst:%kmserver%        
cscript   ospp.vbs /act 
cscript   ospp.vbs /dstatus
pause && exit

:turnoffice 

echo 转换VL版
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16"
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16"

echo 正在重置Office2019零售激活...
cscript ospp.vbs /rearm
echo 正在安装 KMS 许可证...
for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
echo 正在安装 MAK 许可证...
for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
echo 正在安装 KMS 密钥...
cscript ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP
echo.
echo 转化完成
if  %num%==3 goto office 
pause >null
exit
