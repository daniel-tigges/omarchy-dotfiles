
# Masks Services which causes problems

# Some systemd Service that causes the boot process to fail, so we need to disable them
sudo systemctl mask systemd-pcrproduct.service
echo " → Masked systemd-pcrproduct.service"