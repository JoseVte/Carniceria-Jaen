#Clase DAO para usuarios
class UsuarioBO
  def all
    Usuario.all
  end

  #Devuelve un producto concreto
  def ver_usuario(usuario)
    Usuario.find_by(user: usuario)
  end

  #Funcion que crea un producto a partir de los datos
  def crear_usuario(datos)
    u = Usuario.new(datos)

    if u.nil?
      'Aqui no va'
    elsif u.valid?
      #'Aqui funca'
      u.save
      u
    else
      'Aqui excepcion'
    end
  end

  #Modifica un producto
  def modificar_usuario(datos)
    u = Usuario.find_by(user: datos['user'])
    datos.delete('user')
    if u.nil?
      'Error 404: no existe el producto '+datos['user']
    elsif u.update(datos)
      u.save
      u
    else
      'Error no se ha podido modificar'
    end
  end

  #Borra un producto por el id
  def borrar_usuario(usuario)
    if Usuario.find_by(user: usuario).nil?
      #Excepcion
      'Error 404: no se ha podido encontrar el producto'
    else
      Usuario.destroy_all(user: usuario)
      'Se ha borrado correctamente'
    end
  end
end