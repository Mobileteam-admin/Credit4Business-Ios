//
//  gojekHomeVM.swift
//  GoferHandy
//
//  Created by Trioangle on 28/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

class HomeVM: BaseViewModel {
    var businessTypeArray = [Common]()
    var fundingPurposeArray = [Common]()
    var nameArray = [Common]()
    var durationArray = [Common]()
    var representativeArray = [Common]()
    var directorNameArray = [SelectedDirector]()
    var businessSectorTypeArray = [Common]()
    var postCodeArray = [Common]()
    var regpremiseTypeArray = [Common]()
    var tradingpremiseTypeArray = [Common]()
//    var premiseTypeArray = [Common]()
    var houseOwnershipArray = [Common]()
    var propertyArray = [PropertyAddressModel]()
    var addressArray = [AddressAloneModel]()
    var postalLookupArray = [PostcodeModel]()
    var companyPostalLookupArray = [CompanyNameModel]()
    var paymentArray = [PaymentHistoryModel]()
    var documentArray = [DocumentModel]()
    var documentArray2 = [DocumentModel]()
    var paymentDayArray = [Common]()
    var otherArray = [DocumentModel]()
    var statementArray = [DocumentModel]()

    override init() {
        super.init()
        self.addBusinessTypeData()
        self.addPaymentDayData()
        self.addBusinessSectorTypeData()
        self.addNameData()
        self.addFundingPurpose()
        self.addDurationData()
        self.addRepresentativeTypeData()
        self.addPostCodeData()
        self.addRegPremiseTypeData()
        self.addTradingPremiseTypeData()
        self.addhouseOwnershipTypeData()
    }
//    func createDirectorArray(count: Int,fundingModel: FundingModel) {
//        var array = [NameModel]()
//        let list = [Int](0...count-1)
//        for (index,_) in list.enumerated(){
//            if index == 0 {
//                var model = NameModel()
//                model.firstName = fundingModel.initial.firstName
//                model.lastName = fundingModel.initial.lastName
//                model.title = fundingModel.initial.title
//                model.id = index
//                array.append(model)
//            }else{
//                var model = NameModel()
//                model.id = index
//                array.append(model)
//            }
//        }
//        self.directorNameArray = array
//        
//    }
    func createDirectorArray(count: Int,selectedArray: [SelectedDirector]) {
        var array = [SelectedDirector]()
        let list = [Int](0...count-1)
        for (index,_) in list.enumerated(){
            if let selectedVal = selectedArray.value(atSafe: index) {
                array.append(selectedVal)
            }else{
                var model = SelectedDirector()
                model.id = 0
                array.append(model)
            }
               
        }
        self.directorNameArray = array
        
    }
    func createPropertyArray(count: Int) {
        var array = [PropertyAddressModel]()
        let list = [Int](0...count-1)
        for (index,_) in list.enumerated(){
            if index == 0 {
                var model = PropertyAddressModel()
                array.append(model)
            }else{
                array.append(PropertyAddressModel())
            }
        }
        self.propertyArray = array
    }
    func addBusinessTypeData() {
        var arr = [Common]()
        arr.append(Common(id: 0, description: "Limited Company"))
        arr.append(Common(id: 1, description: "Limited Partnership (LLP)"))
        arr.append(Common(id: 2, description: "Sole Trader"))
        self.businessTypeArray = arr
    }
    func addPaymentDayData() {
        var arr = [Common]()
        arr.append(Common(id: 0, description: "Monday"))
        arr.append(Common(id: 1, description: "Tuesday"))
        arr.append(Common(id: 2, description: "Wednesday"))
        arr.append(Common(id: 2, description: "Thursday"))
        arr.append(Common(id: 2, description: "Friday"))
//        arr.append(Common(id: 2, description: "Saturday"))
//        arr.append(Common(id: 2, description: "Sunday"))
//        arr.append(Common(id: 2, description: "Custom"))

        self.paymentDayArray = arr
    }
    func addhouseOwnershipTypeData() {
        var arr = [Common]()
        arr.append(Common(id: 0, description: "Owned"))
        arr.append(Common(id: 1, description: "Tenant"))
        arr.append(Common(id: 2, description: "Family Owned"))
        arr.append(Common(id: 3, description: "Spouse Owned"))
        self.houseOwnershipArray = arr
    }
    func addPostCodeData() {
        var arr = [Common]()
        arr.append(Common(id: 0, description: "674656"))
        arr.append(Common(id: 1, description: "674657"))
        arr.append(Common(id: 2, description: "674658"))
        self.postCodeArray = arr
    }
    func addRegPremiseTypeData() {
        var arr = [Common]()
        arr.append(Common(id: 0, description: "Freehold"))
        //arr.append(Common(id: 1, description: "Leasehold"))
        arr.append(Common(id: 2, description: "Registered Lease"))
        self.regpremiseTypeArray = arr
    }
    func addTradingPremiseTypeData() {
        var arr = [Common]()
        arr.append(Common(id: 0, description: "Freehold"))
        arr.append(Common(id: 1, description: "Leasehold"))
        arr.append(Common(id: 2, description: "Registered Lease"))
        self.tradingpremiseTypeArray = arr
    }
    func addBusinessSectorTypeData() {
        var arr = [Common]()
        arr.append(Common(id: 0, description: "Offlicense"))
        arr.append(Common(id: 1, description: "Restaurant"))
        arr.append(Common(id: 2, description: "Courier/Logistics"))
        arr.append(Common(id: 3, description: "Wholesaler/Distributor"))
        arr.append(Common(id: 4, description: "Convenience store"))
        arr.append(Common(id: 5, description: "Petrol Pump"))
        arr.append(Common(id: 6, description: "Car/vehicle service & sales"))
        arr.append(Common(id: 7, description: "Other business"))
        self.businessSectorTypeArray = arr
    }
    func addRepresentativeTypeData() {
        var arr = [Common]()
        arr.append(Common(id: 0, description: "Representative1"))
        arr.append(Common(id: 1, description: "Representative2"))
        self.representativeArray = arr
    }
    func addNameData() {
        var arr = [Common]()
        arr.append(Common(id: 0, description: "Mr"))
        arr.append(Common(id: 1, description: "Mrs"))
        arr.append(Common(id: 2, description: "Miss"))
//        arr.append(Common(id: 0, description: "Ms"))
//        arr.append(Common(id: 0, description: "Dr"))
        self.nameArray = arr
    }
    func addDurationData() {
        var arr = [Common]()
        let list = [Int](1...40)
        for (element,index) in list.enumerated(){
            arr.append(Common(id: element, description: "\(index)"))
        }
        self.durationArray = arr

    }
    func addFundingPurpose() {
        var arr = [Common]()
        arr.append(Common(id: 0, description: "Hire Staff"))
        arr.append(Common(id: 1, description: "Management Buyout"))
        arr.append(Common(id: 2, description: "Marketing"))
        arr.append(Common(id: 3, description: "Moving premises"))
        arr.append(Common(id: 4, description: "Full-fill a order or contract"))
        arr.append(Common(id: 5, description: "Pay a due bill"))
        arr.append(Common(id: 6, description: "Pay HMRC"))
        arr.append(Common(id: 7, description: "Pay Staff"))
        arr.append(Common(id: 8, description: "Purchase Stock"))
        arr.append(Common(id: 9, description: "Purchase equipment"))
        arr.append(Common(id: 10, description: "Refinance Debt"))
        arr.append(Common(id: 11, description: "Upgrade Website"))
        arr.append(Common(id: 12, description: "Business Expansion"))
        arr.append(Common(id: 13, description: "Working Capital/Cash flow"))
        arr.append(Common(id: 14, description: "Other (Please Specify)"))
        self.fundingPurposeArray = arr
    }
    func OTPVerificationApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<OTPVerificationModel,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.otpVerification,
                                            params: params)
//            .responseJSON({ (json) in
//                if json.isSuccess{
//                    completionHandler(.success(true))
//                } else {
//                    completionHandler(.failure(CommonError.failure("failed")))
//                }
//            })
            .responseDecode(to: OTPVerificationModel.self,{ (json) in
                if json.statusCode == 200 {
                    completionHandler(.success(json))
                }else{
                    completionHandler(.failure(CommonError.failure("failed")))
                }
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    func ResendOTPApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<Bool,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.resendOTP,
                                            params: params)
            .responseJSON({ (json) in
                if json.isSuccess{
                    completionHandler(.success(true))
                } else {
                    completionHandler(.failure(CommonError.failure("failed")))
                }
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    func SignupApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<Bool,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.signUp,
                                            params: params)
            .responseJSON({ (json) in
                if json.isSuccess{
                    completionHandler(.success(true))
                } else {
                    completionHandler(.failure(CommonError.failure("failed")))
                }
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    func SigninApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<LoginModel,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.signin,
                                            params: params)
//            .responseJSON({ (json) in
//                if json.isSuccess{
//                    completionHandler(.success(true))
//                } else {
//                    completionHandler(.failure(CommonError.failure("failed")))
//                }
//            })
            .responseDecode(to: LoginModel.self,{ (json) in
                if json.statusCode == 200 {
                    completionHandler(.success(json))
                }else{
                    completionHandler(.failure(CommonError.failure("failed")))
                }
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    func ChangePasswordApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<Bool,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.changePassword,
                                            params: params)
            .responseJSON({ (json) in
                if json.isSuccess{
                    completionHandler(.success(true))
                } else {
                    completionHandler(.failure(CommonError.failure("failed")))
                }
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    func ConsentApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<Bool,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.createConsent,
                                            params: params)
            .responseJSON({ (json) in
                if json.isSuccess{
                    completionHandler(.success(true))
                } else {
                    completionHandler(.failure(CommonError.failure("failed")))
                }
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    func BusinessDetailsApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<Bool,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.createBusiness,
                                            params: params)
            .responseJSON({ (json) in
                if json.isSuccess{
                    completionHandler(.success(true))
                } else {
                    completionHandler(.failure(CommonError.failure("failed")))
                }
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    func GeneralDetailsApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<Bool,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.general,
                                            params: params)
            .responseJSON({ (json) in
                if json.isSuccess{
                    completionHandler(.success(true))
                } else {
                    completionHandler(.failure(CommonError.failure("failed")))
                }
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    static func convertJSONStringToAny(text: String) -> Any {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Any
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return text
    }
    func PostcodeLookupApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<LookupModel,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
         ConnectionHandler.shared.getRequest(for: APIEnums.addressLookup,
                                            params: params)
//            .responseJSON({ (json) in
//                if json.isSuccess{
//                    var data = json["data"] as? JSON
//                    var results = data?["Results"] as? JSON
//                    var items = results?["Items"] as! Any
//
////                    let user = PostcodeModel(json: JSON)
////                    var array = [PostcodeModel]()
////                    for element in items {
////                        var model = PostcodeModel(json: element)
////                        array.append(model)
////                    }
//
//                    completionHandler(.success(true))
//                } else {
//                    completionHandler(.failure(CommonError.failure("failed")))
//                }
//            })
            .responseDecode(to: LookupModel.self,{ (json) in
                completionHandler(.success(json))
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    func PostcodeLookupSidApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<LookupModel,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.addressLookupSid,
                                            params: params)
//            .responseJSON({ (json) in
//                if json.isSuccess{
//                    completionHandler(.success(true))
//                } else {
//                    completionHandler(.failure(CommonError.failure("failed")))
//                }
//            })
            .responseDecode(to: LookupModel.self,{ (json) in
                completionHandler(.success(json))
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    func CompanyPostcodeLookupApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<CompanyLookupModel,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
         ConnectionHandler.shared.getRequest(for: APIEnums.companyAddressLookup,
                                            params: params)
//            .responseJSON({ (json) in
//                if json.isSuccess{
//                    var data = json["data"] as? JSON
//                    var results = data?["Results"] as? JSON
//                    var items = results?["Items"] as! Any
//
////                    let user = PostcodeModel(json: JSON)
////                    var array = [PostcodeModel]()
////                    for element in items {
////                        var model = PostcodeModel(json: element)
////                        array.append(model)
////                    }
//
//                    completionHandler(.success(true))
//                } else {
//                    completionHandler(.failure(CommonError.failure("failed")))
//                }
//            })
            .responseDecode(to: CompanyLookupModel.self,{ (json) in
                completionHandler(.success(json))
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
    func CompanyPostcodeLookupSidApicall(parms: [AnyHashable: Any],
                      completionHandler : @escaping (Result<CompanyLookupModel,Error>) -> Void) {
        guard let params = parms as? JSON else{
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.companyAddressLookupSid,
                                            params: params)
//            .responseJSON({ (json) in
//                if json.isSuccess{
//                    completionHandler(.success(true))
//                } else {
//                    completionHandler(.failure(CommonError.failure("failed")))
//                }
//            })
            .responseDecode(to: CompanyLookupModel.self,{ (json) in
                completionHandler(.success(json))
            })
            .responseFailure({ (error) in
                completionHandler(.failure(CommonError.failure(error)))
            })
    }
}
