@ECHO OFF&PUSHD %~DP0 &TITLE ����ߣ�Windows��Office����д�ˣ����� 2019.6.21 V1.1

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

echo ����ӷ�������ַ��Ĭ��Ϊkms.03k.org��Ĭ����س���

set /p kmserver=

if not defined server (echo ʹ��%kmserver%���������� ) else ( echo ʹ��%kmserver%���м���)


echo ע�⣡���� ע�⣡���� �˽ű�ֻ֧��VL�汾����VL��֧��
echo.
echo.
echo ######################################��ѡ��Ҫִ�еĲ���#################################
echo --------------------------------------1������Windows ------------------------------------
echo --------------------------------------2������Office -------------------------------------
echo --------------------------------------3��ת��office VL������ ----------------------------
echo --------------------------------------4������Window��Office -----------------------------
echo.
echo.
echo ��ѡ��Ҫִ�еĲ���:

set /p num=
if %num%==1 goto windows
if %num%==2 goto office
if %num%==3 goto turnoffice
if %num%==4 goto windows

:windows
echo ж����Կ
cscript /nologo %slmgrPath% /upk 
echo ���ע�����Կ
cscript /nologo %slmgrPath% /cpky 
echo �����Կ���������
cscript /nologo %slmgrPath% /ckms 
echo ��װ��Կ             
cscript /nologo %slmgrPath% /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
echo ������Կ��������ַ         
cscript /nologo %slmgrPath% /skms %kmserver% 
echo ���м���  
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

echo ת��VL��
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16"
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16"

echo ��������Office2019���ۼ���...
cscript ospp.vbs /rearm
echo ���ڰ�װ KMS ���֤...
for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
echo ���ڰ�װ MAK ���֤...
for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
echo ���ڰ�װ KMS ��Կ...
cscript ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP
echo.
echo ת�����
if  %num%==3 goto office 
pause >null
exit
