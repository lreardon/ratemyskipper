class AddIndexesToReviews < ActiveRecord::Migration[7.0]
  def change
    add_index :reviews, :author_id
    add_index :reviews, :skipper_id
    add_index :reviews, :would_return
    add_index :reviews, :reckless
    add_index :reviews, :did_not_pay
    add_index :reviews, :aggressive
    # Ex:- add_index("admin_users", "username")
  end
end
