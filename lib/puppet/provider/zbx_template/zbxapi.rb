require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_template).provide(:zbxapi) do

  def self.instances
    templates = $zabbix.template.get( 'output' => 'extend', 'selectGroups' => 'extend', 'selectParentTemplates' => 'extend' )
    templates.collect do |template|
      hostgroups = []
      template['groups'].each do |group|
        hostgroups << group['name']
      end
      parents = []
      template['parentTemplates'].each do |parent|
        parents << parent['name']
      end
      new( :name        => template["host"],
           :ensure      => :present,
           :templateid  => template["templateid"],
           :visiblename => template["name"],
           :hostgroups  => hostgroups,
           :parents     => parents,
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
		hostgroupids = $zabbix.hostgroup.get( 'output' => 'shorten', 'filter' => {'name' => resource[:hostgroups]})
		templateids = []
		unless resource[:parents].empty?
  		templateids  = $zabbix.template.get( 'output' => 'shorten', 'filter' => { 'host' => resource[:parents] })
		end
    $zabbix.template.create( 'host'      => resource[:name],
                             'name'      => resource[:visiblename],
                             'groups'    => hostgroupids,
                             'templates' => templateids,
                             'hosts'     => [] )
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

  def visiblename=(value)
    #FIXME If a visiblename is set and then removed Puppet doesn't remove the visible name from Zabbix configuration.
    @property_flush['name'] = value
  end

  def hostgroups=(value)
    #FIXME There is some issue with the ordering of hostgroupids array, if not in hostgroup id numerical order Puppet keeps trying to make a change.
    # Can't quite figure out where this is happening.
    hostgroupids = $zabbix.hostgroup.get( 'output' => 'shorten', 'filter' => {'name' => value})
    @property_flush['groups'] = hostgroupids
  end

  def parents=(value)
    #FIXME There is some issue with the ordering of templateids array, if not in template id numerical order Puppet keeps trying to make a change.
    # Can't quite figure out where this is happening.
    templateids = []
    unless value.empty?
      templateids  = $zabbix.template.get( 'output' => 'shorten', 'filter' => { 'host' => value })
    end
    @property_flush['templates'] = templateids
  end

  def flush
    unless @property_flush.empty?
			@property_flush['templateid'] = @property_hash[:templateid]
      $zabbix.template.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
