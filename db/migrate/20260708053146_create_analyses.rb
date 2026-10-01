class CreateAnalyses < ActiveRecord::Migration[8.1]
  def change
    create_table :analyses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :todo_list, null: false, foreign_key: true
      t.string :company_name
      t.string :job_title
      t.text :jd_text
      t.integer :match_score
      t.text :advice

      t.timestamps
    end
  end
end
