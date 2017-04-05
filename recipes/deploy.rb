#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: deploy
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

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

    before_symlink do
        bash 'database.json' do
            cwd release_path
            code <<-EOH
                cp src/server/config/database.json.template src/server/config/database.json
            EOH
        end
    end

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
