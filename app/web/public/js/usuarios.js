/**
 * Created by josrom on 18/11/14.
 */

//Registro
function registro(){
    var request = new XMLHttpRequest();
    request.onreadystatechange = callback_registro;
    request.open("POST","/api/usuario/new",true);
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    request.send(datos_registro())
}

function callback_registro() {
    if (this.readyState == 4) {
        if (this.status == 201) {
            registro_completado()
        }
    }
}

function datos_registro(){
    return '{"user":"'+ $("#inputUser").val() +
        '", "password":"'+ $("#inputPassword").val() +
        '"}';
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
            var partial = {img_perfil: '<img src="{{url_imagen}}" class="img-responsive">'}
            $("#body").html(Mustache.render(plantilla.replace('&gt;','>'),user,partial))
        })
    }
}