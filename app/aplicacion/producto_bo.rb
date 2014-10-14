#Clase DAO para productos
class ProductoBO

  #Funcion que devuelve una lista de los productos en oferta
  def ofertas
    Producto.where(:ofertas=>true)
  end

  #Funcion que crea un producto a partir de los datos
  def crear_producto(datos, login)
  end
end