name 'dev-machine' # rubocop:disable FileName
default_source :supermarket
run_list 'my-dev-machine'
cookbook 'my-dev-machine', path: '.'

default['mac_app_store']['username'] = 'j@p4nt5.com'
