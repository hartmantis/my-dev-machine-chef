# Encoding: UTF-8
#
# rubocop:disable SingleSpaceBeforeFirstArg
name             'my-dev-machine'
maintainer       'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license          'apache2'
description      'Installs/Configures my-dev-machine'
long_description 'Installs/Configures my-dev-machine'
version          '0.0.1'

depends          'mac-app-store', '~> 0.1'
depends          'microsoft-remote-desktop', '~> 0.1'
depends          'tweetbot', '~> 0.1'

supports         'mac_os_x'
# rubocop:enable SingleSpaceBeforeFirstArg
