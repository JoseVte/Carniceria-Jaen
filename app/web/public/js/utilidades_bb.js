/**
 * Created by josrom on 18/11/14.
 */
//Cargar todos los metodos de la pagina
$(document).ready(function () {
    mostrar_logout();
    principal();
    $(document).on('click', '#button_search', function () {
        productoRouter.search($('#search').val());
    });
    $(document).on('click', "#inicio", principal);
    $(document).on('click', "#button_login", login);
    $(document).on('click', "#button_open_registro", mostrar_registro_parte_1);
    $(document).on('click', "#button_registro_parte_1", validar_registro_parte_1);
    $(document).on('click', "#button_registro_parte_2", validar_registro_parte_2);
    $(document).on('change', "#input_imagen_registro", validar_imagen);
    $(document).on('click', "#borrar_imagen_registro", borrar_imagen);
    $(document).on('click', "#click_login", toggle_login);
    $(document).on('click', "#buttom_registro_edit", mostrar_registro_parte_1);
    $(document).on('click', "#buttom_registro_completar", registro_completado);

    $(document).on('click', "#click_crud", function () {
        productoRouter.crud();
    });
    $(document).on('click', "#update_crud", function () {
        productoRouter.update(datosForm('#form_update_crud'));
    });

    Backbone.history.start();
});

//Carga la vista principal
function principal() {
    $("#body").load("templates/inicioTemplate.mustache #plantilla_inicio", function () {
        productoRouter = new ProductoRouter();

        productoRouter.all();
        productoRouter.ofertas();
    })
}

/**********************************************************/
/***************** Registro de usuario ********************/
/**********************************************************/

//Variable global del registro
var datosFormRegistro;

//Metodos de la primera parte formulario de registro
function mostrar_registro_parte_1() {
    toggle_login();
    $("#body").load("templates/registroTemplate.mustache #plantilla_registro_1", function () {
        datosFormRegistro = {};
        var plantilla = document.getElementById("plantilla_registro_1").innerHTML;
        $("#body").html(Mustache.render(plantilla));
    })
}
function validar_registro_parte_1() {
    var arrayDatos = [];
    var arrayForm = [];
    arrayForm['user'] = 'Escriba el nombre de usuario';
    arrayForm['pass'] = 'Escriba la contraseña';
    arrayForm['pass_2'] = 'Escriba la confimacion de la contraseña';
    arrayForm['email'] = 'Escriba el email de contacto';

    var correcto = bucle_form(arrayForm, arrayDatos);

    if (correcto) {
        datosFormRegistro = {
            'datos1': arrayDatos
        };
        mostrar_registro_parte_2()
    }
}

//Metodos de la segunda parte del formulario
function mostrar_registro_parte_2() {
    $("#body").load("templates/registroTemplate.mustache #plantilla_registro_2", function () {
        var plantilla = document.getElementById("plantilla_registro_2").innerHTML;
        $("#body").html(Mustache.render(plantilla));
    })
}
function validar_registro_parte_2() {
    var arrayDatos = [];
    var arrayForm = [];
    arrayForm['nombre'] = 'Escriba su nombre';
    arrayForm['apellidos'] = 'Escriba sus apellidos';
    arrayForm['direccion'] = 'Escriba su direccion';
    arrayForm['telefono'] = 'Escriba un telefono';
    arrayForm['imagen'] = '';

    bucle_form(arrayForm, arrayDatos);

    if (comprobar_errores(arrayForm)) {
        datosFormRegistro.datos2 = arrayDatos;
        datosFormRegistro.imagen = {
            url: validar_imagen(),
            title: $("#preview").attr('title'),
            src: $("#preview").attr('src')
        };
        mostrar_registro_resumen();
    }
}

//Metodos de la confirmacion del formulario
function mostrar_registro_resumen() {
    $("#body").load("templates/registroTemplate.mustache #plantilla_confirmacion", function () {
        var plantilla = document.getElementById("plantilla_confirmacion").innerHTML;
        $("#body").html(Mustache.render(plantilla.replace('&gt;', '>'), datosFormRegistro, partial_img_reg));
    })
}
function registro_completado() {
    $("#body").load("templates/registroTemplate.mustache #plantilla_redir", function () {
        var plantilla = document.getElementById("plantilla_redir").innerHTML;
        $("#body").html(Mustache.render(plantilla));
        registrar_usuario(datosFormRegistro);
        datosFormRegistro = {};
    })
}

//Funciones auxiliares para validar los formularios del registro
function bucle_form(arrayForm, arrayDatos) {
    var i = 0;

    for (var campo in arrayForm) {
        var valorCampo = $("#input_" + campo + "_registro").val();
        var helper = $("#help_" + campo);
        var icon = $("#icon_help_" + campo);

        helper.html("");
        helper.removeClass("alert alert-warning alert-danger");
        icon.removeClass("glyphicon-warning-sign glyphicon-remove");

        if (valorCampo == "" && campo != "imagen") {
            helper.html(arrayForm[campo]);
            helper.addClass("alert alert-warning");
            icon.addClass("glyphicon-warning-sign");
        } else if (campo != "imagen") {
            validar_servidor(campo, valorCampo, helper, icon);
            arrayDatos[i] = {
                campo: campo,
                valor: valorCampo
            };
            i++;
        }
    }
}
function validar_servidor(campo, valorCampo, helper, icon) {
    switch (campo) {
        case 'user':
            user_exist(valorCampo);
            break;
        case 'pass':
        case 'pass_2':
            var pass = $("#input_pass_registro");
            var pass2 = $("#input_pass_2_registro");
            if (pass.val() != "" && pass2.val() != "") {
                if (pass.val() != pass2.val()) {
                    helper.html("Las contraseñas deben coincidir");
                    helper.addClass("alert alert-danger");
                    icon.addClass("glyphicon-remove");
                }
            }
            break;
        case 'email':
            if (!checkEmail(valorCampo)) {
                helper.html("Introduzca un email valido");
                helper.addClass("alert alert-danger");
                icon.addClass("glyphicon-remove");
            } else {
                email_exist(valorCampo);
            }
            break;
        case 'telefono':
            var regExpNum = /^[0-9]{9}$/;
            var regExpNumComp = /^\(\+\d{2,3}\)\d{9}$/;
            if (!(!valorCampo.match(regExpNum) ^ !valorCampo.match(regExpNumComp))) {
                helper.html("Introduzca un telefono valido");
                helper.addClass("alert alert-danger");
                icon.addClass("glyphicon-remove");
            }
            break;
    }
}
function comprobar_errores(arrayForm) {
    var correcto = true;

    for (var campo in arrayForm) {
        var helper = $("#help_" + campo);

        if ((helper.html() == "") && correcto)
            correcto = true;
        else
            correcto = false;
    }
}
function checkEmail(email) {
    var sQtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]';
    var sDtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]';
    var sAtom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+';
    var sQuotedPair = '\\x5c[\\x00-\\x7f]';
    var sDomainLiteral = '\\x5b(' + sDtext + '|' + sQuotedPair + ')*\\x5d';
    var sQuotedString = '\\x22(' + sQtext + '|' + sQuotedPair + ')*\\x22';
    var sDomain_ref = sAtom;
    var sSubDomain = '(' + sDomain_ref + '|' + sDomainLiteral + ')';
    var sWord = '(' + sAtom + '|' + sQuotedString + ')';
    var sDomain = sSubDomain + '(\\x2e' + sSubDomain + ')*';
    var sLocalPart = sWord + '(\\x2e' + sWord + ')*';
    var sAddrSpec = sLocalPart + '\\x40' + sDomain; // complete RFC822 email address spec
    var sValidEmail = '^' + sAddrSpec + '$'; // as whole string
    var regExpEmail = new RegExp(sValidEmail);

    return regExpEmail.test(email);
}
function validar_imagen() {
    var foto = $("#input_imagen_registro")[0].files[0];
    var url_imagen;
    var helper = $("#help_imagen");
    var icon = $("#icon_help_imagen");
    if (foto == null) {
        url_imagen = $("#input_imagen_registro")[0].defaultValue;
    } else if (!foto.type.match("image.")) { //Solo subir imagenes
        helper.html("Suba una imagen");
        helper.addClass("alert alert-danger");
        icon.addClass("glyphicon-remove");
    } else if (foto.size > 1048576) { //No debe ser mayor que un 1MB
        helper.html("Imagen demasiado grande");
        helper.addClass("alert alert-danger");
        icon.addClass("glyphicon-remove");
    } else {
        url_imagen = "img/usuarios/" + datosFormRegistro.datos1.user + ".png";

        var reader = new FileReader();
        reader.onload = (function (archivo) {
            return function (e) {
                var preview = document.getElementById("preview");
                preview.src = e.target.result;
                preview.title = escape(archivo.name);
            };
        })(foto);

        reader.readAsDataURL(foto);
    }
    return url_imagen;
}
function borrar_imagen() {
    $("#input_imagen_registro").val("");
    $("#preview").attr({src: "img/missing_user.png", title: ""});
}
function upload_imagen(datos) {
    $.ajax({
        type: 'POST',
        url: "/web/upload",
        data: datos,
        success: function (msg) {
            console.log(msg);
            $.notify(msg);
        },
        error: function (xhr) {
            console.log(xhr.responseText);
            $.notify(xhr.responseText, 'error');
        }
    });
}

/**********************************************************/
/***************** Login de usuario ***********************/
/**********************************************************/

//Animacion para mostrar-ocultar el menu de login
function toggle_login() {
    var form = document.getElementById("form_login");
    var login = document.getElementById("login");

    if (form.style.display == "block") {
        setTimeout(function () {
            form.style.display = "none";
        }, 0);
        $('#errorLogin').html("");
        $('#login_user').removeClass('has-warning');
        $('#login_pass').removeClass('has-warning');
        fx(login, [
            {'inicio': 280, 'fin': 100, 'u': 'px', 'propCSS': 'width'},
            {'inicio': 250, 'fin': 45, 'u': 'px', 'propCSS': 'height'},
            {'inicio': 1, 'fin': 1, 'u': '', 'propCSS': 'opacity'}
        ], 200, true, desacelerado);
    } else {
        fx(login, [
            {'inicio': 100, 'fin': 280, 'u': 'px', 'propCSS': 'width'},
            {'inicio': 45, 'fin': 250, 'u': 'px', 'propCSS': 'height'},
            {'inicio': 1, 'fin': 1, 'u': '', 'propCSS': 'opacity'}
        ], 200, true, desacelerado);
        setTimeout(function () {
            form.style.display = "block";
        }, 200)
    }
}

//Validacion del form del login
function validar_form_login() {
    var errorLogin = $('#errorLogin');
    var loginUser = $('#login_user');
    var loginPass = $('#login_pass');
    var login = document.getElementById("login");

    if ($("#inputUser").val() == "" || $("#inputPassword").val() == "") {
        errorLogin.load("templates/loginTemplate.mustache #plantilla_error", function () {
            var plantilla = document.getElementById('plantilla_error').innerHTML;
            loginUser.removeClass('has-warning');
            loginPass.removeClass('has-warning');

            if ($("#inputUser").val() == "") {
                errorLogin.html(Mustache.render(plantilla,
                    {icon: "fa-warning", class: "alert-warning", error: "Por favor, introduzca el usuario"}));
                loginUser.addClass('has-warning');
                fx(login, [
                    {'inicio': 280, 'fin': 280, 'u': 'px', 'propCSS': 'width'},
                    {'inicio': 250, 'fin': 320, 'u': 'px', 'propCSS': 'height'},
                    {'inicio': 1, 'fin': 1, 'u': '', 'propCSS': 'opacity'}
                ], 200, true, desacelerado);
                return false;

            }

            if ($("#inputPassword").val() == "") {
                errorLogin.html(Mustache.render(plantilla,
                    {icon: "fa-warning", class: "alert-warning", error: "Por favor, introduzca la contraseña"}));
                loginPass.addClass('has-warning');
                fx(login, [
                    {'inicio': 280, 'fin': 280, 'u': 'px', 'propCSS': 'width'},
                    {'inicio': 250, 'fin': 320, 'u': 'px', 'propCSS': 'height'},
                    {'inicio': 1, 'fin': 1, 'u': '', 'propCSS': 'opacity'}
                ], 200, true, desacelerado);
                return false;

            }
        });
    }
    errorLogin.html("");
    return true;
}

//Vista de cuando se esta logueado
function mostrar_login_ok(user) {
    var login = $("#login");

    if (have_credentiales()) {
        login.load("templates/loginTemplate.mustache #plantilla_login_ok", function () {
            var plantilla = document.getElementById("plantilla_login_ok").innerHTML;
            login.html(Mustache.render(plantilla.replace('&gt;', '>'), user, partial_img_perfil));
            login.css('width', '260px');
            login.css('height', '105px');
            login.css('top', '-60px');
        });
    }
}
//Vista de cuando no se esta logueado
function mostrar_logout() {
    var login = $("#login");

    if (!have_credentiales()) {
        login.load("templates/loginTemplate.mustache #plantilla_logout", function () {
            var plantilla = document.getElementById("plantilla_logout").innerHTML;
            login.html(Mustache.render(plantilla));
            login.css('width', '100px');
            login.css('height', '45px');
            login.css('top', '0px');
        })
    } else {
        $.cookie.json = true;
        var usuarioObj = JSON.parse(localStorage.getItem('usuarioObj'));
        $.cookie.json = false;
        mostrar_login_ok(usuarioObj);
    }
}

/**********************************************************/
/***************** CRUD de productos **********************/
/**********************************************************/

function datosForm(form) {
    var inputs = $(form + " input");
    var datos = {
        'desc': $(form + " textarea").val()
    };
    for (var i = 0; i < inputs.length; i++) {
        datos[inputs[i].id.replace('_input', '')] = inputs[i].value;
    }
    return datos;
}

/**********************************************************/
/***************** Gestion de credenciales ****************/
/**********************************************************/

//Comprobamos si hay credenciales guardadas y si son validas
function have_credentiales() {
    //Comprobamos si esta en local, sino buscamos en la cookie y las guardamos en local
    var items = ['token', 'usuarioObj', 'usuario'];
    var aux = true;

    for (var i = 0; i < items.length; i++) {
        if (localStorage.getItem(items[i]) == null || localStorage.getItem(items[i]) == "undefined")
            aux = false;
    }

    if (aux == false) {
        var arrayCookie = [];
        aux = true;
        for (var i = 0; i < items.length; i++) {
            arrayCookie[i] = $.cookie(items[i]);
            if (arrayCookie[i] == null)
                aux = false;
        }
        //Si todo esta correcto en la cookie la guardamos en local
        if (aux) {
            for (var i = 0; i < items.length; i++) {
                localStorage.setItem(items[i], arrayCookie[i]);
            }
        } else {
            delete_credenciales()
        }
    }

    return aux;
}
//Borramos todas las credenciales del programa
function delete_credenciales() {
    localStorage.removeItem('usuario');
    localStorage.removeItem('usuarioObj');
    localStorage.removeItem('token');
    $.removeCookie('usuario');
    $.removeCookie('usuarioObj');
    $.removeCookie('token');
}

/**********************************************************/
/***************** Animacion de los menus *****************/
/**********************************************************/

function transicion(curva, ms, callback) {
    this.ant = 0.01;
    var _this = this;
    this.start = new Date().getTime();
    this.init = function () {
        setTimeout(function () {
            if (!_this.next()) {
                callback(1);
                _this.done_ = true;
                window.globalIntervalo = 0;
                return;
            }
            callback(_this.next());
            _this.init();
        }, 13);
    };
    this.next = function () {
        var now = new Date().getTime();
        if ((now - this.start) > ms)
            return false;
        return this.ant = curva((now - this.start + .001) / ms, this.ant);
    }
}
function fx(obj, efectos, ms, cola, curva) {
    if (!window.globalIntervalo)
        window.globalIntervalo = 1;
    else {
        if (cola)
            return setTimeout(function () {
                fx(obj, efectos, ms, cola, curva)
            }, 30);
        else
            return;
    }
    var t = new transicion(
        curva, ms, function (p) {
            for (var i = 0; efectos[i]; i++) {
                if (efectos[i].fin < efectos[i].inicio) {
                    var delta = efectos[i].inicio - efectos[i].fin;
                    obj.style[efectos[i].propCSS] = (efectos[i].inicio - (p * delta)) + efectos[i].u;
                    if (efectos[i].propCSS == 'opacity') {
                        obj.style.zoom = 1;
                        obj.style.MozOpacity = (efectos[i].inicio - (p * delta));
                        obj.style.KhtmlOpacity = (efectos[i].inicio - (p * delta));
                        obj.style.filter = 'alpha(opacity=' + 100 * (efectos[i].inicio - (p * delta)) + ')';
                    }
                }
                else {
                    var delta = efectos[i].fin - efectos[i].inicio;
                    obj.style[efectos[i].propCSS] = (efectos[i].inicio + (p * delta)) + efectos[i].u;
                    if (efectos[i].propCSS == 'opacity') {
                        obj.style.zoom = 1;
                        obj.style.MozOpacity = (efectos[i].inicio + (p * delta));
                        obj.style.KhtmlOpacity = (efectos[i].inicio + (p * delta));
                        obj.style.filter = 'alpha(opacity=' + 100 * (efectos[i].inicio + (p * delta)) + ')';
                    }
                }
            }

        });
    t.init();
    t = null;
}
function desacelerado(p, ant) {
    var maxValue = 1, minValue = .001, totalP = 1, k = .25;
    var delta = maxValue - minValue;
    return minValue + (Math.pow(((1 / totalP) * p), k) * delta); //stepp
}