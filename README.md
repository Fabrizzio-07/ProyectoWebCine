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
