@echo off
rem Lance le site en local avec le studio de synchronisation (publication, forme d'onde).
rem Laisser cette fenetre ouverte pendant l'utilisation ; la fermer pour arreter.
cd /d "%~dp0"
set "STUDIO=%~dp0..\sources\studio.py"
if not exist "%STUDIO%" set "STUDIO=%~dp0sources\studio.py"
python "%STUDIO%" 8000
if errorlevel 1 pause
