Puppet::Type.newtype(:zbx_hostgroup) do

  desc 'zbx_hostgroup is used to manage the Hostgroups configured in your Zabbix server'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Zabbix Hostgroup'
  end

  newproperty(:groupid) do
    desc 'The read-only Groupid of the Zabbix Hostgroup'
  end

  newproperty(:internal) do
    desc 'Read-only flag for if the Hostgroup is internal to Zabbix'
  end

  newparam(:purge) do
    desc <<-EOT
      Hostgroups cannot be deleted from Zabbix when they still have dependant
      Hosts. When set to true, this flag will delete all dependant Hosts as
      well as the Hostgroup itself. Be careful with this, make sure you know
      what will happen if you enable this.
    EOT
    defaultto :false
    newvalues(:true, :false)
  end

end
