class AddGoodFlagsToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :good_teacher, :boolean
    add_column :reviews, :paid_fuel, :boolean
    add_column :reviews, :paid_retros, :boolean
    add_column :reviews, :paid_food, :boolean
  end
end
