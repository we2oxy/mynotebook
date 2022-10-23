@echo off 
sc start bits
sc start wuauserv
sc start appidsvc
sc start cryptsvc
sc start trustedinstaller
pause