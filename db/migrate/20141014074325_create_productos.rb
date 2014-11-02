class CreateProductos < ActiveRecord::Migration
  def change
    create_table :productos do |p|
      p.string :nombre, null:false
      p.text :descripcion
      p.float :precioKg, null:false
      p.integer :stock, :default=> 0
      p.boolean :ofertas, :default=> false
    end
  end
end
