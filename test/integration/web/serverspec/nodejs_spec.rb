require 'spec_helper'

describe 'get-native.com-cookbook::nodejs' do
    node_version = '6.10.3'

    %W{/usr/local/nodejs-binary-#{node_version}/bin/node /usr/local/nodejs-binary-#{node_version}/bin/npm}.each do |f|
        describe file(f) do
            it { should be_symlink }
            it { should be_executable.by('get-native') }
        end
    end

    describe file('/home/get-native/.bashrc') do
        it { should be_file }
        its(:content) { should match /export PATH="\/usr\/local\/nodejs-binary\/bin:\$PATH"/ }
    end
end
