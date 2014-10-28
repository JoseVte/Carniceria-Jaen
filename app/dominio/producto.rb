require 'active_record'

#Clase principal de productos
class Producto < ActiveRecord::Base
  validates :nombre, presence: true
  validates :precioKg, presence: true
end