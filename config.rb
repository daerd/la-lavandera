require 'lib/helpers'
helpers Helpers

config[:layout] = 'site'

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

activate :i18n,        mount_at_root: :es
activate :asset_hash
activate :minify_html

################
# PAGES CONFIG #
################

# Navigation
config[:navigation] = [
  {
    key:  'home',
    text: 'navigation.home',
    link: '/'
  },
  {
    key:  'services',
    text: 'navigation.services.text',
    link: '#',
    items: [
      {
        key: 'laundry',
        text: 'navigation.services.items.laundry',
        link: '/laundry.html'
      },
      {
        key:  'dry_cleaning',
        text: 'navigation.services.items.dry_cleaning',
        link: '/dry-cleaning.html'
      },
      {
        key: 'leather_and_suede',
        text: 'navigation.services.items.leather_and_suede',
        link: '/leather-and-suede.html'
      },
      {
        key: 'wedding_and_event_clothing',
        text: 'navigation.services.items.wedding_and_event_clothing',
        link: '/wedding-and-event-clothing.html'
      },
      {
        key:  'uniforms',
        text: 'navigation.services.items.uniforms',
        link: '/uniforms.html'
      },
      {
        key:  'linen',
        text: 'navigation.services.items.linen',
        link: '/linen.html'
      }
    ]
  },
  {
    key:  'prices',
    text: 'navigation.prices',
    link: '/prices.html'
  },
  {
    key:  'faq',
    text: 'navigation.faq',
    link: '/faq.html'
  },
  {
    key:  'deals',
    text: 'navigation.deals',
    link: '/deals.html'
  },
  {
    key:  'contact',
    text: 'navigation.contact',
    link: '/contact.html'
  }
]

# Services
config[:navigation].select{ |x| x[:key] == 'services' }.first[:items].map{ |x| x[:key] }.each do |service|
  proxy "/#{service.gsub('_', '-')}.html", '/service.html', locals: { service: service }, ignore: true
end

# Contact
page 'send_email.php', layout: false
config[:contact_email] = 'lalavanderacb@gmail.com'

# Google Maps
config[:gmaps_api_key] = 'gmaps_api_key'
config[:gmaps_lat]     = '40.4298498'
config[:gmaps_lng]     = '-3.6422492'
config[:gmaps_zoom]    = '14'
