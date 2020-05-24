# Anthro

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
CSPACE_CONVERTER_BASE_URI=https://anthro.dev.collectionspace.org/cspace-services
CSPACE_CONVERTER_DB_NAME=nightly_anthro
CSPACE_CONVERTER_DOMAIN=anthro.collectionspace.org
CSPACE_CONVERTER_MODULE=Anthro
CSPACE_CONVERTER_USERNAME=admin@anthro.collectionspace.org
CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
./reset.sh # make sure we're empty
./bin/rake remote:client:get[claims] # test connection

./import.sh data/anthro/$TODO.csv claims1 nagpra
./remote.sh transfer Nagpra claims1
./remote.sh delete Nagpra claims1

./import.sh data/anthro/osteology_anthro_all.csv osteology1 osteology
./remote.sh transfer Osteology osteology1
./remote.sh delete Osteology osteology1

./import.sh data/anthro/anthro_taxon_all.csv taxon1 taxonomy
./remote.sh transfer Taxon taxon1
./remote.sh delete Taxon taxon1
```
