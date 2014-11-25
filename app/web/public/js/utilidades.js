/**
 * Created by josrom on 18/11/14.
 */
$(document).ready(function(){
    mostrar_logout();
    principal();
    $(document).on('click', "#inicio", principal);
    $(document).on('click', "#button_login", login);
    $(document).on('click', "#button_open_registro", mostrar_registro_parte_1);
    $(document).on('click', "#button_registro_parte_1", validar_registro_parte_1);
    $(document).on('click', "#click_login", toggle_login);
});

//Carga la vista principal
function principal(){
    $("#body").load("templates/inicioTemplate.mustache #plantilla_inicio", function() {
        var plantilla = document.getElementById("plantilla_inicio").innerHTML;
        $("#body").html(Mustache.render(plantilla));
        get_ofertas();
        get_productos();
    })
}

//Vista de la primera parte formulario de registro
function mostrar_registro_parte_1(){
    toggle_login();
    $("#body").load("templates/registroTemplate.mustache #plantilla_registro", function() {
        var plantilla = document.getElementById("plantilla_registro").innerHTML;
        $("#body").html(Mustache.render(plantilla));
    })
}

//Valida los datos de la primera parte del registro
function validar_registro_parte_1(e){
    e.preventDefault();
    var correcto = true,campo;
    var arrayDatos = new Array();
    var arrayForm = new Array();
    arrayForm['user'] = 'Escriba el nombre de usuario';
    arrayForm['pass'] = 'Escriba la contraseña';
    arrayForm['pass_2'] = 'Escriba la confimacion de la contraseña';
    arrayForm['email'] = 'Escriba el email de contacto';

    for(campo in arrayForm){
        var valorCampo = $("#input_"+campo+"_registro").val();
        var helper = $("#help_"+campo);
        var icon = $("#icon_help_"+campo);

        helper.html("");
        helper.removeClass("alert alert-warning alert-error");
        icon.removeClass("glyphicon-warning-sign glyphicon-remove");

        if(valorCampo == ""){
            helper.html(arrayForm[campo]);
            helper.addClass("alert alert-warning");
            icon.addClass("glyphicon-warning-sign");
        } else {
            arrayDatos[campo] = valorCampo;
            switch(campo){
                case 'user':
                    user_exist(valorCampo);
                    break;
                case 'pass':
                case 'pass_2':
                    if($("#input_pass_registro").val() != "" &&  $("#input_pass_2_registro").val() != "") {
                        if ($("#input_pass_registro").val() != $("#input_pass_2_registro").val()) {
                            helper.html("Las contraseñas deben coincidir");
                            helper.addClass("alert alert-danger");
                            icon.addClass("glyphicon-remove");
                        }
                    }
                    break;
                case 'email':
                    var regExp = /[\w-\.]{3,}@([\w-]{2,}\.)*([\w-]{2,}\.)[\w-]{2,4}/;
                    if(!valorCampo.match(regExp)){
                        helper.html("Introduzca un email valido");
                        helper.addClass("alert alert-danger");
                        icon.addClass("glyphicon-remove");
                    }else{
                        email_exist(valorCampo);
                    }
                    break;
            }
        }

        correcto = (helper.html() == "")
    }

    if(correcto){
        mostrar_registro_parte_2(arrayDatos)
    }
}

//Vista de la segunda parte del formulario
function mostrar_registro_parte_2(datosParte1){
    registro_completado();
}

//Vista cuando se ha registrado correctamente
function registro_completado(){
    $("#body").load("templates/registroTemplate.mustache #plantilla_redir", function() {
        var plantilla = document.getElementById("plantilla_redir").innerHTML;
        $("#body").html(Mustache.render(plantilla));
        setTimeout ("principal()", 3000); //tiempo en milisegundos
    })
}

//Animacion para mostrar-ocultar el menu de login
function toggle_login() {
    var form = document.getElementById("form_login");
    var login = document.getElementById("login");

    if(form.style.display == "block"){
        setTimeout(function(){form.style.display = "none";},0);
        $('#errorLogin').html("");
        $('#login_user').removeClass('has-warning');
        $('#login_pass').removeClass('has-warning');
        fx(login,[
            {'inicio':280,'fin':100,'u':'px','propCSS':'width'},
            {'inicio':250,'fin':45,'u':'px','propCSS':'height'},
            {'inicio':1,'fin':1,'u':'','propCSS':'opacity'}
        ],200,true,desacelerado);
    }else{
        fx(login,[
            {'inicio':100,'fin':280,'u':'px','propCSS':'width'},
            {'inicio':45,'fin':250,'u':'px','propCSS':'height'},
            {'inicio':1,'fin':1,'u':'','propCSS':'opacity'}
        ],200,true,desacelerado);
        setTimeout(function(){form.style.display = "block";},200)
    }
}

//Comprobamos si hay credenciales guardadas y si son validas
function have_credentiales(){
    //Comprobamos si esta en local, sino buscamos en la cookie y las guardamos en local
    var arrayLocal = [localStorage.getItem('token'),localStorage.getItem('usuarioObj'),localStorage.getItem('usuario')];

    var item,aux = true;
    for(item in arrayLocal){
        if(arrayLocal[item] == null || arrayLocal [item] == "undefined")
            aux = false;
    }

    if(aux == false){
        var arrayCookie = new Array();
        arrayCookie['usuario'] = $.cookie('usuario');
        arrayCookie['token'] = $.cookie('token');
        $.cookie.json = true;
        arrayCookie['usuarioObj'] = $.cookie('usuarioObj');
        $.cookie.json = false;
        aux = true;

        for(item in arrayCookie){
            if(arrayCookie[item] == null)
                aux = false;
        }

        //Si todo esta correcto en la cookie la guardamos en local
        if(aux){
            localStorage.setItem('usuario',arrayCookie['usuario']);
            localStorage.setItem('usuarioObj',JSON.stringify(arrayCookie['usuarioObj']));
            localStorage.setItem('token',arrayCookie['token']);
        }else{
            delete_credenciales()
        }
    }

    return aux;
}

//Borramos todas las credenciales del programa
function delete_credenciales(){
    localStorage.removeItem('usuario');
    localStorage.removeItem('usuarioObj');
    localStorage.removeItem('token');
    $.removeCookie('usuario');
    $.removeCookie('usuarioObj');
    $.removeCookie('token');
}

//Vista de cuando se esta logueado
function mostrar_login_ok(user){
    var login = $("#login");

    if(have_credentiales()){
        login.load("templates/loginTemplate.mustache #plantilla_login_ok", function() {
            var plantilla = document.getElementById("plantilla_login_ok").innerHTML;
            var partial = {img_perfil: '<img src="{{url_imagen}}" class="img-circle" height="48px" width="48px">'}
            login.html(Mustache.render(plantilla.replace('&gt;','>'),user,partial));
            login.css('width','260px');
            login.css('height','105px');
            login.css('top','-60px');
        });
    }
}

//Vista de cuando no se esta logueado
function mostrar_logout(){
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

//Validacion del form del login
function validar_form() {
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

//Funcion para mostrar el panel
function transicion(curva,ms,callback){
    this.ant=0.01;
    var _this=this;
    this.start=new Date().getTime();
    this.init=function(){
        setTimeout(function(){
            if(!_this.next()){
                callback(1);
                _this.done_=true;
                window.globalIntervalo=0;
                return;
            }
            callback(_this.next());
            _this.init();
        },13);
    };
    this.next=function(){
        var now=new Date().getTime();
        if((now-this.start)>ms)
            return false;
        return this.ant=curva((now-this.start+.001)/ms,this.ant);
    }
}

function fx(obj,efectos,ms,cola,curva){
    if(!window.globalIntervalo)
        window.globalIntervalo=1;
    else {
        if(cola)
            return setTimeout(function(){fx(obj,efectos,ms,cola,curva)},30);
        else
            return;
    }
    var t=new transicion(
        curva,ms,function(p){
            for (var i=0;efectos[i];i++){
                if(efectos[i].fin<efectos[i].inicio){
                    var delta=efectos[i].inicio-efectos[i].fin;
                    obj.style[efectos[i].propCSS]=(efectos[i].inicio-(p*delta))+efectos[i].u;
                    if(efectos[i].propCSS=='opacity'){
                        obj.style.zoom=1;
                        obj.style.MozOpacity = (efectos[i].inicio-(p*delta));
                        obj.style.KhtmlOpacity = (efectos[i].inicio-(p*delta));
                        obj.style.filter='alpha(opacity='+100*(efectos[i].inicio-(p*delta))+')';
                    }
                }
                else{
                    var delta=efectos[i].fin-efectos[i].inicio;
                    obj.style[efectos[i].propCSS]=(efectos[i].inicio+(p*delta))+efectos[i].u;
                    if(efectos[i].propCSS=='opacity'){
                        obj.style.zoom=1;
                        obj.style.MozOpacity = (efectos[i].inicio+(p*delta));
                        obj.style.KhtmlOpacity = (efectos[i].inicio+(p*delta));
                        obj.style.filter='alpha(opacity='+100*(efectos[i].inicio+(p*delta))+')';
                    }
                }
            }

        });
    t.init();
    t=null;
}

function desacelerado(p,ant){
    var maxValue=1, minValue=.001, totalP=1, k=.25;
    var delta = maxValue - minValue;
    var stepp = minValue+(Math.pow(((1 / totalP) * p), k) * delta);
    return stepp;
}