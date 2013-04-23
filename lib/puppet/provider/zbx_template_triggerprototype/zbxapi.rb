require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_template_triggerprototype).provide(:zbxapi) do

  def self.instances
    triggerprototypes = $zabbix.triggerprototype.get( 'output' => 'extend', 'templated' => true, 'inherited' => false, 'selectHosts' => 'expand', 'expandExpression' => true, 'expandData' => true, 'selectDiscoveryRule' => 'refer' )
    triggerprototypes.collect do |triggerprototype|
      new( :name            => triggerprototype["description"],
           :ensure          => :present,
           :triggerid       => triggerprototype["triggerid"],
           :hostid          => triggerprototype["hostid"],
           :ruleid          => triggerprototype["discoveryRule"],
           :expression      => triggerprototype["expression"],
           :comments        => triggerprototype["comments"],
           :priority        => triggerprototype["priority"],
           :enabled         => triggerprototype["status"],
           :multiple_events => triggerprototype["type"],
           :url             => triggerprototype["url"],
      )
    end
  end

  def self.prefetch(resources)
    triggerprototypes = instances
    resources.keys.each do |name|
      if provider = triggerprototypes.find{ |triggerprototype| triggerprototype.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.triggerprototype.create( 'description' => resource[:name],
                            'expression'  => resource[:expression],
                            'comments'    => resource[:comments],
                            'priority'    => resource[:priority],
                            'status'      => resource[:enabled],
                            'type'        => resource[:multiple_events],
                            'url'         => resource[:url])
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.triggerprototype.delete([@property_hash[:triggerid]])
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

  def expression=(value)
    @property_flush['expression'] = value
  end

  def comments=(value)
    @property_flush['comments'] = value
  end

  def priority=(value)
    @property_flush['priority'] = value
  end

  def enabled=(value)
    @property_flush['status'] = value
  end

  def url=(value)
    @property_flush['url'] = value
  end

  def multiple_events=(value)
    @property_flush['type'] = value
  end

  def flush
    unless @property_flush.empty?
			@property_flush['triggerid'] = @property_hash[:triggerid]
      $zabbix.triggerprototype.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
