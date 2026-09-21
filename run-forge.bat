@echo off
setlocal
cd /d "%~dp0"

call "%~dp0webui.settings.bat"

if not exist "%PYTHON%" (
  echo Forge runtime not found. Run Install-ForgeRuntime.ps1 first.
  exit /b 1
)

"%PYTHON%" -s -c "import sys, torch, torchvision, bitsandbytes; assert sys.prefix.lower().rstrip('\\') == r'%VENV_DIR%'.lower().rstrip('\\'), sys.prefix; assert torch.__version__ == '2.9.1+cu130', torch.__version__; assert torchvision.__version__ == '0.24.1+cu130', torchvision.__version__; assert torch.version.cuda == '13.0', torch.version.cuda; assert bitsandbytes.__version__ == '0.50.2', bitsandbytes.__version__; assert torch.cuda.is_available()"
if errorlevel 1 (
  echo Forge runtime validation failed. Run Install-ForgeRuntime.ps1 in a fresh clone.
  exit /b 1
)

call webui.bat %*
endlocal