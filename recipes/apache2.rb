#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: apache2
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

%w(software-properties-common python-software-properties libnghttp2-dev).each do |pkg|
    apt_package pkg
end

apt_repository 'ondrej-apache2' do
    uri 'ppa:ondrej/apache2'
    deb_src true
    notifies :run, 'execute[apt-get update]', :immediately
end

%w(default mod_ssl mod_deflate mod_rewrite mod_proxy mod_proxy_http mod_http2 mod_expires mod_setenvif mod_log_config).each do |r|
    include_recipe "apache2::#{r}"
end

apache_module 'proxy_http2'

include_recipe 'logrotate::default'

logrotate_app 'getnative' do
    path node['apache']['log_dir']
    frequency 'daily'
    options %w(missingok compress delaycompress notifempty sharedscripts)
    rotate 14
    create '644 root adm'
    postrotate <<-EOF
        if invoke-rc.d apache2 status > /dev/null 2>&1; then \
            invoke-rc.d apache2 reload > /dev/null 2>&1; \
        fi;
    EOF
    prerotate <<-EOF
        if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
            run-parts /etc/logrotate.d/httpd-prerotate; \
        fi;
    EOF
end
