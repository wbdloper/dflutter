# Imagen Docker para crear aplicaciones con Flutter

Este repositorio crea una imagen [Docker](https://hub.docker.com/r/wbdloper/dflutter) que ayuda a simplificar y acelerar el flujo de trabajo en el desarrollo de aplicaciones [Flutter](https://flutter.dev/). 

## Características
 
|  |  |
| -- | -- |
| **Sistema operativo** | [Ubuntu](https://hub.docker.com/_/ubuntu)|
| **Android nivel de API** | Android 12 (API 31) |
| **Flutter versión** | Ultima versión disponible en el [canal estable](https://docs.flutter.dev/development/tools/sdk/releases#:~:text=Stable%20channel%20(Windows)) |

## Conexión TCP/IP para dispositivos físicos (Opcional)

Permite establecer una **conexión inalámbrica** con su dispositivo móvil físico. Para crear y ejecutar aplicaciones **Flutter**.

> Este proceso debe hacerlo dentro del contenedor

**1.** Escriba el siguiente comando `adb devices`, debería obtener una lista vacía

**2.** Ejecute los siguientes comandos para conectarse al dispositivo de forma inalámbrica:

- `adb tcpip 5555`
- `adb connect 192.168.0.5:5555`
- `adb devices`

> Reemplace la **dirección IP** con la del Wifi al que está conectado el dispositivo móvil. Puede obtenerlo yendo a **Configuración de Wifi** > **Avanzado en su dispositivo móvil.** 

>Además, asegúrese de **permitir la depuración USB** cuando aparezca la ventana emergente en el dispositivo.

>  **NOTA**: Tanto el dispositivo móvil como el sistema deben estar conectados a la misma red.

**3.** En el paso anterior, es posible que obtenga un dispositivo no autorizado. Para solucionarlo, ejecute:

- `adb kill-server`
- `adb connect 192.168.0.5:5555`
- `adb devices`

> Ahora verá que el error no autorizado ha desaparecido.  

**4.** Ejecute `flutter doctor` para verificar que Flutter reconozca el dispositivo.

**5.** Ahora solo resta seleccionar el dispositivo y ejecutar la aplicación
