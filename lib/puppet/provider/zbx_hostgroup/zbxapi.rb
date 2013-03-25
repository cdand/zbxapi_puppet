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

  def exists?
    result = $zabbix.hostgroup.get( 'output' => 'shorten', 'filter' => { 'name' => resource[:name] })
    if result.empty?
      false
    else
      true
    end
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
    result = $zabbix.hostgroup.get( 'output' => 'shorten', 'filter' => { 'name' => resource[:name] })
    groupid = result[0]["groupid"]
  end

  def internal
    result = $zabbix.hostgroup.get( 'output' => 'extend', 'filter' => { 'name' => resource[:name] })
    internal = result[0]["internal"]
  end
end
