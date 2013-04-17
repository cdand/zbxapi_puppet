Puppet::Type.newtype(:zbx_template_discoveryrule) do

  desc <<-EOT
    zbx_template_discoveryrule is used to manage the Zabbix Low Level Discovery rules for templates.
  EOT

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the LLD rule'
  end

  newproperty(:itemid) do
    desc '(read-only) ID of the LLD rule'
  end

  newproperty(:delay) do
    desc <<-EOT
      Update interval of the LLD rule in seconds.

			Default 3600
    EOT
		defaultto 3600
  end

  newproperty(:hostid) do
    desc <<-EOT
      (read-only) ID of the host that the LLD rule belongs to.
    EOT
  end

  newproperty(:template) do
    desc <<-EOT
      Template that the LLD rule belongs to.
    EOT
  end

  autorequire(:zbx_template) do
    self[:template]
  end

  newproperty(:interfaceid) do
    desc <<-EOT
      ID of the LLD rule's host interface.
    EOT
  end

  newproperty(:key_) do
    desc <<-EOT
      LLD rule key.
    EOT
  end

  newproperty(:type) do
    desc <<-EOT
      Type of the LLD rule. 
      
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

  newproperty(:authtype) do
    desc <<-EOT
      SSH authentication method. Used only by SSH agent LLD rules. 

      'password' (default)
      'public key'
    EOT
    defaultto 'password'
    munge do |value|
      case value
      when 'password'
        0
      when 'public key'
        1
      end
    end
  end

  newproperty(:delay_flex) do
    desc <<-EOT
      Flexible intervals as a serialized string. 

      Each serialized flexible interval consists of an update interval and a time period separated by a forward slash. Multiple intervals are separated by a colon.
    EOT
  end

  newproperty(:description) do
    desc <<-EOT
      Description of the LLD rule.
    EOT
  end

  newproperty(:error) do
    desc <<-EOT
      (read-only) Error text if there are problems updating the LLD rule.
    EOT
  end

  newproperty(:filter) do
    desc <<-EOT
      LLD rule filter containing the macro to filter by and the regexp to be used for filtering separated by a colon.

      For example {#IFNAME}:@Network interfaces for discovery.
    EOT
  end

  newproperty(:ipmi_sensor) do
    desc <<-EOT
      IPMI sensor. Used only by IPMI LLD rules.
    EOT
  end

  newproperty(:lastclock) do
    desc <<-EOT
      (read-only) Time when the LLD rule was last executed.
    EOT
  end

  newproperty(:lastns) do
    desc <<-EOT
      (read-only) Nanoseconds when the LLD rule was last executed.(read-only) Nanoseconds when the LLD rule was last executed.
    EOT
  end

  newproperty(:lifetime) do
    #TODO validate integer
    desc <<-EOT
      Time period after which items that are no longer discovered will be deleted, in days. 

      Default: 30.
    EOT
    defaultto 30
  end

  newproperty(:params) do
    desc <<-EOT
      Additional parameters depending on the type of the LLD rule: 
      - executed script for SSH and telnet LLD rules; 
      - additional parameters for database monitor LLD rules; 
      - formula for calculated LLD rules.
    EOT
  end

  newproperty(:password) do
    desc <<-EOT
      Password for authentication. Used only by SSH, telnet and JMX LLD rules.
    EOT
  end

  newproperty(:port) do
    desc <<-EOT
      Port used by the LLD rule. Used only by SNMP LLD rules.
    EOT
  end

  newproperty(:privatekey) do
    desc <<-EOT
      Name of the private key file.
    EOT
  end

  newproperty(:publickey) do
    desc <<-EOT
      Name of the public key file.
    EOT
  end

  newproperty(:snmp_community) do
    desc <<-EOT
      SNMP community.
    EOT
  end

  newproperty(:snmp_oid) do
    desc <<-EOT
      SNMP OID.
    EOT
  end

  newproperty(:snmpv3_authpassphrase) do
    desc <<-EOT
      SNMPv3 auth passphrase. Used only by SNMPv3 LLD rules.
    EOT
  end

  newproperty(:snmpv3_privpassphrase) do
    desc <<-EOT
      SNMPv3 priv passphrase. Used only by SNMPv3 LLD rules.
    EOT
  end

  newproperty(:snmpv3_securitylevel) do
    desc <<-EOT
      SNMPv3 security level. Used only by SNMPv3 LLD rules. 

      'noAuthNoPriv'
      'authNoPriv'
      'authPriv'
    EOT
    newvalues( 'noAuthNoPriv', 'authNoPriv', 'authPriv' )
    munge do |value|
      case value
      when 'noAuthNoPriv'
        0
      when 'authNoPriv'
        1
      when 'authPriv'
        2
      end
    end
  end

  newproperty(:snmpv3_securityname) do
    desc <<-EOT
      SNMPv3 security name. Used only by SNMPv3 LLD rules.
    EOT
  end

  newproperty(:enabled) do
    desc <<-EOT
      Status of the LLD rule. 

      'true'        = (default) enabled LLD rule; 
      'false'       = disabled LLD rule; 
    EOT
    defaultto 'true'
    newvalues( 'true', 'false', 'unsupported' )
    munge do |value|
      case value
      when 'true'
        0
      when 'false'
        1
      when 'unsupported'
        2
      end
    end
  end

  newproperty(:templateid) do
    desc <<-EOT
      (read-only) ID of the parent template LLD rule.
    EOT
  end

  newproperty(:trapper_hosts) do
    desc <<-EOT
      Allowed hosts. Used only by trapper LLD rules.
    EOT
  end

  newproperty(:username) do
    desc <<-EOT
      Username for authentication. Used only by SSH, telnet and JMX LLD rules. 

      Required by SSH and telnet LLD rules.
    EOT
  end

end
