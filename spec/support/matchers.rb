# Encoding: UTF-8

if defined?(ChefSpec)
  ChefSpec.define_matcher(:mac_os_x_userdefaults)

  def write_mac_os_x_userdefaults(name)
    ChefSpec::Matchers::ResourceMatcher.new(:mac_os_x_userdefaults,
                                            :write,
                                            name)
  end
end
