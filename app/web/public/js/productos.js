/**
 * Created by josrom on 18/11/14.
 */

/**********************************************************/
/***************** Productos en oferta ********************/
/**********************************************************/

function get_ofertas(){
    $.get("/api/producto/ofertas")
        .success(function (data) {
            mostrar_ofertas(data)
        });
}
function mostrar_ofertas(ofertas){
    for (var i = 0; i < ofertas.length; i++) {
        ofertas[i].fecha_js = new Date(ofertas[i].updated_at).toLocaleDateString();
    }

    $("#ofertas").load("templates/productoTemplate.mustache #plantilla_ofertas", function() {
        var plantilla = document.getElementById("plantilla_ofertas").innerHTML;
        var partial = {img_ofertas: '<img src="{{url_imagen}}" height="128px" width="128px" class="img-rounded">'};
        var html = Mustache.render(plantilla.replace('&gt;','>'),ofertas,partial);
        $("#ofertas").html(html);
    });
}

/**********************************************************/
/***************** Todos los productos ********************/
/**********************************************************/

function get_productos(){
    $.get("/api/producto/all")
        .success(function (data) {
            mostrar_productos(data)
        });
}
function mostrar_productos(all){
    $("#productos").load("templates/productoTemplate.mustache #plantilla_paginacion", function() {
        var plantilla = document.getElementById("plantilla_paginacion").innerHTML;
        var partial = {img_pag: '<img src="{{url_imagen}}" height="128px" width="128px" class="img-responsive">'};
        $("#productos").html(Mustache.render(plantilla.replace('&gt;','>'),all,partial));
    });
}

/**********************************************************/
/***************** Detalles de un producto ****************/
/**********************************************************/

function get_producto_detalles(id){
    $.get("/api/producto/" + id)
        .success(function (data) {
            mostrar_detalles(data)
        })
        .fail(function (xhr) {
            console.log(xhr.responseText)
        });
}
function mostrar_detalles(producto){
    producto.fecha_js = new Date(producto.created_at).toLocaleDateString();
    producto.fecha_js = new Date(producto.updated_at).toLocaleDateString();

    $("#body").load("templates/productoTemplate.mustache #plantilla_detalles", function() {
        var plantilla = document.getElementById("plantilla_detalles").innerHTML;
        var partial = {img_detalles: '<img src="{{url_imagen}}" class="img-responsive">'};
        $("#body").html(Mustache.render(plantilla.replace('&gt;','>'), producto, partial));//Antes de que se acabe la etiqueta
    });
}