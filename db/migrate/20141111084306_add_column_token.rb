# Crea la migracion para añadir la seguridad por web token
class AddColumnToken < ActiveRecord::Migration
  # Añadimos la columna token a usuarios
  def change
    add_column :usuarios, :token, :string, :limit => 512, :default => ''
  end
end
