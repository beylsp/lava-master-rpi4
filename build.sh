#!/bin/sh -xe

UBUNTU=ubuntu-20.04.2-preinstalled-server-arm64+raspi
LAVA=ubuntu-20.04.2-lava-master-arm64+raspi
UBUNTU_URL=https://cdimage.ubuntu.com/releases/20.04.2/release/

# download and uncompress
wget -q $UBUNTU_URL/$UBUNTU.img.xz
unxz -v $UBUNTU.img.xz
mkdir -p out
cp $UBUNTU.img out/$LAVA.img

SANDBOX=$(mktemp -d -t guestfish-sandbox-XXXXXX)

sudo guestfish -a out/$LAVA.img --rw << __EOF__

# start the guestfs VM
run

# upload cloud-init config and ssh public key
mount /dev/sda1 /
upload assets/user-data /user-data
umount /dev/sda1

__EOF__

rm -rf $SANDBOX
rm -rf *.img *.img.xz

xz -fv out/$LAVA.img