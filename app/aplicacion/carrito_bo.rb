require 'app/aplicacion/usuario_bo'
require 'app/dominio/usuario'

# Clase DAO para carrito
class CarritoBO
  @@usuario_bo = UsuarioBO.new

  # Todos los productos del carrito en un hash
  def all(usuario,login)
    u = @@usuario_bo.ver_usuario(usuario)
    raise CustomMsgException.new(404,"Error 404: No existe el usuario #{usuario}") if u.nil?

    json = Carrito.where(usuarios_id: u.id).to_json
    hash = JSON.parse(json)
    hash.each { |par| par.delete('id') }
    return hash
  end

  # Añade un producto a un carrito comprobando los datos previamente
  def crear_prod_en_carrito(datos,login)
    raise CustomMsgException.new(404,"Error 404: No existe el usuario con id #{datos[:usuarios_id]}") if Usuario.find_by(id: datos[:usuarios_id]).nil?
    raise CustomMsgException.new(404,"Error 404: No existe el producto #{datos[:productos_id]}") if Producto.find_by(id: datos[:productos_id]).nil?

    c = Carrito.new(datos)
    raise CustomMsgException.new(400,'Error 400: Los datos son incorrectos') if !c.valid?
    c.save
    return "Añadido el producto #{datos[:productos_id]} al carrito"
  end
end