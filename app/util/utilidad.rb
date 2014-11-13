# Clase auxiliar donde guardar los metodos auxiliares
class Utilidad

  SECRET = 'ADI'

  # Dados una url base, unos datos que se puedan convertir en array, y los parametros de la url devuelve un JSON con los elementos indicados
  def self.paginacion(url_base, datos, params)
    inicio = 1
    if !params[:inicio].nil?
      inicio = params[:inicio]
    end

    cantidad = 10
    if !params[:cantidad].nil?
      cantidad = params[:cantidad]
    end

    # Montamos el JSON final
    result = { :total => datos.length,
               :contenido => seleccion(datos,inicio,cantidad),
               :link => { :rel => 'self',
                          :href => "#{url_base}?inicio=#{inicio}&cantidad=#{cantidad}"
               }
    }

    # Añadimos la pagina previa
    if inicio.to_i > 1
      aux=1
      if inicio.to_i-cantidad.to_i>0
        aux=inicio
      end
      result.store(:link_prev,{:rel => 'prev',:href => "#{url_base}?inicio=#{aux}&cantidad=#{cantidad}"})
    end

    # Añadimos la siguiente pagina
    if (inicio.to_i + cantidad.to_i) <= datos.length
      result.store(:link_next,{:rel => 'next',:href => "#{url_base}?inicio=#{inicio.to_i+cantidad.to_i}&cantidad=#{cantidad}"})
    end

    return result
  end

  # Dados los datos y el principio y la cantidad, devuelve un array con los datos seleccionados
  def self.seleccion(datos,inicio,cantidad)
    # Transformamos los datos en un array
    seleccion_datos = JSON.parse(datos.to_json)
    datos_finales = Array.new

    # Seleccionamos los de la pagina actual
    aux = 1
    seleccion_datos.each { |obj|
      if aux >= inicio.to_i && aux < (cantidad.to_i + inicio.to_i)
        datos_finales << obj
      end
      aux+=1
    }

    return datos_finales
  end
end