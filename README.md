# ProyectoWebCine

## Descripción del proyecto

ProyectoWebCine es una aplicación web desarrollada en Java para la gestión de las operaciones de un cine. El sistema integra la administración de personal, venta de boletos, gestión de productos de confitería, control de inventario, historiales de ventas y estadísticas.

La aplicación utiliza una base de datos Microsoft SQL Server para almacenar y consultar la información.

## 1. Tecnologías utilizadas

- Java JDK 17

- Java Servlets y JSP

- HTML y CSS

- Gradle 8.6

- Apache Tomcat 9.0.118

- Microsoft SQL Server 2025 Developer Edition

- Microsoft JDBC Driver para SQL Server

- Apache NetBeans IDE 29 (entorno de desarrollo)

- Git y GitHub (control de versiones)

## 2. Funcionalidades principales

### Administrador

- Acceso al panel administrativo.

- Visualización de estadísticas generales.

- Administración y consulta de personal.

- Consulta de ventas realizadas.

- Gestión de productos e inventario.

- Consulta del historial de boletos.

- Generación de reportes y exportaciones disponibles.

### Cajero

- Inicio de sesión mediante una cuenta autorizada.

- Consulta de películas y funciones disponibles.

- Selección de asientos.

- Venta de boletos.

- Consulta y venta de productos de confitería.

## 3. Requisitos para ejecutar el proyecto

Antes de ejecutar el sistema es necesario contar con:

1. Java JDK 17 instalado.

2. Apache Tomcat 9 instalado.

3. Microsoft SQL Server instalado y en ejecución.

4. La base de datos confiteria creada y configurada.

5. Credenciales SQL con permisos adecuados sobre la base de datos.

6. Acceso a las dependencias configuradas mediante Gradle.

El proyecto fue probado localmente en Windows 11.

## 4. Estructura del proyecto

- src/main/java: clases Java, servlets, modelos y acceso a datos.

- src/main/webapp: páginas JSP, HTML y archivos CSS.

- database/01_schema.sql: script de estructura de la base de datos.

- gradle/wrapper: archivos del Gradle Wrapper.

- build.gradle: configuración de compilación y dependencias.

- gradlew.bat: ejecución de Gradle en Windows.

- .env.example: ejemplo de las variables de conexión requeridas.

- .gitignore: archivos y carpetas excluidos del repositorio.

## 5. Configuración de la base de datos

El proyecto utiliza Microsoft SQL Server y una base de datos denominada confiteria.

El archivo database/01_schema.sql contiene la estructura de las tablas y los objetos SQL necesarios para el sistema.

Este archivo no incluye los registros iniciales de la aplicación, como cuentas de usuario, productos o películas.

Para una instalación completamente nueva será necesario configurar dichos datos. La instalación desde cero todavía está pendiente de validación.

No ejecutar el script sobre una base de datos existente sin revisar previamente su contenido.

### Configuración de la conexión

Las clases de acceso a datos utilizan las siguientes variables de entorno:

DB_HOST: dirección del servidor SQL.

DB_PORT: puerto de conexión.

DB_NAME: nombre de la base de datos.

DB_USER: usuario de SQL Server.

DB_PASSWORD: contraseña del usuario SQL.

Las credenciales reales deben configurarse localmente y no deben incorporarse al repositorio.

## 6. Ejecución del proyecto en Windows

Los siguientes pasos describen la configuración utilizada durante el desarrollo.

Las rutas pueden cambiar si Java, Tomcat o el proyecto se encuentran instalados en otras ubicaciones.

### Paso 1. Abrir CMD

Presionar Windows + R.

Escribir cmd y presionar Enter.

Se abrirá el Símbolo del sistema de Windows.

### Paso 2. Ingresar a la carpeta del proyecto

Ejecutar:

cd /d "C:\\ProyectosVarios\\ProyectoWebCine_GitHub\\ModuloConfiteria"

### Paso 3. Configurar Java 17

Ejecutar los siguientes comandos por separado:

set "JAVA_HOME=C:\\Program Files\\Java\\jdk-17"

set "JRE_HOME=C:\\Program Files\\Java\\jdk-17"

set "PATH=%JAVA_HOME%\\bin;%PATH%"

Comprobar la versión instalada:

java -version

La versión utilizada durante el desarrollo es Java 17.0.12.

### Paso 4. Configurar Apache Tomcat

Ejecutar los siguientes comandos por separado:

set "CATALINA_HOME=C:\\apache-tomcat-9.0.118"

set "CATALINA_BASE=C:\\apache-tomcat-9.0.118"

Estas variables indican la ubicación del servidor Tomcat.

Las configuraciones realizadas mediante el comando set son temporales y se mantienen solamente en la ventana CMD actual.

### Paso 5. Configurar las credenciales SQL

En la instalación local de Tomcat se utiliza un archivo privado denominado setenv.bat.

Su ubicación es:

C:\\apache-tomcat-9.0.118\\bin\\setenv.bat

Este archivo permite proporcionar las variables de entorno al proceso de Tomcat cuando se inicia mediante sus scripts estándar.

Ejemplo de configuración, utilizando valores de referencia:

@echo off

set "DB_HOST=localhost"

set "DB_PORT=1433"

set "DB_NAME=confiteria"

set "DB_USER=USUARIO_SQL"

set "DB_PASSWORD=CONTRASENA_SQL"

Se deben reemplazar USUARIO_SQL y CONTRASENA_SQL por las credenciales correspondientes de SQL Server.

El archivo real debe permanecer fuera del repositorio y mantenerse protegido. No se recomienda utilizar contraseñas de desarrollo en servidores de producción.

### Paso 6. Compilar el proyecto

Con CMD ubicado en la carpeta principal del proyecto, ejecutar:

gradlew.bat clean war --rerun-tasks

Si la compilación es correcta, Gradle mostrará el mensaje:

BUILD SUCCESSFUL

El archivo WAR generado se encontrará en la carpeta:

build\\libs\\ModuloConfiteria.war

### Paso 7. Configurar el despliegue en Tomcat

Tomcat debe estar configurado para desplegar el archivo WAR generado por Gradle.

En la instalación local utilizada durante el desarrollo, el descriptor de despliegue se encuentra en:

C:\\apache-tomcat-9.0.118\\conf\\Catalina\\localhost\\ModuloConfiteria.xml

Este descriptor utiliza como origen el WAR de la carpeta build\\libs del proyecto.

El nombre ModuloConfiteria.xml define el contexto de acceso de la aplicación.

Si se utiliza otra instalación de Tomcat o una ubicación diferente del proyecto, será necesario adaptar la configuración de despliegue.

### Paso 8. Iniciar Tomcat

Con CMD abierto y las variables de entorno configuradas, ejecutar:

"C:\\apache-tomcat-9.0.118\\bin\\startup.bat"

El servidor iniciará y mostrará sus registros en una ventana de consola.

Se recomienda comprobar que Tomcat haya iniciado correctamente antes de abrir la aplicación.

### Paso 9. Abrir la aplicación web

Abrir un navegador web e ingresar a la dirección:

http://localhost:8080/ModuloConfiteria/

Se mostrará la pantalla de inicio de sesión del sistema.

Para acceder es necesario disponer de una cuenta de usuario registrada en la base de datos y con los permisos correspondientes.

### Paso 10. Detener Tomcat

Al finalizar el uso de la aplicación, regresar a CMD y ejecutar:

"C:\\apache-tomcat-9.0.118\\bin\\shutdown.bat"

Esto solicita el cierre ordenado del servidor.

## 7. Cómo ejecutar el proyecto después de reiniciar Windows

Cuando se enciende nuevamente la computadora, no es necesario recompilar el proyecto si no se han realizado modificaciones.

Se debe comprobar que SQL Server esté funcionando.

Después, abrir CMD y ejecutar los siguientes comandos en orden:

1. Ingresar al proyecto:

cd /d "C:\\ProyectosVarios\\ProyectoWebCine_GitHub\\ModuloConfiteria"

2. Configurar Java:

set "JAVA_HOME=C:\\Program Files\\Java\\jdk-17"

set "JRE_HOME=C:\\Program Files\\Java\\jdk-17"

set "PATH=%JAVA_HOME%\\bin;%PATH%"

3. Configurar Tomcat:

set "CATALINA_HOME=C:\\apache-tomcat-9.0.118"

set "CATALINA_BASE=C:\\apache-tomcat-9.0.118"

4. Iniciar el servidor:

"C:\\apache-tomcat-9.0.118\\bin\\startup.bat"

5. Abrir el navegador:

http://localhost:8080/ModuloConfiteria/

Para detener el servidor:

"C:\\apache-tomcat-9.0.118\\bin\\shutdown.bat"

## 8. Cómo actualizar el proyecto después de modificar código

Cuando se realizan cambios en los archivos Java, JSP, HTML o CSS, es necesario actualizar el WAR desplegado.

Procedimiento recomendado:

1. Guardar las modificaciones en NetBeans o en el editor utilizado.

2. Detener Tomcat.

3. Abrir CMD y entrar en la carpeta del proyecto.

4. Configurar Java 17.

5. Compilar nuevamente.

6. Iniciar Tomcat.

7. Verificar los cambios desde el navegador.

Comando de compilación:

gradlew.bat clean war --rerun-tasks

Comando para iniciar Tomcat:

"C:\\apache-tomcat-9.0.118\\bin\\startup.bat"

La aplicación utiliza un despliegue basado en el WAR generado, por lo que guardar código fuente no implica necesariamente que el servidor actualice automáticamente los cambios.

## 9. Seguridad y configuración

Para evitar exponer información sensible, el repositorio no debe contener:

- Contraseñas reales de SQL Server.

- Archivos locales con credenciales privadas.

- Archivos de bases de datos reales.

- Copias de seguridad con datos privados.

- Carpetas generadas automáticamente por la compilación.

- Archivos de configuración personal que no sean necesarios.

El archivo .gitignore excluye las carpetas build y .gradle, así como determinados archivos temporales y privados.

El repositorio contiene un ejemplo de variables de entorno mediante .env.example.

## 10. Consideraciones importantes

La aplicación fue probada localmente utilizando Java 17, Apache Tomcat 9 y Microsoft SQL Server 2025.

El proyecto no incluye automáticamente una instalación de SQL Server ni un servidor Tomcat.

El archivo de estructura SQL no incorpora cuentas de usuario ni todos los datos necesarios para una instalación completamente funcional.

Por ello, una instalación nueva requiere configuración adicional de la base de datos.

El procedimiento de instalación desde cero aún no ha sido validado en otro equipo.

## 11. Control de versiones

El proyecto utiliza Git para el control de versiones.

El código fuente se almacena en un repositorio privado de GitHub.

Repositorio:

https://github.com/Fabrizzio-07/ProyectoWebCine

Las modificaciones se administran mediante commits para mantener un historial de desarrollo.

## 12. Instalación inicial en una computadora nueva (Windows)

Esta sección es para integrantes que todavía no tienen Java, Tomcat, SQL Server ni el proyecto instalado. Las rutas se deben adaptar a cada computadora.

**Estado de la guía:** la aplicación funciona en el equipo de desarrollo, pero todavía no se ha validado una instalación limpia en otra computadora. En particular, el repositorio contiene la estructura de SQL Server pero NO incluye cuentas de acceso ni datos iniciales. Seguir estos pasos no garantiza poder iniciar sesión hasta completar el apartado 12.7.

### 12.1. Instalar las herramientas

Instalar en el orden siguiente:

1. Git para Windows: https://git-scm.com/downloads/win
2. Java **JDK 17**, por ejemplo Eclipse Temurin 17: https://adoptium.net/temurin/releases/?version=17
3. Apache Tomcat **9** (no Tomcat 10): https://tomcat.apache.org/download-90.cgi
4. Microsoft SQL Server, edición apropiada para desarrollo: https://www.microsoft.com/en-us/sql-server/sql-server-downloads
5. SQL Server Management Studio (SSMS): https://learn.microsoft.com/en-us/ssms/install/install
6. Apache NetBeans (recomendado para editar; no obligatorio para compilar): https://netbeans.apache.org/download/

El proyecto ya incluye el **Gradle Wrapper**, por lo que no hace falta instalar Gradle separadamente. Se requiere acceso a Internet en la primera compilación para descargar Gradle y las dependencias.

Abrir CMD y comprobar:

~~~bat
git --version
java -version
javac -version
~~~

Java y javac deben mostrar la versión 17. No basta con instalar únicamente el JRE.

### 12.2. Descargar el repositorio privado

Primero aceptar la invitación al repositorio enviada por el propietario en GitHub. Después ejecutar en CMD:

~~~bat
cd /d "%USERPROFILE%\Documents"
git clone https://github.com/Fabrizzio-07/ProyectoWebCine.git
cd ProyectoWebCine
git branch --show-current
~~~

La rama inicial debe ser main. GitHub podría pedir autenticación mediante el navegador.

### 12.3. Configurar JAVA_HOME y verificar JDK 17

Abrir Inicio de Windows, buscar **Editar las variables de entorno del sistema**, entrar a **Variables de entorno**, crear JAVA_HOME con la carpeta real del JDK 17 (sin agregar bin al final) y añadir %JAVA_HOME%\bin a la variable Path si no está presente.

Cerrar y volver a abrir CMD. Verificar:

~~~bat
echo %JAVA_HOME%
java -version
javac -version
~~~

Alternativamente, solo en la ventana CMD actual:

~~~bat
set "JAVA_HOME=RUTA_REAL_DEL_JDK_17"
set "JRE_HOME=%JAVA_HOME%"
set "PATH=%JAVA_HOME%\bin;%PATH%"
~~~

Reemplazar RUTA_REAL_DEL_JDK_17 por la carpeta donde se instaló Java. No asumir que todos usan la misma ruta.

### 12.4. Preparar el motor SQL Server

Instalar SQL Server y SSMS. Comprobar que el servicio del motor correspondiente a la instancia esté iniciado.

La aplicación utiliza autenticación SQL con usuario y contraseña propios. Si SQL Server permite solo autenticación de Windows, un administrador debe entrar a SSMS, abrir las propiedades del servidor, sección **Seguridad**, habilitar **Autenticación de SQL Server y Windows (modo mixto)** y reiniciar el servicio del motor. No es necesario habilitar la cuenta sa.

Comprobar el nombre de la instancia y el puerto TCP utilizado. Para conexiones TCP/IP, verificar el protocolo y puerto en SQL Server Configuration Manager; muchas instalaciones no emplean el puerto 1433 de manera predeterminada. Si se cambia la configuración del servicio, reiniciarlo.

Conectarse a SSMS y ejecutar esta consulta de diagnóstico, que no modifica datos:

~~~sql
SELECT @@SERVERNAME AS servidor,
       DB_NAME() AS base_actual,
       SYSTEM_USER AS identidad_sql,
       ORIGINAL_LOGIN() AS login_original;
~~~

No abrir puertos SQL Server hacia Internet para esta práctica local.

### 12.5. Ejecutar el script de la base de datos: solo en una instalación nueva

**IMPORTANTE:** no ejecutar database/01_schema.sql en la base de datos real de otro integrante ni sobre una base existente. El script todavía no se ha validado en una instalación limpia. Además, los separadores GO hacen que su comprobación inicial no proteja automáticamente todos los lotes siguientes.

En SSMS, conectarse a una **instancia de pruebas** con una cuenta autorizada para crear bases de datos. Ejecutar primero:

~~~sql
SELECT DB_ID(N'confiteria') AS id_base_existente;
~~~

**Continuar solo si el resultado es NULL.** Si devuelve un número, detenerse; no eliminar ni reemplazar la base.

Para una instancia nueva sin esa base:

1. Abrir en SSMS el archivo database/01_schema.sql mediante **Archivo > Abrir > Archivo**.
2. Comprobar que el editor está conectado a la instancia de pruebas correcta.
3. Revisar el script y ejecutarlo una única vez.
4. Examinar la pestaña **Mensajes**; detenerse si aparece cualquier error.

Verificar la creación con consultas de solo lectura:

~~~sql
USE confiteria;
GO
SELECT DB_NAME() AS base_actual;
SELECT name FROM sys.tables ORDER BY name;
SELECT name FROM sys.procedures ORDER BY name;
~~~

### 12.6. Crear y comprobar el usuario SQL de la aplicación

En SSMS, conectado con una cuenta administradora de la instancia de pruebas:

1. Abrir **Seguridad > Inicios de sesión** y seleccionar **Nuevo inicio de sesión**.
2. Elegir un nombre para el usuario de la aplicación, seleccionar **Autenticación de SQL Server** y definir una contraseña privada.
3. En **Asignación de usuarios**, seleccionar la base confiteria y asignar los permisos requeridos para las operaciones de la aplicación: lectura, inserción, actualización, eliminación y ejecución de procedimientos almacenados cuando correspondan. Un administrador deberá comprobar los permisos. No conceder privilegios de administrador del servidor.
4. Guardar los cambios.

**Prueba del usuario y contraseña:** cerrar la conexión administrativa y crear una conexión nueva en SSMS seleccionando **Autenticación de SQL Server**. Introducir el nombre y la contraseña recién creados. La conexión debe funcionar y permitir seleccionar la base confiteria.

Ejecutar estas consultas de comprobación:

~~~sql
USE confiteria;
GO
SELECT SYSTEM_USER AS usuario_conectado, DB_NAME() AS base_actual;
SELECT HAS_PERMS_BY_NAME(N'dbo.Producto', 'OBJECT', 'SELECT') AS puede_leer_producto;
SELECT HAS_PERMS_BY_NAME(N'dbo.Producto', 'OBJECT', 'UPDATE') AS puede_actualizar_producto;
~~~

Para las consultas HAS_PERMS_BY_NAME, 1 significa que el permiso consultado está disponible. La comprobación no sustituye las pruebas reales de escritura de la aplicación. No compartir capturas donde aparezcan contraseñas.

### 12.7. Datos iniciales: requisito aún pendiente

**El repositorio NO incluye un script validado de datos iniciales.** El script de esquema crea tablas y procedimientos, pero no inserta roles, empleados, productos ni cuentas administrativas.

El inicio de sesión necesita un usuario registrado en Personal. Además, el registro de nuevos empleados ahora exige una sesión de Administrador. Por ello, una base completamente vacía no permite crear el primer administrador desde la interfaz.

El equipo deberá preparar y validar, en una base de datos desechable, un script independiente que incorpore roles, una cuenta de prueba con el formato de contraseña compatible con el sistema y productos ficticios. No exportar cuentas reales ni reutilizar contraseñas del equipo original.

**No puedo confirmar todavía que el inicio de sesión funcione en una instalación recién creada** sin completar este paso.

### 12.8. Configurar usuario y contraseña de SQL Server en Tomcat

Dentro de la instalación local de Tomcat 9, crear el archivo privado bin\setenv.bat. Ejemplo con datos ficticios:

~~~bat
@echo off
set "DB_HOST=localhost"
set "DB_PORT=1433"
set "DB_NAME=confiteria"
set "DB_USER=USUARIO_SQL_LOCAL"
set "DB_PASSWORD=CONTRASENA_SQL_LOCAL"
~~~

Reemplazar los valores de usuario y contraseña con los creados en SSMS. Ajustar DB_HOST y DB_PORT al servidor y puerto realmente configurados.

**Nunca publicar setenv.bat ni contraseñas reales en GitHub.** El archivo .env.example del repositorio es solo una referencia: Java no lo carga automáticamente. Actualmente la conexión JDBC utiliza encrypt=false, destinado únicamente al entorno académico local de pruebas; no es una configuración recomendada para producción.

### 12.9. Compilar por primera vez

En CMD, dentro de la carpeta clonada del proyecto:

~~~bat
java -version
gradlew.bat clean war
~~~

Debe aparecer BUILD SUCCESSFUL. El archivo creado será build\libs\ModuloConfiteria.war.

Si falla, revisar primero JAVA_HOME, versión de Java, acceso a Internet y el mensaje de error. No utilizar el botón Run de NetBeans para desplegar esta copia si se trabaja con el método de CMD y WAR.

### 12.10. Desplegar e iniciar Tomcat

Método sencillo para una **instalación nueva**: con Tomcat detenido y sin un despliegue previo de ModuloConfiteria, copiar el WAR generado a la carpeta webapps de Tomcat con nombre ModuloConfiteria.war.

**No mezclar** este método con un descriptor existente conf\Catalina\localhost\ModuloConfiteria.xml que apunte a otra ubicación del WAR.

Ejemplo únicamente para quien instaló Tomcat en C:\apache-tomcat-9.0.118, ejecutando CMD desde la carpeta del proyecto:

~~~bat
copy /Y "build\libs\ModuloConfiteria.war" "C:\apache-tomcat-9.0.118\webapps\ModuloConfiteria.war"
set "CATALINA_HOME=C:\apache-tomcat-9.0.118"
set "CATALINA_BASE=C:\apache-tomcat-9.0.118"
set "JRE_HOME=%JAVA_HOME%"
"C:\apache-tomcat-9.0.118\bin\startup.bat"
~~~

Adaptar la carpeta si la instalación de Tomcat está en otra ubicación.

Abrir en el navegador:

http://localhost:8080/ModuloConfiteria/

Para detener Tomcat desde CMD con las variables de Tomcat configuradas:

~~~bat
"C:\apache-tomcat-9.0.118\bin\shutdown.bat"
~~~

La URL puede responder incluso si aún faltan usuarios y productos de demostración. Para iniciar sesión y operar hacen falta los datos iniciales del apartado 12.7.

### 12.11. Lista de comprobación final

- Git puede clonar el repositorio y la rama main.
- java y javac corresponden a JDK 17.
- SQL Server está funcionando y SSMS permite iniciar sesión con el usuario SQL de la aplicación.
- Existe la base confiteria con sus tablas y procedimientos.
- Tomcat tiene el archivo privado setenv.bat con las credenciales locales.
- Gradle muestra BUILD SUCCESSFUL y genera el WAR.
- Tomcat inicia y la aplicación responde en el navegador.
- **Pendiente:** contar con cuentas, roles y productos de demostración para iniciar sesión en una instalación recién creada.
- **Pendiente:** probar el procedimiento completo en otro equipo sin depender de archivos privados del desarrollador original.

### 12.12. Recomendaciones para trabajar en equipo

Crear una rama distinta para cada tarea. Desde la carpeta del proyecto:

~~~bat
git switch main
git pull --ff-only origin main
git switch -c nombre-de-mi-tarea
~~~

Tras guardar los cambios y verificar que no haya secretos ni archivos innecesarios:

~~~bat
git status
git add .
git commit -m "Descripcion de los cambios"
git push -u origin nombre-de-mi-tarea
~~~

Crear un Pull Request en GitHub para revisión antes de integrar en main.

La eliminación de los módulos de boletos y gestión de personal todavía está pendiente; no borrar indiscriminadamente las clases relacionadas con Personal y Rol, porque la autenticación y las ventas actualmente dependen de ellas.
