#!/bin/bash

FILE=${1:-data/core/SampleCatalogingData.csv}
BATCH=${2:-cataloging1}
PROFILE=${3:-cataloging}

./bin/rake \
  import:csv[$FILE,$BATCH,$PROFILE]
