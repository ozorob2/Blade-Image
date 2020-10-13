#!/bin/bash -e

print_help() {
  echo """
usage: build.sh [-d]

Create a modified Ubuntu ISO from a base Ubuntu ISO that contains all
neccessary packages and SAGE software tools for installation on a Dell blade.

  -d : don't build the image and enter debug mode within the Docker build environment.
  -? : print this help menu
"""
}

CMD="./create_image.sh"
OUTPUT_NAME="sage_ubuntu"
TTY=
while getopts "d?" opt; do
  case $opt in
    d) # enable debug mode
      echo "** DEBUG MODE **"
      set +x
      TTY="-it"
      CMD="/bin/bash"
      ;;
    ?|*)
      print_help
      exit 1
      ;;
  esac
done

# create version string for build repository
BASE_VERSION="$(cat 'version' | xargs).${BUILD_NUMBER:-local}"
GIT_SHA=$(git rev-parse --short HEAD)
DIRTY=$([[ -z $(git status -s) ]] || echo '-dirty')
PROJ_VERSION=${BASE_VERSION}-${GIT_SHA}${DIRTY}
PWD=`pwd`

# create and run the Docker build environment
docker build -f Dockerfile -t blade_image_build .
docker run $TTY --rm --privileged \
    -v ${PWD}:/output \
    --env OUTPUT_NAME=${OUTPUT_NAME} \
    --env VERSION=${PROJ_VERSION} \
    blade_image_build $CMD
