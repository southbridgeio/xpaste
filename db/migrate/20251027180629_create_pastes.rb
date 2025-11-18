class CreatePastes < ActiveRecord::Migration[8.1]
  def change
    create_table :pastes do |t|
      t.string :permalink,            null: false, index: { unique: true }
      t.text :body,                   null: false
      t.string :language,             null: false
      t.jsonb :request_info
      t.boolean :auto_destroy,        null: false, default: false
      t.datetime :will_be_deleted_at, null: false
      t.timestamps
    end
  end
end
