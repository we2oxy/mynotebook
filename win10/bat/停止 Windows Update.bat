@echo off 
sc stop wuauserv
sc stop bits
sc stop bits
sc stop appidsvc
sc stop cryptsvc
sc stop trustedinstaller
pause