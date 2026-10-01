class Todo < ApplicationRecord
  belongs_to :todo_list
  
  scope :recent, -> { order(created_at: :desc) }
  
  before_create :set_default_done
  
  private
  
  def set_default_done
    self.done = false if self.done.nil?
  end
end
