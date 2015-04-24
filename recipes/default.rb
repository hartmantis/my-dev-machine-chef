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

include_recipe 'chef-dk'

##################
# App Store Apps #
##################
include_recipe 'mac-app-store'
include_recipe 'microsoft-remote-desktop'
include_recipe 'tweetbot'

##############
# Other Apps #
##############
include_recipe 'dropbox'
include_recipe 'private-internet-access'
include_recipe 'webhook'
