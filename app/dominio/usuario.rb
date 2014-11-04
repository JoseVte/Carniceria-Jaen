require 'active_record'

#Clase principal de usuarios
class Usuario < ActiveRecord::Base
  validates :user, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :pass, presence: true
  validates :nombre, presence: true
  validates :apellidos, presence: true
  validates :direccion, presence: true
  validates :telefono, presence: true

  # Un usuario no puede tener mas de un carrito
  has_one :carrito
end