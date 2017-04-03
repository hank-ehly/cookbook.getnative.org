#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: app
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

%w(libtool autoconf mkdocs).each do |pkg|
    apt_package pkg
end

%w(gulp-cli pm2).each do |pkg|
    nodejs_npm pkg
end

directory node['apache']['docroot_dir'] do
    user 'root'
    group 'root'
    mode 0755
end

# todo: Match directory name to server_name (apache config and other places will also need modification)
directory "#{node['apache']['docroot_dir']}/get-native.com" do
    user node['get-native']['user']['name']
    group node['apache']['group']
    mode 0755
end

%w(/var/log/pm2 /run/pm2).each do |d|
    directory d do
        user 'root'
        group 'root'
        mode 0777
    end
end

git_ssh_wrapper_path = "#{Chef::Config[:file_cache_path]}/git-ssh-wrapper.bash"

template 'git_ssh_wrapper' do
    path git_ssh_wrapper_path
    source 'web-app/git-ssh-wrapper.bash.erb'
    owner 'root'
    group 'root'
    mode 0755
    action :create
end

deploy 'get-native' do
    user node['get-native']['user']['name']
    group node['apache']['group']
    branch 'develop'
    repo "git@github.com:#{node['get-native']['github']['repo']}"
    scm_provider Chef::Provider::Git
    shallow_clone true
    git_ssh_wrapper git_ssh_wrapper_path
    deploy_to "#{node['apache']['docroot_dir']}/get-native.com"
    symlink_before_migrate.clear
    create_dirs_before_symlink.clear
    purge_before_symlink.clear
    symlinks.clear

    before_restart do
        ['npm install', 'mkdocs build'].each do |cmd|
            execute cmd do
                cwd "#{node['apache']['docroot_dir']}/get-native.com/current"
                user node['get-native']['user']['name']
                group node['apache']['group']
                environment ({:HOME => node['get-native']['user']['home']})
            end
        end
    end

    restart_command do
        execute 'pm2' do
            command '/usr/local/nodejs-binary/bin/pm2 start /var/www/get-native.com/current/ecosystem.config.js -i max --silent'
            user node['get-native']['user']['name']
            group node['apache']['group']
            environment ({:HOME => node['get-native']['user']['home']})
        end
    end

    action :deploy
    notifies :create, 'template[git_ssh_wrapper]', :before
    not_if { Dir::exist? "#{node['apache']['docroot_dir']}/get-native.com/current" }
end

data_bag = "#{node['get-native']['environment']}-#{node['get-native']['role']}"
htpasswd = data_bag_item(data_bag, 'htpasswd')

bash 'htpasswd' do
    code <<-EOH
        echo "#{htpasswd['password']}" | htpasswd -iBc #{node['apache']['dir']}/.htpasswd #{htpasswd['user']}
    EOH

    not_if { File::exist? "#{node['apache']['dir']}/.htpasswd" }
end

%W(#{node['get-native']['server_name']} api.#{node['get-native']['server_name']} docs.#{node['get-native']['server_name']}).each do |domain|
    conf_name = File::exist?("#{node['apache']['dir']}/ssl/live/#{domain}/fullchain.pem") ? "#{domain}-ssl" : domain

    web_app conf_name do
        template "web-app/#{conf_name}.conf.erb"
        server_name domain
        docroot node['get-native']['docroot']
    end
end
