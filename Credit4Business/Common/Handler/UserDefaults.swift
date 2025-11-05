//
//  UserDefaults.swift
//  Credit4Business
//
//  Created by MacMini on 27/05/24.
//

import Foundation
extension UserDefaults {
    
    private enum UserDefaultsKeys: String {
        case name
        case email
        case address
        case image
    }
    
    var profileName: String {
        get {
            string(forKey: UserDefaultsKeys.name.rawValue) ?? ""
        }
        
        set {
            setValue(newValue, forKey: UserDefaultsKeys.name.rawValue)
        }
    }
    var profileEmail: String {
        get {
            string(forKey: UserDefaultsKeys.email.rawValue) ?? ""
        }
        
        set {
            setValue(newValue, forKey: UserDefaultsKeys.email.rawValue)
        }
    }
    var profileImage: String {
        get {
            string(forKey: UserDefaultsKeys.image.rawValue) ?? ""
        }
        
        set {
            setValue(newValue, forKey: UserDefaultsKeys.image.rawValue)
        }
    }
    var profileAddress: String {
        get {
            string(forKey: UserDefaultsKeys.address.rawValue) ?? ""
        }
        
        set {
            setValue(newValue, forKey: UserDefaultsKeys.address.rawValue)
        }
    }
}
