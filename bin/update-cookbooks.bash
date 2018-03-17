#!/usr/bin/env bash

set -e

if [ -d cookbooks ]; then
    rm -rf cookbooks
fi

if [ -f Berksfile.lock ]; then
    rm -f Berksfile.lock
fi

bundle exec berks install
bundle exec berks update
bundle exec berks vendor cookbooks
