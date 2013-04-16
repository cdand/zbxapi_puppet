require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_template_discoveryrule).provide(:zbxapi) do

  def self.instances
    discoveryrules = $zabbix.discoveryrule.get( 'output' => 'extend', 'templated' => true, 'inherited' => false)
    discoveryrules.collect do |discoveryrule|
      new( :name                  => discoveryrule["name"],
           :ensure                => :present,
           :itemid                => discoveryrule["itemid"],
           :delay                 => discoveryrule["delay"],
           :hostid                => discoveryrule["hostid"],
           :interfaceid           => discoveryrule["interfaceid"],
           :key_                  => discoveryrule["key_"],
           :type                  => discoveryrule["type"],
           :authtype              => discoveryrule["authtype"],
           :delay_flex            => discoveryrule["delay_flex"],
           :description           => discoveryrule["description"],
           :error                 => discoveryrule["error"],
           :filter                => discoveryrule["filter"],
           :ipmi_sensor           => discoveryrule["ipmi_sensor"],
           :lastclock             => discoveryrule["lastclock"],
           :lastns                => discoveryrule["lastns"],
           :lifetime              => discoveryrule["lifetime"],
           :params                => discoveryrule["params"],
           :password              => discoveryrule["password"],
           :port                  => discoveryrule["port"],
           :privatekey            => discoveryrule["privatekey"],
           :publickey             => discoveryrule["publickey"],
           :snmp_community        => discoveryrule["snmp_community"],
           :snmp_oid              => discoveryrule["snmp_oid"],
           :snmpv3_authpassphrase => discoveryrule["snmpv3_authpassphrase"],
           :snmpv3_privpassphrase => discoveryrule["snmpv3_privpassphrase"],
           :snmpv3_securitylevel  => discoveryrule["snmpv3_securitylevel"],
           :snmpv3_securityname   => discoveryrule["snmpv3_securityname"],
           :status                => discoveryrule["status"],
           :templateid            => discoveryrule["templateid"],
           :trapper_hosts         => discoveryrule["trapper_hosts"],
           :username              => discoveryrule["username"],
      )
    end
  end

  def self.prefetch(resources)
    discoveryrules = instances
    resources.keys.each do |name|
      if provider = discoveryrules.find{ |discoveryrule| discoveryrule.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
		hostid = $zabbix.template.get( 'output' => 'shorten', 'filter' => { 'name' => resource[:template]} )
    $zabbix.discoveryrule.create( 'name'                  => resource[:name],
                                  'delay'                 => resource[:delay],
                                  'hostid'                => hostid.first.map { |key, value| value }.first,
                                  'interfaceid'           => resource[:interfaceid],
                                  'key_'                  => resource[:key_],
                                  'type'                  => resource[:type],
                                  'authtype'              => resource[:authtype],
                                  'delay_flex'            => resource[:delay_flex],
                                  'description'           => resource[:description],
                                  'filter'                => resource[:filter],
                                  'ipmi_sensor'           => resource[:ipmi_sensor],
                                  'lifetime'              => resource[:lifetime],
                                  'params'                => resource[:params],
                                  'password'              => resource[:password],
                                  'port'                  => resource[:port],
                                  'privatekey'            => resource[:privatekey],
                                  'publickey'             => resource[:publickey],
                                  'snmp_community'        => resource[:snmp_community],
                                  'snmp_oid'              => resource[:snmp_oid],
                                  'snmpv3_authpassphrase' => resource[:snmpv3_authpassphrase],
                                  'snmpv3_privpassphrase' => resource[:snmpv3_privpassphrase],
                                  'snmpv3_securitylevel'  => resource[:snmpv3_securitylevel],
                                  'snmpv3_securityname'   => resource[:snmpv3_securityname],
                                  'status'                => resource[:status],
                                  'trapper_hosts'         => resource[:trapper_hosts],
                                  'username'              => resource[:username],
                                )
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.discoveryrule.delete([@property_hash[:itemid]])
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the
  # getters for all properties. I'm not sure yet how this can possibly work
	# for setters though.
  mk_resource_methods 

  # Despite Puppet Labs docs, it would appear mk_resource methods is only
  # useful for getters. We need to create all the different setters.
  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def flush
    unless @property_flush.empty?
      @property_flush['discoveryruleid'] = @property_hash[:itemid]
      $zabbix.discoveryrule.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
