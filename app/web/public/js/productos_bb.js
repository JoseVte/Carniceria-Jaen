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
        "all/:url": "all",
        "producto/:id": "show",
        "ofertas": "ofertas",
        "search/:cadena": "search",
        "crud": "crud",
        "new": "crear",
        "update": "update",
        "delete": "delete"
    },
    all: function (url) {
        url || (url = "/api/producto/all");
        var datosProductos = new Catalogo();
        datosProductos.url = url;
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
    },
    search: function (cadena) {
        var model = new Catalogo();
        var datosBusqueda = model.filtrar_por_nombre(cadena);
        datosBusqueda.fetch({
            success: function () {
                var productos = new CatalogoView();
                productos.productos = datosBusqueda;
                productos.render();
            }
        })
    },
    crud: function (url) {
        url || (url = "/api/producto/all");
        var model = new Catalogo();
        model.url = url;
        model.fetch({
            success: function () {
                var productos = new CRUDView();
                productos.productos = model;
                productos.render();
            }
        })
    },
    crear: function () {
    },
    update: function () {
    },
    delete: function () {
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
        productoRouter.navigate('producto/' + e.currentTarget.id.slice(4));
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
        var filtered = this.filter(function (modelo) {
            return modelo.get('nombre').indexOf(cadena) >= 0
        });
        return new Producto(filtered);
    }
});
var CatalogoView = Backbone.View.extend({
    el: "#productos",
    url_template: 'templates/productoTemplate.mustache',
    id_template: '#plantilla_paginacion',
    partial: partial_img_productos,
    events: {
        'click main>div>a': 'detail',
        'click #next>a': 'pagina',
        'click #self>a': 'pagina',
        'click #prev>a': 'pagina'
    },
    detail: function (e) {
        e.preventDefault();
        productoRouter.navigate('producto/' + e.currentTarget.id.slice(4));
        productoRouter.show(e.currentTarget.id.slice(4));
    },
    pagina: function (e) {
        e.preventDefault();
        var url = e.currentTarget.href.replace("javascript:", '').replace("get_productos_url", '').replace("('", '').replace("')", '');
        productoRouter.navigate('all/' + url.replace("/api/producto/all", ''));
        productoRouter.all(url);
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

/**********************************************************/
/***************** CRUD de productos **********************/
/**********************************************************/

var CRUDView = Backbone.View.extend({
    el: "#body",
    url_template: 'templates/CRUDTemplate.mustache',
    id_template: '#menu',
    modal_template: '#modal_generic',
    partial: partial_img_productos,
    events: {
        'click #crear>a': 'crear',
        'click .detail>button': 'detail',
        'click .update>button': 'update',
        'click .delete>button': 'delete'
    },
    crear: function (e) {
    },
    detail: function (e) {
        var button = e.currentTarget;
        var accion = button.dataset.action;
        var id = button.dataset.id;
        var that = this;

        $.get('/api/producto/' + id).success(function (data) {
            that.$el.load(that.url_template, function () {
                that.template = $(accion).html().replace('&gt;', '>');
                that.$el.html(Mustache.render(that.template, data));
            });
            return that;
        });
    },
    update: function (e) {
        var button = e.currentTarget;
        var accion = button.dataset.action;
        var id = button.dataset.id;
        var that = this;

        $.get('/api/producto/' + id).success(function (data) {
            that.$el.load(that.url_template, function () {
                that.template = $(accion).html().replace('&gt;', '>');
                that.$el.html(Mustache.render(that.template, data, partial_img_productos));
            });
            return that;
        });
    },
    delete: function (e) {
    },
    render: function () {
        var that = this;
        this.$el.load(this.url_template, function () {
            that.template = $(that.id_template).html().replace('&gt;', '>');
            that.partial.funcion = "productoRouter.crud";
            that.$el.html(Mustache.render(that.template, that.productos.toJSON()[0], that.partial));
        });
        return this;
    }
});
