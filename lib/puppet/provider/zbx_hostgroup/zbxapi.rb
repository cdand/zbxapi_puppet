#require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'helper.rb'))
require 'zbxapi'

ZABBIX_URL='http://localhost/'
ZABBIX_USER='admin'
ZABBIX_PASSWD='zabbix'

Puppet::Type.type(:zbx_hostgroup).provide(:zbxapi) do

  $zabbix = ZabbixAPI::ZabbixAPI.new(ZABBIX_URL)
  $zabbix.verify_ssl = false
  $zabbix.login(ZABBIX_USER, ZABBIX_PASSWD)

  def self.instances
    hostgroups = $zabbix.hostgroup.get( 'output' => 'extend' )
    hostgroups.collect do |hostgroup|
			new( :name    => hostgroup["name"],
          :ensure   => :present,
          :groupid  => hostgroup["groupid"],
          :internal => hostgroup["internal"],
         )
    end
  end

  def self.prefetch(resources)
    hostgroups = instances
    resources.keys.each do |name|
      if provider = hostgroups.find{ |hostgroup| hostgroup.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.hostgroup.create( 'name' => resource[:name] )
  end

  def destroy
    result = $zabbix.hostgroup.get( 'output' => 'shorten', 'filter' => { 'name' => resource[:name] })
    id = result[0]["groupid"]
    $zabbix.hostgroup.delete([id])
  end

  def groupid
		@property_hash[:groupid]
  end

  def internal
 		@property_hash[:internal]
 end
end
