@echo off 
echo 正在同步时间...
net stop w32time  
w32tm /unregister  
w32tm /register  
net start w32time  
w32tm /resync /nowait  
pause