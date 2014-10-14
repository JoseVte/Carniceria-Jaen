class CreateProductos < ActiveRecord::Migration
  def change
    create_table :productos do |p|
      p.string :nombre
      p.text :descripcion
      p.float :precioKg
      p.integer :stock
      p.boolean :ofertas
    end
  end
end
