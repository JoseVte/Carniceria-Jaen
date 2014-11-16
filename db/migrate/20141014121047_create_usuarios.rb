# Añade la migracion para los usuarios
class CreateUsuarios < ActiveRecord::Migration
  # Creamos la tabla usuarios
  def change
    create_table :usuarios do |u|
      #Sera la clave primaria
      u.string :user, null:false
      #Estara codificada con digest
      u.string :password_digest, null:false

      #Nombre completo
      u.string :nombre, null:false
      u.string :apellidos, null:false

      u.string :email, null:false
      #De momento solo una direccion y un telefono
      u.text :direccion,null:false
      u.string :telefono, null:false

      u.timestamps
    end
  end
end
