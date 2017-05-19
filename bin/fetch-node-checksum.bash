#!/usr/bin/env bash

set -e

if [[ ${#} = 0 ]]; then
    echo "Version not specified. Checking for latest LTS..."
    NODE_VERSION=$(curl https://nodejs.org/en/ -s | grep -E "^\s+v[0-9]\.[0-9]+\.[0-9] LTS" | awk '{print $1}')
else
    if [[ `echo ${1} | grep -E '^v'` ]]; then
        NODE_VERSION=${1}
    else
        NODE_VERSION="v${1}"
    fi
fi

CHECKSUM=$(curl https://nodejs.org/dist/${NODE_VERSION}/SHASUMS256.txt.asc -s | grep "node-${NODE_VERSION}-linux-x64.tar.gz" | awk '{print $1}')

if [[ -z ${CHECKSUM} ]]; then
    echo "Node version ${NODE_VERSION} does not exist."
    exit 0
fi

echo ${NODE_VERSION}
echo ${CHECKSUM}
