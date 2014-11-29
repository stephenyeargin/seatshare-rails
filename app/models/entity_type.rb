class EntityType < ActiveRecord::Base
  scope :order_by_sort, -> { order('sort ASC') }

  def display_name
    "#{entity_type_name} (#{entity_type_abbreviation})"
  end
end
