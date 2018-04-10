@echo off

setlocal enableextensions enabledelayedexpansion

for /f %%f in ('wmic ComputerSystem get TotalPhysicalMemory /value ^| find "="') do set %%f

set TotalPhysicalMemory=%TotalPhysicalMemory%
set "TotalPhysicalMemory=%TotalPhysicalMemory:~0,-3%"
set /A MB_MEMORY=%TotalPhysicalMemory%/1049

set UV_THREADPOOL_SIZE=%NUMBER_OF_PROCESSORS%

"%ProgramFiles%\Nimiq\node" --max_old_space_size=%MB_MEMORY% "%ProgramFiles%\Nimiq\index.js" --config="%LocalAppData%\Nimiq\nimiq-conf.txt"
