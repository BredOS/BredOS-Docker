FROM bredos/bredos AS builder

WORKDIR /bredos

RUN mkdir -p /bredos/rootfs

COPY pacstrap-docker /archlinux/

RUN ./pacstrap-docker /bredos/rootfs \
      bash sed gzip pacman archlinux-keyring && \
    (pacman -r /bredos/rootfs -S --noconfirm archlinuxarm-keyring || true) && \
    rm rootfs/var/lib/pacman/sync/*

FROM scratch

ARG BUILDARCH
COPY --from=builder /bredos/rootfs/ /
COPY rootfs/common/ /
COPY rootfs/$BUILDARCH/ /

ENV LANG=en_US.UTF-8

RUN locale-gen && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    (pacman-key --populate archlinuxarm || true) && \
    echo 68B3537F39A313B3E574D06777193F152BDBE6A6:6: | gpg --homedir /etc/pacman.d/gnupg --allow-weak-key-signatures --import-ownertrust

CMD ["/usr/bin/bash"]
