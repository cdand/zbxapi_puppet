require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_trigger_action).provide(:zbxapi) do

  def self.instances
    actions = $zabbix.action.get( 'output' => 'extend', 'selectOperations' => 'extend', 'filter' => { 'eventsource' => 0 } )
    actions.collect do |action|
      operations = []
      action['operations'].each do |operation|
				operations << operation[1]
      end
      new( :name             => action["name"],
           :ensure           => :present,
           :actionid         => action["actionid"],
           :enabled          => action["status"],
           :eventsource      => action["eventsource"],
           :evaluation_type  => action["evaltype"],
           :step_duration    => action["esc_period"],
           :default_subject  => action["def_shortdata"],
           :default_message  => action["def_longdata"],
           :recovery_subject => action["r_shortdata"],
           :recovery_message => action["r_longdata"],
           :recovery_enabled => action["recovery_msg"],
           :operations       => operations,
      )
    end
  end

  def self.prefetch(resources)
    actions = instances
    resources.keys.each do |name|
      if provider = actions.find{ |action| action.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.action.create( 'name'          => resource[:name],
                           'status'        => resource[:enabled],
                           'eventsource'   => 0,
                           'evaltype'      => resource[:evaluation_type],
                           'esc_period'    => resource[:step_duration],
                           'def_shortdata' => resource[:default_subject],
                           'def_longdata'  => resource[:default_message],
                           'r_shortdata'   => resource[:recovery_subject],
                           'r_longdata'    => resource[:recovery_message],
                           'recovery_msg'  => resource[:recovery_enabled],
                           'operations'    => resource[:operations],
                         )
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.action.delete([@property_hash[:actionid]])
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the
  # getters for all properties. I'm not sure yet how this can possibly work
	# for setters though.
  mk_resource_methods 

  def operations
    @property_hash[:operations].first.delete("operationid")
    @property_hash[:operations].first.delete("actionid")
    @property_hash[:operations].first.delete("opconditions")
    @property_hash[:operations].first["opmessage_grp"].first.delete("operationid")
    @property_hash[:operations].first.delete("opmessage_usr")
    @property_hash[:operations].first["opmessage"].delete("operationid")
#    puts @property_hash[:operations].first
    @property_hash[:operations]
  end

  # Despite Puppet Labs docs, it would appear mk_resource methods is only
  # useful for getters. We need to create all the different setters.
  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def enabled=(value)
    @property_flush['status'] = value
  end

  def evaluation_type=(value)
    @property_flush['evaltype'] = value
  end

  def step_duration=(value)
    @property_flush['esc_period'] = value
  end

  def default_subject=(value)
    @property_flush['def_shortdata'] = value
  end

  def default_message=(value)
    @property_flush['def_longdata'] = value
  end

  def recovery_subject=(value)
    @property_flush['r_shortdata'] = value
  end

  def recovery_message=(value)
    @property_flush['r_longdata'] = value
  end

  def recovery_enabled=(value)
    @property_flush['recovery_msg'] = value
  end

  def operations=(value)
		puts value
    @property_flush['operations'] = value
#    @property_flush['operations']['actionid'] = @property_hash[:actionid]
  end

  def flush
    unless @property_flush.empty?
      @property_flush['actionid'] = @property_hash[:actionid]
      $zabbix.action.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
