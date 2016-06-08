name 'dev-machine' # rubocop:disable FileName
default_source :supermarket
run_list 'my-dev-machine'
cookbook 'my-dev-machine', path: '.'
