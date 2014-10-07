#Clase DAO para productos
class ProductoBO

  #Funcion que devuelve una lista de los productos en oferta
  def ofertas
    'ofertas'
  end

  #Funcion que crea un producto a partir de los datos
  def crear_prodcuto(datos, login)
    Producto.new
  end
end