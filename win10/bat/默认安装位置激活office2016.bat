@echo off   
::64位Office2016默认路径在C:\Program Files\Microsoft Office\Office16
::64位Office2013默认路径在C:\Program Files\Microsoft Office\Office15
::32位Office2016默认路径在C:\Program Files (x86)\Microsoft Office\Office16
::32位Office2013默认路径在C:\Program Files (x86)\Microsoft Office\Office15
cd C:\Program Files\Microsoft Office\Office16
cscript ospp.vbs /sethst:binye.xyz
cscript ospp.vbs /act                           
pause

