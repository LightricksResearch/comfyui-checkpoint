#! /bin/bash
# download models from huggingface and save to models/

VAE_URL=https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors
VAE_FILENAME="models/vae/${VAE_URL##*/}"
mkdir -p models/vae

MODEL_URL=https://huggingface.co/sf3q5ws/duc/resolve/main/juggernautXL_juggXIByRundiffusion.safetensors
MODEL_FILENAME="models/checkpoints/${MODEL_URL##*/}"
mkdir -p models/checkpoints

if [ ! -f "$MODEL_FILENAME" ]; then
	echo "Downloading model $MODEL_FILENAME"
	curl --location $MODEL_URL -o $MODEL_FILENAME
fi

if [ ! -f "$VAE_FILENAME" ]; then
	echo "Downloading vae $VAE_FILENAME"
	curl --location $VAE_FILE -o $VAE_FILENAME
fi


