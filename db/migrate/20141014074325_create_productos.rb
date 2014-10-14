class CreateProductos < ActiveRecord::Migration
  def change
    create_table :productos do |p|
      p.string :nombre
      p.text :descripcion
      p.integer :stock
    end
  end
end
