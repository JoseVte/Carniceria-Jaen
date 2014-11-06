require 'app/dominio/proovedor'

# Clase que se encarga de contener todos los metodos de acceso de la BD a los Proovedor
class ProovedorBO

  def select_by(campo,cadena)
    raise CustomMsgException.new(404,"Error 404: El campo #{campo} no existe") if !Proovedor.column_names.include?(campo)
    Proovedor.where("#{campo} LIKE ?", "%#{cadena}%")
  end

  # Todos los proovedores
  def all
    Proovedor.all
  end

  # Devuelve el proovedor concreto
  def find_by_id(id)
    p = Proovedor.find_by(id: id)
    raise CustomMsgException.new(404,"Error 404: No existe el proovedor con id #{id}") if p.nil?
    p
  end

  # Crea un proovedor a partir de los datos
  def create(datos,login)
    p = Proovedor.new(datos)

    raise CustomMsgException.new(400,'Error 400: Los datos son incorrectos') if !p.valid?

    p.save
    p
  end

  # Modifica un proovedor a partir del id
  def update(datos, login)
    p = find_by_id(datos[:id])

    datos.delete(:id)
    raise CustomMsgException.new(500,'Error 500: No se ha podido modificar') if !p.update(datos)

    p.save
    p
  end

  # Borra un proovedor por el id
  def delete(id, login)
    find_by_id(id)

    Proovedor.destroy_all(id: id)
    return "Se ha borrado correctamente el proovedor #{id}"
  end
end