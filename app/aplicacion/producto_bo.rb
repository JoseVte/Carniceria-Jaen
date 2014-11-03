# Clase DAO para productos
class ProductoBO

  # Funcion que devuelve una lista de los productos en oferta
  def ofertas
    Producto.where(:ofertas=>true)
  end

  # Todos los productos
  def all
    Producto.all
  end

  # Devuelve un producto concreto
  def ver_producto(id)
    p = Producto.find_by(id: id)
    raise CustomMsgException.new(404,'Error 404: No existe el producto '+id.to_s) if p.nil?
    p
  end

  # Crea un producto a partir de los datos
  def crear_producto(datos, login)
    p = Producto.new(datos)

    raise CustomMsgException.new(400,'Error 400: Los datos son incorrectos') if !p.valid?

    p.save
    p
  end

  # Modifica un producto a partir del id
  def modificar_producto(datos, login)
    p = Producto.find_by(id: datos['id'])
    raise CustomMsgException.new(404,'Error 404: No existe el producto '+datos['id'].to_s) if p.nil?

    datos.delete('id')
    raise CustomMsgException.new(500,'Error 500: No se ha podido modificar') if !p.update(datos)

    p.save
    p
  end

  # Borra un producto por el id
  def borrar_producto(id, login)
    raise CustomMsgException.new(404,'Error 404: No existe el producto con id '+id.to_s) if Producto.find_by(id: id).nil?

    Producto.destroy_all(id: id)
    'Se ha borrado correctamente el producto '+id.to_s
  end
end