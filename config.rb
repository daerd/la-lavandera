require 'lib/helpers'
helpers Helpers

### COMMON ###

config[:layout]            = 'layouts/site'
config[:default_locale]    = :es
config[:available_locales] = [ config[:default_locale], :en ]

# I18n
activate :i18n, mount_at_root: config[:default_locale], langs: config[:available_locales]
I18n.load_path = Dir[Middleman::Application.root_path.join('locales', '**', '*.{yml}')]

# Webpack.
activate :external_pipeline,
           name:    :webpack,
           command: build? ? 'npm run build' : 'npm run start',
           source:  '.tmp/webpack_output',
           latency: 1

config[:js_dir]     = 'assets/javascripts'
config[:css_dir]    = 'assets/stylesheets'
config[:fonts_dir]  = 'assets/fonts'
config[:images_dir] = 'assets/images'

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
  activate :asset_hash
  activate :minify_html

  config[:php_files] = %w(index deals)
end

after_build do |builder|
  # We change the some files extension to make possible its interpretation as PHP code by the final server.
  config[:php_files].each do |page|
    [ nil ] + config[:available_locales].each do |locale|
      page_name = if page == 'index'
        page
      else
        locale_paths = I18n.t('paths', locale: locale || config[:default_locale])
        locale_paths.include?(page.to_sym) ? locale_paths[page.to_sym] : nil
      end

      if page_name
        locale_path = (locale.present? && locale != config[:default_locale]) ? "#{locale.to_s}/" : ''

        builder.thor.run "mv #{__dir__}/build/#{locale_path}#{page_name}.html #{__dir__}/build/#{locale_path}#{page_name}.php"
      end
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

### PAGES ###

# Services
I18n.t('navigation.services.items').keys.each do |service|
  [ nil ] + config[:available_locales].each do |locale|
    page_name   = I18n.t("paths.#{service}", locale: locale || config[:default_locale])
    locale_path = (locale.present? && locale != config[:default_locale]) ? "#{locale.to_s}/" : ''

    proxy "/#{locale_path}#{page_name}.html", 'localizable/service.html', locals: { service: service }, ignore: true, lang: locale
  end
end

# Contact
page 'send_email.php', layout: false
config[:contact_email] = 'info@tintorerialalavandera.com'
config[:errors_email]  = 'info@tintorerialalavandera.com'

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
