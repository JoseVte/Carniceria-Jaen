require 'app/aplicacion/usuario_bo'
require 'app/aplicacion/producto_bo'

# Clase DAO para carrito
class CarritoBO
  @@usuario_bo = UsuarioBO.new
  @@producto_bo = ProductoBO.new

  # Todos los productos del carrito en un hash
  def all(usuario,login)
    json = Carrito.where(usuarios_id: @@usuario_bo.ver_usuario(usuario).id).to_json
    hash = JSON.parse(json)
    hash.each { |par| par.delete('id') }
    return hash
  end

  # Añade un producto a un carrito
  def crear_prod_en_carrito(datos,login)
    c = Carrito.new(datos)
    raise CustomMsgException.new(400,'Error 400: Los datos son incorrectos') if !c.valid?
    c.save
    return 'Añadido el producto '+datos['productos_id'].to_s+' al carrito'
  end
end