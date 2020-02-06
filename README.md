# cspace-converter

[![Build Status](https://travis-ci.com/collectionspace/cspace-converter.svg?branch=master)](https://travis-ci.com/collectionspace/cspace-converter) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

Migrate data to CollectionSpace.

## Getting Started

The converter tool is a [Ruby on Rails](https://rubyonrails.org/) application.
The database backend is [MongoDB](https://www.mongodb.com/) (v3.2).

For deployments there is a [Docker image](https://hub.docker.com/repository/docker/collectionspace/cspace-converter) and [docs](docs/DEPLOYMENT.md) available.

## Running the Converter locally

To run the converter locally install Ruby and bundler then run:

```bash
bundle install
```

See `.ruby-version` for the recommended version of Ruby.

## Configuration

There is a default `.env` file that provides example configuration. Override it
by creating a `.env.local` file with custom settings.

```bash
# DEVELOPMENT .env.local
export CSPACE_CONVERTER_BASE_URI=https://core.dev.collectionspace.org/cspace-services
export CSPACE_CONVERTER_DOMAIN=core.collectionspace.org
export CSPACE_CONVERTER_MODULE=Core
export CSPACE_CONVERTER_USERNAME=admin@core.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

The `CSPACE_CONVERTER_BASE_URI` variable must point to an _available_ ColletionSpace
Services Layer backend.

## Start the MongoDB Server

Run Mongo using Docker:

```bash
docker run --name mongo -d -p 27017:27017 mongo:3.2
```

You should be able to access MongDB on `http://localhost:27017`.

If you prefer to run Mongo traditionally follow the installation docs online.

You can dump and restore the database with Mongo Tools:

```bash
sudo apt-get install mongo-tools # ubuntu
mongodump --archive=data/dump/cspace_converter_development.gz
mongorestore --archive=data/dump/cspace_converter_development.gz
```

[Robo3T](https://robomongo.org/download) is recommended for a GUI client.

## Setup CSV Data to be Imported

Before the tool can import CSV data into CollectionSpace, it first "stages" the
data from the CSV files into the MongoDB database.

Create a data directory and add the CSV files. For example:

```txt
data/core/
├── mymuseum_cataloging.csv
```

There are sample data files available for testing for each supported
Collectionspace profile.

## Setup the cache

To match csv fields to existing CollectionSpace authority and vocabulary terms:

```bash
./reset.sh # ensure db empty and cache is refreshed, requires Mongo
```

## Converter Tool Web UI

```bash
./bin/rails s
```

Once started, visit http://localhost:3000 with a web browser.

To execute jobs created using the UI run this command:

```bash
./bin/delayed_job run --exit-on-complete
```

## Conveter Tool CLI

### Stage the data to MongoDB

The general format for the command is:

```bash
./import.sh [FILE] [BATCH] [PROFILE]
```

- `FILE`: path to the import file
- `BATCH`: import batch label (for future reference)
- `PROFILE`: profile key from config (`config.yml` registered_profiles)

For example:

```bash
./import.sh data/core/cataloging_core_excerpt.csv cataloging1 cataloging
```

Then to transfer:

```bash
./remote.sh transfer CollectionObject cataloging1
./remote.sh delete CollectionObject cataloging1
```

## Useful commands

### Making api requests to the remote CollectionSpace instance

```bash
# provides a list of records
./bin/rake remote:get[collectionobjects]

# get a record
./bin/rake remote:get[collectionobjects/$CSID]
```

### Using the console

```ruby
# ./bin/rails c
p = DataObject.first
puts p.inspect
```

### Clearing out data

```bash
./bin/rake db:nuke
```

Or use 'Nuke' in the ui. Warning: this deletes all data, including failed jobs.

### Running tests

```bash
./bin/rake spec # requires Mongo
```

## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---
