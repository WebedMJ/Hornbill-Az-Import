FROM mcr.microsoft.com/windows/servercore

LABEL description="Azure2HornbillUserImport" version="0.2.1"

COPY src/install-hornbill.ps1 c:/windows/temp/install-hornbill.ps1
RUN powershell.exe -noprofile -executionpolicy bypass -file c:\windows\temp\install-hornbill.ps1
COPY src/conftemplate.json c:/Hornbill_Import/conftemplate.json
COPY src/start-hornbillsync.ps1 c:/Hornbill_Import/start-hornbillsync.ps1

ENTRYPOINT ["powershell.exe", "-executionpolicy bypass", "-noprofile"]
CMD ["-file c:\\Hornbill_Import\\start-hornbillsync.ps1"]