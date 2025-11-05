//
//  ConnectionHandler.swift
//  Credit4Business
//
//  Created by MacMini on 29/02/24.
//

import Foundation
import UIKit
import Alamofire

final class ConnectionHandler : NSObject {
    static let shared = ConnectionHandler()
    private let alamofireManager : Session
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var preference = UserDefaults.standard
    
    override init() {
        print("Singleton initialized")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300 // seconds
        configuration.timeoutIntervalForResource = 500
        alamofireManager = Session.init(configuration: configuration,
                                        serverTrustManager: .none)//Alamofire.SessionManager(configuration: configuration)
    }
    func getRequest(for api : APIEnums,
                    params : Parameters) -> APIResponseProtocol{
        if api.method == .get {
            return self.getRequest(forAPI: APIUrl + api.rawValue,
                                   params: params,
                                   CacheAttribute: .none)
        } else {
             return self.postRequest(forAPI: APIUrl + api.rawValue,
                                     params: params,isAuthenticated: api.isAuthenticated)
        }
    }
    
    func postRequest(forAPI api: String, params: Parameters,isAuthenticated: Bool) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        var token = UserDefaults.standard.value(forKey: "access")
        var parameters = params
        parameters["token"] = ""
        AppLoader.shared.addLoader()
        var headers = HTTPHeaders()
        if let access = token, token as! String != "" && isAuthenticated {
            headers.add(name: "Authorization", value: "Bearer \(token)")
        }
//        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)

        alamofireManager.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, to: api,headers: headers).response { results in
            AppLoader.shared.removeLoader()

            switch results.result{

            case .success(let anyData):
                print("Succesfully uploaded")
                print(results.request?.url as Any)
                if let err = results.error{
                    responseHandler.handleFailure(value: err.localizedDescription)
                    //                                       self.appDelegate.createToastMessage(err.localizedDescription, bgColor: .black, textColor: .white)
                    return
                }
                if let data = anyData,
                   let json = JSON(data){
                    if json.status_code == 200 || json.status_code == 201 {
                        
                        responseHandler.handleSuccess(value: json, data: data)
                    }else{
                        responseHandler.handleFailure(value: json.status_message)
                    }
                }
            case .failure(let error):
                if error._code == 13 {
                    responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription)
                }
            }
        }
//        alamofireManager.request(api,
//                                 method: .post,
//                                 parameters: parameters,
//                                 encoding: URLEncoding.default,
//                                 headers: nil)
//            .responseJSON { (response) in
//                print("Å api : ",response.request?.url ?? ("\(api)\(parameters)"))
//                guard response.response?.statusCode != 401 else{//Unauthorized
//                    if response.request?.url?.description.contains(APIUrl) ?? false{
//                    }
//                    return
//                }
//
//                guard response.response?.statusCode != 503 else { // Web Under Maintenance
//                    return
//                }
//                switch response.result{
//                case .success(let value):
//                    let json = value as! JSON
//                    let error = json.string("error")
//                    guard error.isEmpty else{
//                        if error == "user_not_found"
//                            && response.request?.url?.description.contains(APIUrl) ?? false{
//                        }
//                        return
//                    }
//                    if json.isSuccess
//                        || !api.contains(APIUrl)
//                        || response.response?.statusCode == 200{
//
//                        responseHandler.handleSuccess(value: value,data: response.data ?? Data())
//                    }else{
//                        responseHandler.handleFailure(value: json.status_message)
//                    }
//                case .failure(let error):
//                    if error._code == 13 {
//                        responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
//                    } else {
//                        responseHandler.handleFailure(value: error.localizedDescription)
//                    }
//                }
//            }
        
        
        return responseHandler
    }
   
    func getRequest(forAPI api: String,
                    params: JSON,
                    CacheAttribute: APIEnums) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        var parameters = params
        let startTime = Date()
        parameters["token"] = ""
        
        alamofireManager.request(api,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: nil).responseJSON { (response) in
                print("Å api : ",response.request?.url ?? ("\(api)\(params)"))
                guard response.response?.statusCode != 503 else { // Web Under Maintenance
                    return
                }
                
                guard response.response?.statusCode != 401 else{//Unauthorized
                    if response.request?.url?.description.contains(APIUrl) ?? false{
                    }
                    return
                }
                switch response.result {
                case .success(let value):
                    let json = value as! JSON
                    let error = json.string("error")
                    guard error.isEmpty else{
                        if error == "user_not_found"
                            && response.request?.url?.description.contains(APIUrl) ?? false{
                        }
                        return
                    }
                    if json.isSuccess
                        || !api.contains(APIUrl)
                        || response.response?.statusCode == 200 {
                        
                        responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                    }else{
                        responseHandler.handleFailure(value: json.status_message)
                    }
                case .failure(let error):
                    if error._code == 13 {
                        responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                    } else {
                        responseHandler.handleFailure(value: error.localizedDescription)
                    }
                }
            }
        
        
        return responseHandler
    }

    

    
    
    //MARK:- Send multiple data format
    
    func uploadMutipleImgPost(wsMethod:String,
                              paramDict: [String:Any],
                              fileName:String="registered_address.leasehold.document",
                              contactLessFilename:String="trading_address.leasehold.document",
                              imgData:Data?,
                              imgData1:Data?,
                              viewController:UIViewController,
                              isToShowProgress:Bool,
                              isToStopInteraction:Bool,
                              complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToStopInteraction {
            // UIApplication.shared.beginIgnoringInteractionEvents()
            UIApplication.shared.windows.last?.isUserInteractionEnabled = false
        }
        var token = UserDefaults.standard.value(forKey: "access") as? String

        var headers = HTTPHeaders()
        if let access = token, token as! String != "" {
            headers.add(name: "Authorization", value: "Bearer \(access)")
        }
        let goferDelUrl = APIUrl
        //AppWebConstants.APIBaseUrl
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict {
                multipartFormData.append(String(describing: value).data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
            }
            let fileName1 =  String(Date().timeIntervalSince1970 * 1000) + "\(fileName).pdf"
            if let data = imgData,imgData != Data() {
                multipartFormData.append(data,
                                         withName: fileName,
                                         fileName: "\(fileName).pdf",
                                         mimeType: "application/pdf")
            }
            
            if let data = imgData1,imgData1 != Data() {
                multipartFormData.append(data,
                                         withName: contactLessFilename,
                                         fileName: "\(contactLessFilename).pdf",
                                         mimeType: "application/pdf")
            }
            //Optional for extra parameters
        },to:"\(goferDelUrl)\(wsMethod)",headers: headers) .response { resp in
           
            switch resp.result {
            case .success(let data):
                if isToStopInteraction {
                    //UIApplication.shared.endIgnoringInteractionEvents()
                    UIApplication.shared.windows.last?.isUserInteractionEnabled = true
                }
                do {
                    if let responseDict = try JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers) as? [String:Any] {
                        guard responseDict["error"] == nil else {
                            return
                        }
                        
                        guard responseDict.count > 0 else {
                            return
                        }
                        
                        if (responseDict["status_code"] as? String ?? "" ) == "0" &&
                            ((responseDict["success_message"] as? String ?? "" ) == "Inactive User" ||
                             (responseDict["success_message"] as? String ?? "" ) == "The token has been blacklisted" ||
                             responseDict["success_message"] as? String ?? ""  == "User not found") {
                            //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "k_LogoutUser"), object: nil)
                        }
                        else {
                            complete(responseDict as [String : Any] )
                        }
                    }
                } catch {
                    print("Error")
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    func uploadDocuments(wsMethod:String,
                              paramDict: [String:Any],
                         dataArray: [String:Any],
                              viewController:UIViewController,
                              isToShowProgress:Bool,
                              isToStopInteraction:Bool,
                              complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToStopInteraction {
            // UIApplication.shared.beginIgnoringInteractionEvents()
            UIApplication.shared.windows.last?.isUserInteractionEnabled = false
        }
        var token = UserDefaults.standard.value(forKey: "access") as? String

        var headers = HTTPHeaders()
        if let access = token, token as! String != "" {
            headers.add(name: "Authorization", value: "Bearer \(access)")
        }
        let goferDelUrl = APIUrl
        //AppWebConstants.APIBaseUrl
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict {
                multipartFormData.append(String(describing: value).data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
            }
//            let fileName1 =  String(Date().timeIntervalSince1970 * 1000) + "\(fileName).jpg"
//            if let data = imgData {
//                multipartFormData.append(data,
//                                         withName: fileName,
//                                         fileName: fileName1,
//                                         mimeType: "image/jpeg")
//            }
            for (key,value) in dataArray {
                if let array = value as? [UploadDocumentModel] {
                    for element in array {
                        var model = element as? UploadDocumentModel
                        if model?.data != Data() {
                            multipartFormData.append(model?.data ?? Data(),
                                                         withName: key,
                                                     fileName: model?.fileName ?? "",
                                                     mimeType: model?.mimeType ?? "")
                        }
                    }
                    
                }else{
                    var model = value as? UploadDocumentModel
                    if model?.data != Data() {
                        multipartFormData.append(model?.data ?? Data(),
                                                     withName: key,
                                                 fileName: model?.fileName ?? "",
                                                 mimeType: model?.mimeType ?? "")
                    }
                }
                
                
            }
            
            //Optional for extra parameters
        },to:"\(goferDelUrl)\(wsMethod)",headers: headers) .response { resp in
           
            switch resp.result {
            case .success(let data):
                if isToStopInteraction {
                    //UIApplication.shared.endIgnoringInteractionEvents()
                    UIApplication.shared.windows.last?.isUserInteractionEnabled = true
                }
                do {
                    if let responseDict = try JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers) as? [String:Any] {
                        guard responseDict["error"] == nil else {
                            return
                        }
                        
                        guard responseDict.count > 0 else {
                            return
                        }
                        
                        if (responseDict["status_code"] as? String ?? "" ) == "0" &&
                            ((responseDict["success_message"] as? String ?? "" ) == "Inactive User" ||
                             (responseDict["success_message"] as? String ?? "" ) == "The token has been blacklisted" ||
                             responseDict["success_message"] as? String ?? ""  == "User not found") {
                            //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "k_LogoutUser"), object: nil)
                        }
                        else {
                            complete(responseDict as [String : Any] )
                        }
                    }
                } catch {
                    print("Error")
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    func profileImageUpload(wsMethod:String,
                              paramDict: [String:Any],
                         dataArray: [String:Any],
                              viewController:UIViewController,
                              isToShowProgress:Bool,
                              isToStopInteraction:Bool,
                              complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToStopInteraction {
            // UIApplication.shared.beginIgnoringInteractionEvents()
            UIApplication.shared.windows.last?.isUserInteractionEnabled = false
        }
        var token = UserDefaults.standard.value(forKey: "access") as? String

        var headers = HTTPHeaders()
        if let access = token, token as! String != "" {
            headers.add(name: "Authorization", value: "Bearer \(access)")
        }
        let goferDelUrl = APIUrl
        //AppWebConstants.APIBaseUrl
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict {
                multipartFormData.append(String(describing: value).data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
            }
//            let fileName1 =  String(Date().timeIntervalSince1970 * 1000) + "\(fileName).jpg"
//            if let data = imgData {
//                multipartFormData.append(data,
//                                         withName: fileName,
//                                         fileName: fileName1,
//                                         mimeType: "image/jpeg")
//            }
            for (key,value) in dataArray {
                var model = value as? UploadDocumentModel
                multipartFormData.append(model?.data ?? Data(),
                                             withName: key,
                                         fileName: model?.fileName ?? "",
                                         mimeType: model?.mimeType ?? "")
            }
            
            //Optional for extra parameters
        },to:"\(goferDelUrl)\(wsMethod)", method: .patch,headers: headers) .response { resp in
           
            switch resp.result {
            case .success(let data):
                if isToStopInteraction {
                    //UIApplication.shared.endIgnoringInteractionEvents()
                    UIApplication.shared.windows.last?.isUserInteractionEnabled = true
                }
                do {
                    if let responseDict = try JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers) as? [String:Any] {
                        guard responseDict["error"] == nil else {
                            return
                        }
                        
                        guard responseDict.count > 0 else {
                            return
                        }
                        
                        if (responseDict["status_code"] as? String ?? "" ) == "0" &&
                            ((responseDict["success_message"] as? String ?? "" ) == "Inactive User" ||
                             (responseDict["success_message"] as? String ?? "" ) == "The token has been blacklisted" ||
                             responseDict["success_message"] as? String ?? ""  == "User not found") {
                            //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "k_LogoutUser"), object: nil)
                        }
                        else {
                            complete(responseDict as [String : Any] )
                        }
                    }
                } catch {
                    print("Error")
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
}


class APIService {
    
    static let shared = APIService()
    private init() {}
   
}
//MARK: -------------------- Common API Call Request --------------------
extension APIService {
    func retrieveRemarkDetails(isRemarks: Bool,loanId: String,completion: @escaping (Result<RemarksModel, Error>) -> Void) {
        NetworkManager.request(endpoint: isRemarks ? APIEnums.retrieveRemarks.rawValue + "\(loanId)/" : APIEnums.retrieveComments.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveCompanyListDetails(url: String,completion: @escaping (Result<CompanyListModel, Error>) -> Void) {
        NetworkManager.request(endpoint: url, method: .get, parameters: nil, completion: completion)
    }
    func retrieveCompanyDetails(loanId: String,completion: @escaping (Result<CompanyModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveCompanyDetails.rawValue + "?loan_id=\(loanId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveConsentFormDetails(loanId: String,completion: @escaping (Result<ConsentResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createConsent.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrievePersonalFormDetails(loanId: String,completion: @escaping (Result<PersonalDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createPersonal.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveAdditionalFormDetails(completion: @escaping (Result<AdditionalDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createAdditional.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveBusinessFormDetails(loanId: String,completion: @escaping (Result<BusinessDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createBusiness.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveDocumentsFormDetails(loanId: String,completion: @escaping (Result<DocumentsDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createDocuments.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveGuarantorFormDetails(loanId: String,completion: @escaping (Result<GuarantorDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createGuarantor.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrievePremiseFormDetails(loanId: String,completion: @escaping (Result<PremiseDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createPremise.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveDirectorsFormDetails(loanId: String,completion: @escaping (Result<SelectedDirectorResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.updateDirector.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrievePhotoIDDetails(completion: @escaping (Result<PhotoIDDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrievePhotoId.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrievePhotoIDDetailsFromAgent(customerId: String,completion: @escaping (Result<PhotoIDDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrievePhotoId.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrievePhotoIDDetailsFromAgent(unitId: String,completion: @escaping (Result<PhotoIDDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrievePhotoId.rawValue + "?unit_id=\(unitId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveOtherFilesDetails(completion: @escaping (Result<OtherDocumentsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveOtherFiles.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveContractDetails(loanId: String,completion: @escaping (Result<ContractModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveContracts.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveOtherFilesDetailsFromAgent(customerId: String,completion: @escaping (Result<OtherDocumentsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveOtherFiles.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveOtherFilesDetailsFromAgent(unitId: String,completion: @escaping (Result<OtherDocumentsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveOtherFiles.rawValue + "?unit_id=\(unitId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveBankStatementDetails(completion: @escaping (Result<BankStatementsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveBankStatements.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveBankStatementDetailsFromAgent(customerId: String,completion: @escaping (Result<BankStatementsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveBankStatements.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveBankStatementDetailsFromAgent(unitId: String,completion: @escaping (Result<BankStatementsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveBankStatements.rawValue + "?unit_id=\(unitId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveAddressProofDetails(completion: @escaping (Result<AddressProofDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveAddressProof.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveAddressProofDetailsFromAgent(customerId: String,completion: @escaping (Result<AddressProofDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveAddressProof.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveAddressProofDetailsFromAgent(unitId: String,completion: @escaping (Result<AddressProofDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveAddressProof.rawValue + "?unit_id=\(unitId)", method: .get, parameters: nil, completion: completion)
    }
    func retrievePaymentDetails(loanId: String,completion: @escaping (Result<UpcomingPaymentsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrievePayment.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveCashDisbursedDetails(customerId: String,completion: @escaping (Result<Summary, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveSummary.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveAllPaymentDetails(completion: @escaping (Result<AllPaymentsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveAllPayment.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrievePaymentDetailsFromAgent(customerId: String,completion: @escaping (Result<UpcomingPaymentsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrievePayment.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveLeadsDetails(url: String,completion: @escaping (Result<LeadsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: url, method: .get, parameters: nil, completion: completion)
    }
    func retrieveCustomerDetails(url: String,completion: @escaping (Result<CustomerModel, Error>) -> Void) {
        NetworkManager.request(endpoint: url, method: .get, parameters: nil, completion: completion)
    }
    func retrievePersonalDetailsFromAgent(customerId: String,completion: @escaping (Result<PersonalDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createPersonal.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveIdentityVerificationStatusFromAgent(customerId: String,completion: @escaping (Result<IdentityVerificationStatusModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveIdentityVerificationStatus.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveAdditionalDetailsFromAgent(customerId: String,completion: @escaping (Result<AdditionalDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createAdditional.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveBusinessDetailsFromAgent(customerId: String,completion: @escaping (Result<BusinessDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createBusiness.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveConsentDetailsFromAgent(customerId: String,completion: @escaping (Result<ConsentResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createConsent.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveDocumentsDetailsFromAgent(customerId: String,completion: @escaping (Result<DocumentsDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createDocuments.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrievePremiseDetailsFromAgent(customerId: String,completion: @escaping (Result<PremiseDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createPremise.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveDirectorDetailsFromAgent(customerId: String,completion: @escaping (Result<SelectedDirectorResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.updateDirector.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveGuarantorFormDetailsFromAgent(customerId: String,completion: @escaping (Result<GuarantorDataResponse, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createGuarantor.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveReferralDetails(completion: @escaping (Result<ReferralModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.createReferral.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveProfileDetails(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveProfileDetails.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveAgentProfileDetails(completion: @escaping (Result<AgentProfileModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveAgentProfileDetails.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveNotificationDetails(completion: @escaping (Result<NotificationModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveNotificationDetails.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveAgentNotificationDetails(completion: @escaping (Result<AgentNotificationModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveAgentNotificationDetails.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrievePendingApprovalDetails(type:String,customerId: String,completion: @escaping (Result<PendingApprovalModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrievePendingApproval.rawValue + "?type=\(type)&customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveLoanDetails(completion: @escaping (Result<LoanModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveLoan.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveLoanDetailsWithLoanID(loanId: String,completion: @escaping (Result<SeparateLoanModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveLoan.rawValue + loanId + "/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveLoanDetailsWithCustomerID(customerId: String,completion: @escaping (Result<LoanModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveLoan.rawValue + "?customer_id=\(customerId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveLoanDetailsFromAgent(unitId:String,completion: @escaping (Result<LoanModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveLoan.rawValue + "?company_id=\(unitId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveKPIDetails(completion: @escaping (Result<KPIModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveKPI.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveFundingOfferDetails(loanId: String,completion: @escaping (Result<FundingOfferModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveFundingOffer.rawValue + "?loan_id=\(loanId)", method: .get, parameters: nil, completion: completion)
    }
    func retrieveBankDetails(loanId: String,completion: @escaping (Result<BankModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveBanks.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveStatementDetails(loanId: String,completion: @escaping (Result<StatementModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveStatement.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveBankAccountDetails(loanId: String,completion: @escaping (Result<BankAccountModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveBankAccounts.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveGocardlessStatementDetails(loanId: String,completion: @escaping (Result<GocardlessStatusModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveGocardlessStatement.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveGocardlessManualStatementDetails(loanId: String,completion: @escaping (Result<GocardlessManualModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveGocardlessManualStatement.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveIdentityVerificationStatus(loanId: String,completion: @escaping (Result<IdentityVerificationStatusModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveIdentityVerificationStatus.rawValue + "\(loanId)/", method: .get, parameters: nil, completion: completion)
    }
    func retrieveIdentityVerificationStatus(customerId: String,completion: @escaping (Result<IdentityVerificationStatusModelForCustomer, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveIdentityVerificationStatusFromCustomer.rawValue + "\(customerId)/", method: .get, parameters: nil, completion: completion)
    }
    func applyNewLoan(completion: @escaping (Result<NewLoanModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.applyNewLoan.rawValue, method: .post, parameters: nil, completion: completion)
    }
    func retrieveCreditMonitoringList(completion: @escaping (Result<CreditMonitoringModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveCreditMonitoring.rawValue, method: .get, parameters: nil, completion: completion)
    }
    func retrieveCreditMonitoringComments(loanId: String,mandateId: String,completion: @escaping (Result<CreditMonitoringCommentsModel, Error>) -> Void) {
        NetworkManager.request(endpoint: APIEnums.retrieveCreditMonitoringComments.rawValue + "\(loanId)/\(mandateId)/", method: .get, parameters: nil, completion: completion)
    }
    func makeRequest(endpoint: String,
                     withLoader: Bool,
                     method: HTTPMethod,
                     params: [String: Any],
                     completion: @escaping (Result<ResponseDataStructure, Error>) -> Void) {
        
        NetworkManager.apiRequest(endpoint: endpoint,
                                  withLoader: withLoader,
                                  method: method,
                                  parameters: params,
                                  completion: completion)
    }
    func loanSubmitRequest(endpoint: String,
                     withLoader: Bool,
                     method: HTTPMethod,
                     params: [String: Any],
                     completion: @escaping (Result<LoanSubmitModel, Error>) -> Void) {
        
        NetworkManager.apiRequest(endpoint: endpoint,
                                  withLoader: withLoader,
                                  method: method,
                                  parameters: params,
                                  completion: completion)
    }
    func InstantPayRequest(endpoint: String,
                     withLoader: Bool,
                     method: HTTPMethod,
                     params: [String: Any],
                     completion: @escaping (Result<InstantPaymentModel, Error>) -> Void) {
        
        NetworkManager.apiRequest(endpoint: endpoint,
                                  withLoader: withLoader,
                                  method: method,
                                  parameters: params,
                                  completion: completion)
    }
    func refreshTokenRequest(endpoint: String,
                     withLoader: Bool,
                     method: HTTPMethod,
                     params: [String: Any],
                     completion: @escaping (Result<RefreshTokenModel, Error>) -> Void) {
        
        NetworkManager.apiRequest(endpoint: endpoint,
                                  withLoader: withLoader,
                                  method: method,
                                  parameters: params,
                                  completion: completion)
    }
    func requisitionRequest(endpoint: String,
                     withLoader: Bool,
                     method: HTTPMethod,
                     params: [String: Any],
                     completion: @escaping (Result<RequisitionModel, Error>) -> Void) {
        
        NetworkManager.apiRequest(endpoint: endpoint,
                                  withLoader: withLoader,
                                  method: method,
                                  parameters: params,
                                  completion: completion)
    }
    func updateConsentDetailsApi(endpoint: String,
                     withLoader: Bool,
                     method: HTTPMethod,
                     params: [String: Any],
                     completion: @escaping (Result<ConsentResponse, Error>) -> Void) {
        
        NetworkManager.apiRequest(endpoint: endpoint,
                                  withLoader: withLoader,
                                  method: method,
                                  parameters: params,
                                  completion: completion)
    }
    func deletePhotoIDDetailsApi(endpoint: String,
                     withLoader: Bool,
                     method: HTTPMethod,
                     params: [String: Any],
                     completion: @escaping (Result<ResponseDataStructure, Error>) -> Void) {
        
        NetworkManager.apiRequest(endpoint: endpoint,
                                  withLoader: withLoader,
                                  method: method,
                                  parameters: params,
                                  completion: completion)
    }
    func forgotPasswordApi(endpoint: String,
                     withLoader: Bool,
                     method: HTTPMethod,
                     params: [String: Any],
                     completion: @escaping (Result<forgotPasswordResponse, Error>) -> Void) {
        
        NetworkManager.apiRequest(endpoint: endpoint,
                                  withLoader: withLoader,
                                  method: method,
                                  parameters: params,
                                  completion: completion)
    }
    func updateProfileDetailsApi(endpoint: String,
                     withLoader: Bool,
                     method: HTTPMethod,
                     params: [String: Any],
                     completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        
        NetworkManager.apiRequest(endpoint: endpoint,
                                  withLoader: withLoader,
                                  method: method,
                                  parameters: params,
                                  completion: completion)
    }
    func updateAgentProfileDetailsApi(endpoint: String,
                     withLoader: Bool,
                     method: HTTPMethod,
                     params: [String: Any],
                     completion: @escaping (Result<AgentProfileModel, Error>) -> Void) {
        
        NetworkManager.apiRequest(endpoint: endpoint,
                                  withLoader: withLoader,
                                  method: method,
                                  parameters: params,
                                  completion: completion)
    }

}

struct ResponseDataStructure: Codable {
    var statusMessage: String
    var statusCode: Int
    var statusTitle: String

    enum CodingKeys: String, CodingKey {
       
        case statusMessage = "status_message"
        case statusCode = "status_code"
        case statusTitle = "status_title"
    }
}
struct LoanSubmitModel: Codable {
    let loanStatusData: LoanStatusData
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case loanStatusData = "loan_status_data"
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}

// MARK: - LoanStatusData
struct LoanStatusData: Codable {
    let id, filledFormsCount, interest: Int
    let isIntrestChanged: Bool
    let approvedDate, appliedDate: String
    let returnedByUnderwriter, approvedByManager: Bool
    let managerApproveDate: String
    let adminReviewRequired, approvedByAdmin: Bool
    let adminApproveDate, currentStatus, upcomingStatus, returnReason: String
    let rejectReason, interestChangeReason: String
    let isIdentityVerificationMailSend, isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case filledFormsCount = "filled_forms_count"
        case interest
        case isIntrestChanged = "is_intrest_changed"
        case approvedDate = "approved_date"
        case appliedDate = "applied_date"
        case returnedByUnderwriter = "returned_by_underwriter"
        case approvedByManager = "approved_by_manager"
        case managerApproveDate = "manager_approve_date"
        case adminReviewRequired = "admin_review_required"
        case approvedByAdmin = "approved_by_admin"
        case adminApproveDate = "admin_approve_date"
        case currentStatus = "current_status"
        case upcomingStatus = "upcoming_status"
        case returnReason = "return_reason"
        case rejectReason = "reject_reason"
        case interestChangeReason = "interest_change_reason"
        case isIdentityVerificationMailSend = "is_identity_verification_mail_send"
        case isActive = "is_active"
    }
}
struct forgotPasswordResponse: Codable {
    var statusMessage: String
    var statusCode: Int
    var statusTitle: String
    var token : String
    enum CodingKeys: String, CodingKey {
       
        case statusMessage = "status_message"
        case statusCode = "status_code"
        case statusTitle = "status_title"
        case token
    }
}
