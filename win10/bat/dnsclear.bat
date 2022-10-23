@echo off
ipconfig /flushdns

net stop Dnscache
net start Dnscache
    
pause