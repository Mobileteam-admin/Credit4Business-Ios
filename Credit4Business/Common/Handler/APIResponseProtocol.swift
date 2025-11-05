//
//  APIResponseProtocol.swift
//  Credit4Business
//
//  Created by MacMini on 29/02/24.
//

import Foundation
//MARK:- protocol APIResponseProtocol
protocol APIResponseProtocol{
    func responseDecode<T: Decodable>(to modal : T.Type,
                              _ result : @escaping Closure<T>) -> APIResponseProtocol
    func responseJSON(_ result : @escaping Closure<JSON>) -> APIResponseProtocol
    func responseFailure(_ error :@escaping Closure<String>)
}
typealias Closure<T> = (T)->()
typealias JSON = [String: Any]
extension JSONDecoder{
    func decode<T : Decodable>(_ model : T.Type,
                               result : @escaping Closure<T>) ->Closure<Data>{
        return { data in
            do{
                let value = try self.decode(model.self, from: data)
                result(value)
                
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}
extension Dictionary where Dictionary == JSON {
    var status_code : Int{
        return Int(self["status_code"] as? Int ?? Int()) 
    }
    var isSuccess : Bool{
        return status_code != 0
    }
    init?(_ data : Data){
          if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
              self = json
          }else{
              return nil
          }
      }
    var status_message : String{
        
        let statusMessage = self.string("status_message")
        let successMessage = self.string("success_message")
        return statusMessage.isEmpty ? successMessage : statusMessage
    }

//    var success_message : String{
//        return self["success_message"] as? String ?? String()
//    }
    
    func array<T>(_ key : String) -> [T]{
        return self[key] as? [T] ?? [T]()
    }
    func array(_ key : String) -> [JSON]{
        return self[key] as? [JSON] ?? [JSON]()
    }
    func json(_ key : String) -> JSON{
        return self[key] as? JSON ?? JSON()
    }
     func string(_ key : String)-> String{
     // return self[key] as? String ?? String()
         let value = self[key]
         if let str = value as? String{
            return str
         }else if let int = value as? Int{
            return int.description
         }else if let double = value as? Double{
            return double.description
         }else{
            return String()
         }
     }
    func nsString(_ key: String)-> NSString {
        return self.string(key) as NSString
    }
     func int(_ key : String)-> Int{
         //return self[key] as? Int ?? Int()
         let value = self[key]
         if let str = value as? String{
            return Int(str) ?? Int()
         }else if let int = value as? Int{
            return int
         }else if let double = value as? Double{
            return Int(double)
         }else{
            return Int()
         }
     }
     func double(_ key : String)-> Double{
     //return self[key] as? Double ?? Double()
         let value = self[key]
         if let str = value as? String{
            return Double(str) ?? Double()
         }else if let int = value as? Int{
            return Double(int)
         }else if let double = value as? Double{
            return double
         }else{
            return Double()
         }
     }
    
    func bool(_ key : String) -> Bool{
        let value = self[key]
        if let bool = value as? Bool{
            return bool
        }else if let int = value as? Int{
            return int == 1
        }else if let str = value as? String{
            return ["1","true"].contains(str)
        }else{
            return Bool()
        }
    }
}
class APIResponseHandler : APIResponseProtocol{
  
    init(){
    }
    var jsonSeq : Closure<JSON>?
    var dataSeq : Closure<Data>?
    var errorSeq : Closure<String>?
    
    func responseDecode<T>(to modal: T.Type, _ result: @escaping Closure<T>) -> APIResponseProtocol where T : Decodable {
        
        let decoder = JSONDecoder()
        self.dataSeq =  decoder.decode(modal, result: result)
        return self
    }
    
    func responseJSON(_ result: @escaping Closure<JSON>) -> APIResponseProtocol {
        self.jsonSeq = result
        return self
    }
    func responseFailure(_ error: @escaping Closure<String>) {
        self.errorSeq = error
        
      }
    func handleSuccess(value : Any,data : Data){
        if let jsonEscaping = self.jsonSeq{
            jsonEscaping(value as! JSON)
        }
        if let dataEscaping = dataSeq{
            dataEscaping(data)
        }
    }
    func handleFailure(value : String){
        self.errorSeq?(value)
     }
}
//MARK:- KeyedDecodingContainer
public extension KeyedDecodingContainer{
    
    func safeDecodeValue<T : SafeDecodable & Decodable>(forKey key : Self.Key) -> T{
        
        if let value = try? self.decodeIfPresent(T.self, forKey: key){
            return value
        }else if let value = try? self.decodeIfPresent(String.self, forKey: key){
            return value.cast()
        }else if let value = try? self.decodeIfPresent(Int.self, forKey: key){
            return value.cast()
        }else if let value = try? self.decodeIfPresent(Float.self, forKey: key){
            return value.cast()
        }else if let value = try? self.decodeIfPresent(Double.self, forKey: key){
            return value.cast()
        }else if let value = try? self.decodeIfPresent(Bool.self, forKey: key){
            return value.cast()
        }
        print("Key Missing : \(key.stringValue)")
        return T.init()
       
    }
   
}
//MARK:- protocol SafeDecodable
public protocol Initializable {
    init()
}

public protocol DefaultValue : Initializable {}
extension DefaultValue {
    static var `default` : Self{return Self.init()}
}

public protocol SafeDecodable : DefaultValue{}
extension SafeDecodable{
    func cast<T: SafeDecodable>() -> T{return T.init()}
}

//extension RawRepresentable where RawValue == String {
//    var description: String {
//        return rawValue
//    }
//
//
//}

//MARK:- Int
extension Int : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.default
    }
    
    
}
//MARK:- Double
extension Double : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- Float
extension Float : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- String
extension String : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is Int.Type:
            castValue = Int(self.description) as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = ["true","yes","1"]
                .contains(self.lowercased()) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- Bool
extension Bool : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Bool.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Float.Type:
            castValue = (self ? 1 : 0) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- Array
extension Array : SafeDecodable{
    public static var `default` : Array<Element> {return Array<Element>()}
    public func cast<T>() -> T where T : SafeDecodable {
       return T.init()
    }
}
