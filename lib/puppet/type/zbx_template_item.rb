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

  autorequire(:zbx_template) do
    self[:template]
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

  newproperty(:data_type) do
    desc <<-EOT
      Data type of the item.

      'decimal' (default)
      'octal'
      'hexadecimal'
      'boolean'
    EOT
    defaultto 'decimal'
    newvalues( 'decimal', 'octal', 'hexadecimal', 'boolean' )
    munge do |value|
      case value
      when 'decimal'
        0
      when 'octal'
        1
      when 'hexadecimal'
        2
      when 'boolean'
        3
      end
    end
  end

  newproperty(:delay_flex) do
    desc <<-EOT
      Flexible intervals as a serialized string.

      Each serialized flexible interval consists of an update interval and a time period separated by a forward slash. Multiple intervals are separated by a colon.
    EOT
  end

  newproperty(:delta) do
    desc <<-EOT
      Value that will be stored.

      'as is'        = As is (default)
      'delta'        = Delta, speed per second
      'simple delta' = Delta, simple change
    EOT
    defaultto 'as is'
    newvalues( 'as is', 'delta', 'simple delta' )
    munge do |value|
      case value
        when 'as is'
          0
        when 'delta'
          1
        when 'simple delta'
          2
			end
    end
  end

  newproperty(:description) do
    desc <<-EOT
      Description of the item.
    EOT
  end

  newproperty(:error) do
    desc <<-EOT
      (read-only) Error text if there are problems updating the item.
    EOT
  end

  newproperty(:flags) do
    desc <<-EOT
      (read-only) Origin of the item.

      0 - a plain item;
      4 - a discovered item.
    EOT
  end

  newproperty(:formula) do
    desc <<-EOT
      Custom multiplier.

      Default: 1.
    EOT
		defaultto 1
  end

  newproperty(:history) do
    desc <<-EOT
      Number of days to keep items history data.

      Default: 90.
    EOT
		defaultto 90
  end

  newproperty(:inventory_link) do
    desc <<-EOT
      ID of the host inventory field that is populated by the item.

      Refer to the host inventory page for a list of supported host inventory fields and their IDs.

      Default: 0.
    EOT
    defaultto 0
  end

  newproperty(:ipmi_sensor) do
    desc <<-EOT
      IPMI sensor. Used only by IPMI items.
    EOT
  end

  newproperty(:lastclock) do
    desc <<-EOT
      (read-only) Time when the item was last updated.
    EOT
  end

  newproperty(:lastns) do
    desc <<-EOT
      (read-only) Nanoseconds when the item was last updated.
    EOT
  end

  newproperty(:logtimefmt) do
    desc <<-EOT
      Format of the time in log entries. Used only by log items.
    EOT
  end

  newproperty(:mtime) do
    desc <<-EOT
      Time when the monitored log file was last updated. Used only by log items.
    EOT
  end

  newproperty(:multiplier) do
    desc <<-EOT
      Whether to use a custom multiplier.
    EOT
  end

  newproperty(:params) do
    desc <<-EOT
      Additional parameters depending on the type of the item:
      - executed script for SSH and telnet items;
      - additional parameters for database monitor items;
      - formula for calculated items.
    EOT
  end

  newproperty(:password) do
    desc <<-EOT
      Password for authentication. Used only by SSH, telnet and JMX items.
    EOT
  end

  newproperty(:port) do
    desc <<-EOT
      Port monitored by the item. Used only by SNMP items.
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
      SNMPv3 auth passphrase. Used only by SNMPv3 items.
    EOT
  end

  newproperty(:snmpv3_privpassphrase) do
    desc <<-EOT
      SNMPv3 priv passphrase. Used only by SNMPv3 items.
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
      SNMPv3 security name. Used only by SNMPv3 items.
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
      (read-only) ID of the parent template item.
    EOT
  end

  newproperty(:trapper_hosts) do
    desc <<-EOT
      Allowed hosts. Used only by trapper items.
    EOT
  end

  newproperty(:trends) do
    desc <<-EOT
      Number of days to keep items trends data.

      Default: 365.
    EOT
    defaultto 365
  end

  newproperty(:units) do
		desc <<-EOT
      Value units.

      If a unit symbol is set, Zabbix will add post processing to the received value
      and display it with the set unit postfix.

      By default, if the raw value exceeds 1000, it is divided by 1000 and displayed
      accordingly. For example, if you set bps and receive a value of 881764, it will
      be displayed as 881.76 Kbps.  Special processing is used for B (byte), Bps
      (bytes per second) units, which are divided by 1024. Thus, if units are set to
      B or Bps Zabbix will display:

      1 as 1B/1Bps
      1024 as 1KB/1KBps
      1536 as 1.5KB/1.5KBps

      Special processing is used if the following time-related units are used:
      unixtime - translated to "yyyy.mm.dd hh:mm:ss". To translate correctly, the
      received value must be a Numeric (unsigned) type of information.

      uptime - translated to "hh:mm:ss" or "N days, hh:mm:ss" For example, if you
      receive the value as 881764 (seconds), it will be displayed as "10 days,
      04:56:04"

      s - translated to "yyy mmm ddd hhh mmm sss ms"; parameter is treated as number
      of seconds.  For example, if you receive the value as 881764 (seconds), it will
      be displayed as "10d 4h 56m" Only 3 upper major units are shown, like "1m 15d
      5h" or "2h 4m 46s". If there are no days to display, only two levels are
      displayed - "1m 5h" (no minutes, seconds or milliseconds are shown). Will be
      translated to "< 1 ms" if the value is less than 0.001.

      See also the unit blacklist.
    EOT
  end

  newproperty(:username) do
    desc <<-EOT
      Username for authentication. Used only by SSH, telnet and JMX items.

      Required by SSH and telnet items.
    EOT
  end

  newproperty(:valuemapid) do
    desc <<-EOT
      ID of the associated value map.
    EOT
  end

end
