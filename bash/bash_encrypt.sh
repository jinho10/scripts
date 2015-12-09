#!/bin/bash

###########################################################################################
# Return Codes:
#                  0   Completed successfully
#                  1   Wrong Permission
#                  2   Wrong Parameters
#                  3   Invalid Options
###########################################################################################

#==============================================================================
# Get Options
#==============================================================================
usage() {
    echo "usage: $0 <options>"
    echo "-s: source bash file to encrypt."
    echo "-t: target directory to copy the encrypted file."
    exit 2
}

while getopts "s:t:h" opt; do
  case $opt in
    s)
      echo "Source bash file: $OPTARG" >&2
      SRC=$OPTARG
      ;;
    t)
      echo "Target directory: $OPTARG." >&2
      TGT=$OPTARG
      ;;
    h)
      usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 3
      ;;
  esac
done

if [ -z $SRC ];
then 
    usage
fi

if [ -z $2 ];
then 
    usage 
fi

encrypt_copy() 
{
    echo "encrypting $SRC..."
    shc -v -r -T -f $SRC

    echo "copy $SRC to $TGT..."
    cp $SRC.x $TGT/$(basename $SRC)
}

shc_install()
{
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root to install the encryption tool" 1>&2
        exit 1
    fi

    echo 'installing shc...'

    wget http://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.7.tgz
    tar xzvf shc-3.8.7.tgz
    cd shc-3.8.7; make; echo y | make install; cd -

    echo 'done...'
}

if [ "$(which shc)" == "" ]; 
then
    shc_install
fi

encrypt_copy 
