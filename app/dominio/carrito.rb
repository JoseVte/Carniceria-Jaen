require 'active_record'

# Clase donde añadimos todas las restricciones de la BD
class Carrito < ActiveRecord::Base
  # Un carrito pertenece a un usuario
  belongs_to :usuario

  # Un carrito puede tener muchos productos
  # Un producto puede estar en varios carritos
  has_and_belongs_to_many :productos

  # Comprobar si contiene el producto en el carrito
  def exists?(producto)
    self.productos.include?(producto)
  end
end