class CreateStories < ActiveRecord::Migration[6.1]
  def change
    create_table :stories do |t|
      t.integer :user_id
      t.string :character
      t.string :setting
      t.string :moral_lesson
      t.string :title
      t.text :content
      t.string :status

      t.timestamps
    end
  end
end
