# Encoding: UTF-8

require_relative '../spec_helper'

describe 'my-dev-machine::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'enables auto-hide for the Dock' do
    expect(chef_run).to write_mac_os_x_userdefaults('com.apple.dock autohide')
      .with(domain: 'com.apple.dock',
            key: 'autohide',
            type: 'boolean',
            value: 'true')
    expect(chef_run.mac_os_x_userdefaults('com.apple.dock autohide'))
      .to notify('execute[killall Dock]').to(:run)
  end

  it 'enables magnification for the Dock' do
    n = 'com.apple.dock magnification'
    expect(chef_run).to write_mac_os_x_userdefaults(n)
      .with(domain: 'com.apple.dock',
            key: 'magnification',
            type: 'boolean',
            value: 'true')
    expect(chef_run.mac_os_x_userdefaults('com.apple.dock magnification'))
      .to notify('execute[killall Dock]').to(:run)
  end

  %w(
    chef-dk mac-app-store iwork divvy microsoft-remote-desktop tweetbot
    fantastical kindle dropbox box-sync gimp private-internet-access spotify
    steam plex-home-theater skype-app vlc vmware-fusion webhook
  ).each do |r|
    it "includes #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
end
