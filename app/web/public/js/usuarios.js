/**
 * Created by josrom on 18/11/14.
 */

//Registro
function registrar_usuario(datosFormRegistro) {
    // TODO Cambiar por ajax todo
    var request = new XMLHttpRequest();
    request.onreadystatechange = callback_registro;
    request.open("POST","/api/usuario/new",true);
    request.setRequestHeader("Content-Type", "multipart/form-data");
    request.send(datos_registro(datosFormRegistro))
}

function callback_registro() {
    if (this.readyState == 4) {
        if (this.status == 201) {
            //TODO Arreglar subida de imagenes
            //upload_imagen();
            registro_completado()
        }
    }
}

function datos_registro(datosFormRegistro) {
    var i, datos1 = datosFormRegistro.datos1, datos2 = datosFormRegistro.datos2;
    var datos = {};
    for (i = 0; i < datos1.length; i++) {
        datos[datos1[i].campo] = datos1[i].valor;
    }

    for (i = 0; i < datos2.length; i++) {
        datos[datos2[i].campo] = datos2[i].valor;
    }

    datos.url_imagen = datosFormRegistro.imagen.url;

    return datos;
}

function user_exist(user){
    var request = new XMLHttpRequest();
    request.onreadystatechange = function(){
        if (this.readyState == 4) {
            var exist = false;
            if(this.status == 200){
                exist=true;
            }
            mostrar_resultado(exist, 'user');
        }
    };
    request.open("GET","/api/usuario/exists/user/"+user,true);
    request.send();
}

function email_exist(email){
    var request = new XMLHttpRequest();
    request.onreadystatechange = function(){
        if (this.readyState == 4) {
            var exist = false;
            if(this.status == 200){
                exist=true;
            }
            mostrar_resultado(exist, 'email');
        }
    };
    request.open("GET","/api/usuario/exists/email/"+email,true);
    request.send();
}

function mostrar_resultado(exist, campo){
    if(exist && campo == "user"){
        $("#help_user").html("El usuario ya existe");
        $("#help_user").addClass("alert alert-danger");
        $("#icon_help_user").addClass("glyphicon-remove");
    }

    if(exist && campo == "email"){
        $("#help_email").html("El email ya existe");
        $("#help_email").addClass("alert alert-danger");
        $("#icon_help_email").addClass("glyphicon-remove");
    }
}

//Login
function login() {
    if(validar_form()){
        var request = new XMLHttpRequest();
        request.onreadystatechange = callback_login;
        request.open("POST","/api/autentificacion/login",true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        request.send(datos_login())
    }
}

function callback_login(){
    if(this.readyState == 4) {
        if(this.status == 200) {
            var json = JSON.parse(this.responseText);
            //Borramos todos los datos guardados ya existentes para evitar conflictos
            delete_credenciales();
            localStorage.setItem('usuario',$("#inputUser").val());
            localStorage.setItem('usuarioObj',JSON.stringify(json.user));
            localStorage.setItem('token',json.token);
            if($("#check_recordar").is(':checked')){
                $.cookie("usuario", $("#inputUser").val());
                $.cookie.json = true;
                $.cookie("usuarioObj", json.user);
                $.cookie.json = false;
                $.cookie("token", json.token);
            }
            mostrar_login_ok(json.user);
        }
    }
}

function datos_login(){
    return '{"login":"'+ $("#inputUser").val() +
        '", "password":"'+ $("#inputPassword").val() + '"}';
}

//Logout
function logout() {
    var request = new XMLHttpRequest();
    request.onreadystatechange = callback_logout;
    request.open("GET","/api/autentificacion/logout",true);
    request.send()
}

function callback_logout(){
    if(this.readyState == 4) {
        if(this.status == 200) {
            delete_credenciales();
            mostrar_logout();
            principal();
        }
    }
}

//Usuario en detalle
function get_datos_user(){
    var user = localStorage.getItem('usuario');
    var token = localStorage.getItem('token');

    if(token != null && user != null){
        var request = new XMLHttpRequest();
        request.onreadystatechange = callback_datos_user;
        request.open("GET","/api/usuario/"+user,true);
        request.setRequestHeader("X-Auth-Token", token);
        request.send();
    }
}

function callback_datos_user(){
    if(this.readyState == 4) {
        if(this.status == 200) {
            var json = JSON.parse(this.responseText);
            mostrar_user(json)
        }
    }
}

function mostrar_user(user){
    var token = localStorage.getItem('token');

    if(token != null){
        $("#body").load("templates/usuarioTemplate.mustache #plantilla_detalles", function(){
            var plantilla = document.getElementById("plantilla_detalles").innerHTML;
            var partial = {img_perfil: '<img src="{{url_imagen}}" class="img-responsive">'};
            $("#body").html(Mustache.render(plantilla.replace('&gt;','>'),user,partial))
        })
    }
}