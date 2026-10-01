class AddResumeTextToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :resume_text, :text
  end
end
