#!/bin/bash -e

echo "Building Dell SAGE Ubuntu [$VERSION]"

#unpack iso
mkdir /mnt/iso
mount -o loop /ubuntu-18.04.5-server-amd64.iso /mnt/iso/

#move contents to rw access
mkdir /iso
cp -rT /mnt/iso/ /iso/

#grab neccessary build files
cp /iso_tools/preseed.seed /iso/preseed/
cp /iso_tools/grub.cfg /iso/boot/grub/grub.cfg
cp /iso_tools/txt.cfg /iso/isolinux/txt.cfg

# TODO: get the base packages into the iso/rootfs
# mkdir -p iso/wscripts
# cp base_packages iso/wscripts/
# cp -r wscripts/* iso/wscripts

mkdir -p /ROOTFS/etc
echo $VERSION > /ROOTFS/etc/sage_version_os

# copy all the SAGE specifics for the end file-system to the ISO
cp -r /ROOTFS /iso/

ouputfile="sage-ubuntu_$VERSION.iso"
pushd /iso
mkisofs -D -r -V "AUTOINSTALL" -cache-inodes -J -l -b isolinux/isolinux.bin \
    -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o \
    /tmp/${ouputfile} .
popd
mv /tmp/${ouputfile} /output
