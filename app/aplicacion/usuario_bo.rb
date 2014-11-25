require 'digest/md5'
require 'jwt'

# Clase que se encarga de contener todos los metodos de acceso de la BD a los Usuario
class UsuarioBO
  include Digest

  # Metodo para comprobar si el login MD5.hexdigestes correcto y devuelve el token
  def login(user, pass)
    begin
      u = Usuario.find_by(:user => user)
    ensure
      raise CustomMsgException.new(401,'Error 401: Autentificacion incorrecta') if u.nil? || (u.authenticate(MD5.hexdigest(pass)) == false)
      return JWT.encode(u.attributes,Utilidad::SECRET)
    end
  end

  # Comprobar si el usuario tiene permisos para acceder a la funcionalidad
  def self.permitted?(token,user_who_wants_to_access)
    if !token.nil?
      u =  JWT.decode(token,Utilidad::SECRET)
      if !u.nil?
        if u[0]['user'] == 'root'
          return true
        elsif u[0]['user'] == user_who_wants_to_access
          return true
        end
      end
    end
    raise CustomMsgException.new(403,'Error 403: Acceso prohibido')
  end

  # Comprobar si un usuario existe o no
  def exists?(campo, cadena)
    exist = Usuario.where("#{campo} LIKE ?", "#{cadena}")
    return !exist.empty?
  end

  # Devuelve una lista de todos los usuarios
  def all(token)
    # Solo se le permite el acceso al admin
    if UsuarioBO.permitted?(token,'root')
      Usuario.all.order('created_at DESC')
    end
  end

  # Devuelve un producto concreto
  def find_by_user(usuario,token)
    if UsuarioBO.permitted?(token,usuario)
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
    u.password = MD5.hexdigest(datos[:password])
    u.password_confirmation = MD5.hexdigest(datos[:password_confirmation])
    u.save
    c = Carrito.new({:usuarios_id => u.id})
    c.save
    u
  end

  # Modifica un usuario
  def update(datos,token)
    if UsuarioBO.permitted?(token,datos[:user])
      u = Usuario.find_by(user: datos[:user])

      raise CustomMsgException.new(404,"Error 404: No existe el usuario #{datos[:user]}") if u.nil?
      datos.delete('user')
      raise CustomMsgException.new(500,'Error 500: No se ha podido modificar') if !u.update(datos)

      u.save
      u
    end
  end

  # Borra un producto por el id
  def delete(usuario,token)
    if UsuarioBO.permitted?(token,usuario)
      raise CustomMsgException.new(404,"Error 404: No existe el usuario #{usuario}") if Usuario.find_by(user: usuario).nil?

      Carrito.delete_all(usuarios_id: Usuario.find_by(user: usuario).id)
      Usuario.destroy_all(user: usuario)
      "Se ha borrado correctamente el usuario #{usuario}"
    end
  end
end