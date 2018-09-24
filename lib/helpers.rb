module Helpers
  def layout_title
    "#{t('global.name')} - #{t(current_page.data.title) || t('global.slogan')}"
  end

  def nav_element_active?(nav_element)
    remove_file_extension(nav_element[:link]) == remove_file_extension(current_page.url) ||
    (
      nav_element[:items].present? &&
      nav_element[:items].select{ |x| remove_file_extension(x[:link]) == remove_file_extension(current_page.url) }.present?
    )
  end

  def nav_subelement_active?(nav_sub_element)
    remove_file_extension(nav_sub_element[:link]) == remove_file_extension(current_page.url)
  end

  def remove_file_extension(file_name)
    File.basename(file_name, File.extname(file_name))
  end
end
