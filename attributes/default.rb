# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: my-dev-machine
# Attributes:: default
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

normal['chef_client']['bin'] = '/usr/local/bin/chef-wrapper'
default['chef_client']['config'].tap do |c|
  c['use_policyfile'] = true
  c['policy_group'] = 'dev'
  c['policy_name'] = 'dev-machine'
end

default['mac_app_store'].tap do |m|
  di = Chef::EncryptedDataBagItem.load('dev', 'mac_app_store')
  m['username'] = di['username']
  m['password'] = di['password']
  # m['mas']['use_rtun'] = true
  m['apps']['Tweetbot for Twitter'] = true
  m['apps']['1Password - Password Manager and Secure Wallet'] = true
  m['apps']['LastPass: Password Manager and Secure Vault'] = true
  m['apps']['Slack'] = true
  m['apps']['Spark - Love your email again'] = true
  m['apps']['Divvy - Window Manager'] = true
  m['apps']['Fantastical 2 - Calendar and Reminders'] = true
end
