/**
 * Created by josrom on 18/11/14.
 */

/**********************************************************/
/***************** Registrar un usuario *******************/
/**********************************************************/

function registrar_usuario(datosFormRegistro) {
    $.post("/api/usuario/new",
        datos_registro(datosFormRegistro))
        .done(function (data) {
            console.log(data);
            //TODO Arreglar subida de imagenes
            //upload_imagen(datosFormRegistro.imagen);
            principal()
        })
        .fail(function (xhr) {
            console.log(xhr.responseText);
            $.notify(xhr.responseText, 'error');
        });
}
function datos_registro(datosFormRegistro) {
    var datos1 = datosFormRegistro.datos1, datos2 = datosFormRegistro.datos2;
    return {
        user: datos1[0].valor,
        pass: datos1[1].valor,
        pass_conf: datos1[2].valor,
        email: datos1[3].valor,
        nombre: datos2[0].valor,
        apellidos: datos2[1].valor,
        direccion: datos2[2].valor,
        telefono: datos2[3].valor,
        url_imagen: datosFormRegistro.imagen.url
    };
}

//Funciones auxiliares para ayudar al formulario de registro
function user_exist(user){
    $.get("/api/usuario/exists/user/" + user)
        .complete(function (xhr) {
            var exist = false;
            if (xhr.status == 200) {
                exist=true;
            }
            mostrar_resultado(exist, 'user');
        });
}
function email_exist(email){
    $.get("/api/usuario/exists/email/" + email)
        .complete(function (xhr) {
            var exist = false;
            if (xhr.status == 200) {
                exist=true;
            }
            mostrar_resultado(exist, 'email');
        });
}
function mostrar_resultado(exist, campo){
    var help_user = $("#help_user");
    var help_email = $("#help_email");
    if(exist && campo == "user"){
        help_user.html("El usuario ya existe");
        help_user.addClass("alert alert-danger");
        $("#icon_help_user").addClass("glyphicon-remove");
    }

    if(exist && campo == "email"){
        help_email.html("El email ya existe");
        help_email.addClass("alert alert-danger");
        $("#icon_help_email").addClass("glyphicon-remove");
    }
}

/**********************************************************/
/************* Login y logout de un usuario ***************/
/**********************************************************/

function login() {
    if (validar_form_login()) {
        $.ajax({
            type: "POST",
            url: "/api/autentificacion/login",
            data: JSON.stringify(datos_login()),
            contentType: "application/x-www-form-urlencoded",
            success: function (json) {
                var user = JSON.stringify(json.user);
                //Expiran en 24 horas
                var date = new Date();
                date.setTime(date.getTime() + json.expire);
                var expire = {expires: date};
                //Borramos todos los datos guardados ya existentes para evitar conflictos
                delete_credenciales();
                localStorage.setItem('usuario', json.user.user);
                localStorage.setItem('usuarioObj', user);
                localStorage.setItem('token', json.token);
                if ($("#check_recordar").is(':checked')) {
                    $.cookie("usuario", json.user.user, expire);
                    $.cookie("usuarioObj", user, expire);
                    $.cookie("token", json.token, expire);
                }
                mostrar_login_ok(json.user);
            },
            error: function (xhr) {
                console.log(xhr.responseText);
                $.notify(xhr.responseText, 'error');
            }
        });
    }
}
function datos_login(){
    return {
        login: $("#inputUser").val(),
        password: $("#inputPassword").val()
    };
}

function logout() {
    $.get("/api/autentificacion/logout")
        .done(function () {
            delete_credenciales();
            mostrar_logout();
            principal();
        });
}

/**********************************************************/
/***************** Detalles de un usuario *****************/
/**********************************************************/

function get_datos_user(){
    if (have_credentiales()) {
        var user = localStorage.getItem('usuario');
        var token = localStorage.getItem('token');

        $.ajax({
            type: "GET",
            url: "/api/usuario/" + user,
            headers: {
                'X-Auth-Token': token
            },
            success: function (data) {
                $("#body").load("templates/usuarioTemplate.mustache #plantilla_detalles", function () {
                    var plantilla = document.getElementById("plantilla_detalles").innerHTML;
                    $("#body").html(Mustache.render(plantilla.replace('&gt;', '>'), data, partial_img_detalles))
                })
            },
            error: function (xhr) {
                console.log(xhr.responseText);
            }
        });
    } else {
        $.notify('Error en las credenciales. Reloguee', 'error')
    }
}

/**********************************************************/
/***************** Añadir al carrito **********************/
/**********************************************************/

function add_prod_carrito(id){
    if (have_credentiales()) {
        var user = JSON.parse(localStorage.getItem('usuarioObj'));
        var token = localStorage.getItem('token');

        $.ajax({
            type: "POST",
            url: "/api/usuario/" + user.user + "/carrito",
            data: {
                user_id: user.id,
                prod_id: id
            },
            headers: {
                'X-Auth-Token': token
            },
            success: function(msg){
                console.log(msg);
                $.notify(msg);
            },
            error: function (xhr) {
                console.log(xhr.responseText);
                $.notify(xhr.responseText, 'error');
            }
        })
    } else {
        $.notify('Debe estar logueado para comprar', 'error')
    }
}

