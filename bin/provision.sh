#!/usr/bin/env bash

set -e

if [ -z ${1} ]; then
    echo "A branch name is required for deployment."
    exit 1
fi

if [ ${1} != "staging" -a ${1} != "production" ]; then
    echo "The only available stages are 'staging' and 'production'. You chose ${1}."
    exit 1
fi

stage=${1}

read -p "You are about to provision the ${stage} server. Continue? [y/N] "
CHOICE=`echo $REPLY | tr [:upper:] [:lower:]`

if [[ $CHOICE = 'y' ]]; then
        echo "bundle exec knife solo cook getnative@getnative.org --environment ${stage} -i ~/.ssh/getnative.org/getnative"
        bundle exec knife solo cook getnative@getnative.org --environment ${stage} -i ~/.ssh/getnative.org/getnative
else
        echo 'Aborted'
        exit 0
fi
