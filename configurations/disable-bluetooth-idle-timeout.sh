# Disables the blueetooth idle timeout to avoid some issues with bluetooth keyboard

sudo sed -i 's/^[#[:space:]]*IdleTimeout.*/IdleTimeout=0/' /etc/bluetooth/input.conf

echo " → Disabled bluetooth idle timeout."
