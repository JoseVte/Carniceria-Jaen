# Crea la migracion para añadir la columna de las imagenes
class AddColumnImagen < ActiveRecord::Migration
  # Añadimos las columnas a cada tabla
  def change
    add_column :productos, :url_imagen, :string, :default => 'img/missing_prod.png'
    add_column :usuarios, :url_imagen, :string, :default => 'img/missing_user.png'
    add_column :proovedors, :url_imagen, :string, :default => 'img/missing_prod.png'
  end
end
