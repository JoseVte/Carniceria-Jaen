/**
 * Created by josrom on 18/11/14.
 */
window.onload = function(){
    mostrar_logout();
    get_ofertas();
    get_productos();
};

//TODO Mirar como cargar las funciones despues de cargar el menu

function login_mostrar() {
    document.getElementById("form_login").style.display = "block";
    $("#button_login").click(login);
}

function login_ocultar(){
        document.getElementById("form_login").style.display="none";
}

function mostrar_login_ok(user){
    var token = localStorage.getItem('token');

    //TODO Meter una plantilla para el login
    if(token != null){
        $("#login").load("templates/loginTemplate.mustache #plantilla_login_ok", function() {
            var plantilla = document.getElementById("plantilla_login_ok").innerHTML;
            $("#login").html(Mustache.render(plantilla,user));
            $("#login").unbind("mouseover");
            $("#login").unbind("mouseout");
        });
    }
}

function mostrar_logout(){
    $("#login").load("templates/loginTemplate.mustache #plantilla_logout", function() {
        var plantilla = document.getElementById("plantilla_logout").innerHTML;
        $("#login").html(Mustache.render(plantilla));
        $("#login").mouseover(login_mostrar);
        $("#login").mouseout(login_ocultar);
    })
}