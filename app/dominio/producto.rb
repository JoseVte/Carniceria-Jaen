require 'active_record'

#Clase principal de productos
class Producto < ActiveRecord::Base
  validates :nombre, presence: true
  validates :precioKg, presence: true

  # Un carrito puede tener muchos productos
  # Un producto puede estar en varios carritos
  has_and_belongs_to_many :carritos
end