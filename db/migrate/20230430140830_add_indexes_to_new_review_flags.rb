class AddIndexesToNewReviewFlags < ActiveRecord::Migration[7.0]
  def change
    add_index :reviews, :good_teacher
    add_index :reviews, :paid_retros
    add_index :reviews, :paid_fuel
    add_index :reviews, :paid_food
  end
end
