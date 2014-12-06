/**
 * Created by josrom on 2/12/14.
 */

describe("Suite de test para la pagina principal", function () {
    it("Cargar header", function () {
        //Cargamos la cabecera
        expect($("header")).not.toBeUndefined();
        //TODO hacer algun test
        //expect($("header>#inicio>div>#titulo").html()).toHaveText('CARNICERIA CHARCUTERIA')
    });
});
