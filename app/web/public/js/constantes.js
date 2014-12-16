/**
 * Created by josrom on 7/12/14.
 */

//Todas las variables que se necesitan antes de que se cargue el resto de javascripts

//Todos los 'partial' para mustache
var partial_img_perfil = {img: '<img src="{{url_imagen}}" class="img-circle" height="48px" width="48px">'};
var partial_img_reg = {img: '<img src="{{imagen.src}}" title="{{imagen.title}}" class="img-circle" height="70px" width="70px">'};
var partial_img_detalles = {img_detalles: '<img src="{{url_imagen}}" class="img-responsive img-rounded" height="300px" width="300px">'};
var partial_img_productos = {img: '<img src="{{url_imagen}}" height="128px" width="128px" class="img-rounded">'};

//Las credenciales estan el las cookies
$(window).on('beforeunload', function () {
    localStorage.removeItem('usuario');
    localStorage.removeItem('usuarioObj');
    localStorage.removeItem('token');
});