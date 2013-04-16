Puppet::Type.newtype(:zbx_template_item) do

  desc 'zbx_template_item is used to manage the items contained within a Zabbix Template'

  ensurable

  newparam(:name, :namevar => true) do
    desc <<-EOT
      Name of the item.
    EOT
  end

  newproperty(:itemid) do
    desc <<-EOT
      (read-only) ID of the item.
    EOT
  end

  newproperty(:hostid) do
    desc <<-EOT
      ID of the host that the item belongs to.
    EOT
  end

end
