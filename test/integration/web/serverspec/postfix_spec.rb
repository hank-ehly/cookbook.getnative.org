require 'spec_helper'

describe 'cookbook.getnativelearning.com::postfix' do
    describe package('postfix') do
        it { should be_installed }
    end

    describe file('/etc/postfix/main.cf') do
        it { should be_file }
        it { should exist }
        it { should be_mode 644 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        its(:content) { should match /smtpd_milters\s=\sinet:localhost:8891/ }
    end

    # todo: what was the purpose of running `postalias` again?

    describe service('postfix') do
        it { should be_enabled }
        it { should be_running.under('systemd') }
    end
end
