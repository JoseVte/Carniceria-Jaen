class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios,{ :id => false, :primary_key => :user } do |u|
      #Sera la clave primaria
      u.string :user
      #Estara codificada con digest
      u.string :pass, null:false

      #Nombre completo
      u.string :nombre, null:false
      u.string :apellidos, null:false

      u.string :email, null:false
      #De momento solo una direccion y un telefono
      u.text :direccion,null:false
      u.string :telefono, null:false
    end
  end
end
