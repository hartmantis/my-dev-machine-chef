# encoding: utf-8
# frozen_string_literal: true

if defined?(ChefSpec)
  ChefSpec.define_matcher(:mac_os_x_userdefaults)
  ChefSpec.define_matcher(:homebrew_package)

  def write_mac_os_x_userdefaults(name)
    ChefSpec::Matchers::ResourceMatcher.new(:mac_os_x_userdefaults,
                                            :write,
                                            name)
  end

  def install_homebrew_package(name)
    ChefSpec::Matchers::ResourceMatcher.new(:homebrew_package, :install, name)
  end
end
