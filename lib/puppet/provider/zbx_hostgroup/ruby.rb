#require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'helper.rb'))
require 'zbxapi'

ZABBIX_URL='http://localhost/'
ZABBIX_USER='admin'
ZABBIX_PASSWD='zabbix'

Puppet::Type.type(:zbx_hostgroup).provide(:ruby) do

  $zabbix = ZabbixAPI::ZabbixAPI.new(ZABBIX_URL)
  $zabbix.verify_ssl = false
  $zabbix.login(ZABBIX_USER, ZABBIX_PASSWD)

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
end
