class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.integer :reports_count, default: 0
      t.string :status, default: 'active'
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
