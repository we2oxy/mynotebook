@echo off 
ipconfig /flushdns
netsh winsock reset
netsh winsock reset proxy
pause