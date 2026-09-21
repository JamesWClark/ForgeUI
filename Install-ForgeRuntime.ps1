[CmdletBinding()]
param(
    [switch]$ValidateOnly
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$venvPath = Join-Path $root '.venv'
$venvPython = Join-Path $venvPath 'Scripts\python.exe'

function Confirm-LastCommand {
    param([string]$Action)

    if ($LASTEXITCODE -ne 0) {
        throw "$Action failed with exit code $LASTEXITCODE."
    }
}

function Test-ForgeRuntime {
    if (-not (Test-Path $venvPython -PathType Leaf)) {
        throw "Forge runtime not found at $venvPython."
    }

    & $venvPython -s -c "import platform, torch, torchvision, bitsandbytes; assert platform.python_version() == '3.10.11', platform.python_version(); assert torch.__version__ == '2.9.1+cu130', torch.__version__; assert torchvision.__version__ == '0.24.1+cu130', torchvision.__version__; assert torch.version.cuda == '13.0', torch.version.cuda; assert bitsandbytes.__version__ == '0.50.2', bitsandbytes.__version__; assert torch.cuda.is_available(); print(platform.python_version(), torch.__version__, torchvision.__version__, torch.version.cuda, bitsandbytes.__version__)"
    Confirm-LastCommand 'Runtime validation'
}

if ($ValidateOnly) {
    Test-ForgeRuntime
    exit 0
}

if (Test-Path $venvPath) {
    throw "$venvPath already exists. Refusing to replace it; use -ValidateOnly or start from a fresh clone."
}

$pythonVersion = & py -3.10 -c "import platform; print(platform.python_version())"
Confirm-LastCommand 'Python discovery'
if ($pythonVersion.Trim() -ne '3.10.11') {
    throw "Python 3.10.11 is required; py -3.10 selected $pythonVersion."
}

& py -3.10 -m venv $venvPath
Confirm-LastCommand 'Virtual environment creation'
& $venvPython -m pip install pip==26.2.1 wheel==0.48.0
Confirm-LastCommand 'Bootstrap package installation'
& $venvPython -m pip install -r (Join-Path $root 'requirements_runtime.txt')
Confirm-LastCommand 'Forge runtime installation'

Test-ForgeRuntime
Write-Host 'Forge runtime installed. Start it with .\run-forge.bat.'