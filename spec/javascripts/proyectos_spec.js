/*describe("prueba de proyectos", function() {


 //Ejemplo de prueba de funciones que modifican el HTML
 describe("pruebas de HTML", function() {
 it("se muestran los detalles de un proyecto en el HTML", function () {
 var proyecto = {id: 1, descripcion: "descripcion 1"}
 //Usamos la librería jasmine_jquery para cargar "fixtures" de HTML:
 //HTML externo que incluimos en la página actual
 loadFixtures('detalles_proyecto.html')
 //Función a probar
 mostrar_detalles(proyecto)
 //Si ha ido bien se debería haber creado el div de detalles del proyecto
 //Accedemos a él
 var div_detalles = document.querySelector('#detalles_1')
 //El div debería existir
 expect(div_detalles).not.toBeUndefined()
 //El div debería contener la descripción del proyecto
 //El "innerText" es el texto que contiene una etiqueta, ignorando los tags
 expect(div_detalles.innerText).toBe("descripcion 1")
 })

 })

 describe("pruebas de AJAX", function() {
 //Antes de cada prueba sustituimos el XMLHttpRequest real por el fake
 beforeEach(function() {
 jasmine.Ajax.install()
 })

 //Al final volvemos al XMLHttpRequest de verdad
 afterEach(function() {
 jasmine.Ajax.uninstall()
 })


 it ("hace petición AJAX de destacados", function() {
 //Sustituye la función "callback_destacados" por un mock
 //sintaxis: spyon(objeto, método)
 //recordemos que cualquier función JS está dentro del objeto window
 //Al poner el callThrough el mock acaba llamando a la función real
 spyOn(window, 'callback_destacados').and.callThrough()

 //Aquí es un mock que no llama al "mostrar_destacados" real
 spyOn(window, 'mostrar_destacados')

 //datos de prueba ficticios que envía el servidor
 var fixture = [{id:1,titulo:"titulo 1"}, {id:2,titulo:"titulo 2"}]

 //función que dispara la prueba
 pedir_destacados()

 //petición mas reciente hecha al AJAX fake de Jasmine
 var peticion = jasmine.Ajax.requests.mostRecent()

 //Esperamos que la URL sea una determinada
 expect(peticion.url).toBe('/api/proyectos/destacados')

 //Ahora simulamos que el servidor responde algo
 jasmine.Ajax.requests.mostRecent().respondWith({
 status: 200,
 responseText: JSON.stringify(fixture)
 })

 //Y esperamos que se haya llamado al callback_destacados
 expect(window.callback_destacados).toHaveBeenCalled()
 //Y que mostrar_destacados haya sido llamado a su vez con el JSON
 expect(window.mostrar_destacados).toHaveBeenCalledWith(fixture)

 })
 })
 })*/