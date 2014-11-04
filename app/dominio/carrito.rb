require 'active_record'

#Clase principal de carritos
class Carrito < ActiveRecord::Base
  # Un carrito pertenece a un usuario
  belongs_to :usuario

  # Un carrito puede tener muchos productos
  # Un producto puede estar en varios carritos
  has_and_belongs_to_many :productos

  def exists?(producto)
    self.productos.include?(producto)
  end
end