Puppet::Type.newtype(:zbx_proxy) do
	# Puppet passive proxy via API bug - ZBX6361

  desc <<-EOT
    zbx_proxy is used to manage the Zabbix proxies that work alongside the
    Zabbix server.
        
    This type and provider support creation of 'active' and 'passive' proxies.
    However due to a bug in the Zabbix API (ZBX6361) the settings defined here will
    not take effect for passive proxies, you'll have to define the passive proxy
    here and then manually set the ip/dns/port settings in the Zabbix frontend.
  EOT

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Zabbix proxy'
  end

  newproperty(:proxyid) do
    desc <<-EOT
      (read-only) The proxyid of the Zabbix proxy.
    EOT
  end

  newproperty(:status) do
    desc <<-EOT
		  Defines the type of proxy that is to be managed.

			'active'  = Active proxy, the proxy host initiates connections to Zabbix server and pulls data.
			'passive' = Passive proxy, the Zabbix server initiates connections and send data to the proxy.
		EOT
		defaultto 'active'
		newvalues( 'active', 'passive' )
		munge do |value|
			case value
			when 'active'
				5
			when 'passive'
				6
			end
		end
  end

  newproperty(:lastaccess) do
    desc <<-EOT
      (read-only) Seconds elapsed since the proxy last connected to the server.
		EOT
  end

  newproperty(:ip) do
    desc <<-EOT
		DNS name to connect to. 

		Can be empty if connections are made via IP address.
		EOT
  end

  newproperty(:dns) do
    desc <<-EOT
		IP address to connect to. 

		Can be empty if connections are made via DNS names.
		EOT
  end

  newproperty(:port) do
    desc <<-EOT
		Port number to connect to.
		EOT
  end

  newproperty(:useip) do
    desc <<-EOT
		Whether the connection should be made via IP address. 

		Possible values are: 
		'false' = connect using DNS name; 
		'true'  = connect using IP address.
		EOT
    # Deliberately no 'defaultto' because it messes with active proxies that don't have this property
		# The default is set by the API logic anyway.
		newvalues( 'true', 'false' )
		munge do |value|
			case value
			when 'true'
				1
			when 'false'
				0
			end
		end
  end

end
