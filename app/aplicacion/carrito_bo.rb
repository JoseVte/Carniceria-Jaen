require 'app/aplicacion/usuario_bo'
require 'app/dominio/usuario'

# Clase que se encarga de contener todos los metodos de acceso de la BD a los Carrito
class CarritoBO
  # Atributo auxiliar para diversos metodos
  @@usuario_bo = UsuarioBO.new

  # Todos los productos del carrito en un hash
  def all(usuario,login)
    u = @@usuario_bo.find_by_user(usuario)
    raise CustomMsgException.new(404,"Error 404: No existe el usuario #{usuario}") if u.nil?
    carrito = Carrito.find_by(usuarios_id: u.id)

    carrito.productos.to_ary
  end

  # Añade un producto a un carrito comprobando los datos previamente
  def add_prod_en_carrito(datos,login)
    raise CustomMsgException.new(404,"Error 404: No existe el usuario con id #{datos[:carrito_id]}") if Usuario.find_by(id: datos[:carrito_id]).nil?
    raise CustomMsgException.new(404,"Error 404: No existe el producto #{datos[:producto_id]}") if Producto.find_by(id: datos[:producto_id]).nil?

    carrito = Carrito.find_by(usuarios_id: datos[:carrito_id])
    producto = Producto.find_by(id: datos[:producto_id])

    raise CustomMsgException.new(400,'Error 400: Ya esta en el carrito') if carrito.exists?(producto)

    carrito.productos << producto
    return "Añadido el producto #{datos[:producto_id]} al carrito"
  end

  # Borra un producto de un carrito
  def delete_prod_en_carrito(user,id,login)
    u = @@usuario_bo.find_by_user(user)
    raise CustomMsgException.new(404,"Error 404: No existe el usuario #{user}") if u.nil?
    raise CustomMsgException.new(404,"Error 404: No existe el producto #{id}") if Producto.find_by(id: id).nil?

    carrito = Carrito.find_by(usuarios_id: u.id)
    producto = Producto.find_by(id: id)

    carrito.productos.destroy(producto)
    "Se ha eliminado el producto #{id} del carrito"
  end
end