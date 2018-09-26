module Helpers
  def layout_title
    "#{t('global.name')} - #{t(current_page.data.title) || t('global.slogan')}"
  end

  def link_path(link, extension = 'html')
    unless '#' == link
      link = t("paths.#{link}")            if     link != '/' && I18n.exists?("paths.#{link}")
      link = "/#{link}"                    unless link[0] == '/'
      link = "/#{I18n.locale.to_s}#{link}" unless I18n.locale == config[:default_locale] || link[0..I18n.locale.length+1] == "/#{I18n.locale.to_s}/"
      link = "#{link}.#{extension}"        if     ![ '/', "/#{I18n.locale}/" ].include?(link) && extension && link[extension.length*-1, extension.length] != extension
    end

    link
  end

  def nav_element_link(nav_element)
    link = if nav_element[:link].present?
      link_path(nav_element[:link])
    else
      link_path(nav_element[:key], nav_element[:link_extension] || 'html')
    end

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
end
