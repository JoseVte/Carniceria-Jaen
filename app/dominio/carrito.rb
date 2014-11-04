require 'active_record'

#Clase principal de carritos
class Carrito < ActiveRecord::Base
  self.primary_key = :id
  # Un carrito pertenece a un usuario
  # Un usuario no puede tener mas de un carrito
  has_one :usuario
  # Un carrito puede tener muchos productos
  # Un producto puede estar en varios carritos
  has_and_belongs_to_many :productos
end