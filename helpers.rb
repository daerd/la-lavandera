helpers do
  def layout_title
    "#{t('global.name')} - #{current_page.data.title || t('global.slogan')}"
  end
end
