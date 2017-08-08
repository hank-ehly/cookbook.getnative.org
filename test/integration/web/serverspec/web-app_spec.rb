require 'spec_helper'

describe 'cookbook.getnativelearning.com::web-app' do
    get_native_user = 'getnative'
    get_native_group = 'getnative'

    %w(libtool autoconf mkdocs libav-tools).each do |pkg|
        describe package(pkg) do
            it { should be_installed }
        end
    end

    %w(/usr/local/nodejs-binary/bin/pm2).each do |f|
        describe file(f) do
            it { should be_file }
            it { should be_executable.by_user(get_native_user) }
        end
    end

    describe file('/var/www') do
        it { should be_directory }
        it { should be_mode 755 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
    end

    %w(/var/log/pm2 /run/pm2).each do |d|
        describe file(d) do
            it { should be_directory }
            it { should be_mode 755 }
            it { should be_owned_by get_native_user }
            it { should be_grouped_into get_native_group }
        end
    end

    describe file('/etc/apache2/.htpasswd') do
        it { should be_file }
        it { should be_mode 644 }
    end
end
