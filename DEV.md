# Development

Configuration and steps for testing converter modules & profiles.

## Core

Config:

```txt
# DEVELOPMENT .env.local
export CSPACE_CONVERTER_DB_HOST=127.0.0.1
export CSPACE_CONVERTER_BASE_URI=https://core.dev.collectionspace.org/cspace-services
export CSPACE_CONVERTER_DOMAIN=core.collectionspace.org
export CSPACE_CONVERTER_LOG_LEVEL=debug
export CSPACE_CONVERTER_MODULE=Core
export CSPACE_CONVERTER_USERNAME=admin@core.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
docker run --name mongo -d -p 27017:27017 mongo:3.2 || true
./reset.sh # make sure we're empty
./bin/rake remote:get[media] # test connection

./import.sh data/core/sample_data_mediahandling_core_all.csv media1 media
./remote.sh transfer Media media1
# verify transferred to: https://core.dev.collectionspace.org
./remote.sh delete Media media1
# verify deleted from: https://core.dev.collectionspace.org

# review other imports
./import.sh data/core/sample_data_cataloging_core_excerpt.csv cataloging1 cataloging
```

## Materials

Config:

```txt
# DEVELOPMENT .env.local
export CSPACE_CONVERTER_DB_HOST=127.0.0.1
export CSPACE_CONVERTER_BASE_URI=https://materials.dev.collectionspace.org/cspace-services
export CSPACE_CONVERTER_DOMAIN=materials.collectionspace.org
export CSPACE_CONVERTER_LOG_LEVEL=debug
export CSPACE_CONVERTER_MODULE=Materials
export CSPACE_CONVERTER_USERNAME=admin@materials.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
docker run --name mongo -d -p 27017:27017 mongo:3.2 || true
./reset.sh # make sure we're empty
./bin/rake remote:get[media] # test connection

./import.sh data/core/sample_data_mediahandling_core_all.csv media1 media
./remote.sh transfer Media media1
# verify transferred to: https://materials.dev.collectionspace.org
./remote.sh delete Media media1
# verify deleted from: https://materials.dev.collectionspace.org
```
