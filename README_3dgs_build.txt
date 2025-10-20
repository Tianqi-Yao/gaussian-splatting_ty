cd /workspace/gaussian-splatting
# 如有 environment.yml：谨慎使用，避免覆盖镜像内 torch
# conda env update -n base -f environment.yml || true
# source /opt/conda/etc/profile.d/conda.sh


python -m pip install -v --no-build-isolation --config-settings editable_mode=compat -e ./submodules/diff-gaussian-rasterization
python -m pip install -v --no-build-isolation --config-settings editable_mode=compat -e ./submodules/simple-knn

# 若有 tiny-cuda-nn：
# python -m pip install -e ./submodules/tiny-cuda-nn

# 训练/转换示例：
python convert.py -s datasets/222lab --camera OPENCV
python train.py -s datasets/222lab

# ffmpeg -y -i input.mp4 -vf fps=10 images/%06d.jpg

======================SIBR Viwer==============================
# https://sibr.gitlabpages.inria.fr/?page=index.html&version=0.9.6
# https://www.bilibili.com/video/BV1J7421R7G5/?vd_source=cb636006646241d410e8f4170a280dfd
# https://blog.csdn.net/sunflowers__k/article/details/143096013 
# 1) 进入工程根目录
cd SIBR_viewers/

# 2) 安装依赖（含你之前缺的 Embree、Boost、FFmpeg 等）
sudo apt update
sudo apt install -y \
  build-essential cmake git python3 python3-pip pkg-config \
  libglfw3-dev libglew-dev libglm-dev libeigen3-dev \
  libpng-dev libjpeg-dev libtiff-dev \
  libopencv-dev libassimp-dev \
  libembree-dev libboost-all-dev \
  libavcodec-dev libavformat-dev libavutil-dev libswscale-dev \
  mesa-common-dev libegl1-mesa-dev

# 3) 生成构建（兼容 xatlas 的旧 CMake 要求；如需压掉 FindBoost 警告可再加 -DCMAKE_POLICY_DEFAULT_CMP0167=OLD）
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5

# 4) 编译并安装到 install/
cmake --build build -j"$(nproc)" --target install

# 5) 运行（注意：可执行文件在 install/bin/ 下，不是目录）
./SIBR_viewers/install/bin/SIBR_gaussianViewer_app -m output/550c8290-f/