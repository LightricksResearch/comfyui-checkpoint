# ComfyUI checkpoint POC

this is a POC for running process checkpoint for ComfyUI 
docker image wraps open source ComfyUI https://github.com/comfyanonymous/ComfyUI

container expects the models to be available on the host under `/models` (not supplied as part of the image)



## deploy using Helm
checkpoint CRD  will be added later
```
├── Chart.yaml
├── values.yaml # values for the chart should be alreted by user
└── templates/
    ├── deployment.yaml
    └── service.yaml
```


```bash
# view the template
helm template comfyui-checkpoint . -f values.yaml

# install [/upgrade] the chart
helm install [/upgrade] comfyui-checkpoint . --namespace $NAMESPACE 

# list the chart
helm list --namespace $NAMESPACE

# delete the chart
helm delete comfyui-checkpoint --namespace $NAMESPACE
```


## Run
make sure you have the models available on the machine
```bash
# we provide ./scripts/download_models.sh
# yet for k8s here is a helpfull command to download the models to the container
kubectl exec -it $POD -- curl --location "https://huggingface.co/sf3q5ws/duc/resolve/main/juggernautXL_juggXIByRundiffusion.safetensors" -o /app/models/checkpoints/juggernautXL_juggXIByRundiffusion.safetensors

kubectl exec -it $POD -- curl --location "https://huggingface.co/Comfy-Org/stable-diffusion-v1-5-archive/resolve/main/v1-5-pruned-emaonly-fp16.safetensors" -o /app/models/checkpoints/v1-5-pruned-emaonly-fp16.safetensors

# verify 
kubectl exec -it $POD -- ls -l /app/models/checkpoints
```


## image dev notes (not in k8s mode)
building and testing applicative container on a VM instance

for testing start the container (example using podman)
```bash
# make sure you have models directory on your local machine
mkdir -p /tmp/output
sudo mkdir /models
sudo chown $USER /models
./scripts/download_models.sh

# start container (inference time will be printed on console)
podman run --security-opt=label=disable --gpus=all -p 8188:8188 -v /models:/app/models -v /tmp/output:/app/output  --name=comfyui  gcr.io/$PROJECT_NAME/comfyui-checkpoint:0.0.4

# execute inference
 ./scripts/generate_image.sh
 
 # we will be able to see images on host under
ls -l /tmp/output/ComfyUI_*_.png

 # alternatively you can use create an ssh tunnel and use the web interface
 gcloud compute ssh $VM_INSTANCE --zone=$ZONE --project=$PROJECT -- -L 8188:0.0.0.0:8188 
```

*build and push image image*
building the image - you shuold provide your own `PROJECT_NAME`
```bash
export PROJECT_NAME=<your-project-name>

podman build . -t gcr.io/$PROJECT_NAME/comfyui-checkpoint:0.0.4

podman push gcr.io/$PROJECT_NAME/comfyui-checkpoint:0.0.4
```


## Execution times
in general the first time prompt execution is much slower than the subsequent ones.

times may vary based on GPU, memory, models size, etc.. 

in this example we can see execution time for using medium side model: `juggernautXL_juggXIByRundiffusion.safetensors`
```
Prompt executed in 43.91 seconds
Prompt executed in 1.68 seconds
Prompt executed in 1.65 seconds
Prompt executed in 1.63 seconds
```
the above execution achieved with the following spec
```
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 560.35.05              Driver Version: 560.35.05      CUDA Version: 12.6     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA A100-SXM4-40GB          Off |   00000000:00:04.0 Off |                    0 |
| N/A   30C    P0             49W /  400W |    7207MiB /  40960MiB |      0%      Default |
|                                         |                        |             Disabled |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A      2243      C   python3                                      7194MiB |
+-----------------------------------------------------------------------------------------+
```
