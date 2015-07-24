# Encoding: UTF-8

require_relative '../../spec_helper'

class Chef
  class Resource
    # A fake mac_os_x_userdefaults resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class MacOsXUserdefaults < Resource::LWRPBase
      self.resource_name = :mac_os_x_userdefaults
      actions [:write]
      default_action :write
      attribute :domain, kind_of: String
      attribute :key, kind_of: String
      attribute :type, kind_of: String
      attribute :value, kind_of: String
    end
  end
end
