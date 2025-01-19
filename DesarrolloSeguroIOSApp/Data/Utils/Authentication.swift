//
//  Authentication.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Diego Herreros Parron on 19/1/25.
//

import Foundation
import LocalAuthentication


class Authentication {

    // MARK: - Properties
    let context: LAContext // Este objeto permite usar las funcionalidades del framework LocalAuthentication
    private var error: NSError?
    
    // MARK: - Init
    init(context: LAContext) {
        self.context = context
    }
    
    // MARK: - Methods
    func getAccessControl() -> SecAccessControl? {
        var accessControlError: Unmanaged<CFError>?
        // our keychain entry can only be read when the iOS device is unlocked. Also it won’t be copied to other devices via iCloud and won’t be added to backups.
        guard let accessControl = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .userPresence, &accessControlError) else {
            print("Error: could not create access control with error \(String(describing: accessControlError))")
            return nil
        }
        return accessControl
    }
}
