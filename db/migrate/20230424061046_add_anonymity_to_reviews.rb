class AddAnonymityToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :anonymity, :string
  end
end
