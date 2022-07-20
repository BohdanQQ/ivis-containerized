#!/bin/bash

set -e

/opt/ivis-core/wait-for-it.sh es:9200 --timeout=1
/opt/ivis-core/wait-for-it.sh db:3306 --timeout=1

cd /opt/ivis-core/server
node ./index.js