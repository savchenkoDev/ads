class Ad < Sequel::Model
  def validate
    super
    validates_presence :city, message: I18n.t(:blank, scope: 'model.errors.ad.city')
    validates_presence :title, message: I18n.t(:blank, scope: 'model.errors.ad.title')
    validates_presence :description, message: I18n.t(:blank, scope: 'model.errors.ad.description')
  end
end
