//
//  GlobalVariables.swift
//  Credit4Business
//
//  Created by MacMini on 29/02/24.
//

import Foundation
import UIKit
let APIBaseUrl : String = "https://credit.demoserver.work/" //"https://staging.credit4business.co.uk/"
let sceneDelegate                           = UIApplication.shared.connectedScenes
        .first!.delegate as! SceneDelegate
let APIUrl : String = APIBaseUrl
var GlobalFundingModelObject = FundingModel()
var GlobalmodeOfApplication : ModeOfApplication = .none
var globalLoanModel : LoanModel?
var canEditForms = true
var isSkip = false
var months = 0
var postCodeCell : AddressTableViewCell?
var textFieldIndexPath = IndexPath()
var propertyTextFieldIndexPath = IndexPath()
var propertyCodeCell : AddressCell?
var selectedStartDate : Date?
var selectedEndDate : Date?
var isFromIncomplete = false
enum CommonError : Error,
                   LocalizedError {
    case server
    case connection
    case failure(_ reason : String)
    
    /**
     return the errorDescription of the appropriate application
     */
    var errorDescription: String?{
        switch self {
        case .failure(let error):
            return error
        default:
            return self.localizedDescription
        }
    }
    /**
     return the localizedDescription of the appropriate application
     */
    var localizedDescription: String {
        switch self {
        case .server:
            return "Internal Server Error"
        case .connection:
            return "No Internet Connection"
        case .failure(let reason):
            return reason
        }
    }
}
