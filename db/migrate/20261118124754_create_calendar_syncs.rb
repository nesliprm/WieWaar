class CreateCalendarSyncs < ActiveRecord::Migration[8.1]
  def change
    create_table :calendar_syncs do |t|
      t.references :employee, null: true, foreign_key: true, index: { unique: true }
      t.string :google_calendar_id, null: false
      t.string :sync_token
      t.string :channel_id
      t.string :channel_resource_id
      t.datetime :channel_expires_at
      t.datetime :last_synced_at

      t.timestamps
    end
    add_index :calendar_syncs, :google_calendar_id, unique: true
    add_index :calendar_syncs, :channel_id, unique: true
  end
end
