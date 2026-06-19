@echo off
echo Installing docx package...
cd /d "%APPDATA%\Claude\local-agent-mode-sessions\5e8e925d-b835-49bc-ae48-7b5e1ba89256\c216b8cf-eec2-4276-9345-fa6900707b3c\local_5584184a-8e55-44ca-a181-86bcc458c7e0\outputs"
npm install docx --save
echo Generating Word document...
node build_nexus_doc.js
echo.
echo Done! File saved to your nexus folder.
pause
