//
//  APIEnum.swift
//  Credit4Business
//
//  Created by MacMini on 29/02/24.
//

import Foundation
import Alamofire

enum APIEnums : String{
    case otpVerification = "user/verify-otp/"
    case signUp = "user/signup/"
    case resendOTP = "user/resend-otp/"
    case createConsent = "loan/consent/"
    case createPersonal = "loan/personal_informations/"
    case createAdditional = "loan/additional_informations/"
    case createBusiness = "loan/business_details/"
    case createPremise = "loan/business_premise_detail/"
    case createDocuments = "loan/documents/"
    case createGuarantor = "loan/guarantor/"
    case updateDirector = "loan/director/"
    case createPhotoId = "loan/photoid/"
    case retrievePhotoId = "loan/photo_id_details/"
    case retrieveOtherFiles = "loan/customer_other_documents/"
    case retrieveBankStatements = "loan/customer_bank_statements_details/"
    case retrieveContracts = "loan/contract/"
    case createAddressProof = "loan/addressproof/"
    case retrieveAddressProof = "loan/address_proof_details/"
    case general = "customer/funding-general-details/"
    case addressLookup = "loan/address_lookup/"
    case addressLookupSid = "loan/address_lookup_sid/"
    case companyAddressLookup = "loan/company_house_address_lookup/"
    case companyAddressLookupSid = "loan/company_address_lookup_sid/"
    case signin = "user/login/"
    case changePassword = "user/change_password/"
    case refreshToken = "user/token/refresh/"
    case createIdentity = "loan/send_trustid_guestlink/"
    case createIdentityFromCustomer = "loan/user_send_trustid_guestlink/"
    case leadsList = "user/leads/"
    case customersList = "user/customer/"
    case formSubmission = "loan/submit_loan/"
    case createReferral = "user/referral/"
    case retrieveProfileDetails = "user/customer_details/"
    case retrieveAgentProfileDetails = "user/agent_details/"
    case logout = "user/logout/"
    case forgotPassword = "user/password_reset/"
    case confirmReset = "user/password_reset/confirm/"
    case retrieveNotificationDetails = "notifications/customer/"
    case retrieveAgentNotificationDetails = "notifications/field_agent/"
    case retrieveLoan = "loan/customer_loan/"
    case retrieveKPI = "user/field_agent_target/"
    case retrieveBanks = "loan/banks/"
    case createRequisition = "loan/requisition/"
    case retrieveBankAccounts = "loan/confirm_bank_account/"
    case retrievePayment = "loan/payments/"
    case retrieveIdentityVerificationStatus = "loan/trustid_status/"
    case retrieveIdentityVerificationStatusFromCustomer = "loan/user_trustid_status/"
    case retrieveGocardlessStatement = "loan/gocardless_statement/"
    case retrieveRemarks = "loan/remarks/"
    case retrieveCompanies = "loan/company/"
    case retrieveCompanyDetails = "loan/company_details/"
    case retrieveComments = "loan/comments/"
    case createInstantPay = "loan/instant_payment/"
    case retrieveAllPayment = "loan/customer_payments/"
    case retrieveFundingOffer = "manage_loan/view-loan-offers/"
    case makeActionForFundingOffer = "manage_loan/loan-offer-decision/"
    case retrievePendingApproval = "user/admin_approval/"
    case applyNewLoan = "loan/apply_new_loan/"
    case retrieveCreditMonitoring = "manage_loan/credit_monitoring/"
    case retrieveCreditMonitoringComments = "manage_loan/credit_monitoring_comments/"
    case moveToLegal = "loan/loan_move_to_legal/"
    case createManualBank = "loan/bank_details/"
    case retrieveGocardlessManualStatement = "loan/process_transactions/"
    case updateFilledForms = "loan/update_filled_forms/"
    case leadCustomerList = "user/lead_customer/"
    case retrieveSummary = "loan/summary/"
    case retrieveStatement = "manage_loan/statement/"
    case none
}
extension APIEnums{//Return method for API
    var method : HTTPMethod{
        switch self {
        case .otpVerification,.signUp,.resendOTP,.createConsent,.createBusiness,.general,.addressLookup,.addressLookupSid,.companyAddressLookupSid,.signin,.changePassword,.createPersonal,.createAdditional,.createDocuments,.createGuarantor,.createPhotoId,.createAddressProof,.createIdentity,.formSubmission,.createReferral,.logout,.forgotPassword,.confirmReset,.createRequisition:
            return .post
        default:
            return .get
        }
    }
    var isAuthenticated : Bool {
        switch self {
        case .changePassword,.createConsent,.createBusiness,.general,.createPersonal,.createAdditional,.createDocuments,.createPremise,.createGuarantor,.createPhotoId,.retrievePhotoId,.createAddressProof,.updateDirector,.createIdentity,.leadsList,.customersList,.formSubmission,.createReferral,.retrieveProfileDetails,.logout,.retrieveAgentProfileDetails,.retrieveNotificationDetails,.retrieveAgentNotificationDetails,.retrieveLoan,.retrieveKPI,.retrieveBanks,.createRequisition,.retrieveBankAccounts,.retrievePayment,.retrieveOtherFiles,.retrieveBankStatements,.retrieveContracts,.retrieveIdentityVerificationStatus,.retrieveGocardlessStatement,.retrieveRemarks,.retrieveCompanies,.retrieveComments:
            return true
        default:
            return false
        }
    }
}
