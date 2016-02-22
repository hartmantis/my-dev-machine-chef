# Encoding: UTF-8
#
# Cookbook Name:: my-dev-machine
# Recipe:: default
#
# Copyright 2015 Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

execute 'killall Dock' do
  action :nothing
end

%w(autohide magnification).each do |i|
  mac_os_x_userdefaults "com.apple.dock #{i}" do
    domain 'com.apple.dock'
    key i
    type 'boolean'
    value 'true'
    user Etc.getlogin
    notifies :run, 'execute[killall Dock]'
  end
end

include_recipe 'chef-dk'

##################
# App Store Apps #
##################
include_recipe 'mac-app-store'
include_recipe 'knock'
include_recipe 'iwork'
include_recipe 'divvy'
include_recipe 'microsoft-remote-desktop'
include_recipe 'tweetbot'
include_recipe 'fantastical'
include_recipe 'kindle'

##############
# Other Apps #
##############
include_recipe 'dropbox'
include_recipe 'box-sync'
include_recipe 'gimp'
include_recipe 'iterm2'
include_recipe 'spotify'
include_recipe 'steam'
include_recipe 'plex-home-theater'
include_recipe 'private-internet-access'
include_recipe 'skype-app'
include_recipe 'vlc'
include_recipe 'vmware-fusion'
include_recipe 'parallels'
include_recipe 'webhook'
include_recipe 'x2go-client'
