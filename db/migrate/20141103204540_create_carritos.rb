class CreateCarritos < ActiveRecord::Migration
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
