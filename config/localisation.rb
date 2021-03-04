module Localisation
  I18n.available_locales = [:en, :ru]
  I18n.default_locale = :ru
  I18n.load_path += Dir[File.join('config', 'locales', '**', '*.yml').to_s]
end