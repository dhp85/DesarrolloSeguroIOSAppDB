//
//  Cripto.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Diego Herreros Parron on 16/1/25.
//

import Foundation
import CryptoKit

enum AESKeySize: Int {
    case bits128 = 16
    case bits192 = 24
    case bits256 = 32
}

class Crypto {
    private let sealedDataBox = "MwPCsKMTTHdj9uxVjbvZMSlW6/UBedz+SiqqiIst/66hA5ZylKI3yrRy+2pbrlKQ+2mxvQZsjiKGhHEGhXpKd3cFT+/3uJfW"
    private let key = "pass"
    
    private func decrypt(input: Data, key: String) -> Data {
        do {
            // Añadimos padding a la key si es necesario (el tamaño tiene que ser el mismo que en la función encrypt)
            let keyData = paddedKey_PKCS7(from: key, withSize: .bits128)
            // Obtenemos una clave simétrica que puede ser usada por Swift
            let key = SymmetricKey(data: keyData)
            // Obtenemos la caja con el cyphertext, el nonce y el tag
            let box = try AES.GCM.SealedBox(combined: input)
            // Se desencripta el cyphertext que hay en box
            let opened = try AES.GCM.open(box, using: key)
            // Devolvemos el mensaje
            return opened
        } catch {
            return "Error while decryption".data(using: .utf8)!
        }
    }
   
    private func paddedKey_PKCS7(from key: String, withSize size: AESKeySize = .bits256) -> Data {
        // Se obtiene la key como data
        guard let keyData = key.data(using: .utf8) else { return Data() }
        // Si la key tiene el tamaño adecuado se devuelve la key como data
        if(keyData.count == size.rawValue) {return keyData}
        // Si la key tiene un tamaño mayor que el deseado, entonces le quitamos los bytes que le sobran
        if(keyData.count > size.rawValue) {return keyData.prefix(size.rawValue)}
        
        // Si la key no tiene el tamaño deseado y es menor que el tamaño deseado (si la key tiene 10 bytes y nosotros queremos una key de 16 bytes)
        // Obtenemos el número de bytes que necesitamos
        let paddingSize = size.rawValue - keyData.count % size.rawValue
        // Le metemos bytes al padding (lo que se hace en el standard PKCS7)
        // Transformamos padding size a bytes
        let paddingByte: UInt8 = UInt8(paddingSize)
        // Añadirle al padding los bytes del padding
        let padding = Data(repeating: paddingByte, count: paddingSize)
        // Devolvemos la key (10 bytes) + el padding (6 bytes)
        return keyData + padding
    }
    
    public func getDecryptedPublicKey () -> String? {
        guard let sealedDataBoxData = Data(base64Encoded: sealedDataBox) else {
            print("Error while decrypting the public ey: sealed box is not valid")
            return nil
        }
        
        let data = decrypt(input: sealedDataBoxData, key: key)
        return String(data: data, encoding: .utf8)
    }
}
