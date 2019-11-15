#!/bin/bash

BUILD_VERSION=`git symbolic-ref -q --short HEAD || git describe --tags --match v*`
BUILD_VERSION=${BUILD_VERSION#"heads/"}
PROCESSES=`grep -c ^processor /proc/cpuinfo`
echo "export BUILD_VERSION=$BUILD_VERSION" >> /set_env
source /set_env
CACHE_REFRESH_SKIP=true ./bin/rails runner 'Delayed::Backend::Mongoid::Job.create_indexes'
CACHE_REFRESH_SKIP=true ./bin/delayed_job start -n $PROCESSES
exec "$@"
