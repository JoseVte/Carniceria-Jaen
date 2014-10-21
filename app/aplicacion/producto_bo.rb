#Clase DAO para productos
class ProductoBO

  #Funcion que devuelve una lista de los productos en oferta
  def ofertas
    Producto.where(:ofertas=>true)
  end

  #Devuelve un producto concreto
  def ver_producto(id)
    Producto.find_by(id)
  end

  #Funcion que crea un producto a partir de los datos
  def crear_producto(datos, login)
    p = Producto.new(datos)

    if p.nil?
      'Aqui no va'
    elsif p.valid?
      #'Aqui funca'
      p.save
      p
    else
      'Aqui excepcion'
    end
  end

  #Modifica un producto
  def modificar_producto(datos, login)
    p = Producto.find_by(datos['id'])
    if p.nil?
      'Error 404: no existe el producto '+datos['id']
    elsif p.update(datos)
      p.save
      p
    else
      'Error no se ha podido modificar'
    end
  end

  #Borra un producto por el id
  def borrar_producto(id)
    if Producto.find_by(id).nil?
      #Excepcion
      'Error 404: no se ha podido encontrar el producto'
    else
      Producto.destroy(id)
      'Se ha borrado correctamente'
    end
  end
end