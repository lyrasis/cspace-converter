# Development

Configuration and steps for testing converter modules & profiles.

## Preliminary setup

Run the preliminary setup run when first using or switching to a config.

```bash
docker run --name mongo -d -p 27017:27017 mongo:3.2 || true
bundle exec rake db:nuke
bundle exec rake cache:download_vocabularies
bundle exec rake cache:download_authorities
```

## Core

Config:

```txt
# DEVELOPMENT .env.local
export CSPACE_CONVERTER_BASE_URI=https://core.dev.collectionspace.org/cspace-services
export CSPACE_CONVERTER_DOMAIN=core.collectionspace.org
export CSPACE_CONVERTER_MODULE=Core
export CSPACE_CONVERTER_USERNAME=admin@core.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
./reset.sh # make sure we're empty
./bin/rake remote:get[media] # test connection

./import.sh data/core/acquisition_core_all.csv acquisition1 acquisition
./remote.sh transfer Acquisition acquisition1
./remote.sh delete Acquisition acquisition1

./import.sh data/core/cataloging_core_excerpt.csv cataloging1 cataloging
./remote.sh transfer CollectionObject cataloging1
./remote.sh delete CollectionObject cataloging1

./import.sh data/core/objectexit_core_all.csv exit1 objectexit
./remote.sh transfer ObjectExit exit1
./remote.sh delete ObjectExit exit1

./import.sh data/core/group_core_all.csv group1 group
./remote.sh transfer Group group1
./remote.sh delete Group group1

./import.sh data/core/loansout_core_all.csv loanout1 loanout
./remote.sh transfer LoanOut loanout1
./remote.sh delete LoanOut loanout1

./import.sh data/core/mediahandling_core_all.csv media1 media
./remote.sh transfer Media media1
### MEDIA UPDATE EXAMPLE
./reset.sh # clear out existing object data
./import.sh data/core/mediahandling_core_update.csv media1 media
./remote.sh update Media media1
###
./remote.sh delete Media media1

./import.sh data/core/lmi_core_all.csv movement1 movement
./remote.sh transfer Movement movement1
./remote.sh delete Movement movement1

./import.sh data/core/authconcept_nomenclature_terms.csv nomenclature1 nomenclature
./remote.sh transfer Concept nomenclature1
./remote.sh delete Concept nomenclature1

./import.sh data/core/authperson_core_all.csv person1 person
./remote.sh transfer Person person1
./remote.sh delete Person person1

./import.sh data/core/objectexit_core_all.csv exit1 objectexit
./remote.sh transfer ObjectExit exit1
./remote.sh delete ObjectExit exit1
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
```

## Materials

Config:

```txt
# DEVELOPMENT .env.local
export CSPACE_CONVERTER_BASE_URI=https://materials.dev.collectionspace.org/cspace-services
export CSPACE_CONVERTER_DOMAIN=materials.collectionspace.org
export CSPACE_CONVERTER_MODULE=Materials
export CSPACE_CONVERTER_USERNAME=admin@materials.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
./reset.sh # make sure we're empty
./bin/rake remote:get[media] # test connection

./import.sh data/materials/cataloging_materials_all.csv cataloging1 cataloging
./remote.sh transfer CollectionObject cataloging1
./remote.sh delete CollectionObject cataloging1

./import.sh data/core/mediahandling_core_all.csv media1 media
./remote.sh transfer Media media1
./remote.sh delete Media media1
```
