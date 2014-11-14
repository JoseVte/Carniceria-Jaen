# Carniceria Jáen #

* Se trata de una aplicacion Web la cual permite al usuario __mirar todos los productos__ y los que estan en __oferta__, y una vez logeado puedes __añadir a un carrito__ y __eliminar del carrito__.

## Acceso a la API

* Los usuarios __no registrados__ solo pueden acceder a:
    * **API de productos**:
        * __ofertas__
        * __todos los productos__
        * __buscar varios productos por nombre__
        * __datos de un productos__
    * **API de proovedores**:
        * __todos los proovedores__
        * __buscar varios proovedores por cualquier campo__
        * __datos de un proovedor__
* Los usuarios __registrados sin acceso ADMIN__ pueden acceder a las funciones anteriores, y ademas a las siguientes:
    * **API de carritos**: todas las funciones de __su carrito__
    * **API de usuarios**: todas las funciones de __su usuario__
* Los usuarios __registrados con acceso ADMIN__ pueden acceder a todas las funcionalidades de la API:
    * **API de usuarios**: todas las funciones de __todos los usuarios__
    * **API de productos**: todas las funciones de __administracion de productos__
    * **API de carritos**: todas las funciones de __todos los carritos__
    * **API de proovedores**: todas las funciones de __administracion de prooverdores__

## Producto
API de productos.

### Ofertas
Devuelve los productos que estan de oferta en `JSON`:  
```
get '{host}/api/producto/ofertas'
```
### Busqueda
Devuelve una lista de productos que cumplen el criterio de busqueda:  
```
get '{host}/api/producto/buscar/:subcadena'
```
### Todos los productos
Devuelve todos los productos:  
```
get '{host}/api/producto/all'
```
### Productos en detalle
Devuelve los datos de un productos a partir de su `id`:  
```
get '{host}/api/producto/:id'
```

### Crear producto
Se debe ser __Administrador__. Crea un nuevo producto:  
```
post '{host}/api/producto/new'
```
### Actualizar producto
Se debe ser __Administrador__. Actualiza los datos de un producto:  
```
post '{host}/api/producto/update'
```
### Borrar producto
Se debe ser __Administrador__. Borra un producto:  
```
delete '{host}/api/producto/:id'
```

## Usuario
API de usuarios.

### Crear usuario
Se utiliza para __registrarse__. Crea un nuevo usuario:  
```
post '{host}/api/usuario/new'
```
### Login
Se utiliza para __loguearse__. Devuelve un token para usarlo como login:    
```
post '{host}/api/autentificacion/login'
```
### Logout
Se utiliza para __desloguearse__. Se desloguea de la aplicacion:     
```
get '{host}/api/autentificacion/logout'
```

### Todos los usuarios
Se debe ser __Administrador__. Devuelve todos los usuarios:  
```
get '{host}/api/usuario/all'
```
### Usuarios en detalle
Se debe estar __registrado__. Muestra el usuario actual:  
```
get '{host}/api/usuario/:user'
```
### Actualizar usuario
Se debe estar __registrado__. Modifica el usuario actual:  
```
post '{host}/api/usuario/update'
```
### Borrar usuario
Se debe estar __registrado__. Borra el usuario actual:  
```
delete '{host}/api/usuario/:user'
```

## Carrito
API de carritos.

### Todo el carrito
Se debe estar __registrado__. Muestra el carrito del usuario actual:  
```
get '{host}/api/usuario/:user/carrito'
```
### Añadir al carrito
Se debe estar __registrado__. Añade un producto al carrito del usuario actual:  
```
post '{host}/api/usuario/:user/carrito'
```
### Borrar en el carrito
Se debe estar __registrado__. Elimina un producto del carrito del usuario actual:  
```
delete '{host}/api/usuario/:user/carrito'
```
## Proovedor
API de proovedores.

### Busqueda
Devuelve una lista de proovedores que cumplen el criterio de busqueda:  
```
get '{host}/api/proovedor/buscar/:campo/:cadena'
```
### Todos los proovedores
Devuelve todos los proovedores:  
```
get '{host}/api/proovedor/all'
```
### Proovedores en detalle
Devuelve los datos de un proovedores a partir de su `id`:  
```
get '{host}/api/proovedor/:id'
```

### Crear proovedor
Se debe ser __Administrador__. Crea un nuevo proovedor:  
```
post '{host}/api/proovedor/new'
```
### Actualizar proovedor
Se debe ser __Administrador__. Actualiza los datos de un proovedor:  
```
post '{host}/api/proovedor/update'
```
### Borrar proovedor
Se debe ser __Administrador__. Borra un proovedor:  
```
delete '{host}/api/proovedor/:id'
```
