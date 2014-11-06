require 'active_record'

# Clase donde añadimos todas las restricciones de la BD
class Usuario < ActiveRecord::Base
   # Validacion del nombre del usuario
  validates :user, uniqueness: true, presence: true
# Validacion del email del usuario
  validates :email, uniqueness: true, presence: true
  # Validacion de la pass del usuario
  validates :pass, presence: true
  # Validacion del nombre del usuario
  validates :nombre, presence: true
  # Validacion de los apellidos del usuario
  validates :apellidos, presence: true
  # Validacion de la direccion del usuario
  validates :direccion, presence: true
  # Validacion del telefono del usuario
  validates :telefono, presence: true

  # Un usuario no puede tener mas de un carrito
  has_one :carrito
end