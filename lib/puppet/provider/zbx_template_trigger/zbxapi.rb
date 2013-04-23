require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_template_trigger).provide(:zbxapi) do

  def self.instances
    triggers = $zabbix.trigger.get( 'output' => 'extend', 'templated' => true, 'inherited' => false, 'selectHosts' => 'expand', 'expandExpression' => true, 'expandData' => true )
    triggers.collect do |trigger|
      new( :name            => trigger["description"],
           :ensure          => :present,
           :triggerid       => trigger["triggerid"],
           :hostid          => trigger["hostid"],
           :template        => trigger["host"],
           :expression      => trigger["expression"],
           :comments        => trigger["comments"],
           :priority        => trigger["priority"],
           :enabled         => trigger["status"],
           :multiple_events => trigger["type"],
           :url             => trigger["url"],
      )
    end
  end

  def self.prefetch(resources)
    triggers = instances
    resources.keys.each do |name|
      if provider = triggers.find{ |trigger| trigger.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.trigger.create( 'description' => resource[:name],
                            'expression'  => resource[:expression],
                            'comments'    => resource[:comments],
                            'priority'    => resource[:priority],
                            'status'      => resource[:enabled],
                            'type'        => resource[:multiple_events],
                            'url'         => resource[:url])
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.trigger.delete([@property_hash[:triggerid]])
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
      $zabbix.trigger.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
