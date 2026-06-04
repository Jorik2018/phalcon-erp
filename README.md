Si tu MySQL ya está corriendo en otro contenedor Podman, lo mejor es que ambos estén en la misma red.

1. Crear una red (una sola vez)
podman network create erp-net
2. Levantar MySQL en esa red

Si ya existe, revisa que esté conectado a erp-net.

Ejemplo:

podman run -d \
  --name mysql \
  --network erp-net \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=erp \
  mysql:8
3. Lanzar Phalcon en la misma red
podman run -d \
  --name phalcon-erp \
  --network erp-net \
  -p 8080:80 \
  -e DB_HOST=mysql \
  -e DB_PORT=3306 \
  -e DB_NAME=erp \
  -e DB_USER=root \
  -e DB_PASS=secret \
  tu_usuario/phalcon-erp:latest

La clave es:

DB_HOST=mysql

porque dentro de la red erp-net, el nombre del contenedor funciona como hostname.

Si tu MySQL ya está corriendo

Verifica el nombre:

podman ps

Ejemplo:

CONTAINER ID   NAMES
abc123         mysql-local
def456         phalcon-erp

Entonces usarías:

DB_HOST=mysql-local

si ambos están en la misma red.

Verificar que se vean entre sí
podman exec -it phalcon-erp bash

Dentro del contenedor:

getent hosts mysql

o

ping mysql

(dependiendo de qué utilidades tenga la imagen).

Si el contenedor MySQL ya existe y está en otra red

Puedes conectarlo:

podman network connect erp-net mysql

y luego arrancar Phalcon en esa misma red.

Revisa la configuración del template

Phalcon suele tener algo como:

'host' => getenv('DB_HOST'),
'dbname' => getenv('DB_NAME'),
'username' => getenv('DB_USER'),
'password' => getenv('DB_PASS'),

o un archivo .env.

Si me muestras el config.php, services.php o .env generado por el template, te digo exactamente qué variables debes pasar al podman run.


Luego lanza tu app así, usando el nombre real del contenedor MySQL:

podman run -d \
  --name phalcon-erp \
  --network erp-net \
  -p 8080:80 \
  -e DB_HOST=mysql \
  -e DB_PORT=3306 \
  -e DB_NAME=test \
  -e DB_USER=root \
  -e DB_PASS=tu_password \
  tu_usuario/phalcon-erp:latest

Si tu contenedor MySQL se llama, por ejemplo, mysql-local, usa:

-e DB_HOST=mysql-local

Y ambos deben estar en la misma red:

podman network connect erp-net mysql
podman network connect erp-net phalcon-erp

Después abres:

http://localhost:8080