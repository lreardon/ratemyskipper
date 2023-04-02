class CreateSkippers < ActiveRecord::Migration[7.0]
  def change
    create_table :skippers, id: :uuid do |t|

      t.timestamps
    end
  end
end
