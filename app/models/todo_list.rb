class TodoList < ApplicationRecord
  belongs_to :user
  has_many :todos, dependent: :destroy
  has_one :analysis, dependent: :destroy
  enum :source, { manual: 0, llm_generated: 1 }
end
