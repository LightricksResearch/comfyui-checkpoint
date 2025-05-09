# building contaienr for https://github.com/comfyanonymous/ComfyUI
FROM docker.io/nvidia/cuda:12.6.3-base-ubuntu24.04
WORKDIR /app

# install curl and git
RUN apt update && apt install -y software-properties-common
RUN apt install -y curl git

# install python and pip
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt install -y python3.9 \
        && apt install -y python3-pip

# Clone the ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI .

RUN pip install torch torchvision torchaudio  --break-system-packages --extra-index-url https://download.pytorch.org/whl/cu124
RUN pip install -r requirements.txt  --break-system-packages

#COPY --exclude=./models/*  . .
COPY ./scripts ./scripts
# RUN ./scripts/download_models.sh

EXPOSE 8188
CMD ["python3", "main.py"]
