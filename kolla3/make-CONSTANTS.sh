
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
IMAGES_AND_ISOS=$SCRIPTPATH/images-and-isos
BASE_IMAGE=$IMAGES_AND_ISOS/focal-server-cloudimg-amd64.img
OS_VARIANT="ubuntu20.04"
PUB_KEY=$(cat ~/.ssh/id_ed25519.pub)

