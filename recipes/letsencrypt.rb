#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: letsencrypt
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

template '999-dummy.conf' do
    path "#{node['apache']['dir']}/sites-available/999-dummy.conf"
    source 'letsencrypt/999-dummy.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
end

cron 'letsencrypt' do
    command "/usr/bin/letsencrypt renew --config-dir #{node['apache']['dir']}/ssl --agree-tos --email #{node['getnative']['contact']}"
    minute '0'
    hour '0,12'
    user 'root'
    mailto node['getnative']['contact']
end

domains = %W(#{node['getnative']['server_name']} api.#{node['getnative']['server_name']} admin.#{node['getnative']['server_name']})

domains.each do |d|
    bash 'letsencrypt' do
        code <<-EOH
            /usr/bin/letsencrypt --domains #{domains.join(',')} \
                                 --apache \
                                 --agree-tos \
                                 --uir \
                                 --hsts \
                                 --non-interactive \
                                 --email #{node['getnative']['contact']} \
                                 --config-dir #{node['apache']['dir']}/ssl \
                                 --apache-server-root #{node['apache']['dir']} \
                                 --apache-vhost-root #{node['apache']['dir']}/sites-available \
                                 --apache-le-vhost-ext="-ssl.conf" \
                                 --redirect \
                                 --logs-dir #{node['apache']['log_dir']}
        EOH
        not_if {File::exist?("#{node['apache']['dir']}/ssl/live/#{d}/fullchain.pem")}
    end
end
