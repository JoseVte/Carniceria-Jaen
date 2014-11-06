require 'active_record'

# Clase donde añadimos todas las restricciones de la BD
class Proovedor < ActiveRecord::Base
  # Validacion del email
  validates :email, uniqueness: true, presence: true
  # Validacion del nombre de la empresa
  validates :nombreEmpresa, presence: true
  # Validacion de la direccion
  validates :direccion, presence: true
  # Validacion del telefono
  validates :telefono, presence: true

  # Un proovedor tiene muchos productos
  has_many :productos
end