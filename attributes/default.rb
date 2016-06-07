# Encoding: UTF-8
#
# Cookbook Name:: my-dev-machine
# Attributes:: default
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

default['chef_client']['config'].tap do |c|
  c['use_policyfile'] = true
  c['policy_group'] = 'dev'
  c['policy_name'] = 'dev-machine'
end

default['mac_app_store'].tap do |m|
  di = Chef::EncryptedDataBagItem.load('dev', 'mac_app_store')
  m['username'] = di['username']
  m['password'] = di['password']
  m['mas']['system_user'] = di['system_user']
  m['mas']['use_rtun'] = true
end
