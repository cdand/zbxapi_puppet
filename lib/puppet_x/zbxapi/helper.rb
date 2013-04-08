require "zbxapi"

#class Puppet::Puppet_X::Zbxapi::Helper
module Zbxapi

  ZABBIX_URL='http://localhost/'
  ZABBIX_USER='admin'
  ZABBIX_PASSWD='zabbix'

  $zabbix = ZabbixAPI::ZabbixAPI.new(ZABBIX_URL)
  $zabbix.verify_ssl = false
  $zabbix.login(ZABBIX_USER, ZABBIX_PASSWD)

end
