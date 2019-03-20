#From https://github.com/ufoym/deepo/blob/master/docker/Dockerfile.pytorch-py36-cu90
#From https://github.com/nutonomy/second.pytorch/blob/master/Dockerfile
FROM nvidia/cuda:10.0-devel-ubuntu16.04
RUN APT_INSTALL="apt-get install -y --no-install-recommends" \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    GIT_CLONE="git clone --depth 10" && \
    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \           
    apt-get update && \
# ==================================================================
# tools
# ------------------------------------------------------------------
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        apt-utils \
        ca-certificates \
        cmake \
        wget \
        git \
        vim \
	fish \
	libsparsehash-dev \
        && \
# ==================================================================
# python
# ------------------------------------------------------------------
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        software-properties-common \
        && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        python3.6 \
        python3.6-dev \
        python3-distutils-extra \
        && \
    wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python && \
    $PIP_INSTALL \
        setuptools \
        && \
    $PIP_INSTALL \
        numpy \
        scipy \
        pandas \
        cloudpickle \
        scikit-learn \
        matplotlib \
        Cython \
        && \
# ==================================================================
# pytorch
# ------------------------------------------------------------------
    $PIP_INSTALL \
        torchvision_nightly \
        && \
    $PIP_INSTALL \
        torch_nightly -f \
        https://download.pytorch.org/whl/nightly/cu90/torch_nightly.html \
        && \
# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*
# ==================================================================
RUN PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    $PIP_INSTALL \
        shapely fire pybind11 tensorboardX protobuf \
        scikit-image pillow \
        numba==0.41.0 \
        llvmlite==0.26.0
WORKDIR /root
RUN wget https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz
RUN tar xzvf boost_1_68_0.tar.gz
RUN cp -r ./boost_1_68_0/boost /usr/include
RUN rm -rf ./boost_1_68_0
RUN rm -rf ./boost_1_68_0.tar.gz
RUN git clone https://github.com/nutonomy/second.pytorch.git --depth 10
RUN git clone https://github.com/facebookresearch/SparseConvNet.git --depth 10
RUN cd ./SparseConvNet && python setup.py install && cd .. && rm -rf SparseConvNet
RUN apt-get -y update
RUN apt-get install -y libboost-all-dev
ENV NUMBAPRO_CUDA_DRIVER=/usr/lib/x86_64-linux-gnu/libcuda.so
ENV NUMBAPRO_NVVM=/usr/local/cuda-10.0/nvvm/lib64/libnvvm.so
ENV NUMBAPRO_LIBDEVICE=/usr/local/cuda-10.0/nvvm/libdevice
ENV PYTHONPATH=/root/second.pytorch
VOLUME ["/root/data"]
VOLUME ["/root/model"]
WORKDIR /root/second.pytorch/second
ENTRYPOINT ["fish"]


