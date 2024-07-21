# BredOS Docker images ![build](https://github.com/BredOS/BredOS-Docker/workflows/build/badge.svg)

Docker images for BredOS on x86_64, AArch32 (ARMv7-A) and AArch64 (ARMv8-A). Built using buildx multi-stage builds.<br />
Built daily by GitHub Actions on publicly visible infrastructure using QEMU emulation to support ARM.<br />

## Running the images

The images are on [Docker Hub](https://hub.docker.com/bill88t/bredos). Use the convenient `docker run`:

    docker run -it --rm bredos/bredos
