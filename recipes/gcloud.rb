#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: gcloud
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

apt_repository 'google-cloud-sdk' do
    uri 'http://packages.cloud.google.com/apt'
    distribution 'cloud-sdk-xenial'
    components ['main']
    key 'https://packages.cloud.google.com/apt/doc/apt-key.gpg'
    notifies :run, 'execute[apt-get update]', :immediately
end

apt_package 'google-cloud-sdk'

# Perform manually
# execute 'gcloud init'