@echo The backup task has been started and will exit automatically after completion.
@echo off

:: Create Date: 2019-10-25 13:50:17
:: Author:      huangweilai
:: Version:     1.0 
:: Description: backup scripts  

set Get_Date=%date:~0,4%-%date:~5,2%-%date:~8,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%

echo %Get_Date% | clip