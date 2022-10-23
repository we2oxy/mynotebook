@echo off 
DISM/Online /Cleanup-image/Scanhealth
DISM.exe /Online /Cleanup-image /Restorehealth
sfc /scannow
pause