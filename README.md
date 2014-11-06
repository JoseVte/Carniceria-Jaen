# Carniceria Jáen #

* Se trata de una aplicacion Web la cual permite al usuario __mirar todos los productos__ y los que estan en __oferta__, y una vez logeado puedes __añadir a un carrito__ y __eliminar del carrito__.

## Acceso a la API

* Los usuarios __no registrados__ solo pueden acceder a las funciones de __ofertas__, __all__, __buscar__ y __productos detallado__ de la API de productos.
* Los usuarios __registrados sin acceso ADMIN__ pueden acceder a las funciones anteriores, y ademas a las siguientes:
>* API carritos para su carrito
>* Ver su propio usuario
* Los usuarios __registrados con acceso ADMIN__ pueden acceder a todas las funcionalidades de la API:
>* API de usuarios entera
>* API de productos entera
>* API de carritos entera

## Producto
API de productos.

### Ofertas
Devuelve los productos que estan de oferta en `JSON`:  
```
get '/ofertas'
```
### Busqueda
Devuelve una lista de productos que cumplen el criterio de busqueda:  
```
get '/buscar/:subcadena'
```
### Todos los productos
Devuelve todos los productos:  
```
get '/all'
```
### Productos en detalle
Devuelve los datos de un productos a partir de su `id`:  
```
get '/:id'
```

### Crear producto
Se debe ser __Administrador__. Crea un nuevo producto:  
```
post '/new'
```
### Actualizar producto
Se debe ser __Administrador__. Actualiza los datos de un producto:  
```
post '/update'
```
### Borrar producto
Se debe ser __Administrador__. Borra un producto:  
```
delete '/:id'
```

## Usuario
API de usuarios

### Todos los usuarios
Se debe ser __Administrador__. Devuelve todos los usuarios:  
```
get '/all'
```
### Usuarios en detalle
Se debe estar __registrado__. Muestra el usuario actual:  
```
get '/:user'
```
### Crear usuario
Se utiliza para __registrarse__. Crea un nuevo usuario:  
```
post '/new'
```
### Actualizar usuario
Se debe estar __registrado__. Modifica el usuario actual:  
```
post '/update'
```
### Borrar usuario
Se debe estar __registrado__. Borra el usuario actual:  
```
delete '/:user'
```

## Carrito
API de carritos.

### Todo el carrito
Se debe estar __registrado__. Muestra el carrito del usuario actual:  
```
get '/:user/carrito'
```
### Añadir al carrito
Se debe estar __registrado__. Añade un producto al carrito del usuario actual:  
```
post '/:user/carrito'
```
### Borrar en el carrito
Se debe estar __registrado__. Elimina un producto del carrito del usuario actual:  
```
delete '/:user/carrito'
```
## Proovedor
API de proovedores.

### Busqueda
Devuelve una lista de proovedores que cumplen el criterio de busqueda:  
```
get '/buscar/:campo/:cadena'
```
### Todos los proovedores
Devuelve todos los proovedores:  
```
get '/all'
```
### Proovedores en detalle
Devuelve los datos de un proovedores a partir de su `id`:  
```
get '/:id'
```

### Crear proovedor
Se debe ser __Administrador__. Crea un nuevo proovedor:  
```
post '/new'
```
### Actualizar proovedor
Se debe ser __Administrador__. Actualiza los datos de un proovedor:  
```
post '/update'
```
### Borrar proovedor
Se debe ser __Administrador__. Borra un proovedor:  
```
delete '/:id'
```
