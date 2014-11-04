class CreateCarritos < ActiveRecord::Migration
  def change
    create_table :carritos, { :id => false } do |c|
      c.belongs_to :usuarios
      c.belongs_to :productos
    end
  end
end
