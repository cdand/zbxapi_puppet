require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_template_item).provide(:zbxapi) do

  def self.instances
    # We pull in a list of all templates here so that we can set the value of
    #@property_flush[:template] to satisfy Puppet's desire to change/set this.
    #This add computational complexity, but saves having thousands of API calls
    #later on.
    templates = $zabbix.template.get( 'output' => 'extend' )
    items = $zabbix.item.get( 'output' => 'extend', 'templated' => true, 'inherited' => false )
    items.collect do |item|
      template = templates.detect { |template| template["hostid"] == item["hostid"] }["host"]
      new( :name        => item["name"],
           :ensure      => :present,
           :itemid      => item["itemid"],
           :hostid      => item["hostid"],
           :template    => template,
           :delay       => item["delay"],
           :key_        => item["key_"],
           :interfaceid => item["interfaceid"],
           :value_type  => item["value_type"],
           :type        => item["type"],
      )
    end
  end

  def self.prefetch(resources)
    items = instances
    resources.keys.each do |name|
      if provider = items.find{ |item| item.name == name }
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
    $zabbix.item.create( 'name'        => resource[:name],
                         'hostid'      => resource[:hostid],
                         'delay'       => resource[:delay],
                         'key_'        => resource[:key_],
                         'interfaceid' => resource[:interfaceid],
                         'value_type'  => resource[:value_type],
                         'type'        => resource[:type] )
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.item.delete([@property_hash[:itemid]])
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

  def flush
    unless @property_flush.empty?
			@property_flush['itemid'] = @property_hash[:itemid]
      $zabbix.item.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
