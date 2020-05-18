# LHMC

Configuration and steps for testing converter modules & profiles.

## Preliminary setup

Run the preliminary setup run when first using or switching to a config.

```bash
docker run --name mongo -d -p 27017:27017 mongo:3.2 || true
./reset.sh
```

## Anthro

Config:

```txt
# DEVELOPMENT .env.local
export CSPACE_CONVERTER_BASE_URI=https://lhmc.dev.collectionspace.org/cspace-services
export CSPACE_CONVERTER_DB_NAME=nightly_lhmc
export CSPACE_CONVERTER_DOMAIN=lhmc.collectionspace.org
export CSPACE_CONVERTER_MODULE=Lhmc
export CSPACE_CONVERTER_USERNAME=admin@lhmc.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
./reset.sh # make sure we're empty
./bin/rake remote:client:get[media] # test connection

./import.sh data/lhmc/collectionobject_partial.csv collobj1 cataloging
./remote.sh transfer CollectionObject collobj1
./remote.sh delete CollectionObject collobj1
```
