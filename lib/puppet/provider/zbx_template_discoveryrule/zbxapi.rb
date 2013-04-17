require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_template_discoveryrule).provide(:zbxapi) do

  def self.instances
    #We pull in a list of all templates here so that we can set the value of
    #@property_flush[:template] to satisfy Puppet's desire to change/set this.
    #This add computational complexity, but saves having thousands of API calls
    #later on.
    templates = $zabbix.template.get( 'output' => 'extend' )
    discoveryrules = $zabbix.discoveryrule.get( 'output' => 'extend', 'templated' => true, 'inherited' => false)
    discoveryrules.collect do |discoveryrule|
      template = templates.detect { |template| template["hostid"] == discoveryrule["hostid"] }["host"]
      new( :name                  => discoveryrule["name"],
           :ensure                => :present,
           :itemid                => discoveryrule["itemid"],
           :delay                 => discoveryrule["delay"],
           :hostid                => discoveryrule["hostid"],
           :template              => template,
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
           :enabled               => discoveryrule["status"],
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
                                  'status'                => resource[:enabled],
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

  def delay=(value)
    @property_flush['delay'] = value
  end

  def key_=(value)
    @property_flush['key_'] = value
  end

  def type=(value)
    @property_flush['type'] = value
  end

  def authtype=(value)
    @property_flush['authtype'] = value
  end

  def delay_flex=(value)
    @property_flush['delay_flex'] = value
  end

  def description=(value)
    @property_flush['description'] = value
  end

  def filter=(value)
    @property_flush['filter'] = value
  end

  def ipmi_sensor=(value)
    @property_flush['ipmi_sensor'] = value
  end

  def lifetime=(value)
    @property_flush['lifetime'] = value
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

  def username=(value)
    @property_flush['username'] = value
  end

  def flush
    unless @property_flush.empty?
      @property_flush['discoveryruleid'] = @property_hash[:itemid]
      $zabbix.discoveryrule.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
