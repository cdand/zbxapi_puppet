Puppet::Type.newtype(:zbx_template_item) do

  desc 'zbx_template_item is used to manage the items contained within a Zabbix Template'

  ensurable

  newparam(:name, :namevar => true) do
    desc <<-EOT
      Name of the item.
    EOT
  end

  newproperty(:itemid) do
    desc <<-EOT
      (read-only) ID of the item.
    EOT
  end

  newproperty(:hostid) do
    desc <<-EOT
      ID of the template that the item belongs to.
    EOT
  end

  newproperty(:template) do
    desc <<-EOT
      Name of the template that the item belongs to.
    EOT
  end

  newproperty(:delay) do
		#TODO verify integer > 60
    desc <<-EOT
      Update interval of the item in seconds.

			Default 3600s
    EOT
		defaultto 3600
  end

  newproperty(:key_) do
    desc <<-EOT
      Item key.
    EOT
  end

  newproperty(:interfaceid) do
    desc <<-EOT
      ID of the item's host interface.
    EOT
  end

  newproperty(:type) do
    desc <<-EOT
      Type of the item.

      'Zabbix agent'
      'SNMPv1 agent'
      'Zabbix trapper'
      'simple check'
      'SNMPv2 agent'
      'Zabbix internal'
      'SNMPv3 agent'
      'Zabbix agent (active)'
      'Zabbix aggregate'
      'external check'
      'database monitor'
      'IPMI agent'
      'SSH agent'
      'TELNET agent'
      'calculated'
      'JMX agent'

      Zabbix web items cannot be created via the Zabbix API
    EOT
    defaultto 'Zabbix agent'
    newvalues( 'Zabbix agent', 'SNMPv1 agent', 'Zabbix trapper', 'simple check', 'SNMPv2 agent', 'Zabbix internal', 'SNMPv3 agent', 'Zabbix agent (active)', 'Zabbix aggregate', 'external check', 'database monitor', 'IPMI agent', 'SSH agent', 'TELNET agent', 'calculated', 'JMX agent')
    munge do |value|
      case value
      when 'Zabbix agent'
        0
      when 'SNMPv1 agent'
        1
      when 'Zabbix trapper'
        2
      when 'simple check'
        3
      when 'SNMPv2 agent'
        4
      when 'Zabbix internal'
        5
      when 'SNMPv3 agent'
        6
      when 'Zabbix agent (active)'
        7
      when 'Zabbix aggregate'
        8
      when 'external check'
        10
      when 'database monitor'
        11
      when 'IPMI agent'
        12
      when 'SSH agent'
        13
      when 'TELNET agent'
        14
      when 'calculated'
        15
      when 'JMX agent'
        16
      end
    end
  end

  newproperty(:value_type) do
    desc <<-EOT
    Type of information of the item.

    'numeric float'
    'character'
    'log'
    'numeric unsigned'
    'text'
    EOT
    defaultto 'numeric unsigned'
    newvalues()
    munge do |value|
      case value
      when 'numeric float'
        0
      when 'character'
        1
      when 'log'
        2
      when 'numeric unsigned'
        3
      when 'text'
        4
      end
    end
  end

end
