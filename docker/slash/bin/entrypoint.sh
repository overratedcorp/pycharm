#!/bin/bash

set -uef -o pipefail

source /opt/virtualenv/bin/activate
export PATH=/opt/docker:${PATH}:/usr/local/bin/aws-cli

git config --global user.name "${GIT_USER}"
git config --global user.email "${GIT_EMAIL}"

exec "/opt/jetbrains/pycharm-${PYCHARM_VERSION}/bin/pycharm.sh"
