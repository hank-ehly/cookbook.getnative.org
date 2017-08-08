require 'spec_helper'

describe 'cookbook.getnativelearning.com::add-user' do
    get_native_user = 'getnative'
    get_native_group = 'getnative'

    describe group(get_native_group) do
        it { should exist }
    end

    describe user(get_native_user) do
        it { should exist }
        it { should belong_to_group get_native_group }
        it { should have_home_directory "/home/#{get_native_user}" }
        it { should have_login_shell '/bin/bash' }
    end

    describe file("/etc/sudoers.d/#{get_native_user}") do
        it { should exist }
        its(:content) { should match /getnative ALL=\(ALL:ALL\) NOPASSWD:ALL/ }
    end

    describe file("/home/#{get_native_user}/.bashrc") do
        it { should exist }
        it { should be_file }
        it { should be_mode 644 }
        it { should be_owned_by get_native_user }
        it { should be_grouped_into get_native_group }
        its(:content) { should match /GET_NATIVE_DB_PASS/ }
    end

    describe file('/root/.bashrc') do
        it { should exist }
        it { should be_file }
        it { should be_mode 644 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        its(:content) { should match /EDITOR/ }
    end
end
