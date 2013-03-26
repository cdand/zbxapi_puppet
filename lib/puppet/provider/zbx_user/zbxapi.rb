#require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'helper.rb'))
require 'zbxapi'

ZABBIX_URL='http://localhost/'
ZABBIX_USER='admin'
ZABBIX_PASSWD='zabbix'

Puppet::Type.type(:zbx_user).provide(:zbxapi) do

  $zabbix = ZabbixAPI::ZabbixAPI.new(ZABBIX_URL)
  $zabbix.verify_ssl = false
  $zabbix.login(ZABBIX_USER, ZABBIX_PASSWD)

  def self.instances
    users = $zabbix.user.get( 'output' => 'extend' )
    users.collect do |user|
			new( :name       => user["alias"],
          :ensure      => :present,
          :userid      => user["userid"],
          :firstname   => user["name"],
          :surname     => user["surname"],
          :usertype    => user["type"],
         )
    end
  end

  def self.prefetch(resources)
    users = instances
    resources.keys.each do |name|
      if provider = users.find{ |user| user.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.user.create( 'alias' => resource[:name], 'passwd' => 'blah', usrgrps:[{'usrgrpid' => '7'}] )
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.user.delete("userid" => @property_hash[:userid])
    @property_hash.clear
  end

	mk_resource_methods

end
