Puppet::Type.newtype(:zbx_template) do

  desc 'zbx_template is used to manage the Templates configured in your Zabbix server'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Zabbix Template'
  end

end
