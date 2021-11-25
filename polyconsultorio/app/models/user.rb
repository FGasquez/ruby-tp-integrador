class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :email, uniqueness: true
end
