module Helpers
  def layout_title
    "#{t('global.name')} - #{t(current_page.data.title) || t('global.slogan')}"
  end

  def nav_element_active?(nav_element)
    nav_element[:link] == current_page.url ||
    (
      nav_element[:items].present? &&
      nav_element[:items].select{ |x| x[:link] == current_page.url }.present?
    )
  end

  def nav_subelement_active?(nav_sub_element)
    nav_sub_element[:link] == current_page.url
  end
end
