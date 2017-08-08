require 'spec_helper'

describe 'cookbook.getnativelearning.com::apache2' do
    %w(software-properties-common python-software-properties libnghttp2-dev).each do |pkg|
        describe package(pkg) do
            it { should be_installed }
        end
    end

    describe ppa('ondrej/apache2') do
        it { should exist }
        it { should be_enabled }
    end

    describe file('/etc/apache2') do
        it { should be_directory }
    end

    describe command('/usr/sbin/apachectl -M') do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should match /ssl_module/ }
        its(:stdout) { should match /deflate_module/ }
        its(:stdout) { should match /rewrite_module/ }
        its(:stdout) { should match /proxy_module/ }
        its(:stdout) { should match /proxy_http_module/ }
        its(:stdout) { should match /proxy_http2_module/ }
        its(:stdout) { should match /http2_module/ }
        its(:stdout) { should match /expires_module/ }
        its(:stdout) { should match /setenvif_module/ }
        its(:stdout) { should match /log_config_module/ }
    end
end
