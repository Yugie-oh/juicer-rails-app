@echo off
setlocal
set "ROOT=%~dp0.."
cd /d "%ROOT%"

echo Starting Tailwind CSS watch in a new window...
start "Tailwind CSS" cmd /k "cd /d "%ROOT%" && ruby bin/rails tailwindcss:watch"

echo Starting Rails server on http://localhost:3000
echo Press Ctrl+C to stop the server. Close the Tailwind window to stop CSS watch.
echo.
ruby bin/rails server
