FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL description="Azure2HornbillUserImport" version="0.3.1"

COPY src/install-hornbill.ps1 c:/windows/temp/install-hornbill.ps1
RUN powershell.exe -noprofile -executionpolicy bypass -file c:\windows\temp\install-hornbill.ps1
COPY src/Get-AzureAppConfig.ps1 c:/Hornbill_Import/Get-AzureAppConfig.ps1
COPY src/start-hornbillsync.ps1 c:/Hornbill_Import/start-hornbillsync.ps1

ENTRYPOINT ["powershell.exe", "-executionpolicy bypass", "-noprofile"]
CMD ["-file c:\\Hornbill_Import\\start-hornbillsync.ps1"]