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
export CSPACE_CONVERTER_BASE_URI=https://anthro.dev.collectionspace.org/cspace-services
export CSPACE_CONVERTER_DOMAIN=anthro.collectionspace.org
export CSPACE_CONVERTER_MODULE=Anthro
export CSPACE_CONVERTER_USERNAME=admin@anthro.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
./reset.sh # make sure we're empty
./bin/rake remote:get[claims] # test connection

./import.sh data/anthro/$TODO.csv claims1 nagpra
./remote.sh transfer Nagpra claims1
./remote.sh delete Nagpra claims1

### Auths

./import.sh data/private/taxon.csv taxon1 taxonomy
./remote.sh transfer Taxon taxon1
./remote.sh update Taxon taxon1
./remote.sh delete Taxon taxon1
```
