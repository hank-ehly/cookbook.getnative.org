require 'spec_helper'

describe 'cookbook.getnativelearning.com::add-user' do
    getnative_user = 'getnative'
    getnative_group = 'getnative'

    describe group(getnative_group) do
        it { should exist }
    end

    describe user(getnative_user) do
        it { should exist }
        it { should belong_to_group getnative_group }
        it { should have_home_directory "/home/#{getnative_user}" }
        it { should have_login_shell '/bin/bash' }
    end

    describe file("/etc/sudoers.d/#{getnative_user}") do
        it { should exist }
        its(:content) { should match /getnative ALL=\(ALL:ALL\) NOPASSWD:ALL/ }
    end

    describe file("/home/#{getnative_user}/.bashrc") do
        it { should exist }
        it { should be_file }
        it { should be_mode 644 }
        it { should be_owned_by getnative_user }
        it { should be_grouped_into getnative_group }
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
