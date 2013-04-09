require 'spec_helper'

describe 'zbx_hostgroup' do

  let(:provider) { Puppet::Type.type(:zbx_hostgroup) }

  it "should get defined as provider" do
    resource = Puppet::Type.type(:zbx_hostgroup).new({
      :name => 'non-existant rspec hostgroup',
    })
    resource.provider.class.to_s.should == "Puppet::Type::Zbx_hostgroup::ProviderZbxapi"
  end

  it "should return false on non-existant hostgroup" do
    resource = Puppet::Type.type(:zbx_hostgroup).new({
      :name => 'non-existant rspec hostgroup',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    resource.provider().exists?().should be_false
  end

  it "should return true on existing hostgroup" do
    resource = Puppet::Type.type(:zbx_hostgroup).new({
      :name => 'existing rspec hostgroup',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    if !resource.provider().exists?()
      resource.provider().create()
    end
    resource.provider().exists?().should be_true
  end

  it "should create a hostgroup, find it and delete it again" do
    resource = Puppet::Type.type(:zbx_hostgroup).new({
      :name => 'rspec zabbix hostgroup',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    resource.provider().create()
    resource.provider().exists?().should be_true
    resource.provider().destroy()
    resource.provider().exists?().should be_false
  end

end
