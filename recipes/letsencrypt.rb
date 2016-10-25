#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: letsencrypt
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

if node['get-native']['environment']['long'] == 'production'
    # apt_package 'python-letsencrypt-apache'

    # TODO: Not desired state
    # execute 'letsencrypt --apache'

    # TODO: Not desired state
    # execute 'letsencrypt renew --dry-run --agree-tos'

    # TODO: Not desired state
    # TODO: Use systemd_unit recipe
    # cron 'certbot-auto-renew' do
    #     minute '0'
    #     hour '0,12'
    #     day '*'
    #     month '*'
    #     weekday '*'
    #     user node['get-native']['user']['name']
    #     command "/usr/bin/env bash /path/to/certbot-auto renew --non-interactive --quiet"
    # end
end
