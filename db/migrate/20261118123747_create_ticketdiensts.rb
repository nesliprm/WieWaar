class CreateTicketdiensts < ActiveRecord::Migration[8.1]
  def change
    create_table :ticketdiensts do |t|
      t.date :date, null: false
      t.references :employee, null: true, foreign_key: true
      t.string :raw_name, null: false
      t.string :google_event_id, null: false

      t.timestamps
    end
    add_index :ticketdiensts, [ :date, :raw_name ], unique: true
  end
end
