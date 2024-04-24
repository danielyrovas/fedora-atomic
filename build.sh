#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

wget https://copr.fedorainfracloud.org/coprs/wezfurlong/wezterm-nightly/repo/fedora-"${RELEASE}"/wezfurlong-wezterm-nightly-"${RELEASE}".repo -O /etc/yum.repos.d/_copr_wezterm-nightly.repo

wget https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-"${RELEASE}"/kylegospo-system76-scheduler-fedora-"${RELEASE}".repo -O /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo

#incus, lxc, lxd
wget https://copr.fedorainfracloud.org/coprs/ganto/lxc4/repo/fedora-"${RELEASE}"/ganto-lxc4-fedora-"${RELEASE}".repo -O /etc/yum.repos.d/ganto-lxc4-fedora-"${RELEASE}".repo


# Bazzite game setup
# wget https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite/repo/fedora-"${RELEASE}"/kylegospo-bazzite-fedora-"${RELEASE}".repo -O /etc/yum.repos.d/_copr_kylegospo-bazzite.repo
# wget https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite-multilib/repo/fedora-"${RELEASE}"/kylegospo-bazzite-multilib-fedora-"${RELEASE}".repo?arch=x86_64 -O /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo
wget https://copr.fedorainfracloud.org/coprs/kylegospo/rom-properties/repo/fedora-"${RELEASE}"/kylegospo-rom-properties-fedora-"${RELEASE}".repo -O /etc/yum.repos.d/_copr_kylegospo-rom-properties.repo


REMOVE="bcache-tools fish gcc glow stress-ng tailscale tmux gnome-shell-extension-tailscale-gnome-qs gamemode"

rpm-ostree override remove $REMOVE

EXTRA="wezterm rom-properties-gtk3 switcheroo-control system76-scheduler btop wmctrl vulkan-tools steam lutris wine wine-core winetricks protontricks mangohud incus incus-agent jetbrains-mono-fonts-all podman-tui podman-plugins"

rpm-ostree install $EXTRA

systemctl enable podman.socket
