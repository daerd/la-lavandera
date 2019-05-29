module Helpers
  def page_title
    "#{t('global.name')} - #{current_page.data.title.present? ? t(current_page.data.title) : t('global.slogan')}"
  end

  def page_description
    page_desc = current_path_key.present? ? (t("page_descriptions.keywords.pages.#{current_path_key}", default: '') + ', ') : ''
    web_desc  = "#{t('page_descriptions.keywords.global')} - #{page_title}"

    # Page and global description+keywords, converted to have only alphanumeric chars for SEO optimization.
    I18n.transliterate("#{page_desc}#{web_desc}")
  end

  def link_path(link)
    unless link == '#'
      link      = '/'                           if     link.to_s == 'home'
      extension = get_path_extension(link)
      link      = t("paths.#{link}")            if     link != '/' && I18n.exists?("paths.#{link}")
      link      = "/#{link}"                    unless link[0] == '/'
      link      = "/#{I18n.locale.to_s}#{link}" unless I18n.locale == config[:default_locale] || link[0..I18n.locale.length+1] == "/#{I18n.locale.to_s}/"
      link      = "#{link}.#{extension}"        if     ![ '/', "/#{I18n.locale}/" ].include?(link) && extension && link[extension.length*-1, extension.length] != extension
    end

    link
  end

  def change_locale_link
    links = ''

    config[:available_locales].each do |new_locale|
      unless new_locale == I18n.locale
        locale_link_path = new_locale == config[:default_locale] ? '' : "/#{new_locale}"

        if current_path_key.present? && I18n.t("paths", locale: new_locale).include?(current_path_key)
          locale_link_path += "/#{t("paths.#{current_path_key}", locale: new_locale)}"
          locale_link_path += ".#{get_path_extension(current_path_key)}"
        elsif new_locale == config[:default_locale]
          locale_link_path = '/'
        end

        links += "<a href=\"#{locale_link_path}\" class=\"change-locale\">#{t('global.change_locale', locale: new_locale)}</a>"
      end
    end

    links
  end

  def current_path_key
    t('paths').invert[remove_file_extension(current_page.path)]
  end

  def nav_link(page, data)
    link = link_path(page)

    link_to data[:text], link, ({ class: 'active' } if nav_link_active?(link, data[:items]))
  end

  def nav_link_active?(link, items)
    remove_file_extension(link) == remove_file_extension(current_page.url) ||
    (I18n.locale.to_s == remove_file_extension(current_page.url) && remove_file_extension(link) == 'home') ||
    (
      items.present? &&
      items.select{ |page,text| remove_file_extension(link_path(page)).to_s == remove_file_extension(current_page.url) }.present?
    )
  end

  def remove_file_extension(file_name)
    File.basename(file_name, File.extname(file_name)) if file_name
  end

  def get_path_extension(path)
    config[:php_files].include?(path.to_s) ? 'php' : 'html'
  end

  def google_analytics
    "<script async src=\"https://www.googletagmanager.com/gtag/js?id=#{config[:ga_id]}\"></script>

    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag() { dataLayer.push(arguments); }
      gtag('js', new Date());
      gtag('config', '#{config[:ga_id]}');
    </script>"
  end
end
