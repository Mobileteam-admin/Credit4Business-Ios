//
//  LeadsModel.swift
//  Credit4Business
//
//  Created by MacMini on 16/05/24.
//

import Foundation
//struct LeadsModel: Codable {
////    let errorCode, errorMessage, moreInfo: String
//    let statusCode : Int //totalCount, numPages: Int
////    let first, previous, next, last: JSONNull?
//    let data: [LeadsData]
////    let statusMessage, statusTitle: String
//
//    enum CodingKeys: String, CodingKey {
////        case errorCode = "error_code"
////        case errorMessage = "error_message"
////        case moreInfo = "more_info"
//        case statusCode = "status_code",data
////        case totalCount = "total_count"
////        case numPages = "num_pages"
////        case first, previous, next, last
////        case statusMessage = "status_message"
////        case statusTitle = "status_title"
//    }
//}
//
//// MARK: - Datum
//struct LeadsData: Codable {
//    let id,agent: Int
//    let firstName,lastName, phoneNumber, email: String
//    let gender, dateOfBirth: String
//    let businessName: String?
//    let location, description: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, firstName = "first_name", lastName = "last_name"
//        case phoneNumber = "phone_number"
//        case email, gender
//        case dateOfBirth = "date_of_birth"
//        case businessName = "business_name"
//        case location, description,agent
//    }
//}
struct LeadsModel: Codable {
    let errorCode, errorMessage, moreInfo: String
    let statusCode, totalCount, numPages: Int
    let first, previous: String
    let next, last: String
    let data: [LeadsData]
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case moreInfo = "more_info"
        case statusCode = "status_code"
        case totalCount = "total_count"
        case numPages = "num_pages"
        case first, previous, next, last, data
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}

// MARK: - Datum
struct LeadsData: Codable {
    let id: String
    let title: Title
    let firstName, lastName, phoneNumber, email: String
    let image: String
    let gender, dateOfBirth, companyName, location: String
    let description: String
    let agent: String
    let loanStatus: [LoanStatus]

    enum CodingKeys: String, CodingKey {
        case id, title
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email, image, gender
        case dateOfBirth = "date_of_birth"
        case companyName = "company_name"
        case location, description, agent
        case loanStatus = "loan_details"
    }
}
struct SeparateLoanModel: Codable {
    let data: LoanData
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}
struct LoanModel: Codable {
    let data: [LoanData]
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}
struct NewLoanModel: Codable {
    let data: LoanData
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}
// MARK: - Datum
struct LoanData: Codable {
    let id: String
    let customer: Customer
   // let loanStatus: LoanStatus
   // let loanStatus: LoanStatus
    let createdOn, modifiedOn, deletedAt, createdBy,modifiedBy: String
//    let personalDetail, businessDetail, businessPremisDetail: Int
//    let marketingPreference, documents, guarantor: Int
   // let bankDetails, signableContract: JSONNull?
  //  let approvedByManager, approvedByAdmin : Bool
    let referedLoan, completePersonalDetail, completeBusinessDetail, completeBusinessPremisDetail: Bool
    let completeMarketingPreference, completeDocuments, completeGuarantors, directorDetail: Bool
    let identityVerified, completeContract, gocardlessStatement, completeAffordability: Bool
    let completeDisbursementAdvice, directorDetailUnderwriterVerified, identityUnderwriterVerified, contractUnderwriterVerified: Bool
    let gocardlessStatementUnderwriterVerified, isLiveTest: Bool
    let expectedCompletionDate: String

    enum CodingKeys: String, CodingKey {
        case id, customer
       // case loanStatus = "loan_status"
        case createdOn = "created_on"
        case modifiedOn = "modified_on"
        case deletedAt = "deleted_at"
        case createdBy = "created_by"
        case modifiedBy = "modified_by"
//        case personalDetail = "personal_detail"
//        case businessDetail = "business_detail"
//        case businessPremisDetail = "business_premis_detail"
//        case marketingPreference = "marketing_preference"
//        case documents, guarantor
       // case bankDetails = "bank_details"
       // case signableContract = "signable_contract"
      //  case loanStatus = "loan_status"
//        case approvedByManager = "approved_by_manager"
//        case approvedByAdmin = "approved_by_admin"
        case referedLoan = "refered_loan"
                case completePersonalDetail = "complete_personal_detail"
                case completeBusinessDetail = "complete_business_detail"
                case completeBusinessPremisDetail = "complete_business_premis_detail"
                case completeMarketingPreference = "complete_marketing_preference"
                case completeDocuments = "complete_documents"
                case completeGuarantors = "complete_guarantors"
                case directorDetail = "director_detail"
                case identityVerified = "identity_verified"
                case completeContract = "complete_contract"
                case gocardlessStatement = "gocardless_statement"
                case completeAffordability = "complete_affordability"
                case completeDisbursementAdvice = "complete_disbursement_advice"
                case directorDetailUnderwriterVerified = "director_detail_underwriter_verified"
                case identityUnderwriterVerified = "identity_underwriter_verified"
                case contractUnderwriterVerified = "contract_underwriter_verified"
                case gocardlessStatementUnderwriterVerified = "gocardless_statement_underwriter_verified"
                case isLiveTest = "is_live_test"
        case expectedCompletionDate = "expected_completion_date"

    }
}

// MARK: - Customer
struct Customer: Codable {
    let id: String
    let title, firstName, lastName, phoneNumber: String
    let email, image, gender, dateOfBirth: String
    let companyName, location, description, agent: String
    let modeOfApplication: String
    let loanDetails: [LoanDetail]
    enum CodingKeys: String, CodingKey {
        case id, title
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email, image, gender
        case dateOfBirth = "date_of_birth"
        case companyName = "company_name"
        case location, description, agent
        case modeOfApplication = "mode_of_application"
        case loanDetails = "loan_details"
    }
}
struct LoanDetail: Codable {
    let loanID: String
    let interest: Int
    let isIntrestChanged: Bool
    let approvedDate, appliedDate: String
    let returnedByUnderwriter, approvedByManager: Bool
   // let approveDate: Date?
    let reviewRequired, approvedByAdmin: Bool?
   // let adminApproveDate: Date?
    let currentStatus,upcomingStatus: String
    let returnReason: String?
    let rejectReason: String?
    let interestChangeReason: String?
    let isIdentityVerificationMailSend, isActive: Bool
    let companyName: String

    enum CodingKeys: String, CodingKey {
        case loanID = "loan_id"
        case interest
        case isIntrestChanged = "is_intrest_changed"
        case approvedDate = "approved_date"
        case appliedDate = "applied_date"
        case returnedByUnderwriter = "returned_by_underwriter"
        case approvedByManager = "approved_by_manager"
       // case approveDate = "approve_date"
        case reviewRequired = "review_required"
        case approvedByAdmin = "approved_by_admin"
      //  case adminApproveDate = "admin_approve_date"
        case currentStatus = "current_status"
        case returnReason = "return_reason"
        case rejectReason = "reject_reason"
        case interestChangeReason = "interest_change_reason"
        case isIdentityVerificationMailSend = "is_identity_verification_mail_send"
        case isActive = "is_active"
        case companyName = "company_name"
        case upcomingStatus = "upcoming_status"
    }
}
// MARK: - LoanStatus
struct LoanStatus: Codable {
    let loanID: String
    let interest: Int
    let isIntrestChanged: Bool
    let approvedDate, appliedDate: String
    let returnedByUnderwriter, approvedByManager: Bool
    let approveDate: String?
    let reviewRequired, approvedByAdmin: Bool
    let adminApproveDate: String?
    let currentStatus: String
    let upcomingStatus: String
   // let returnReason, rejectReason, interestChangeReason: JSONNull?
    let isIdentityVerificationMailSend, isActive: Bool

    enum CodingKeys: String, CodingKey {
        case loanID = "loan_id"
        case interest
        case isIntrestChanged = "is_intrest_changed"
        case approvedDate = "approved_date"
        case appliedDate = "applied_date"
        case returnedByUnderwriter = "returned_by_underwriter"
        case approvedByManager = "approved_by_manager"
        case approveDate = "approve_date"
        case reviewRequired = "review_required"
        case approvedByAdmin = "approved_by_admin"
        case adminApproveDate = "admin_approve_date"
        case currentStatus = "current_status"
        case upcomingStatus = "upcoming_status"
//        case returnReason = "return_reason"
//        case rejectReason = "reject_reason"
//        case interestChangeReason = "interest_change_reason"
        case isIdentityVerificationMailSend = "is_identity_verification_mail_send"
        case isActive = "is_active"
    }
}

enum AdminApproveDate: String, Codable {
    case empty = ""
    case the20240527T145750635654Z = "2024-05-27T14:57:50.635654Z"
    case the20240529T054119301947Z = "2024-05-29T05:41:19.301947Z"
}

enum CurrentStatus: String, Codable {
    case adminApproved = "Admin_Approved"
    case empty = "empty"
    case submitted = "Submitted"
}

enum ID: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ID"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

enum Title: String, Codable {
    case mr = "Mr"
}
struct CustomerModel: Codable {
    let data: [CustomerData]
    let statusCode: Int
    let first, previous: String
    let next, last: String
//    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data,first,previous,next,last
        case statusCode = "status_code"
//        case statusMessage = "status_message"
//        case statusTitle = "status_title"
    }
}

// MARK: - Datum
struct CustomerData: Codable {
    let agent: String
    let firstName,lastName, phoneNumber, email: String
    let gender : String
    let dateOfBirth: String
    let companyName: String?
    let location, description,title,image: String
    let id : String
    let loanStatus: [LoanStatus]

    enum CodingKeys: String, CodingKey {
        case id, firstName = "first_name", lastName = "last_name"
        case phoneNumber = "phone_number"
        case email, gender,title,image
        case dateOfBirth = "date_of_birth"
        case companyName = "company_name"
        case location, description, agent
        case loanStatus = "loan_details"
    }
}
struct ReferralModel: Codable {
    let errorCode, errorMessage, moreInfo: String
    let statusCode, totalCount, numPages: Int
    let first, previous: JSONNull?
    let next, last: String
    let data: [ReferralData]
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case moreInfo = "more_info"
        case statusCode = "status_code"
        case totalCount = "total_count"
        case numPages = "num_pages"
        case first, previous, next, last, data
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}

// MARK: - Datum
struct ReferralData: Codable {
    let id: Int
    let firstName, lastName, phoneNumber, email: String
    let businessName: String
    let referedBy: Int?
    let assignedFieldAgent: JSONNull?
    let assignedManager: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email
        case businessName = "business_name"
        case referedBy = "refered_by"
        case assignedFieldAgent = "assigned_field_agent"
        case assignedManager = "assigned_manager"
    }
}
struct ProfileModel: Codable {
    let data: ProfileData
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}

// MARK: - DataClass
struct ProfileData: Codable {
    let id: String
    let customerID: Int
    let title, firstName, lastName, phoneNumber: String
    let email, image, gender, dateOfBirth: String
    let companyName, address, description, agent: String
    let modeOfApplication: String
    let loanDetails: [LoanDetail]

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case title
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email, image, gender
        case dateOfBirth = "date_of_birth"
        case companyName = "company_name"
        case address, description, agent
        case modeOfApplication = "mode_of_application"
        case loanDetails = "loan_details"
    }
}
struct AgentProfileModel: Codable {
    let data: AgentProfileData
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}

// MARK: - DataClass
struct AgentProfileData: Codable {
    let id: String?
    let firstName,lastName, email: String
    let image, address, description: String
    let assignedManager : Int?
    let phoneNumber: String
    enum CodingKeys: String, CodingKey {
        case id
        case phoneNumber = "phone_number"
        case email, image
        case address, description
        case assignedManager = "assigned_manager"
        case firstName = "first_name", lastName = "last_name"
    }
}
struct NotificationModel: Codable {
    let data: [NotificationData]
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}

// MARK: - Datum
struct NotificationData: Codable {
    let customerLoan: String
    let notificationType, message,createdOn,id: String
    let isNotified: Bool
    //let notificationStatus : JSONNull?
    enum CodingKeys: String, CodingKey {
        case id
        case customerLoan = "customer_loan"
        case notificationType = "notification_type"
        case message
        //case notificationStatus = "notification_status"
        case createdOn = "created_on"
        case isNotified = "is_notified"
    }
}
struct AgentNotificationModel: Codable {
    let data: [AgentNotificationData]
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}

// MARK: - Datum
struct AgentNotificationData: Codable {
    let fieldAgent: String
    let notificationType, message,createdOn,id: String
    let isNotified: Bool
    //let notificationStatus : JSONNull?
    enum CodingKeys: String, CodingKey {
        case id
        case fieldAgent = "field_agent"
        case notificationType = "notification_type"
        case message
        //case notificationStatus = "notification_status"
        case createdOn = "created_on"
        case isNotified = "is_notified"
    }
}
struct KPIModel: Codable {
    let data: [KPIData]
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}

// MARK: - Datum
struct KPIData: Codable {
    let title, duration: String
    let percentage: Double
    let numberOfNewClients: Int?
    let isTrendIncreasing: Bool
    let target: Int
    let numberOfOldClients: Int?
    let fundDisbursed: Double?

    enum CodingKeys: String, CodingKey {
        case title, duration, percentage
        case numberOfNewClients = "number_of_new_clients"
        case isTrendIncreasing = "is_trend_increasing"
        case target
        case numberOfOldClients = "number_of_old_clients"
        case fundDisbursed = "fund_disbursed"
    }
}
struct CreditMonitoringModel: Codable {
    let data: [CreditMonitoring]
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}

// MARK: - Datum
struct CreditMonitoring: Codable {
    let id: String
    let mandate: Mandate
    let previousComment: PreviousComment?
    let loanStatus: CMLoanStatus
    let modifiedOn, deletedAt, createdOn, amount: String
    let createdBy, modifiedBy, company, customerLoan: String

    enum CodingKeys: String, CodingKey {
        case id, mandate
        case previousComment = "previous_comment"
        case loanStatus = "loan_status"
        case modifiedOn = "modified_on"
        case deletedAt = "deleted_at"
        case createdOn = "created_on"
        case amount
        case createdBy = "created_by"
        case modifiedBy = "modified_by"
        case company
        case customerLoan = "customer_loan"
    }
}
struct CMLoanStatus: Codable {
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

// MARK: - Mandate
struct Mandate: Codable {
    let id, modifiedOn, deletedAt, mandateID: String
    let status, metadata, createdOn, createdBy: String
    let modifiedBy, company, customerLoan, customer: String
    let bankAccount: String

    enum CodingKeys: String, CodingKey {
        case id
        case modifiedOn = "modified_on"
        case deletedAt = "deleted_at"
        case mandateID = "mandate_id"
        case status, metadata
        case createdOn = "created_on"
        case createdBy = "created_by"
        case modifiedBy = "modified_by"
        case company
        case customerLoan = "customer_loan"
        case customer
        case bankAccount = "bank_account"
    }
}

// MARK: - PreviousComment
struct PreviousComment: Codable {
    let id: String
    let createdBy: CreatedBy
    let modifiedOn, deletedAt, comment, createdOn: String
    let modifiedBy, creditMonitor: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case modifiedOn = "modified_on"
        case deletedAt = "deleted_at"
        case comment
        case createdOn = "created_on"
        case modifiedBy = "modified_by"
        case creditMonitor = "credit_monitor"
    }
}
struct CreditMonitoringCommentsModel: Codable {
    let data: [CreditMonitoringComments]
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}

// MARK: - Datum
struct CreditMonitoringComments: Codable {
    let id: String
    let createdBy: CreatedBy
    let modifiedOn, deletedAt, comment, createdOn: String
    let modifiedBy, creditMonitor: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case modifiedOn = "modified_on"
        case deletedAt = "deleted_at"
        case comment
        case createdOn = "created_on"
        case modifiedBy = "modified_by"
        case creditMonitor = "credit_monitor"
    }
}
