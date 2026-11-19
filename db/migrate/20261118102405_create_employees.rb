class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :surname
      t.string :email, null: false
      t.string :mobile
      t.text :avatar_svg
      t.boolean :active, null: false, default: true
      t.timestamps
    end
    add_index :employees, :email, unique: true
  end
end
