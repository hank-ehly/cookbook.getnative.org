require 'spec_helper'

describe 'cookbook.getnative.org::certbot' do
    describe package('software-properties-common') do
        it {should be_installed}
    end

    describe ppa('certbot/certbot') do
        it {should exist}
        it {should be_enabled}
    end

    describe package('python-certbot-apache') do
        it {should be_installed}
    end
end
