#!/bin/bash

ACTION=${1:-transfer}
TYPE=${2:-CollectionObject}
BATCH=${3:-cataloging1}

./bin/rake \
  remote:batch:$ACTION[$TYPE,$BATCH]
