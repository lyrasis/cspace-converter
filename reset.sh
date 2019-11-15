#!/bin/bash

./bin/rake db:nuke
./bin/rake cache:refresh
