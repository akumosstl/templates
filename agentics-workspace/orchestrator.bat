@echo off

cd C:\Users\MEUCOMPUTADOR\.agentic-workspace\portosantos\frontend-port-scheduler

set ROOT=C:\Users\MEUCOMPUTADOR\.agentic\sourcecode\template-processor\output
set SCRIPT=false

echo DEVOPS INITIAL
set ACTION=%ROOT%\devops-initial.md
java -jar C:\Users\MEUCOMPUTADOR\.agentic\bin\agentic.jar

echo ANGULAR AGENT
set ACTION=%ROOT%\angular.md
java -jar C:\Users\MEUCOMPUTADOR\.agentic\bin\agentic.jar

