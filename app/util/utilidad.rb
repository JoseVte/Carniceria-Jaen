# Clase auxiliar donde guardar los metodos auxiliares
class Utilidad

  # Secreto para el JWT
  SECRET = 'ADI'

  # Tiempo para expirar
  EXPIRE = 1000*60*60*24

  # Dados una url base, unos datos que se puedan convertir en array, y los parametros de la url devuelve un JSON con los elementos indicados
  def self.paginacion(url_base, datos, params)
    inicio = params[:inicio]
    cantidad = params[:cantidad]

    # Montamos el JSON final
    result = {
        :total => datos[:total],
        :params => params,
        :contenido => datos[:datos],
        :link => {
            :rel => 'self',
            :href => "#{url_base}?inicio=#{inicio}&cantidad=#{cantidad}"
        }
    }

    # Añadimos la pagina previa
    if inicio.to_i > 1
      aux=1
      if inicio.to_i-cantidad.to_i>0
        aux= (inicio.to_i-cantidad.to_i)
      end
      result.store(:link_prev,{:rel => 'prev',:href => "#{url_base}?inicio=#{aux}&cantidad=#{cantidad}"})
    end

    # Añadimos la siguiente pagina
    if (inicio.to_i + cantidad.to_i) <= datos[:total]
      result.store(:link_next,{:rel => 'next',:href => "#{url_base}?inicio=#{inicio.to_i+cantidad.to_i}&cantidad=#{cantidad}"})
    end

    return result
  end

  # Dados el principio y la cantidad, devuelve un array con los parametros
  def self.parse_params(params)
    inicio = 1
    if !params[:inicio].nil?
      inicio = params[:inicio]
    end

    cantidad = 10
    if !params[:cantidad].nil?
      cantidad = params[:cantidad]
    end

    return {
        inicio: inicio,
        cantidad: cantidad
    }
  end
end