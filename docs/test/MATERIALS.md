# Development

Configuration and steps for testing converter modules & profiles.

## Preliminary setup

Run the preliminary setup run when first using or switching to a config.

```bash
docker run --name mongo -d -p 27017:27017 mongo:3.2 || true
./reset.sh
```

## Materials

Config:

```txt
# DEVELOPMENT .env.local
CSPACE_CONVERTER_BASE_URI=https://materials.dev.collectionspace.org/cspace-services
CSPACE_CONVERTER_DB_NAME=nightly_materials
CSPACE_CONVERTER_DOMAIN=materials.collectionspace.org
CSPACE_CONVERTER_MODULE=Materials
CSPACE_CONVERTER_USERNAME=admin@materials.collectionspace.org
CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
./reset.sh # make sure we're empty
./bin/rake remote:client:get[media] # test connection

./import.sh data/materials/cataloging_materials_all.csv cataloging1 cataloging
./remote.sh transfer CollectionObject cataloging1
./remote.sh update CollectionObject cataloging1
./remote.sh delete CollectionObject cataloging1

./import.sh data/materials/materials_authority.csv materials1 material
./remote.sh transfer Material material1
./remote.sh delete Material material1

./import.sh data/materials/media_materials_all.csv media1 media
./remote.sh transfer Media media1
./remote.sh delete Media media1
```
