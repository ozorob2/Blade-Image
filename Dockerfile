# ANL:waggle-license
#  This file is part of the Waggle Platform.  Please see the file
#  LICENSE.waggle.txt for the legal details of the copyright and software
#  license.  For more details on the Waggle project, visit:
#           http://www.wa8.gl
# ANL:waggle-license

FROM ubuntu:18.04
# TODO arg or env for ubuntu version
RUN apt-get update && apt-get install -y \
  curl \
  mkisofs

RUN curl -L http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.5-server-amd64.iso > /ubuntu-18.04.5-server-amd64.iso

COPY ROOTFS/ /ROOTFS

COPY iso_tools /iso_tools

COPY create_image.sh .
