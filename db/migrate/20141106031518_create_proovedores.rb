# Crea la migracion para añadir los proovedores
class CreateProovedores < ActiveRecord::Migration
  def change
    # Creamos la tabla de proovedores
    create_table :proovedores do |p|
      # Nombre de la empresa
      p.string :nombreEmpresa, null:false

      # Opcional: Nombre completo del contacto
      p.string :nombre
      p.string :apellidos

      # Datos de contacto
      p.string :email, null:false
      p.text :direccion, null:false
      p.string :telefono, null:false
    end

    # Añadimos la columna de proovedores
    change_table :productos do |p|
      p.belongs_to :proovedor
    end
  end
end
