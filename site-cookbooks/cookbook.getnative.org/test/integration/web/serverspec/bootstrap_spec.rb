require 'spec_helper'

describe 'cookbook.getnative.org::bootstrap' do
    describe file('/etc/ssh/sshd_config') do
        it { should exist }
        it { should be_file }
        its(:content) { should match /PasswordAuthentication no/ }
    end

    %w(ntp git psmisc tree tmux cron-apt).each do |pkg|
        describe package(pkg) do
            it { should be_installed }
        end
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
