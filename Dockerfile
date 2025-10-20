FROM pytorch/pytorch:2.8.0-cuda12.8-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential cmake ninja-build pkg-config \
    curl wget ca-certificates unzip tar ffmpeg \
    colmap imagemagick \
    libgl1 libglib2.0-0 libx11-6 libxi6 libxrandr2 libxinerama1 libxxf86vm1 \
    libgtk-3-0 \
 && rm -rf /var/lib/apt/lists/*

RUN python -m pip install -U pip wheel setuptools && \
    python -m pip install \
      numpy scipy tqdm matplotlib opencv-python plyfile ninja imageio scikit-image

# 算力（可按需改；5080 先用 9.0 兜底）
ARG TORCH_CUDA_ARCH_LIST="9.0+PTX"
ENV TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}
ARG TCNN_CUDA_ARCHS="90"
ENV TCNN_CUDA_ARCHS=${TCNN_CUDA_ARCHS}

CMD ["/bin/bash"]
