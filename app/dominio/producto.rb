require 'active_record'

# Clase donde añadimos todas las restricciones de la BD
class Producto < ActiveRecord::Base
   # Validacion del nombre del producto
  validates :nombre, presence: true
  # Validacion del precio por kilo del producto
  validates :precioKg, presence: true

  # Un carrito puede tener muchos productos
  # Un producto puede estar en varios carritos
  has_and_belongs_to_many :carritos
end