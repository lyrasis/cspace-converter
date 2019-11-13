#!/bin/bash

BUILD_VERSION=`git symbolic-ref -q --short HEAD || git describe --tags --match v*`
BUILD_VERSION=${BUILD_VERSION#"heads/"}
echo "export BUILD_VERSION=$BUILD_VERSION" >> /set_env
source /set_env
exec "$@"
