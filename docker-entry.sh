#!/bin/bash

set -e

(
    cd /opt/ivis-core/server/lib/tasks/python/ivis && python3 setup.py sdist bdist_wheel
)

sleep 10

cd /opt/ivis-core/server && npx nodemon --legacy-watch --ignore 'files/' index.js 