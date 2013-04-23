require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_template_itemprototype).provide(:zbxapi) do

  def self.instances
    # We pull in a list of all templates here so that we can set the value of
    #@property_flush[:template] to satisfy Puppet's desire to change/set this.
    #This add computational complexity, but saves having thousands of API calls
    #later on.
    templates = $zabbix.template.get( 'output' => 'extend' )
    discovery_rules = $zabbix.discoveryrule.get( 'output' => 'extend' )
    itemprototypes = $zabbix.itemprototype.get( 'output' => 'extend', 'templated' => true, 'inherited' => false, 'selectDiscoveryRule' => 'refer' )
    itemprototypes.collect do |itemprototype|
      template = templates.detect { |template| template["hostid"] == itemprototype["hostid"] }["host"]
      discovery_rule = discovery_rules.detect { |discovery_rule| discovery_rule["itemid"] == itemprototype["discoveryRule"]["itemid"] }["name"]
      new( :name                   => itemprototype["name"],
           :ensure                 => :present,
           :itemid                 => itemprototype["itemid"],
           :ruleid                 => itemprototype["discoveryRule"]["itemid"],
           :discovery_rule         => discovery_rule,
           :hostid                 => itemprototype["hostid"],
           :template               => template,
           :delay                  => itemprototype["delay"],
           :key_                   => itemprototype["key_"],
           :interfaceid            => itemprototype["interfaceid"],
           :value_type             => itemprototype["value_type"],
           :type                   => itemprototype["type"],
           :username               => itemprototype["username"],
           :authtype               => itemprototype["authtype"],
           :data_type              => itemprototype["data_type"],
           :delay_flex             => itemprototype["delay_flex"],
           :delta                  => itemprototype["delta"],
           :description            => itemprototype["description"],
           :formula                => itemprototype["formula"],
           :history                => itemprototype["history"],
           :ipmi_sensor            => itemprototype["ipmi_sensor"],
           :logtimefmt             => itemprototype["logtimefmt"],
           :multiplier             => itemprototype["multiplier"],
           :params                 => itemprototype["params"],
           :password               => itemprototype["password"],
           :port                   => itemprototype["port"],
           :privatekey             => itemprototype["privatekey"],
           :publickey              => itemprototype["publickey"],
           :snmp_community         => itemprototype["snmp_community"],
           :snmp_oid               => itemprototype["snmp_oid"],
           :snmpv3_authpassphrase  => itemprototype["snmpv3_authpassphrase"],
           :snmpv3_privpassphrase  => itemprototype["snmpv3_privpassphrase"],
           :snmpv3_securitylevel   => itemprototype["snmpv3_securitylevel"],
           :snmpv3_securityname    => itemprototype["snmpv3_securityname"],
           :enabled                => itemprototype["status"],
           :templateid             => itemprototype["templateid"],
           :trapper_hosts          => itemprototype["trapper_hosts"],
           :trends                 => itemprototype["trends"],
           :units                  => itemprototype["units"],
           :valuemapid             => itemprototype["valuemapid"],
         )
    end
  end



  def self.prefetch(resources)
    itemprototypes = instances
    resources.keys.each do |name|
      if provider = itemprototypes.find{ |item| item.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    hostid = $zabbix.template.get( 'output' => 'shorten', 'filter' => { 'name' => resource[:template]} )
    resource[:hostid] = hostid.first["templateid"]
    ruleid = $zabbix.discoveryrule.get( 'output' => 'shorten', 'filter' => { 'host' => resource[:template], 'name' => resource[:discovery_rule] } )
    resource[:ruleid] = ruleid.first["itemid"]
    $zabbix.itemprototype.create( 'name'                  => resource[:name],
                                  'hostid'                => resource[:hostid],
                                  'ruleid'                => resource[:ruleid],
                                  'delay'                 => resource[:delay],
                                  'key_'                  => resource[:key_],
                                  'interfaceid'           => resource[:interfaceid],
                                  'value_type'            => resource[:value_type],
                                  'type'                  => resource[:type],
                                  'template'              => resource[:template],
                                  'username'              => resource[:username],
                                  'authtype'              => resource[:authtype],
                                  'data_type'             => resource[:data_type],
                                  'delay_flex'            => resource[:delay_flex],
                                  'delta'                 => resource[:delta],
                                  'description'           => resource[:description],
                                  'formula'               => resource[:formula],
                                  'history'               => resource[:history],
                                  'ipmi_sensor'           => resource[:ipmi_sensor],
                                  'logtimefmt'            => resource[:logtimefmt],
                                  'multiplier'            => resource[:multiplier],
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
                                  'status'                => resource[:enabled],
                                  'trapper_hosts'         => resource[:trapper_hosts],
                                  'trends'                => resource[:trends],
                                  'units'                 => resource[:units],
                                  'valuemapid'            => resource[:valuemapid],
                                )
    @property_hash[:ensure] = :present
  end


  def destroy
    $zabbix.itemprototype.delete([@property_hash[:itemid]])
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

  def delay=(value)
    @property_flush['delay'] = value
  end

  def key_=(value)
    @property_flush['key_'] = value
  end

  def interfaceid=(value)
    @property_flush['interfaceid'] = value
  end

  def value_type=(value)
    @property_flush['value_type'] = value
  end

  def type=(value)
    @property_flush['type'] = value
  end

  def template=(value)
    templateid = $zabbix.template.get( 'output' => 'shorten', 'filter' => { 'name' => value } ).first["templateid"]
    @property_flush['template'] = templateid
  end

  def authtype=(value)
    @property_flush['authtype'] = value
  end

  def data_type=(value)
    @property_flush['data_type'] = value
  end

  def delay_flex=(value)
    @property_flush['delay_flex'] = value
  end

  def delta=(value)
    @property_flush['delta'] = value
  end

  def description=(value)
    @property_flush['description'] = value
  end

  def formula=(value)
    @property_flush['formula'] = value
  end

  def history=(value)
    @property_flush['history'] = value
  end

  def ipmi_sensor=(value)
    @property_flush['ipmi_sensor'] = value
  end

  def logtimefmt=(value)
    @property_flush['logtimefmt'] = value
  end

  def multiplier=(value)
    @property_flush['multiplier'] = value
  end

  def params=(value)
    @property_flush['params'] = value
  end

  def password=(value)
    @property_flush['password'] = value
  end

  def port=(value)
    @property_flush['port'] = value
  end

  def privatekey=(value)
    @property_flush['privatekey'] = value
  end

  def publickey=(value)
    @property_flush['publickey'] = value
  end

  def snmp_community=(value)
    @property_flush['snmp_community'] = value
  end

  def snmp_oid=(value)
    @property_flush['snmp_oid'] = value
  end

  def snmpv3_authpassphrase=(value)
    @property_flush['snmpv3_authpassphrase'] = value
  end

  def snmpv3_privpassphrase=(value)
    @property_flush['snmpv3_privpassphrase'] = value
  end

  def snmpv3_securitylevel=(value)
    @property_flush['snmpv3_securitylevel'] = value
  end

  def snmpv3_securityname=(value)
    @property_flush['snmpv3_securityname'] = value
  end

  def enabled=(value)
    @property_flush['status'] = value
  end

  def trapper_hosts=(value)
    @property_flush['trapper_hosts'] = value
  end

  def trends=(value)
    @property_flush['trends'] = value
  end

  def units=(value)
    @property_flush['units'] = value
  end

  def username=(value)
    @property_flush['username'] = value
  end

  def valuemapid=(value)
    @property_flush['valuemapid'] = value
  end

  def flush
    unless @property_flush.empty?
			@property_flush['itemid'] = @property_hash[:itemid]
      $zabbix.itemprototype.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
