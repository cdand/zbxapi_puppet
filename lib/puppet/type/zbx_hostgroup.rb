Puppet::Type.newtype(:zbx_hostgroup) do

  desc 'zbx_hostgroup is used to manage the HostGroups configured in your Zabbix server'

  ensurable

  newparam(:name, :namevar => true) do
	  desc 'The name of the Zabbix HostGroup'
  end

end
