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
        var html = Mustache.render(plantilla.replace('&gt;', '>'), ofertas, partial_img_productos);
        $("#ofertas").html(html);
    });
}

/**********************************************************/
/***************** Todos los productos ********************/
/**********************************************************/

function get_productos_url(url) {
    url || (url = "/api/producto/all");
    $.get(url)
        .success(function (data) {
            mostrar_productos(data)
        });
}
function mostrar_productos(all){
    $("#productos").load("templates/productoTemplate.mustache #plantilla_paginacion", function() {
        var plantilla = document.getElementById("plantilla_paginacion").innerHTML;
        partial_img_productos.funcion = "get_productos_url";
        $("#productos").html(Mustache.render(plantilla.replace('&gt;', '>'), all, partial_img_productos));
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
        $("#body").html(Mustache.render(plantilla.replace('&gt;', '>'), producto, partial_img_detalles));//Antes de que se acabe la etiqueta
    });
}

/**********************************************************/
/***************** Buscar productos ***********************/
/**********************************************************/

function search_producto(url) {
    var search = $('#search').val();

    if (search != "" && (url instanceof Object)) {
        $.get("/api/producto/buscar/" + search)
            .success(function (data) {
                mostrar_busqueda(data)
            });
    } else if (!(url instanceof Object)) {
        $.get(url)
            .success(function (data) {
                mostrar_busqueda(data)
            });
    }
}
function mostrar_busqueda(data) {
    $("#body").load("templates/productoTemplate.mustache #plantilla_paginacion", function () {
        var plantilla = document.getElementById("plantilla_paginacion").innerHTML;
        partial_img_productos.funcion = "search_producto";
        $("#body").html(Mustache.render(plantilla.replace('&gt;', '>'), data, partial_img_productos));
    });
}

