#!/bin/bash

set -e

/opt/ivis-core/wait-for-it.sh es:9200 --timeout=1

cd /opt/ivis-core/server
node ./index.js