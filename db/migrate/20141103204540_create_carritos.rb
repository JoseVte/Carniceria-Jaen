# Crea la migracion para añadir los carritos
class CreateCarritos < ActiveRecord::Migration
  # Creamos la tabla carritos y carritos_productos, para la relacion N a N
  def change
    create_table :carritos do |c|
      c.belongs_to :usuarios
    end

    create_table :carritos_productos, { :id => false } do |cp|
      cp.column :carrito_id, :integer
      cp.column :producto_id, :integer
    end
  end
end
