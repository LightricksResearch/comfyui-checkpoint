# building contaienr for https://github.com/comfyanonymous/ComfyUI
# FROM nvidia/cuda:12.6.2-devel-ubuntu24.04
FROM nvidia/cuda:12.6.2-base-ubuntu24.04
WORKDIR /app

# Clone the ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI .


RUN ./scripts/download_models.sh

#RUN ##add-apt-repository ppa:deadsnakes/ppa \
RUN apt update && apt install -y software-properties-common
RUN apt install -y curl
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt install -y python3.9 \
	&& apt install -y python3-pip
#COPY --exclude=./models/*  . .

RUN pip install torch torchvision torchaudio  --break-system-packages --extra-index-url https://download.pytorch.org/whl/cu124
RUN pip install -r requirements.txt  --break-system-packages
EXPOSE 8188
CMD ["python3", "main.py"]
