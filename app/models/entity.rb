class Entity < ActiveRecord::Base
  has_many :tickets, through: :events
  has_many :groups
  has_many :events

  validates :entity_name, :presence => true
  validates_uniqueness_of :entity_name, scope: :entity_type
  before_save :clean_import_key

  scope :order_by_name, -> { order('LOWER(entity_type) ASC, LOWER(entity_name) ASC') }
  scope :active, -> { where('status = 1') }

  def initialize(attributes={})
    attr_with_defaults = {
      :status => 0,
      :import_key => generate_import_key(attributes)
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def display_name
    "#{entity_name} (#{entity_type})"
  end

  private

  def generate_import_key(attributes)
    "#{attributes[:entity_type]}: #{attributes[:entity_name]}".parameterize
  end

  def clean_import_key
    if self.import_key.blank?
      self.import_key = generate_import_key(self)
    end
  end

end
