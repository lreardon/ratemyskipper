class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews, id: :uuid do |t|
      t.string :author_id
      t.string :skipper_id

      t.boolean :would_return

      t.boolean :did_not_pay, null: false, default: false
      t.boolean :aggressive, null: false, default: false
      t.boolean :reckless, null: false, default: false

      t.text :comment

      t.timestamps
    end
  end
end
