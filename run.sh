#!/bin/bash

OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
mod_dir="seeed-voicecard_${BALENA_DEVICE_TYPE}_${OS_VERSION}.dev"

echo "OS Version is $OS_VERSION"

modprobe -v i2c-dev

echo "Loading snd-soc-simple-card first..."
modprobe -v snd-soc-simple-card

echo "Loading modules from $mod_dir"
insmod $mod_dir/snd-soc-ac108.ko
insmod $mod_dir/snd-soc-seeed-voicecard.ko
insmod $mod_dir/snd-soc-wm8960.ko
lsmod | grep snd

ln -s /etc/voicecard/wm8960_asound.state /var/lib/alsa/asound.state
alsactl restore
amixer cset numid=3 1

while true; do
	sleep 60
done
