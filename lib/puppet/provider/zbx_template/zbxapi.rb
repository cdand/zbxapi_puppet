require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_template).provide(:zbxapi) do

  def self.instances
    templates = $zabbix.template.get( 'output' => 'extend' )
    templates.collect do |template|
      new( :name        => template["host"],
           :ensure      => :present,
           :visiblename => template["name"],
      )
    end
  end

  def self.prefetch(resources)
    templates = instances
    resources.keys.each do |name|
      if provider = templates.find{ |template| template.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.template.create( 'name' => resource[:name] )
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.template.delete([@property_hash[:templateid]])
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

  def templateid=(value)
    @property_flush['templateid'] = value
  end

  def flush
    unless @property_flush.empty?
			@property_flush['templateid'] = @property_hash[:templateid]
      $zabbix.template.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
