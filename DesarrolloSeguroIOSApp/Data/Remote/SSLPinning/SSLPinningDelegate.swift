//
//  SSLPinningDelegate.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Diego Herreros Parron on 13/1/25.
//

import Foundation
import CryptoKit
import CommonCrypto

class SSLPinningDelegate: NSObject {
    
}

extension SSLPinningDelegate: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        
        // Get the server trust.
        /*
         Un server trust es el proceso de validar que un servidor es auténtico y seguro al establecer una conexión cifrada, como HTTPS. Esto se logra verificando el certificado del servidor para asegurarse de que:
             1.    Es emitido por una autoridad certificadora (CA) confiable.
             2.    El dominio coincide con el certificado.
             3.    El certificado no está expirado ni revocado.

         Este proceso garantiza que el cliente está comunicándose con el servidor correcto y no con un impostor.
         */
        guard let serverTrust = challenge.protectionSpace.serverTrust  else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server didn't present trust")
            return
        }

        // Obtén los certificados del servidor: si la confianza del servidor contiene un array de certificados que identifica al servidor
        let serverCertificates: [SecCertificate]?
        serverCertificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate]
        // Desenvolver el certificado del servidor, si no está disponible, entonces error de SSL Pinning
        guard let serverCertificate = serverCertificates?.first else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server certificate is nil")
            return
        }
        
        // Obtener la clave pública del servidor: el certificado contiene la clave pública del servidor.
        guard let serverPublicKey = SecCertificateCopyKey(serverCertificate) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server public key is nil")
            return
        }

        // Transformar la clave pública en datos (actualmente es un SecKey.
        guard let serverPublicKeyRep = SecKeyCopyExternalRepresentation(serverPublicKey, nil) else {
            print("SSLPinning error: unable to convert server public key to data")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let serverPublicKeyData: Data = serverPublicKeyRep as Data
        
        let serverHashKeyBase64: String = sha256CryptoKit(data: serverPublicKeyData)

        let localPublicKey = Crypto().getDecryptedPublicKey()
        
        if serverHashKeyBase64 == localPublicKey {
            print("Servidor \(serverHashKeyBase64)")
            print("Local \(localPublicKey)")

            // Continuar con la conexión -> porque sabemos que el servidor es quien dice ser
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
            print("SSLPinning filter passed")
        } else {
            // Cancelamos conexión -> porque hay alguien en medio
            print("Servidor \(serverHashKeyBase64)")
            print("Local \(localPublicKey)")
            print("SSLPinning error: server certificate doesn't match")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
}

//MARK: - Extensión SSLPinning: SHA
extension SSLPinningDelegate {
    
    /// Crea una representación SHA256 de los datos pasados como parámetro (usando CommonCrypto)
    /// - Parámetro data: Los datos que serán convertidos a SHA256.
    /// - Retorna: La representación SHA256 de los datos.
    private func sha256(data : Data) -> String {
        
        // Obtener los datos del sha256 en una variable
        let dataToHash = Data(data)
        
        // Crear un array de bytes donde se copiarán los datos
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        // Copiar los datos al array de bytes hash (usando CommonCrypto, no CryptoKit)
        dataToHash.withUnsafeBytes { bufferPointer in
            _ = CC_SHA256(bufferPointer.baseAddress, CC_LONG(bufferPointer.count), &hash)
        }
        
        // Convertir el hash a una cadena en Base64
        return Data(hash).base64EncodedString()
    }
    
    /// Crea una representación SHA256 de los datos pasados como parámetro (usando CryptoKit)
    /// - Parámetro data: Los datos que serán convertidos a SHA256.
    /// - Retorna: La representación SHA256 de los datos.
    private func sha256CryptoKit(data: Data) -> String {
        // Calcular el hash usando CryptoKit
        let hash = SHA256.hash(data: data)
        // Convertir el hash a una cadena en Base64
        return Data(hash).base64EncodedString()
    }
}
