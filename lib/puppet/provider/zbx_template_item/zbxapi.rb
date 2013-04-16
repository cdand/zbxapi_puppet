require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_template_item).provide(:zbxapi) do

  def self.instances
    items = $zabbix.item.get( 'output' => 'extend', 'templated' => true, 'inherited' => false )
    items.collect do |item|
      new( :name        => item["name"],
           :ensure      => :present,
           :itemid      => item["itemid"],
           :hostid      => item["hostid"],
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

  def flush
    unless @property_flush.empty?
			@property_flush['itemid'] = @property_hash[:itemid]
      $zabbix.item.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
