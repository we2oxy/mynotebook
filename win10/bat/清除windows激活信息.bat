@echo off        
@echo 正在清除windows激活信息......
slmgr /upk
slmgr /ckms
slmgr /rearm
pause