# Build args can be provided on the commandline when building locally with:
#   podman build -f Containerfile --build-arg FEDORA_VERSION=40 -t local-image

# See list here: https://github.com/orgs/ublue-os/packages?repo_name=main
# silverblue, kinoite, sericea, onyx lazurite, vauxite, base, aurora,
# bazzite, bluefin or ucore
ARG SOURCE_IMAGE="bluefin"
# ARG SOURCE_IMAGE="silverblue"
# main, nvidia, asus, asus-nvidia, surface, surface-nvidia
# ucore: stable, testing, stable-nvidia, stable-zfs, stable-nvidia-zfs
ARG SOURCE_SUFFIX="nvidia"
ARG FEDORA_VERSION="40"

FROM ghcr.io/ublue-os/${SOURCE_IMAGE}-${SOURCE_SUFFIX}:${FEDORA_VERSION}
LABEL org.opencontainers.image.source https://github.com/danielyrovas/fedora-atomic
RUN mkdir -p /var/lib/alternatives && \
    ostree container commit

# gamemode
RUN \
    if [[ "${RELEASE}" =~ "bluefin" ]]; then \
    echo "removing bluefin packeges" \
    rpm-ostree override remove fish gcc glow stress-ng \
    tailscale gnome-shell-extension-tailscale-gnome-qs \
    ; else \
    echo "removing silverblue packeges" \
    ; fi && \
    ostree container commit

# Fedora coprs
# wget --no-hsts https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-"${RELEASE}"/kylegospo-system76-scheduler-fedora-"${RELEASE}".repo -O /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo && \
# wget --no-hsts https://copr.fedorainfracloud.org/coprs/kylegospo/rom-properties/repo/fedora-"${RELEASE}"/kylegospo-rom-properties-fedora-"${RELEASE}".repo -O /etc/yum.repos.d/_copr_kylegospo-rom-properties.repo && \
RUN \
    wget --no-hsts https://copr.fedorainfracloud.org/coprs/ganto/lxc4/repo/fedora-"${RELEASE}"/ganto-lxc4-fedora-"${RELEASE}".repo -O /etc/yum.repos.d/ganto-lxc4-fedora-"${RELEASE}".repo && \
    wget --no-hsts https://copr.fedorainfracloud.org/coprs/wezfurlong/wezterm-nightly/repo/fedora-"${RELEASE}"/wezfurlong-wezterm-nightly-"${RELEASE}".repo -O /etc/yum.repos.d/_copr_wezterm-nightly.repo && \
    ostree container commit

RUN rpm-ostree install steam lutris mangohud && \
    ostree container commit
RUN rpm-ostree install wine wine-core winetricks protontricks && \
    ostree container commit
RUN rpm-ostree install wmctrl vulkan-tools switcheroo-control && \
    ostree container commit
# RUN rpm-ostree install rom-properties-gtk3 system76-scheduler && \
#     ostree container commit
RUN rpm-ostree install podman-tui jetbrains-mono-fonts-all btop incus incus-agent && \
    ostree container commit
RUN rpm-ostree install wezterm && \
    ostree container commit

RUN systemctl enable podman.socket && \
    ostree container commit

# TODO: wezterm
