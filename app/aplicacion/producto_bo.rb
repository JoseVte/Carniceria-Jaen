require 'app/aplicacion/usuario_bo'

# Clase que se encarga de contener todos los metodos de acceso de la BD a los Producto
class ProductoBO

  # Funcion que devuelve una lista de los productos en oferta
  def ofertas
    Producto.where(:ofertas=>true)
  end

  # Busqueda por proovedor
  def select_by_proovedor(proovedor)
    Producto.where("proovedor_id == ?", "#{proovedor}")
  end

  # Busqueda de productos por subcadena
  def select_by_nombre(subcadena)
    Producto.where("nombre LIKE ?", "%#{subcadena}%")
  end

  # Todos los productos
  def all
    Producto.all
  end

  # Devuelve un producto concreto
  def find_by_id(id)
    p = Producto.find_by(id: id)
    raise CustomMsgException.new(404,"Error 404: No existe el producto con id #{id}") if p.nil?
    p
  end

  # Crea un producto a partir de los datos
  def create(datos, login)
    if UsuarioBO.permitted?(login,'root')
      p = Producto.new(datos)

      raise CustomMsgException.new(400,'Error 400: Los datos son incorrectos') if !p.valid?

      p.save
      p
    end
  end

  # Modifica un producto a partir del id
  def update(datos, login)
    if UsuarioBO.permitted?(login,'root')
      p = find_by_id(datos[:id])

      datos.delete(:id)
      raise CustomMsgException.new(500,'Error 500: No se ha podido modificar') if !p.update(datos)

      p.save
      p
    end
  end

  # Borra un producto por el id
  def delete(id, login)
    if UsuarioBO.permitted?(login,'root')
      find_by_id(id)

      Producto.destroy_all(id: id)
      return "Se ha borrado correctamente el producto #{id}"
    end
  end
end