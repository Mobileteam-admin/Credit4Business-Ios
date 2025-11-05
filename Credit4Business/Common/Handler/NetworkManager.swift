//
//  NetworkManager.swift
//  Credit4Business
//
//  Created by MacMini on 24/04/24.
//

import Foundation
import Alamofire
import SwiftyJSON
enum NetworkEnvironment {
    case development
    case production
    case staging
    
    static var current: NetworkEnvironment!
    
    var baseURL: String {
        switch self {
        case .development:
            return "https://credit.demoserver.work/"
        case .staging:
            return "https://staging.credit4business.co.uk/"
        case .production:
            return "https://credit.demoserver.work/"
        }
    }
    
    static var isProduction: Bool {
        return current == .production
    }
}
class NetworkManager {
    
    static var environment: NetworkEnvironment = NetworkEnvironment.current
    private static let reachability = NetworkReachabilityManager()
    
    static func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Encodable? = nil,
        headers: HTTPHeaders? = defaultHeaders,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let isReachable = reachability?.isReachable, isReachable else {
            completion(.failure(NetworkError.noInternetConnection))
            return
        }
        
        let url = "\(environment.baseURL)\(endpoint)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        
        headers?.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        
        if let parameters = parameters {
            request.httpBody = try? JSONEncoder().encode(parameters)
        }
        
        
        AF.request(request)
            .validate()
            .responseDecodable(of: T.self) { response in
                print(response)
                let body = response.data
                if let body = body, let bodyString = String(data: body, encoding: .utf8) {
                    let dictionary = Utilities.convertStringToDictionary(text: bodyString)
                    if let responseMessage = dictionary?["status_message"] as? String {
                        if responseMessage.contains("Given token not valid for any token type") {
//                            UIApplication.topViewController()?.showAlert(title: "Session Expired", message: "Your session is expired", options: "OK", completion: { option in
//                                UserDefaults.standard.sessionId = ""
//                                let LoginVC = UIStoryboard(name: Storyboards.Login, bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                let navController = UINavigationController(rootViewController: LoginVC)
//                                sceneDelegate.window?.rootViewController = navController
//                                sceneDelegate.window?.makeKeyAndVisible()
//                            })
                            var dict = JSON()
                            dict["refresh"] = UserDefaults.standard.value(forKey: "refresh") as? String
                            APIService.shared.refreshTokenRequest(endpoint: APIEnums.refreshToken.rawValue,
                                                          withLoader: true,
                                                          method: .post,
                                                          params: dict) { result in
                                
                                switch result {
                                case .success(let data):
                                    if data.statusCode == 200 {
                                        UserDefaults.standard.set(data.access, forKey:"access")
                                        UserDefaults.standard.set(data.refresh, forKey:"refresh")
                                        request.headers = HTTPHeaders()
                                        defaultHeaders?.forEach { header in
                                            request.setValue(header.value, forHTTPHeaderField: header.name)
                                        }
                                        AF.request(request)
                                            .validate()
                                            .responseDecodable(of: T.self) { response in
                                                
                                                let body = response.data
                                                if let body = body, let bodyString = String(data: body, encoding: .utf8) {
                                                    let dictionary = Utilities.convertStringToDictionary(text: bodyString)
                                                    if let responseMessage = dictionary?["status_message"] as? String {
                                                        if responseMessage.contains("Given token not valid for any token type") {
                                                            return
                                                        }
                                                    }}
                                                switch response.result {
                                                case .success(let value):
                                                    completion(.success(value))
                                                case .failure(let error):
                                                    if let decodingError = error.asAFError?.underlyingError as? DecodingError {
                                                        completion(.failure(NetworkError.decodingError(decodingError)))
                                                    } else if let encodingError = error.asAFError?.underlyingError as? EncodingError {
                                                        completion(.failure(NetworkError.encodingError(encodingError)))
                                                    } else if let httpResponse = response.response, let responseData = response.data {
                                                        let serverMessage = String(data: responseData, encoding: .utf8) ?? "Unknown Error"
                                                        switch httpResponse.statusCode {
                                                        case 400: completion(.failure(NetworkError.custom(message: "Bad Request: \(serverMessage)")))
                                                        case 401: completion(.failure(NetworkError.custom(message: "Unauthorized: \(serverMessage)")))
                                                        case 403: completion(.failure(NetworkError.custom(message: "Forbidden: \(serverMessage)")))
                                                        case 404: completion(.failure(NetworkError.custom(message: "Not Found: \(serverMessage)")))
                                                        case 405: completion(.failure(NetworkError.custom(message: "Method Not Allowed: \(serverMessage)")))
                                                        case 406: completion(.failure(NetworkError.custom(message: "Not Acceptable: \(serverMessage)")))
                                                        case 407: completion(.failure(NetworkError.custom(message: "Proxy Authentication Required: \(serverMessage)")))
                                                        case 408: completion(.failure(NetworkError.custom(message: "Request Timeout: \(serverMessage)")))
                                                        case 409: completion(.failure(NetworkError.custom(message: "Conflict: \(serverMessage)")))
                                                        case 410: completion(.failure(NetworkError.custom(message: "Gone: \(serverMessage)")))
                                                        case 411: completion(.failure(NetworkError.custom(message: "Length Required: \(serverMessage)")))
                                                        case 500: completion(.failure(NetworkError.custom(message: "Internal Server Error: \(serverMessage)")))
                                                        case 501: completion(.failure(NetworkError.custom(message: "Not Implemented: \(serverMessage)")))
                                                        case 502: completion(.failure(NetworkError.custom(message: "Bad Gateway: \(serverMessage)")))
                                                        case 503: completion(.failure(NetworkError.custom(message: "Service Unavailable: \(serverMessage)")))
                                                        case 504: completion(.failure(NetworkError.custom(message: "Gateway Timeout: \(serverMessage)")))
                                                        case 505: completion(.failure(NetworkError.custom(message: "HTTP Version Not Supported: \(serverMessage)")))
                                                        default: completion(.failure(NetworkError.custom(message: serverMessage)))
                                                        }
                                                    } else {
                                                        completion(.failure(NetworkError.custom(message: error.localizedDescription)))
                                                    }
                                                }}
                                    }
                                    else if data.statusCode == 422 {
                                        UserDefaults.standard.set("", forKey:"access")
                                        UserDefaults.standard.set("", forKey:"refresh")
                                        UserDefaults.standard.set("", forKey:"role")
                                        UserDefaults.standard.set(0, forKey:"isLogin")
                                        UserDefaults.standard.set("", forKey:"email")
                                        UserDefaults.standard.set("", forKey:"name")
                                        UserDefaults.standard.set("", forKey:"image")
                                        UserDefaults.standard.set("", forKey:"address")

                                        var navigationController = UINavigationController()
                                        navigationController = UINavigationController(rootViewController: HomeViewController.initWithStory())
                                        sceneDelegate.window?.rootViewController = navigationController
                                        sceneDelegate.window?.makeKeyAndVisible()
                                        navigationController.isNavigationBarHidden = true
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                            //AppLoader.shared.removeLoader()

                            return
                        }
                    }
                }
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    if let decodingError = error.asAFError?.underlyingError as? DecodingError {
                        completion(.failure(NetworkError.decodingError(decodingError)))
                    } else if let encodingError = error.asAFError?.underlyingError as? EncodingError {
                        completion(.failure(NetworkError.encodingError(encodingError)))
                    } else if let httpResponse = response.response, let responseData = response.data {
                        let serverMessage = String(data: responseData, encoding: .utf8) ?? "Unknown Error"
                        switch httpResponse.statusCode {
                        case 400: completion(.failure(NetworkError.custom(message: "Bad Request: \(serverMessage)")))
                        case 401: completion(.failure(NetworkError.custom(message: "Unauthorized: \(serverMessage)")))
                        case 403: completion(.failure(NetworkError.custom(message: "Forbidden: \(serverMessage)")))
                        case 404: completion(.failure(NetworkError.custom(message: "Not Found: \(serverMessage)")))
                        case 405: completion(.failure(NetworkError.custom(message: "Method Not Allowed: \(serverMessage)")))
                        case 406: completion(.failure(NetworkError.custom(message: "Not Acceptable: \(serverMessage)")))
                        case 407: completion(.failure(NetworkError.custom(message: "Proxy Authentication Required: \(serverMessage)")))
                        case 408: completion(.failure(NetworkError.custom(message: "Request Timeout: \(serverMessage)")))
                        case 409: completion(.failure(NetworkError.custom(message: "Conflict: \(serverMessage)")))
                        case 410: completion(.failure(NetworkError.custom(message: "Gone: \(serverMessage)")))
                        case 411: completion(.failure(NetworkError.custom(message: "Length Required: \(serverMessage)")))
                        case 500: completion(.failure(NetworkError.custom(message: "Internal Server Error: \(serverMessage)")))
                        case 501: completion(.failure(NetworkError.custom(message: "Not Implemented: \(serverMessage)")))
                        case 502: completion(.failure(NetworkError.custom(message: "Bad Gateway: \(serverMessage)")))
                        case 503: completion(.failure(NetworkError.custom(message: "Service Unavailable: \(serverMessage)")))
                        case 504: completion(.failure(NetworkError.custom(message: "Gateway Timeout: \(serverMessage)")))
                        case 505: completion(.failure(NetworkError.custom(message: "HTTP Version Not Supported: \(serverMessage)")))
                        default: completion(.failure(NetworkError.custom(message: serverMessage)))
                        }
                    } else {
                        completion(.failure(NetworkError.custom(message: error.localizedDescription)))
                    }
                }
            }
    }
    
    static func apiRequest<T: Decodable>(
        endpoint: String,
        withLoader: Bool,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = defaultHeaders,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let isReachable = reachability?.isReachable, isReachable else {
            completion(.failure(NetworkError.noInternetConnection))
            return
        }
        
        let url = "\(environment.baseURL)\(endpoint)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        
        headers?.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        
        if let parameters = parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = jsonData
        }
        
        
        if withLoader {
            AppLoader.shared.addLoader()
        }
        
        AF.request(request)
            .validate()
            .responseDecodable(of: T.self) { response in
                print(response)
                if withLoader {
                    AppLoader.shared.removeLoader()
                }
                
                let body = response.data
                if let body = body, let bodyString = String(data: body, encoding: .utf8) {
                    let dictionary = Utilities.convertStringToDictionary(text: bodyString)
                    if let responseMessage = dictionary?["status_message"] as? String {
                        if responseMessage.contains("Given token not valid for any token type") {
                            //                            UIApplication.topViewController()?.showAlert(title: "Session Expired", message: "Your session is expired", options: "OK", completion: { option in
                            //                                UserDefaults.standard.sessionId = ""
                            //                                let LoginVC = UIStoryboard(name: Storyboards.Login, bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            //                                let navController = UINavigationController(rootViewController: LoginVC)
                            //                                sceneDelegate.window?.rootViewController = navController
                            //                                sceneDelegate.window?.makeKeyAndVisible()
                            //                            })
                                                        var dict = JSON()
                                                        dict["refresh"] = UserDefaults.standard.value(forKey: "refresh") as? String
                            
                                                        APIService.shared.refreshTokenRequest(endpoint: APIEnums.refreshToken.rawValue,
                                                                                      withLoader: true,
                                                                                      method: .post,
                                                                                      params: dict) { result in
                                                            
                                                            switch result {
                                                            case .success(let data):
                                                                if data.statusCode == 200 {
                                                                    UserDefaults.standard.set(data.access, forKey:"access")
                                                                    UserDefaults.standard.set(data.refresh, forKey:"refresh")
                                                                    request.headers = HTTPHeaders()
                                                                    defaultHeaders?.forEach { header in
                                                                        request.setValue(header.value, forHTTPHeaderField: header.name)
                                                                    }
                                                                    AF.request(request)
                                                                        .validate()
                                                                        .responseDecodable(of: T.self) { response in
                                                                            
                                                                            let body = response.data
                                                                            if let body = body, let bodyString = String(data: body, encoding: .utf8) {
                                                                                let dictionary = Utilities.convertStringToDictionary(text: bodyString)
                                                                                if let responseMessage = dictionary?["status_message"] as? String {
                                                                                    if responseMessage.contains("Given token not valid for any token type") {
                                                                                        return
                                                                                    }
                                                                                }}
                                                                            switch response.result {
                                                                            case .success(let value):
                                                                                completion(.success(value))
                                                                            case .failure(let error):
                                                                                if let decodingError = error.asAFError?.underlyingError as? DecodingError {
                                                                                    completion(.failure(NetworkError.decodingError(decodingError)))
                                                                                } else if let encodingError = error.asAFError?.underlyingError as? EncodingError {
                                                                                    completion(.failure(NetworkError.encodingError(encodingError)))
                                                                                } else if let httpResponse = response.response, let responseData = response.data {
                                                                                    let serverMessage = String(data: responseData, encoding: .utf8) ?? "Unknown Error"
                                                                                    switch httpResponse.statusCode {
                                                                                    case 400: completion(.failure(NetworkError.custom(message: "Bad Request: \(serverMessage)")))
                                                                                    case 401: completion(.failure(NetworkError.custom(message: "Unauthorized: \(serverMessage)")))
                                                                                    case 403: completion(.failure(NetworkError.custom(message: "Forbidden: \(serverMessage)")))
                                                                                    case 404: completion(.failure(NetworkError.custom(message: "Not Found: \(serverMessage)")))
                                                                                    case 405: completion(.failure(NetworkError.custom(message: "Method Not Allowed: \(serverMessage)")))
                                                                                    case 406: completion(.failure(NetworkError.custom(message: "Not Acceptable: \(serverMessage)")))
                                                                                    case 407: completion(.failure(NetworkError.custom(message: "Proxy Authentication Required: \(serverMessage)")))
                                                                                    case 408: completion(.failure(NetworkError.custom(message: "Request Timeout: \(serverMessage)")))
                                                                                    case 409: completion(.failure(NetworkError.custom(message: "Conflict: \(serverMessage)")))
                                                                                    case 410: completion(.failure(NetworkError.custom(message: "Gone: \(serverMessage)")))
                                                                                    case 411: completion(.failure(NetworkError.custom(message: "Length Required: \(serverMessage)")))
                                                                                    case 500: completion(.failure(NetworkError.custom(message: "Internal Server Error: \(serverMessage)")))
                                                                                    case 501: completion(.failure(NetworkError.custom(message: "Not Implemented: \(serverMessage)")))
                                                                                    case 502: completion(.failure(NetworkError.custom(message: "Bad Gateway: \(serverMessage)")))
                                                                                    case 503: completion(.failure(NetworkError.custom(message: "Service Unavailable: \(serverMessage)")))
                                                                                    case 504: completion(.failure(NetworkError.custom(message: "Gateway Timeout: \(serverMessage)")))
                                                                                    case 505: completion(.failure(NetworkError.custom(message: "HTTP Version Not Supported: \(serverMessage)")))
                                                                                    default: completion(.failure(NetworkError.custom(message: serverMessage)))
                                                                                    }
                                                                                } else {
                                                                                    completion(.failure(NetworkError.custom(message: error.localizedDescription)))
                                                                                }
                                                                            }}
                                                                }
                                                                else if data.statusCode == 422 {
                                                                    UserDefaults.standard.set("", forKey:"access")
                                                                    UserDefaults.standard.set("", forKey:"refresh")
                                                                    UserDefaults.standard.set("", forKey:"role")
                                                                    UserDefaults.standard.set(0, forKey:"isLogin")
                                                                    UserDefaults.standard.set("", forKey:"email")
                                                                    UserDefaults.standard.set("", forKey:"name")
                                                                    UserDefaults.standard.set("", forKey:"image")
                                                                    UserDefaults.standard.set("", forKey:"address")

                                                                    var navigationController = UINavigationController()
                                                                    navigationController = UINavigationController(rootViewController: HomeViewController.initWithStory())
                                                                    sceneDelegate.window?.rootViewController = navigationController
                                                                    sceneDelegate.window?.makeKeyAndVisible()
                                                                    navigationController.isNavigationBarHidden = true
                                                                }
                                                            case .failure(let error):
                                                                print(error)
                                                            }
                                                        }
                                                        //AppLoader.shared.removeLoader()

                                                        return
                                                    }
                    }
                }
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    if let decodingError = error.asAFError?.underlyingError as? DecodingError {
                        completion(.failure(NetworkError.decodingError(decodingError)))
                    } else if let encodingError = error.asAFError?.underlyingError as? EncodingError {
                        completion(.failure(NetworkError.encodingError(encodingError)))
                    } else if let httpResponse = response.response, let responseData = response.data {
                        let serverMessage = String(data: responseData, encoding: .utf8) ?? "Unknown Error"
                        switch httpResponse.statusCode {
                        case 400: completion(.failure(NetworkError.custom(message: "Bad Request: \(serverMessage)")))
                        case 401: completion(.failure(NetworkError.custom(message: "Unauthorized: \(serverMessage)")))
                        case 403: completion(.failure(NetworkError.custom(message: "Forbidden: \(serverMessage)")))
                        case 404: completion(.failure(NetworkError.custom(message: "Not Found: \(serverMessage)")))
                        case 405: completion(.failure(NetworkError.custom(message: "Method Not Allowed: \(serverMessage)")))
                        case 406: completion(.failure(NetworkError.custom(message: "Not Acceptable: \(serverMessage)")))
                        case 407: completion(.failure(NetworkError.custom(message: "Proxy Authentication Required: \(serverMessage)")))
                        case 408: completion(.failure(NetworkError.custom(message: "Request Timeout: \(serverMessage)")))
                        case 409: completion(.failure(NetworkError.custom(message: "Conflict: \(serverMessage)")))
                        case 410: completion(.failure(NetworkError.custom(message: "Gone: \(serverMessage)")))
                        case 411: completion(.failure(NetworkError.custom(message: "Length Required: \(serverMessage)")))
                        case 500: completion(.failure(NetworkError.custom(message: "Internal Server Error: \(serverMessage)")))
                        case 501: completion(.failure(NetworkError.custom(message: "Not Implemented: \(serverMessage)")))
                        case 502: completion(.failure(NetworkError.custom(message: "Bad Gateway: \(serverMessage)")))
                        case 503: completion(.failure(NetworkError.custom(message: "Service Unavailable: \(serverMessage)")))
                        case 504: completion(.failure(NetworkError.custom(message: "Gateway Timeout: \(serverMessage)")))
                        case 505: completion(.failure(NetworkError.custom(message: "HTTP Version Not Supported: \(serverMessage)")))
                        default: completion(.failure(NetworkError.custom(message: serverMessage)))
                        }
                    } else {
                        completion(.failure(NetworkError.custom(message: error.localizedDescription)))
                    }
                }
            }
    }
    private static var defaultHeaders: HTTPHeaders? {
        var headers = HTTPHeaders()
        headers.add(name: "Accept", value: "application/json")
        headers.add(name: "Content-Type", value: "application/json")
        if let access = UserDefaults.standard.value(forKey: "access"), access as! String != "" {
            headers.add(name: "Authorization", value: "Bearer \(access)")
        }
        return headers
    }
    
}
enum NetworkError: Error {
    case noInternetConnection
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case internalServerError
    case serverUnavailable
    case custom(message: String)
    case encodingError(EncodingError)
    case decodingError(DecodingError)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No internet connection."
        case .badRequest:
            return "Bad request."
        case .unauthorized:
            return "You're not authorized to access this."
        case .forbidden:
            return "Access is forbidden."
        case .notFound:
            return "The resource was not found."
        case .internalServerError:
            return "Internal server error."
        case .serverUnavailable:
            return "Server is currently unavailable. Please try again later."
        case .custom(let message):
            return message
        case .encodingError(let error):
            return encodeErrorDescription(from: error)
        case .decodingError(let error):
            return decodeErrorDescription(from: error)
        }
    }

    private func decodeErrorDescription(from error: DecodingError) -> String {
        switch error {
        case .dataCorrupted(let context):
            return "Data corrupted: \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            return "Key '\(key.stringValue)' not found: \(context.debugDescription)"
        case .typeMismatch(let type, let context):
            return "Type mismatch for type \(type): \(context.debugDescription)"
        case .valueNotFound(let value, let context):
            return "Value \(value) not found: \(context.debugDescription)"
        @unknown default:
            return "Unknown decoding error"
        }
    }

    private func encodeErrorDescription(from error: EncodingError) -> String {
        switch error {
        case .invalidValue(let value, let context):
            return "Invalid value \(value) provided: \(context.debugDescription)"
        @unknown default:
            return "Unknown encoding error"
        }
    }
}

