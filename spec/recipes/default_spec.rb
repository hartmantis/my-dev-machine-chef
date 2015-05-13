# Encoding: UTF-8

require_relative '../spec_helper'

describe 'my-dev-machine::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  %w(
    chef-dk mac-app-store iwork divvy microsoft-remote-desktop tweetbot kindle
    dropbox private-internet-access webhook
  ).each do |r|
    it "includes #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
end
