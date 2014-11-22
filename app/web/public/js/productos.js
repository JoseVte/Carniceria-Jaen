/**
 * Created by josrom on 18/11/14.
 */

//Productos en oferta
function get_ofertas(){
    var request = new XMLHttpRequest();
    request.open("GET","/api/producto/ofertas",true);
    request.onreadystatechange = callback_ofertas;
    request.send()
}

function callback_ofertas(){
    if(this.readyState == 4){
        if(this.status == 200){
            var ofertas = JSON.parse(this.responseText);
            mostrar_ofertas(ofertas)
        }//Excepcion al usuario
    }
}

function mostrar_ofertas(ofertas){
    for(i=0;i<ofertas.length;i++){
        ofertas[i].fecha_js = new Date(ofertas[i].updated_at).toLocaleDateString();
    }

    $("#ofertas").load("templates/productoTemplate.mustache #plantilla_ofertas", function() {
        var plantilla = document.getElementById("plantilla_ofertas").innerHTML;
        var partial = {img_ofertas: '<img src="{{url_imagen}}" height="128px" width="128px" class="img-rounded">'};
        var html = Mustache.render(plantilla.replace('&gt;','>'),ofertas,partial);
        $("#ofertas").html(html);//Antes de que se acabe la etiqueta
    });
}

//Todos los productos
function get_productos(){
    var request = new XMLHttpRequest();
    request.open("GET","/api/producto/all",true);
    request.onreadystatechange = callback_productos;
    request.send()
}

function callback_productos(){
    if(this.readyState == 4){
        if(this.status == 200){
            var all = JSON.parse(this.responseText);
            mostrar_productos(all)
        }//Excepcion al usuario
    }
}

function mostrar_productos(all){
    $("#productos").load("templates/productoTemplate.mustache #plantilla_paginacion", function() {
        var plantilla = document.getElementById("plantilla_paginacion").innerHTML;
        var partial = {img_pag: '<img src="{{url_imagen}}" height="128px" width="128px" class="img-responsive">'};
        $("#productos").html(Mustache.render(plantilla.replace('&gt;','>'),all,partial));
    });
}

//Detalles de un producto
function get_producto_detalles(id){
    var request = new XMLHttpRequest();
    request.open("GET","/api/producto/"+ id,true);
    request.onreadystatechange = callback_detalles;
    request.send()
}

function callback_detalles(){
    if(this.readyState == 4){
        if(this.status == 200){
            var producto = JSON.parse(this.responseText);
            mostrar_detalles(producto)
        }//Excepcion al usuario
    }
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