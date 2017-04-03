# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: my-dev-machine
# Recipe:: default
#
# Copyright 2015-2017, Jonathan Hartman
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

# Wrap Chef inside a double-sudo so that our references to `~` and
# `Etc.getlogin` will still work even when the LaunchDaemon is running Chef
# as root.
file "/etc/sudoers.d/#{File.basename(node['chef_client']['bin'])}" do
  content <<-EOH.gsub(/^ +/, '')
    # This file is managed by Chef. Any changes will be overwritten.

    #{Etc.getlogin} ALL=NOPASSWD: /opt/chefdk/embedded/bin/chef-client
  EOH
end

file node['chef_client']['bin'] do
  mode '0755'
  content <<-EOH.gsub(/^ +/, '')
    #!/bin/bash
    #
    # This file is managed by Chef. Any changes will be overwritten.

    set -e
    sudo -u #{Etc.getlogin} -i sudo /opt/chefdk/embedded/bin/chef-client
  EOH
end
include_recipe 'chef-client'
t = resources(template: '/Library/LaunchDaemons/com.chef.chef-client.plist')
t.variables(launchd_mode: node['chef_client']['launchd_mode'],
            client_bin: node['chef_client']['bin'])
include_recipe 'chef-client::config'
include_recipe 'chef-client::delete_validation'

include_recipe 'build-essential'

git File.expand_path('~/.oh-my-zsh') do
  repository 'https://github.com/robbyrussell/oh-my-zsh'
end
file File.expand_path('~/.zshrc') do
  content lazy {
    File.read(File.expand_path('~/.oh-my-zsh/templates/zshrc.zsh-template'))
  }
end
user Etc.getlogin do
  shell '/bin/zsh'
end

# %w(.bundle .chef .ssh .vim).each do |d|
%w(.chef).each do |d|
  directory File.expand_path("~/#{d}") do
    action :delete
    recursive true
    only_if { File.directory?(File.expand_path("~/#{d}")) }
  end
end

# %w(.profile .gitconfig .vimrc .vimrc.local).each do |f|
%w(.gitconfig).each do |f|
  file File.expand_path("~/#{f}") do
    action :delete
    only_if do
      path = File.expand_path("~/#{f}")
      File.exist?(path) && File.ftype(path) != 'link'
    end
  end
end

directory File.expand_path('~/.ssh') do
  recursive true
  action :delete
  only_if { File.ftype(File.expand_path('~/.ssh')) != 'link' }
end

# /var/root/.ssh?

#  .bundle
#  .vim
#  .profile
#  .vimrc
#  .vimrc.local
%w(
  .chef
  .stove
  .ssh
  .gitconfig
  .aws
  .provisionatorcli.toml
).each do |l|
  link File.expand_path("~/#{l}") do
    to File.expand_path("~/Dropbox/Home/#{l}")
  end
end

execute 'killall Dock' do
  action :nothing
end

execute 'killall SystemUIServer' do
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

include_recipe 'mac_os_x::screensaver'

mac_os_x_userdefaults 'com.apple.dock bl-hot-corner' do
  domain 'com.apple.dock'
  key 'wvous-bl-corner'
  type 'int'
  value 5
  user Etc.getlogin
  notifies :run, 'execute[killall Dock]'
end

mac_os_x_userdefaults 'com.apple.dock bl-modifier' do
  domain 'com.apple.dock'
  key 'wvous-bl-modifier'
  type 'int'
  value 0
  user Etc.getlogin
  notifies :run, 'execute[killall Dock]'
end

mac_os_x_userdefaults 'com.apple.menuextra.battery ShowPercent' do
  domain 'com.apple.menuextra.battery'
  key 'ShowPercent'
  type 'string'
  value 'YES'
  user Etc.getlogin
  # TODO: Why is this notification happening on every run?
  notifies :run, 'execute[killall SystemUIServer]'
end

# include_recipe 'chef-dk'
include_recipe 'homebrew'

#################
# Homebrew Apps #
#################
homebrew_package 'postgresql'
homebrew_package 'python3'
homebrew_package 'ruby'
gem_package 'bundler' do
  gem_binary '/usr/local/bin/gem'
end

homebrew_package 'tig'
homebrew_package 'packer'

##################
# App Store Apps #
##################
include_recipe 'mac-app-store'
# include_recipe 'iwork'
# include_recipe 'microsoft-remote-desktop'
# include_recipe 'tweetbot'
# include_recipe 'fantastical'
# include_recipe 'kindle'

##############
# Other Apps #
##############

# The install script for Vagrant tries to run `sudo -E ... installer ...`
file '/etc/sudoers.d/installer' do
  content <<-EOH.gsub(/^ +/, '')
    # This file is managed by Chef. Any changes will be overwritten.

    #{Etc.getlogin} ALL=NOPASSWD:SETENV: /usr/sbin/installer
  EOH
end

%w(
  iterm2
  dropbox
  tunnelblick
  spotify
  vagrant
  docker
  virtualbox
  google-chrome
).each do |c|
  homebrew_cask c
end

execute 'Start Docker' do
  command 'open /Applications/Docker.app'
  action :nothing
  subscribes :run, 'homebrew_cask[docker]', :immediately
end

dir = File.expand_path('~/Library/Application Support/Tunnelblick')
directory dir do
  owner Etc.getlogin
  group 'staff'
  recursive true
end
directory File.join(dir, 'Configurations') do
  recursive true
  action :delete
  only_if { File.exist?(dir) && File.ftype(dir) != 'link' }
end
link File.join(dir, 'Configurations') do
  to File.expand_path(
    "~/Dropbox/Home/Application-Support-Tunnelblick-Configurations"
  )
end

# include_recipe 'dropbox'
# include_recipe 'box-sync'
# include_recipe 'gimp'
# include_recipe 'iterm2'
# include_recipe 'spotify'
# include_recipe 'steam'
# include_recipe 'plex-home-theater'
# include_recipe 'private-internet-access'
# include_recipe 'skype-app'
# include_recipe 'vlc'
# include_recipe 'vmware-fusion'
# include_recipe 'parallels'
# include_recipe 'x2go-client'
