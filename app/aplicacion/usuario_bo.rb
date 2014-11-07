# Clase que se encarga de contener todos los metodos de acceso de la BD a los Usuario
class UsuarioBO

  # Metodo para comprobar si el login es correcto
  def login(user, pass)
    begin
      u = find_by_user(user,user)
    ensure
      raise CustomMsgException.new(401,'Error 401: Autentificacion incorrecta') if u.nil? || !(u.pass == pass)
      return u.user
    end
  end

  # Comprobar si el usuario tiene permisos para acceder a la funcionalidad
  def self.permitted?(user_want_to_access,user_who_wants_to_access)
    # Acceso maestro a todo
    if user_want_to_access == 'root'
      return true
    else
      # Al resto de usuario solo se les permite acceder a sus datos
      if user_want_to_access == user_who_wants_to_access
        return true
      else
        raise CustomMsgException.new(403,'Error 403: Acceso prohibido')
      end
    end
  end

  # Devuelve una lista de todos los usuarios
  def all(login)
    # Solo se le permite el acceso al admin
    if UsuarioBO.permitted?(login,'root')
      Usuario.all
    end
  end

  # Devuelve un producto concreto
  def find_by_user(usuario,login)
    if UsuarioBO.permitted?(login,usuario)
      u = Usuario.find_by(user: usuario)
      raise CustomMsgException.new(404,"Error 404: No existe el usuario #{usuario}") if u.nil?
      u
    end
  end

  # Funcion que crea un usuario a partir de los datos
  def create(datos)
    exist = Usuario.find_by(user: datos[:user])
    raise CustomMsgException.new(400,"Error 400: El usuario #{datos[:user]} ya existe") if !exist.nil?

    u = Usuario.new(datos)
    raise CustomMsgException.new(400,'Error 400: Los datos son incorrectos') if !u.valid?
    u.save
    c = Carrito.new({:usuarios_id => u.id})
    c.save
    u
  end

  # Modifica un usuario
  def update(datos,login)
    if UsuarioBO.permitted?(login,datos[:user])
      u = Usuario.find_by(user: datos[:user])

      raise CustomMsgException.new(404,"Error 404: No existe el usuario #{datos[:user]}") if u.nil?
      datos.delete('user')
      raise CustomMsgException.new(500,'Error 500: No se ha podido modificar') if !u.update(datos)

      u.save
      u
    end
  end

  # Borra un producto por el id
  def delete(usuario,login)
    if UsuarioBO.permitted?(login,usuario)
      raise CustomMsgException.new(404,"Error 404: No existe el usuario #{usuario}") if Usuario.find_by(user: usuario).nil?

      Carrito.delete_all(usuarios_id: Usuario.find_by(user: usuario).id)
      Usuario.destroy_all(user: usuario)
      "Se ha borrado correctamente el usuario #{usuario}"
    end
  end
end