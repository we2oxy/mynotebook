@echo off 
SC config wuauserv start= auto
SC config bits start= auto
SC config cryptsvc start= auto
SC config trustedinstaller start= auto
pause