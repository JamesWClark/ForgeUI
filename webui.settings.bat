@echo off
set "PYTHONNOUSERSITE=1"
set "VENV_DIR=%~dp0.venv"
set "PYTHON=%VENV_DIR%\Scripts\python.exe"
set "TORCH_INDEX_URL=https://download.pytorch.org/whl/cu130"
set "TORCH_COMMAND=pip install torch==2.9.1+cu130 torchvision==0.24.1+cu130 --extra-index-url https://download.pytorch.org/whl/cu130"
set "PYTORCH_ALLOC_CONF=backend:cudaMallocAsync"
set "PYTORCH_CUDA_ALLOC_CONF="
set COMMANDLINE_ARGS=--api --autolaunch --autolaunch-chrome-incognito --cuda-malloc --port 7861 --data-dir "%~dp0data" --output-dir "%~dp0outputs" --gradio-allowed-path "%~dp0." --models-dir "%~dp0models" --embeddings-dir "%~dp0embeddings" --ckpt-dir "%~dp0models\Stable-diffusion" --vae-dir "%~dp0models\VAE" --lora-dir "%~dp0models\Lora" --ui-settings-file "%~dp0data\config.json" --ui-config-file "%~dp0data\ui-config.json" --styles-file "%~dp0styles_integrated.csv"
