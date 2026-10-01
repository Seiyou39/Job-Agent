class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :todo_lists, dependent: :destroy
  has_many :analyses, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :role, inclusion: { in: ["admin", "reviewer"] }
end
