# Encoding: UTF-8

require_relative '../spec_helper'

describe 'my-dev-machine::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'ensures build-essential is run' do
    expect(chef_run).to include_recipe('build-essential')
  end

  %w(.bundle .chef .ssh .vim).each do |d|
    context "#{d} is a directory" do
      before(:each) do
        allow(File).to receive(:directory?).and_call_original
        allow(File).to receive(:directory?).with(File.expand_path("~/#{d}"))
          .and_return(true)
      end

      it "deletes the #{d} directory" do
        expect(chef_run).to delete_directory(File.expand_path("~/#{d}"))
          .with(recursive: true)
      end
    end

    context "#{d} is not a directory" do
      before(:each) do
        allow(File).to receive(:directory?).and_call_original
        allow(File).to receive(:directory?).with(File.expand_path("~/#{d}"))
          .and_return(false)
      end

      it "does not delete the #{d} directory" do
        expect(chef_run).to_not delete_directory(File.expand_path("~/#{d}"))
      end
    end
  end

  %w(.profile .gitconfig .vimrc .vimrc.local).each do |f|
    context "#{f} does not exist" do
      before(:each) do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with(File.expand_path("~/#{f}"))
          .and_return(false)
      end

      it "does not delete the #{f} file" do
        expect(chef_run).to_not delete_file(File.expand_path("~/#{f}"))
      end
    end

    context "#{f} is not a symlink" do
      before(:each) do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with(File.expand_path("~/#{f}"))
          .and_return(true)
        allow(File).to receive(:ftype).and_call_original
        allow(File).to receive(:ftype).with(File.expand_path("~/#{f}"))
          .and_return('file')
      end

      it "deletes the #{f} file" do
        expect(chef_run).to delete_file(File.expand_path("~/#{f}"))
      end
    end

    context "#{f} is a symlink" do
      before(:each) do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with(File.expand_path("~/#{f}"))
          .and_return(true)
        allow(File).to receive(:ftype).and_call_original
        allow(File).to receive(:ftype).with(File.expand_path("~/#{f}"))
          .and_return('link')
      end

      it "does not delete the #{f} file" do
        expect(chef_run).to_not delete_file(File.expand_path("~/#{f}"))
      end
    end
  end

  %w(
    .bundle .chef .ssh .vim .profile .gitconfig .vimrc .vimrc.local
  ).each do |l|
    it "creates a symlink for #{l}" do
      expect(chef_run).to create_link(File.expand_path("~/#{l}"))
        .with(to: File.expand_path("~/Dropbox/#{l}"))
    end
  end

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
    iwork
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
    x2go-client
  ).each do |r|
    it "includes #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end

  it 'installs Ruby via Homebrew' do
    expect(chef_run).to install_homebrew_package('ruby')
  end

  it 'installs Tig via Homebrew' do
    expect(chef_run).to install_homebrew_package('tig')
  end
end
