#!/bin/bash

set -e

hostType=centos7-aws

SCRIPT_PATH=$(dirname $(realpath -s $0))
. $SCRIPT_PATH/functions-centos

performInstallLocal "$#" false
