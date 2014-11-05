# Clase que se encarga de contener todos los metodos de acceso de la BD a los Usuario
class UsuarioBO

  # Devuelve una lista de todos los usuarios
  def all
    Usuario.all
  end

  # Devuelve un producto concreto
  def ver_usuario(usuario)
    u = Usuario.find_by(user: usuario)
    raise CustomMsgException.new(404,"Error 404: No existe el usuario #{usuario}") if u.nil?
    u
  end

  # Funcion que crea un producto a partir de los datos
  def crear_usuario(datos,login)
    exist = Usuario.find_by(user: datos[:user])
    raise CustomMsgException.new(400,"Error 400: El usuario #{datos[:user]} ya existe") if !exist.nil?

    u = Usuario.new(datos)
    raise CustomMsgException.new(400,'Error 400: Los datos son incorrectos') if !u.valid?
    u.save
    c = Carrito.new({:usuarios_id => u.id})
    c.save
    u
  end

  # Modifica un producto
  def modificar_usuario(datos,login)
    u = Usuario.find_by(user: datos[:user])

    raise CustomMsgException.new(404,"Error 404: No existe el usuario #{datos[:user]}") if u.nil?
    datos.delete('user')
    raise CustomMsgException.new(500,'Error 500: No se ha podido modificar') if !u.update(datos)

    u.save
    u
  end

  # Borra un producto por el id
  def borrar_usuario(usuario,login)
    raise CustomMsgException.new(404,"Error 404: No existe el usuario #{usuario}") if Usuario.find_by(user: usuario).nil?

    Carrito.delete_all(usuarios_id: Usuario.find_by(user: usuario).id)
    Usuario.destroy_all(user: usuario)
    "Se ha borrado correctamente el usuario #{usuario}"
  end
end