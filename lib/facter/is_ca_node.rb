Facter.add(:is_ca_node) do
  setcode do
    File.directory?("#{Puppet.settings[:ssldir]}/ca")
  end
end
