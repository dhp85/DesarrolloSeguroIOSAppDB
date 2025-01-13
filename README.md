
# 📱 Desarrollo Seguro en iOS

Este proyecto es una aplicación iOS desarrollada con un enfoque en la **seguridad** y la **arquitectura limpia**, utilizando **SwiftUI**,
el patrón **MVVM** y el patrón **Repository** para estructurar el código de manera eficiente y segura. Se ha implementado **SSL Pinning** para garantizar conexiones seguras con los servidores.

---

## 🛠️ Tecnologías y patrones utilizados

- **SwiftUI**: Framework declarativo para construir interfaces de usuario modernas.
- **MVVM (Model-View-ViewModel)**: Patrón de diseño que separa la lógica de negocio de la presentación.
- **Repository Pattern**: Abstracción de la capa de datos para facilitar la gestión y modularidad.
- **CommonCrypto** y **CryptoKit**: Para implementar funciones criptográficas, como hashing SHA256.
- **URLSession**: Para realizar solicitudes de red con validación segura mediante SSL Pinning.

---

## 🔒 Seguridad: Implementación de SSL Pinning

La seguridad de las conexiones de red es crítica para evitar ataques como el **Man-in-the-Middle (MitM)**. Este proyecto implementa **SSL Pinning**, una técnica que asegura que las solicitudes se realicen solo a servidores autenticados.

### Componentes principales:
- **`SSLPinningDelegate`**:
  - Valida el certificado del servidor utilizando la cadena de confianza y una public key almacenada localmente.
  - Implementa funciones de hashing como `sha256` para comparar claves públicas.
- **`SSLPinningSecureURLSession`**:
  - Abstrae el uso de `URLSession` para proporcionar una capa adicional de seguridad en las solicitudes HTTP.

---

## 🚀 Funcionalidades principales
	1.	Conexiones de red seguras con SSL Pinning:
	•	Valida la publica key del servidor comparándola con la key almacenada localmente.
	•	Mitiga riesgos de ataques MitM y falsificación de servidores.
	2.	Arquitectura modular y escalable:
	•	Uso de MVVM para separar la lógica de negocio de la presentación.
	•	Repository Pattern para desacoplar la fuente de datos de las capas superiores.
	3.	SwiftUI:
	•	Interfaz moderna y reactiva que permite una fácil integración con la lógica del ViewModel.
	4.	Hashing seguro:
	•	Uso de SHA256 mediante CommonCrypto y CryptoKit para validar claves públicas.

 ## 🛠 Instalación y Ejecución

1. Clona este repositorio:

   ```bash
   git clone https://github.com/dhp85/DesarrolloSeguroIOSAppDB.git

	2.	Abre el archivo DesarrolloSeguroIOSAppDB.xcodeproj en Xcode.
	3.	Asegúrate de seleccionar el simulador o dispositivo correcto.
	4.	Compila y ejecuta el proyecto:

Cmd + R

## 🧪 Pruebas
	•	Validación de SSL Pinning:
	•	Cambiar el certificado local por uno incorrecto y verificar que la conexión sea rechazada.

 ✨ Créditos

Desarrollado por Diego Herreros Parrón para practicar lo aprendido en el modulo de Desarrollo Seguro en la escuela tech KEEPCODING.

