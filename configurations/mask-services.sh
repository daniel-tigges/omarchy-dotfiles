
# Masks Services which causes problems

# Some systemd Service that causes the boot process to fail, so we need to disable them
sudo systemctl mask systemd-pcrproduct.service

# configure libvirt
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $USER
echo " → Masked systemd-pcrproduct.service"