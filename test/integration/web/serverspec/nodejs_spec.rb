require 'spec_helper'

describe 'cookbook.getnativelearning.com::nodejs' do
    describe command('node --version') do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should match /v8.1.0/ }
    end

    describe file('/usr/local/nodejs-binary') do
        it { should be_symlink }
    end

    %W{/usr/local/nodejs-binary/bin/node /usr/local/nodejs-binary/bin/npm}.each do |f|
        describe file(f) do
            it { should be_file }
        end
    end

    describe file('/home/getnative/.bashrc') do
        it { should be_file }
        its(:content) { should match /export PATH="\/usr\/local\/nodejs-binary\/bin:\$PATH"/ }
    end
end
