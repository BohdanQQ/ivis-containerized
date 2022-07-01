#!/bin/bash

set -e

(
    cd /opt/ivis-core/server/lib/tasks/python/ivis && python3 setup.py sdist bdist_wheel
)

# TODO: somehow wait for db and elasticsearch exactly
sleep 10

cd /opt/ivis-core/server && npm-run-all --parallel watch:*