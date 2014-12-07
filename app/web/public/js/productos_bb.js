/**
 * Created by josrom on 2/12/14.
 */
var Producto = Backbone.Model.extend({
    urlRoot: '../api/producto',
    defaults: {
        stock: 0,
        ofertas: false,
        rebaja: 0.0,
        url_imagen: 'img/missing_prod.png'
    },
    validate: function (attrs) {
        var errores = [];
        if (!attrs.nombre)
            errores.push("Falta nombre");
        if (!attrs.precioKg)
            errores.push("Faltan precioKg");
        if (errores.length > 0)
            return errores;
    },
    crear: function () {
        return this.save(null, {
            success: function (model, response, opts) {
                console.log('Producto ' + model.id + ' creado correctamente')
            },
            error: function (model, xhr, opts) {
                console.log("Error al crear, status: " + xhr.status + " response: " + xhr.responseText)
            }
        })
    }
});

var ProductoRouter = Backbone.Router.extend({
    routes: {
        "producto": "root",
        "producto/:id": "show",
        "producto/ofertas": "ofertas"
    },
    root: function () {
        var datosProductos = new Catalogo();
        datosProductos.fetch({
            success: function () {
                var productos = new CatalogoView();
                productos.productos = datosProductos;
                productos.render();
            }
        });
    },
    show: function (id) {
        var datosProducto = new Producto({id: id});
        datosProducto.fetch({
            success: function (datos) {
                var detalles = new DetallesProducto();
                detalles.datos = datos;
                detalles.render();
            },
            fail: function (xhr) {
                console.log(xhr.responseText)
            }
        });
    },
    ofertas: function () {
        var datosOfertas = new Ofertas();
        datosOfertas.fetch({
            success: function () {
                var ofertas = new OfertasView();
                ofertas.ofertas = datosOfertas;
                ofertas.render();
            }
        });
    }
});

/**********************************************************/
/***************** Productos en oferta ********************/
/**********************************************************/

var Ofertas = Backbone.Collection.extend({
    model: Producto,
    url: "../api/producto/ofertas"
});
var OfertasView = Backbone.View.extend({
    el: '#ofertas',
    url_template: 'templates/productoTemplate.mustache',
    id_template: '#plantilla_ofertas',
    partial: partial_img_productos,
    events: {
        'click a': 'detail'
    },
    detail: function (e) {
        e.preventDefault();
        productoRouter.show(e.currentTarget.id.slice(4));
    },
    render: function () {
        var that = this;
        this.$el.load(this.url_template, function () {
            that.template = $(that.id_template).html().replace('&gt;', '>');
            that.$el.html(Mustache.render(that.template, that.ofertas.toJSON(), that.partial));
        });
        return this;
    }
});

/**********************************************************/
/***************** Todos los productos ********************/
/**********************************************************/

var Catalogo = Backbone.Collection.extend({
    model: Producto,
    url: "../api/producto/all",
    filtrar_por_nombre: function (cadena) {
        return this.filter(function (modelo) {
            return modelo.get('nombre').indexOf(cadena) >= 0
        })
    }
});
var CatalogoView = Backbone.View.extend({
    el: "#productos",
    url_template: 'templates/productoTemplate.mustache',
    id_template: '#plantilla_paginacion',
    partial: partial_img_productos,
    events: {
        'click div>a': 'detail',
        'click #productos>a': 'pagina'
    },
    detail: function (e) {
        e.preventDefault();
        productoRouter.show(e.currentTarget.id.slice(4));
    },
    pagina: function (e) {
        e.preventDefault();
        console.log(e.currentTarget.value)
    },
    render: function () {
        var that = this;
        this.$el.load(this.url_template, function () {
            that.template = $(that.id_template).html().replace('&gt;', '>');
            that.$el.html(Mustache.render(that.template, that.productos.toJSON()[0], that.partial));
        });
        return this;
    }
});

/**********************************************************/
/***************** Detalles de un producto ****************/
/**********************************************************/

var DetallesProducto = Backbone.View.extend({
    el: '#body',
    url_template: 'templates/productoTemplate.mustache',
    id_template: '#plantilla_detalles',
    partial: partial_img_detalles,
    render: function () {
        var that = this;
        this.$el.load(this.url_template, function () {
            that.template = $(that.id_template).html().replace('&gt;', '>');
            that.$el.html(Mustache.render(that.template, that.datos.toJSON(), that.partial));
        });
        return this;
    }
});