//
//  Logger.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Diego Herreros Parron on 17/1/25.
//

import Foundation
import OSLog

enum LogPrivacy {
    case publicLog
    case privateLog
}

class AppLogger {
    // El subsystem en logging permite filtrar y separar los logs de diferentes orígenes (apps, sistema, frameworks) evitando que se mezclen, facilitando la identificación y depuración de los registros específicos de la aplicación. Normalmente se aconseja poner un nombre como com.ismaelsabri.desarrolloseguroiosapp
    private static  let subsystem =  "MYAPP"
    
    private static var loggerCache: [String: Logger] = [:]
    
    // Cada vez que creemos un logger se añade al diccionario de loggerCache para que no se repitan y se use una única instancia por cada categoría
    private static func getLogger(category: String) -> Logger {
        guard let logger = loggerCache[category] else {
            loggerCache[category] = Logger(subsystem: subsystem, category: category)
            return loggerCache[category]!
        }
        return logger
    }
        

    static func debug(_ message: String, withSensitiveValues sensitiveValues: [String: String]? = nil, inFile file: StaticString = #file, andFunction function: StaticString = #function, onLine line: UInt = #line) {
        
        let filename: NSString = ("\(file)" as NSString).lastPathComponent as NSString
        let category = filename.deletingPathExtension
        let logger = getLogger(category: category)
        
        let logMessage = "el mensaje customizado es este: 🔍 \(message)"
        
        if let sensitiveValues = sensitiveValues {
            logger.debug("\(logMessage) with sensitive values --> in \(function) on \(line)")
            // Reemplazar cada valor sensible
            for (key, value) in sensitiveValues {
                logger.debug("--> \(key): \(value, privacy: .sensitive(mask: .hash))")
            }
        } else {
            logger.debug("\(logMessage) --> in \(function) on \(line)")
        }
    }
}

extension Logger {
    private static var subsystem = "MYAPP"
    static let remoteDataSource = Logger(subsystem: subsystem, category: "RemoteDataSource")
}
