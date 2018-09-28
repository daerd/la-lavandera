require 'lib/helpers'
helpers Helpers

### COMMON ###

config[:layout]            = 'layouts/site'
config[:default_locale]    = :es
config[:available_locales] = [ config[:default_locale], :en ]

activate :i18n, mount_at_root: config[:default_locale], langs: config[:available_locales]
I18n.load_path = Dir[Middleman::Application.root_path.join('locales', '**', '*.{yml}')]

### DEVELOPMENT ###

configure :development do
  activate :livereload

  config[:debug_assets]          = true
  config[:livereload_css_target] = nil
  config[:php_files]             = []
end

### BUILD & DEPLOY ###

configure :build do
  activate :minify_css
  activate :minify_javascript

  config[:php_files] = %w(index deals)
end

after_build do |builder|
  # We change the some files extension to make possible its interpretation as PHP code by the final server.
  config[:php_files].each do |page|
    [ nil ] + config[:available_locales].each do |locale|
      page_name   = page == 'index' ? page : I18n.t("paths.#{page}", locale: locale || config[:default_locale])
      locale_path = (locale.present? && locale != config[:default_locale]) ? "#{locale.to_s}/" : ''

      builder.thor.run "mv #{__dir__}/build/#{locale_path}#{page_name}.html #{__dir__}/build/#{locale_path}#{page_name}.php"
    end
  end
end

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

activate :deploy do |deploy|
  deploy.deploy_method = :ftp
  deploy.host          = ENV['SERVER_HOST']
  deploy.path          = ENV['SERVER_PATH']
  deploy.user          = ENV['SERVER_USER']
  deploy.password      = ENV['SERVER_PASS']
  deploy.build_before  = true
end

activate :imageoptim do |options|
  options.manifest             = true # Use a build manifest to prevent re-compressing images between builds.
  options.skip_missing_workers = true # Silence problematic "image_optim" workers.
  options.verbose              = false # Causes "image_optim" to be in shouty-mode.
  options.nice                 = true # Setting "nice" and "threads" to true or nil will let options determine them.
  options.threads              = true
  options.image_extensions     = %w(.png .jpg .gif .svg) # Image extensions to attempt to compress.
  options.advpng               = { level: 4 }
  options.gifsicle             = { interlace: false }
  options.jpegoptim            = { strip: [ 'all' ], max_quality: 100 }
  options.jpegtran             = { copy_chunks: false, progressive: true, jpegrescan: true }
  options.optipng              = { level: 6, interlace: false }
  options.pngcrush             = { chunks: [ 'all' ], fix: false, brute: false }
  options.pngout               = { copy_chunks: false, strategy: 0 }
  options.svgo                 = {}
end

activate :asset_hash
activate :minify_html

### PAGES ###

# Services
I18n.t('navigation.services.items').keys.each do |service|
  [ nil ] + config[:available_locales].each do |locale|
    page_name   = I18n.t("paths.#{service}", locale: locale || config[:default_locale])
    locale_path = (locale.present? && locale != config[:default_locale]) ? "#{locale.to_s}/" : ''

    proxy "/#{locale_path}#{page_name}.html", 'localizable/service.html', locals: { service: service }, ignore: true
  end
end

# Contact
page 'send_email.php', layout: false
config[:contact_email] = 'lalavanderacb@gmail.com'
config[:errors_email]  = 'lalavanderacb@gmail.com'

# Google
config[:google_api_key]      = ENV['GOOGLE_API_KEY']
config[:gmaps_lat]           = '40.4298498'
config[:gmaps_lng]           = '-3.6422492'
config[:gmaps_zoom]          = '14'
config[:gplaces_place_id]    = 'ChIJJZgiAUIvQg0RNuOj8RudPRs'
config[:gplaces_min_rating]  = 4
config[:gplaces_max_reviews] = 25

# Facebook
config[:facebook_token]      = ENV['FACEBOOK_TOKEN']
config[:facebook_page_id]    = 1845404685734378
config[:facebook_max_posts]  = 15
