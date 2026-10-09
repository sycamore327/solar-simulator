@echo off
chcp 65001 >nul
cd /d "%~dp0"
setlocal

echo ============================================
echo    Solar Simulator  ·  太阳系模拟器
echo ============================================
echo.

set "PORT=8000"
set "URL=http://localhost:%PORT%/index.html"

rem —— 找一个能用的 Python ——
set "PY="
where python  >nul 2>nul && set "PY=python"
if not defined PY ( where py      >nul 2>nul && set "PY=py" )
if not defined PY ( where python3 >nul 2>nul && set "PY=python3" )
if not defined PY (
  echo [X] 没找到 Python。请先安装后再运行本文件。
  echo     下载地址： https://www.python.org/downloads/
  echo.
  pause
  exit /b 1
)

rem —— 端口已被占用，说明服务在跑，直接开浏览器 ——
netstat -an | findstr ":%PORT%" | findstr LISTENING >nul 2>nul
if not errorlevel 1 (
  echo 端口 %PORT% 上已经有服务在运行，直接打开浏览器。
  start "" "%URL%"
  timeout /t 2 >nul
  exit /b 0
)

echo 正在启动本地服务：%URL%
echo 关掉这个黑窗口 = 停止服务。
echo.
start "" "%URL%"
%PY% -m http.server %PORT%
