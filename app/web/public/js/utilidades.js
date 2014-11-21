/**
 * Created by josrom on 18/11/14.
 */
$(document).ready(function(){
    mostrar_logout();
    principal();
    $(document).on('click', "#inicio", principal);
    $(document).on('click', "#button_login", login);
    $(document).on('click', "#button_open_registro", open_registro);
    $(document).on('click', "#button_registrarse", registro_completado);
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

//Vista de formulario de registro
function open_registro(){
    toggle_login();
    $("#body").load("templates/registroTemplate.mustache #plantilla_registro", function() {
        var plantilla = document.getElementById("plantilla_registro").innerHTML;
        $("#body").html(Mustache.render(plantilla));
    })
}

//Vista cuando se ha registrado correctamente
function registro_completado(){
    $("#body").load("templates/registroTemplate.mustache #plantilla_redir", function() {
        var plantilla = document.getElementById("plantilla_redir").innerHTML;
        $("#body").html(Mustache.render(plantilla));
        //setTimeout ("principal()", 3000); //tiempo en milisegundos
    })
}

//Animacion para mostrar-ocultar el menu de login
function toggle_login() {
    var form = document.getElementById("form_login");
    var login = document.getElementById("login");

    if(form.style.display == "block"){
        setTimeout(function(){form.style.display = "none";},0);
        fx(login,[
            {'inicio':260,'fin':100,'u':'px','propCSS':'width'},
            {'inicio':250,'fin':45,'u':'px','propCSS':'height'},
            {'inicio':1,'fin':1,'u':'','propCSS':'opacity'}
        ],1000,true,desacelerado);
    }else{
        fx(login,[
            {'inicio':100,'fin':260,'u':'px','propCSS':'width'},
            {'inicio':45,'fin':250,'u':'px','propCSS':'height'},
            {'inicio':1,'fin':1,'u':'','propCSS':'opacity'}
        ],1000,true,desacelerado);
        setTimeout(function(){form.style.display = "block";},1000)
    }
}

//Vista de cuando se esta logueado
function mostrar_login_ok(user){
    var token = localStorage.getItem('token');

    if(token != null){
        $("#login").load("templates/loginTemplate.mustache #plantilla_login_ok", function() {
            var plantilla = document.getElementById("plantilla_login_ok").innerHTML;
            $("#login").html(Mustache.render(plantilla,user));
            $("#login").css('width','260px');
            $("#login").css('height','105px');
            $("#login").css('top','-60px');
        });
    }
}

//Vista de cuando no se esta logueado
function mostrar_logout(){
    var token = localStorage.getItem('token');
    var recordar = localStorage.getItem('recordar')

    if(token == null && recordar == null){
        $("#login").load("templates/loginTemplate.mustache #plantilla_logout", function() {
            var plantilla = document.getElementById("plantilla_logout").innerHTML;
            $("#login").html(Mustache.render(plantilla));
            $("#login").css('width','100px');
            $("#login").css('height','45px');
            $("#login").css('top','0px');
        })
    }else{
        mostrar_login_ok(JSON.parse(localStorage.getItem('usuarioObj')));
    }
}


//Funcion para mostrar el panel
function transicion(curva,ms,callback){
    this.ant=0.01;
    this.done_=false;
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
    }
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