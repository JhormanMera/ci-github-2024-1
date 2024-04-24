# CI de imagen de docker desde github actions

## Descripción

Este repositorio hace uso de github actions para publicar de forma automatizada la imagen del proyecto en dockerhub cada vez que se realiza un push (cada vez que hay nuevos cambios) en la rama `main`.

---
### Nota:

Antes de realizar la automatización del proyecto, debemos probar en local que la aplicación funcione, para esto es necesario tener `Node.js` instalado en el sistema.

# Comenzando con Create React App

Este proyecto fue creado con [Create React App](https://github.com/facebook/create-react-app).

## Scripts Disponibles

En el directorio del proyecto, puede ejecutar:

### `npm start`

Ejecuta la aplicación en modo de desarrollo.\
Abra [http://localhost:3000](http://localhost:3000) para verla en su navegador.

La página se recargará cuando realice cambios.\
También puede ver cualquier error de lint en la consola.

#### Nota: Fue necesario agregar un script "start" en el archivo `package.json` para que este comando funcione, esto puede ser reemplazado por el comando `npm run dev` el cual ejecuta la aplicación de la misma manera que se esperaba del comando start.

### `npm test`

Inicia el corredor de pruebas en el modo de observación interactiva.\
Consulte la sección sobre [ejecución de pruebas](https://facebook.github.io/create-react-app/docs/running-tests) para obtener más información.

### `npm run build`

Construye la aplicación para producción en la carpeta `build`.\
Agrupa correctamente React en modo de producción y optimiza la compilación para obtener el mejor rendimiento.

La compilación se minimiza y los nombres de archivo incluyen los hashes.\
¡Tu aplicación está lista para ser desplegada!

Consulte la sección sobre [despliegue](https://facebook.github.io/create-react-app/docs/deployment) para obtener más información.

### `npm run eject`

**Nota: esta es una operación unidireccional. Una vez que `eject` se realiza, ¡no se puede volver atrás!**

Si no está satisfecho con la herramienta de construcción y las opciones de configuración, puede `eject` en cualquier momento. Este comando eliminará la dependencia de compilación única de su proyecto.

En su lugar, copiará todos los archivos de configuración y las dependencias transitivas (webpack, Babel, ESLint, etc.) directamente en su proyecto para que tenga control total sobre ellos. Todos los comandos excepto `eject` seguirán funcionando, pero apuntarán a los scripts copiados para que pueda modificarlos. En este punto, estás por tu cuenta.

No tienes que usar `eject` nunca. El conjunto de funciones curado es adecuado para despliegues pequeños y medianos, y no deberías sentirte obligado a usar esta función. Sin embargo, entendemos que esta herramienta no sería útil si no pudieras personalizarla cuando estés listo para ello.

## Aprender Más

Puedes aprender más en la [documentación de Create React App](https://facebook.github.io/create-react-app/docs/getting-started).

Para aprender React, consulta la [documentación de React](https://reactjs.org/).

### División de Código

Esta sección se ha movido aquí: [https://facebook.github.io/create-react-app/docs/code-splitting](https://facebook.github.io/create-react-app/docs/code-splitting)

### Analizando el Tamaño del Paquete

Esta sección se ha movido aquí: [https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size](https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size)

### Hacer una Aplicación Web Progresiva

Esta sección se ha movido aquí: [https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app](https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app)

### Configuración Avanzada

Esta sección se ha movido aquí: [https://facebook.github.io/create-react-app/docs/advanced-configuration](https://facebook.github.io/create-react-app/docs/advanced-configuration)

### Despliegue

Esta sección se ha movido aquí: [https://facebook.github.io/create-react-app/docs/deployment](https://facebook.github.io/create-react-app/docs/deployment)

### `npm run build` no se minimiza

Esta sección se ha movido aquí: [https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify](https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify)

# CI de imagen de docker desde github actions

## Archivo Dockerfile

Es necesario crear un archivo `Dockerfile` en la raiz del proyecto para contenerizar la aplicación.

 ```
 # Use a base image with the latest Node.js LTS installed
FROM node:20

# Set the working directory inside the container
WORKDIR /app

# Copy the application code to the working directory
COPY . .

# Install dependencies
RUN npm install

# Build the app
RUN npm run build

EXPOSE 3000

# Start the app
CMD ["npm", "start"]
 ```

## Configuración de Secretos

Lo primero es configurar en Github los secretos para almacenar las credenciales de usuario de Dockerhub, en este proyecto se nombran como: `USERNAME` y `PASSWORD`.

Para configurar los secretos, siga estos pasos:

1. Navegue a la página principal de su repositorio en GitHub.
2. Haga clic en la pestaña "Settings" (Configuración) en la parte superior derecha.
3. En el menú de la izquierda, haga clic en "Secrets" (Secretos).
4. Haga clic en el botón "New repository secret" (Nuevo secreto de repositorio) y agregue los secretos mencionados anteriormente.

---

## Estructura del Proyecto

```bash
ci-github-2024-1/
├── .github
    ├── workflows
        ├── docker-publish.yml
├── Dockerfile
├── index.js
├── package.json
└── ...
```
- **docker-publish.yml**: Flujo de trabajo que contiene las instrucciones de GitHub Actions para construir y publicar la imagen a Dockerhub.

```
name: Docker Image CI

on:
  push:
    branches: [ "main" ]
 
jobs:

  build:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout Repo
      uses: actions/checkout@v3
    - name: Docker Setup Buildx
      uses: docker/setup-buildx-action@v3.0.0
    - name: Docker Login
      uses: docker/login-action@v1
      with:
            username: ${{ secrets.USERNAME }}
            password: ${{ secrets.PASSWORD}}
    - name: Build and Push Docker image
      uses: docker/build-push-action@v5.0.0
      with:
          context: .  # Ruta al contexto de construcción (puede ser el directorio actual)
          file: ./Dockerfile  # Ruta al Dockerfile
          push: true  # Habilitar el empuje de la imagen
          tags: ${{ secrets.USERNAME }}/node-ci:latest  # Nombre y etiqueta de la imagen
      env:
          DOCKER_USERNAME: ${{ secrets.USERNAME }}
          DOCKER_PASSWORD: ${{ secrets.PASSWORD }}
```

## Evidencia

### El workflow se ejecuta correctamente
![actions_workflow](/images/actions_workflow.png)
### Verificamos la creación del repositorio en dockerhub
![dockerhub_repository](/images/dockerhub_repository.png)
### Extraemos la imagen de dockerhub y creamos el contenedor de la app
![docker_container](/images/docker_container.png)
### Aplicación corriendo exitosamente
![running_app](/images/running_app.png)

