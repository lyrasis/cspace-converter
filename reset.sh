#!/bin/bash

bundle exec rake db:nuke
bundle exec rake cache:import[~/.cspace-converter/cache.csv]
