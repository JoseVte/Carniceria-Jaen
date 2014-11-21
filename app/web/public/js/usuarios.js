/**
 * Created by josrom on 18/11/14.
 */

//Login
function login() {
    var request = new XMLHttpRequest();
    request.onreadystatechange = callback_login;
    request.open("POST","/api/autentificacion/login",true);
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    request.send(datos_login())
}

function callback_login(){
    if(this.readyState == 4) {
        if(this.status == 200) {
            var json = JSON.parse(this.responseText);
            localStorage.setItem('usuario',$("#inputUser").val());
            localStorage.setItem('usuarioObj',JSON.stringify(json.user));
            localStorage.setItem('token',json.token);
            localStorage.setItem('recordar',$("#check_recordar").is(':checked'));
            mostrar_login_ok(json.user);
        }
    }
}

function datos_login(){
    var json = '{"login":"'+ $("#inputUser")[0].value +
        '", "password":"'+ $("#inputPassword")[0].value+'"}';
    return json
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
            localStorage.clear();
            mostrar_logout();
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

            $("#body").html(Mustache.render(plantilla,user))
        })
    }
}