# Clase generica para albelgar todas las excepciones de la API
class CustomMsgException < StandardError
  # Atributo para el mensaje
  attr :msg
  # Atributo para el codigo
  attr :status
  
  # Crea una excepcion a partir de un codigo HTTP y un mensaje
  def initialize(status,msg)
    @msg = msg
    @status = status
  end

  # Devuelve el mensaje de la excepcion
  def message
    @msg
  end

  # Devuelve el codigo HTTP
  def status
    @status
  end
end