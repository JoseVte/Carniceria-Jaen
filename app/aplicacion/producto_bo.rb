# Clase que se encarga de contener todos los metodos de acceso de la BD a los Producto
class ProductoBO

  # Funcion que devuelve una lista de los productos en oferta
  def ofertas
    Producto.where(:ofertas=>true)
  end

  # Busqueda de productos por subcadena
  def busqueda(subcadena)
    Producto.where("nombre LIKE ?", "%#{subcadena}%")
  end

  # Todos los productos
  def all
    Producto.all
  end

  # Devuelve un producto concreto
  def ver_producto(id)
    p = Producto.find_by(id: id)
    raise CustomMsgException.new(404,"Error 404: No existe el producto con id #{id}") if p.nil?
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
    p = ver_producto(datos[:id])

    datos.delete(:id)
    raise CustomMsgException.new(500,'Error 500: No se ha podido modificar') if !p.update(datos)

    p.save
    p
  end

  # Borra un producto por el id
  def borrar_producto(id, login)
    ver_producto(id)

    Producto.destroy_all(id: id)
    return "Se ha borrado correctamente el producto #{id}"
  end
end