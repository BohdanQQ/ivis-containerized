#!/bin/bash

set -e

(
    cd /opt/ivis-core/server/lib/tasks/python/ivis && python3 setup.py sdist bdist_wheel
)

/opt/ivis-core/wait-for-it.sh es:9200 --timeout=1

cd /opt/ivis-core/server
npm-run-all --parallel watch:*