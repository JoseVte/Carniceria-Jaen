#Estructura de datos de un producto
class Producto
  attr_accessor :id, :nombre, :descripcion
  #1 a N
  attr_accessor :carrito, :proveedor

  #Funcion JSON
  def to_json(*opts)
    {
        :id=>id,
        :nombre=>nombre,
        :descripcion=>descripcion,
    }.to_json(*opts)
  end
end