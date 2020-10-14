# ANL:waggle-license
#  This file is part of the Waggle Platform.  Please see the file
#  LICENSE.waggle.txt for the legal details of the copyright and software
#  license.  For more details on the Waggle project, visit:
#           http://www.wa8.gl
# ANL:waggle-license

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
  curl \
  mkisofs \
  wget

# Add the docker sources as `docker` is in the REQ Package list
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Download all the required debian packages for inclusion in the ISO
ARG REQ_PACKAGES
RUN mkdir /isodebs
RUN cd /isodebs && apt-get update && apt-get download -y $REQ_PACKAGES

# Add the SAGE/Waggle debian packages
RUN cd /isodebs && \
    wget https://github.com/waggle-sensor/beekeeper-registration/releases/download/v1.1.0/waggle-registration_1.1.0.local-47ccaae_all.deb
RUN cd /isodebs && \
    wget https://github.com/waggle-sensor/beekeeper-registration/releases/download/v1.1.0/waggle-reverse-tunnel_1.1.0.local-47ccaae_all.deb

# Download the base Ubuntu ISO (don't use var in curl to use docker cache)
RUN curl -L http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.5-server-amd64.iso > /ubuntu-18.04.5-server-amd64.iso
ENV UBUNTU_IMG=ubuntu-18.04.5-server-amd64.iso

# Copy iso specific tools and final system root file system files
COPY iso_tools /iso_tools
COPY ROOTFS/ /ROOTFS

COPY create_image.sh .
