class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

  enum role: {
    admin: 'admin',
    consultante: 'consultante',
    asistente: 'asistente'
  }

end
