# Añade la migracion para los productos
class CreateProductos < ActiveRecord::Migration
  # Creamos la tabla productos
  def change
    create_table :productos do |p|
      p.string :nombre, null:false
      p.text :descripcion
      p.float :precioKg, null:false
      p.integer :stock, :default=> 0
      p.boolean :ofertas, :default=> false
      p.float :rebaja, :default => 0
      p.timestamps
    end
  end
end
