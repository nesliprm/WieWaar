class CreateCalEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :cal_events do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :google_event_id, null: false
      t.datetime :starts_at, null: false, index: true
      t.datetime :ends_at, null: false, index: true
      t.boolean :all_day, null: false, default: false
      t.string :status, null: false
      t.boolean :reachable, null: false, default: true
      t.timestamps
    end
    add_index :cal_events, [ :employee_id, :google_event_id ], unique: true
  end
end
