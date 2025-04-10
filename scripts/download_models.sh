#! /bin/bash
# download models from huggingface and save to host machine /models

download_model() {
    local url=$1
	local dir=$2
    local filename="/models/${dir}/${url##*/}"
    
    if [ ! -f "$filename" ]; then
        echo "Downloading model $filename"
		mkdir -p /models/${dir}
        curl --location "$url" -o "$filename"
    else
        echo "Model $filename already exists"
    fi
}

# VAE_URL=https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors
# download_model $VAE_URL "vae"
MEDIUM_MODEL_URL=https://huggingface.co/sf3q5ws/duc/resolve/main/juggernautXL_juggXIByRundiffusion.safetensors
SMALL_MODEL_URL=https://huggingface.co/Comfy-Org/stable-diffusion-v1-5-archive/resolve/main/v1-5-pruned-emaonly-fp16.safetensors
download_model $MEDIUM_MODEL_URL "checkpoints"
download_model $SMALL_MODEL_URL "checkpoints"


/


