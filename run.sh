#!/bin/bash

OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
mod_dir="seeed-voicecard_${BALENA_DEVICE_TYPE}_${OS_VERSION}.dev"

echo "OS Version is $OS_VERSION"

modprobe -v i2c-dev

echo "Loading snd-soc-simple-card first..."
modprobe -v snd-soc-simple-card

echo "Loading modules from $mod_dir"
insmod $mod_dir/snd-soc-seeed-voicecard.ko
insmod $mod_dir/snd-soc-wm8960.ko
insmod $mod_dir/snd-soc-ac108.ko
lsmod | grep snd

echo 'ls -l /var/lib:'
ls -l /var/lib
echo 'ls -l /var/lib/alsa:'
ls -l /var/lib/alsa

ALSA_STATE_FILE=/var/lib/alsa/asound.state
# I'm not sure what's happening here, but it *looks* like the state
# file, if already present as a symlink, interferes somehow not just
# with the symlinking (which is to be expected), but with the state
# restore that comes next -- with the result that the soundcard does
# not work unless we restart the container.
if [ -f $ALSA_STATE_FILE ] ; then
    echo "Existing alsa state file found, removing"
    rm $ALSA_STATE_FILE
fi
ln -s /etc/voicecard/wm8960_asound.state $ALSA_STATE_FILE

alsactl restore -d
amixer cset numid=3 1

while true; do
	sleep 60
done
