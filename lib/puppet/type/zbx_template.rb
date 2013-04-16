Puppet::Type.newtype(:zbx_template) do

  desc 'zbx_template is used to manage the Templates configured in your Zabbix server'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Zabbix Template'
  end

	newproperty(:visiblename) do
		#FIXME If a visiblename is set and then removed Puppet doesn't remove the visible name from Zabbix configuration.
		#      isn't as simple as just setting a blank default.
    desc 'The visible name of the Zabbix Template'
  end

  newproperty(:hostgroups, :array_matching => :all) do
    desc <<-EOT
      Array of Hostgroups to add the template to.
			
			(default) ['Templates']

			e.g. ['Templates', 'Linux templates']
    EOT
		defaultto ['Templates']
  end

  newproperty(:parents, :array_matching => :all) do
    desc <<-EOT
      Array of parent templates to link the template to.
			
			(default) [] = empty array

			e.g. ['Template Ruckus Controller', 'Templates SNMP Generic']
    EOT
 		defaultto []
 end

end
