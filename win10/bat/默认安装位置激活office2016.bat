@echo off   
::64λOffice2016Ĭ��·����C:\Program Files\Microsoft Office\Office16
::64λOffice2013Ĭ��·����C:\Program Files\Microsoft Office\Office15
::32λOffice2016Ĭ��·����C:\Program Files (x86)\Microsoft Office\Office16
::32λOffice2013Ĭ��·����C:\Program Files (x86)\Microsoft Office\Office15
cd C:\Program Files\Microsoft Office\Office16
cscript ospp.vbs /sethst:binye.xyz
cscript ospp.vbs /act                           
pause

