activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :livereload
end

activate :deploy do |deploy|
  deploy.method       = :ftp
  deploy.host         = 'ftp.cluster023.hosting.ovh.net'
  deploy.path         = '/www'
  deploy.user         = 'tintorerlk'
  deploy.password     = ENV['PASS']
  deploy.build_before = true
end
