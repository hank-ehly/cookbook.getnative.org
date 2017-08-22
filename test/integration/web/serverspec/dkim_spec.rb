require 'spec_helper'

describe 'cookbook.getnativelearning.com::dkim' do
    dkim_user = 'opendkim'
    dkim_group = 'opendkim'

    describe package('opendkim') do
        it { should be_installed }
    end

    describe package('opendkim-tools') do
        it { should be_installed }
    end

    describe service('opendkim') do
        it { should be_enabled }
        it { should be_running.under('systemd') }
    end

    describe file('/etc/dkimkeys/localhost') do
        it { should be_directory }
    end

    describe file('/var/log/dkim-filter') do
        it { should be_directory }
        it { should be_mode 700 }
        it { should be_owned_by dkim_user }
        it { should be_grouped_into dkim_group }
    end

    describe file('/etc/dkimkeys/localhost/mail.private') do
        it { should be_file }
        it { should exist }
        it { should be_mode 600 }
        it { should be_owned_by dkim_user }
        it { should be_grouped_into dkim_group }
    end

    describe file('/etc/dkimkeys/dkim.key') do
        it { should be_symlink }
        it { should be_linked_to '/etc/dkimkeys/localhost/mail.private' }
        it { should exist }
        it { should be_owned_by dkim_user }
        it { should be_grouped_into dkim_group }
    end

    describe file('/etc/opendkim.conf') do
        it { should be_file }
        it { should exist }
        it { should be_mode 644 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        its(:content) { should match /Domain\s+localhost/ }
    end

    describe file('/etc/default/opendkim') do
        it { should be_file }
        it { should exist }
        its(:content) { should match /SOCKET="inet:8891@localhost"/ }
    end
end
