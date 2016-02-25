# Encoding: UTF-8

require_relative '../spec_helper'

describe 'my-dev-machine::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'creates an execute resource for restarting the Dock' do
    expect(chef_run.execute('killall Dock')).to do_nothing
  end

  it 'creates an execute resource for restarting the SystemUIServer' do
    expect(chef_run.execute('killall SystemUIServer')).to do_nothing
  end

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

  it 'includes the screensaver recipe' do
    expect(chef_run).to include_recipe('mac_os_x::screensaver')
  end

  it 'enables the bottom-left hot corner' do
    d = 'com.apple.dock bl-hot-corner'
    expect(chef_run).to write_mac_os_x_userdefaults(d)
      .with(domain: 'com.apple.dock',
            key: 'wvous-bl-corner',
            type: 'int',
            value: 5)
    expect(chef_run.mac_os_x_userdefaults(d))
      .to notify('execute[killall Dock]').to(:run)
    d = 'com.apple.dock bl-modifier'
    expect(chef_run).to write_mac_os_x_userdefaults(d)
      .with(domain: 'com.apple.dock',
            key: 'wvous-bl-modifier',
            type: 'int',
            value: 0)
    expect(chef_run.mac_os_x_userdefaults(d))
      .to notify('execute[killall Dock]').to(:run)
  end

  it 'enables battery percentage display' do
    exp = 'com.apple.menuextra.battery ShowPercent'
    expect(chef_run).to write_mac_os_x_userdefaults(exp)
      .with(domain: 'com.apple.menuextra.battery',
            key: 'ShowPercent',
            type: 'string',
            value: 'YES')
    expect(chef_run.mac_os_x_userdefaults(exp))
      .to notify('execute[killall SystemUIServer]').to(:run)
  end

  %w(
    chef-dk
    chef-client
    chef-client::config
    chef-client::delete_validation
    homebrew
    mac-app-store
    knock
    iwork
    divvy
    microsoft-remote-desktop
    tweetbot
    fantastical
    kindle
    dropbox
    box-sync
    gimp
    iterm2
    private-internet-access
    spotify
    steam
    plex-home-theater
    skype-app
    vlc
    vmware-fusion
    parallels
    webhook
    x2go-client
  ).each do |r|
    it "includes #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end

  it 'installs Ruby via Homebrew' do
    expect(chef_run).to install_homebrew_package('ruby')
  end
end
