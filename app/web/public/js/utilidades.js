/**
 * Created by josrom on 18/11/14.
 */
window.onload = function(){
    menu_login("ocultar");
    get_ofertas();
    get_productos();
};

function menu_login(accion){
    if(accion=="mostrar")
        document.getElementById("form_login").style.display="block";

    if(accion=="ocultar")
        document.getElementById("form_login").style.display="none";
}