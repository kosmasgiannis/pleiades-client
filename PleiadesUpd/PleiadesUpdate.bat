@echo on
find "sourcedir=" PleiadesUpd.ini | sort /r | date | find "=" > en#er.bat
echo set value=%%6> enter.bat
call en#er.bat
del en?er.bat > nul
echo Value is %value%.
dir %value%
start PleiadesUpd.exe -a
