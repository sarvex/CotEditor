//
//  UserDefaults+DefaultKey.swift
//
//  CotEditor
//  https://coteditor.com
//
//  Created by 1024jp on 2020-08-30.
//
//  ---------------------------------------------------------------------------
//
//  © 2016-2021 1024jp
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import struct CoreGraphics.CGFloat
import class Foundation.UserDefaults

extension UserDefaults {
    
    /// Restore default value to the factory default.
    ///
    /// - Parameter key: The default key to restore.
    func restore<T>(key: DefaultKey<T>) {
        
        self.removeObject(forKey: key.rawValue)
    }
    
    
    /// Return the initial value for key registered on `register(defaults:)`.
    ///
    /// - Parameter key: The default key.
    /// - Returns: The initial value.
    func registeredValue<T>(for key: DefaultKey<T>) -> T {
        
        self.volatileDomain(forName: UserDefaults.registrationDomain)[key.rawValue] as! T
    }
    
    
    subscript(key: DefaultKey<Bool>) -> Bool {
        
        get { self.bool(forKey: key.rawValue) }
        set { self.set(newValue, forKey: key.rawValue) }
    }
    
    
    subscript(key: DefaultKey<Int>) -> Int {
        
        get { self.integer(forKey: key.rawValue) }
        set { self.set(newValue, forKey: key.rawValue) }
    }
    
    
    subscript(key: DefaultKey<UInt>) -> UInt {
        
        get { UInt(exactly: self.integer(forKey: key.rawValue)) ?? 0 }
        set { self.set(newValue, forKey: key.rawValue) }
    }
    
    
    subscript(key: DefaultKey<Double>) -> Double {
        
        get { self.double(forKey: key.rawValue) }
        set { self.set(newValue, forKey: key.rawValue) }
    }
    
    
    subscript(key: DefaultKey<CGFloat>) -> CGFloat {
        
        get { self.double(forKey: key.rawValue) }
        set { self.set(newValue, forKey: key.rawValue) }
    }
    
    
    subscript(key: DefaultKey<String>) -> String {
        
        get { self.string(forKey: key.rawValue)! }
        set { self.set(newValue, forKey: key.rawValue) }
    }
    
    
    subscript(key: DefaultKey<String?>) -> String? {
        
        get { self.string(forKey: key.rawValue) }
        set { self.set(newValue, forKey: key.rawValue) }
    }
    
    
    subscript(key: DefaultKey<[String]>) -> [String] {
        
        get { self.stringArray(forKey: key.rawValue) ?? [] }
        set { self.set(newValue, forKey: key.rawValue) }
    }
    
    
    subscript<T>(key: DefaultKey<[T]>) -> [T] {
        
        get { self.array(forKey: key.rawValue) as? [T] ?? [] }
        set { self.set(newValue, forKey: key.rawValue) }
    }
    
    
    subscript<T>(key: DefaultKey<T>) -> T where T: RawRepresentable, T.RawValue == Int {
        
        get { T(rawValue: self.integer(forKey: key.rawValue)) ?? T(rawValue: 0)! }
        set { self.set(newValue.rawValue, forKey: key.rawValue) }
    }
}
