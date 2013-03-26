Puppet::Type.newtype(:zbx_user) do

  desc 'zbx_user is used to manage the Users configured in your Zabbix server'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The username of the Zabbix User'
  end

  newproperty(:userid) do
    desc 'The read-only userid of the Zabbix User'
  end

  newproperty(:firstname) do
    desc 'The firstname of the Zabbix User'
  end

  newproperty(:surname) do
    desc 'The firstname of the Zabbix User'
  end

  newproperty(:usertype) do
    desc 'The firstname of the Zabbix User'
  end

end
