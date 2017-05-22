require 'spec_helper'

describe 'get-native.com-cookbook::bootstrap' do
    describe file('/etc/ssh/sshd_config') do
        it { should exist }
        it { should be_file }
        its(:content) { should match /PasswordAuthentication no/ }
    end

    describe package('ntp') do
        it { should be_installed }
    end

    describe package('git') do
        it { should be_installed }
    end

    describe package('psmisc') do
        it { should be_installed }
    end

    describe package('tree') do
        it { should be_installed }
    end

    describe package('tmux') do
        it { should be_installed }
    end

    describe package('cron-apt') do
        it { should be_installed }
    end

    describe command('timedatectl status --no-pager') do
        its(:stdout) { should match /Time zone: UTC \(UTC, \+0000\)/ }
        its(:stdout) { should match /NTP synchronized: yes/ }
    end

    describe file('/etc/cron-apt/config') do
        it { should exist }
        it { should be_file }
        it { should be_mode 644 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        its(:content) { should match /MAILON="always"/ }
    end
end
