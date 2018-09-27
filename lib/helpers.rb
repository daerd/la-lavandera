module Helpers
  def layout_title
    "#{t('global.name')} - #{t(current_page.data.title) || t('global.slogan')}"
  end

  def link_path(link)
    unless '#' == link
      extension = get_path_extension(link)
      link      = t("paths.#{link}")            if     link != '/' && I18n.exists?("paths.#{link}")
      link      = "/#{link}"                    unless link[0] == '/'
      link      = "/#{I18n.locale.to_s}#{link}" unless I18n.locale == config[:default_locale] || link[0..I18n.locale.length+1] == "/#{I18n.locale.to_s}/"
      link      = "#{link}.#{extension}"        if     ![ '/', "/#{I18n.locale}/" ].include?(link) && extension && link[extension.length*-1, extension.length] != extension
    end

    link
  end

  def change_locale_links
    links            = ''
    current_path_key = t('paths').invert[remove_file_extension(current_page.path)]

    config[:available_locales].each do |new_locale|
      unless new_locale == I18n.locale
        locale_link_path = new_locale == config[:default_locale] ? '' : "/#{new_locale}"

        if current_path_key.present?
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

  def nav_element_link(nav_element)
    link = link_path(nav_element[:link] || nav_element[:key])

    link_to t(nav_element[:text]), link, ({ class: 'active' } if nav_element_active?(link, nav_element[:items]))
  end

  def nav_element_active?(link, items)
    remove_file_extension(link) == remove_file_extension(current_page.url) ||
    (
      items.present? &&
      items.select{ |x| remove_file_extension(x[:link]) == remove_file_extension(current_page.url) }.present?
    )
  end

  def remove_file_extension(file_name)
    File.basename(file_name, File.extname(file_name)) if file_name
  end

  def get_path_extension(path)
    config[:php_files].include?(path.to_s) ? 'php' : 'html'
  end
end
