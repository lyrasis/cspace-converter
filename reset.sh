#!/bin/bash

./bin/rake db:nuke
./bin/rake db:mongoid:create_indexes
# ./bin/rake cache:refresh
