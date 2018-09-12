config[:layout]        = 'site'
config[:gmaps_api_key] = 'gmaps_api_key'
config[:gmaps_lat]     = '40.4298991'
config[:gmaps_lng]     = '-3.643181'
config[:gmaps_zoom]    = '14'

configure :development do
  activate :livereload

  config[:debug_assets]          = true
  config[:livereload_css_target] = nil
end

configure :build do
  activate :minify_css
  activate :minify_javascript
end

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

activate :deploy do |deploy|
  deploy.deploy_method = :ftp
  deploy.host          = 'ftp.cluster023.hosting.ovh.net'
  deploy.path          = '/www'
  deploy.user          = 'tintorerlk'
  deploy.password      = ENV['PASS']
  deploy.build_before  = true
end

