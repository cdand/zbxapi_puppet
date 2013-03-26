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
    hostgroups = $zabbix.hostgroup.get( 'output' => 'extend', 'selectHosts' => 'extend' )
    hostgroups.collect do |hostgroup|
			new( :name    => hostgroup["name"],
          :ensure   => :present,
          :groupid  => hostgroup["groupid"],
          :internal => hostgroup["internal"],
          :hosts    => hostgroup["hosts"],
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
    @property_hash[:ensure] = :present
  end

  def destroy
    if resource[:purge]
      @property_hash[:hosts].each do |host|
        $zabbix.host.delete("hostid" => host["hostid"])
      end
    end
    $zabbix.hostgroup.delete([@property_hash[:groupid]])
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the
  # getters for 'groupid' and 'internal' properties (left commented below). I'm
  # not sure yet how this can possibly work for setters though.
  #
  #  def groupid
  #		@property_hash[:groupid]
  #  end
  #
  #  def internal
  # 		@property_hash[:internal]
  #  end
  mk_resource_methods

end
