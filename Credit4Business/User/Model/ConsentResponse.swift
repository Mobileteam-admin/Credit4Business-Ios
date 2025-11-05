//
//  ConsentResponse.swift
//  Credit4Business
//
//  Created by MacMini on 25/04/24.
//

import Foundation
struct ConsentResponse: Codable {
    let data: DataClass
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
struct DataClass: Codable {
    let id: Int
    let receivingMarketingInfo, sendingMarketingInformation, thirdPartySharing: ReceivingMarketingInfo

    enum CodingKeys: String, CodingKey {
        case id
        case receivingMarketingInfo = "receiving_marketing_info"
        case sendingMarketingInformation = "sending_marketing_information"
        case thirdPartySharing = "third_party_sharing"
    }
}

// MARK: - ReceivingMarketingInfo
struct ReceivingMarketingInfo: Codable {
    let id: Int
    let email, post, sms, socialMedia: Bool
    let telephone: Bool

    enum CodingKeys: String, CodingKey {
        case id, email, post, sms
        case socialMedia = "social_media"
        case telephone
    }
}
struct CompanyListModel: Codable {
    let errorCode, errorMessage, moreInfo: String
    let statusCode, totalCount, numPages: Int
    let first, previous: String
    let next, last: String
    let data: [CompanyList]
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
struct CompanyList: Codable {
    let id: String
    let customers: [Customer]
    let companyName, companyPhoneNumber: String
    let companyStatus: String
    let businessType: String
    let tradingStyle, companyNumber, fundingPurpose, otherFundingPurpose: String
    let gocardlessStatus: Bool


    enum CodingKeys: String, CodingKey {
        case id, customers
        case companyName = "company_name"
        case companyPhoneNumber = "company_phone_number"
        case companyStatus = "company_status"
        case businessType = "business_type"
        case tradingStyle = "trading_style"
        case companyNumber = "company_number"
        case fundingPurpose = "funding_purpose"
        case otherFundingPurpose = "other_funding_purpose"
        case gocardlessStatus = "gocardless_status"
    }
}


struct CompanyModel: Codable {
    let data: CompanyData
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
struct CompanyData: Codable {
    let id, customer, companyName, companyStatus: String
    let businessType, tradingStyle, companyNumber, fundingPurpose: String
    let otherFundingPurpose: String

    enum CodingKeys: String, CodingKey {
        case id, customer
        case companyName = "company_name"
        case companyStatus = "company_status"
        case businessType = "business_type"
        case tradingStyle = "trading_style"
        case companyNumber = "company_number"
        case fundingPurpose = "funding_purpose"
        case otherFundingPurpose = "other_funding_purpose"
    }
}
struct RemarksModel: Codable {
    let data: [RemarksData]
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
struct RemarksData: Codable {
    let id: String
    let createdBy: CreatedBy
    let modifiedBy, createdOn, modifiedOn, deletedAt: String
    let remarks: String?
    let isNotified: Bool
    let customerLoan: String
    let comments,commentType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case modifiedBy = "modified_by"
        case createdOn = "created_on"
        case modifiedOn = "modified_on"
        case deletedAt = "deleted_at"
        case remarks,comments
        case isNotified = "is_notified"
        case customerLoan = "customer_loan"
        case commentType = "comment_type"

    }
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int
    let username, firstName, lastName, email: String
    let role: String

    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName = "first_name"
        case lastName = "last_name"
        case email, role
    }
}
struct PersonalDataResponse: Codable {
    let data: PersonalDataClass
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
struct PersonalDataClass: Codable {
    let id: Int
    let email, title, firstName, lastName: String
    let pincode, address: String
    let phoneNumber, fundRequestAmount: String
    let fundRequestDurationWeeks: Int
    let isOtpVerified, agreeTermsAndConditions, agreeCommunicationAuthorization,isMajor: Bool
    let repaymentDayOfWeek : String
  //  let companyName, businessType, tradingStyle, companyNumber,fundingPurpose: String
    let modeOfApplication : String
    let representatives : String?
    let agreeAuthorization, isPendingThreatenedOrRecently, applyForFundingAssisted: Bool
    //let otherFundingPurpose: String?
  //  let fullName : String?
    let company: Company

    enum CodingKeys: String, CodingKey {
        case id, email, title
        case firstName = "first_name"
        case lastName = "last_name"
      //  case fullName = "full_name"
        case pincode, address
        case phoneNumber = "phone_number"
        case fundRequestAmount = "fund_request_amount"
        case fundRequestDurationWeeks = "fund_request_duration_weeks"
        case isOtpVerified = "is_otp_verified"
        case agreeTermsAndConditions = "agree_terms_and_conditions"
        case agreeCommunicationAuthorization = "agree_communication_authorization"
        case isMajor = "is_major"
        case repaymentDayOfWeek = "repayment_day_of_week"
       // case companyName = "company_name"
        //case businessType = "business_type"
        //case tradingStyle = "trading_style"
        //case companyNumber = "company_number"
        //case fundingPurpose = "funding_purpose"
       // case otherFundingPurpose = "other_funding_purpose"
        case modeOfApplication = "mode_of_application"
        case representatives
        case agreeAuthorization = "agree_authorization"
        case isPendingThreatenedOrRecently = "is_pending_threatened_or_recently"
        case applyForFundingAssisted = "apply_for_funding_assisted"
        case company
    }
}
struct Company: Codable {
    let id : String?
    let companyName, companyStatus, businessType, tradingStyle,companyPhoneNumber: String
    let companyNumber, fundingPurpose, otherFundingPurpose: String
    let companyAddress: CompanyAddress

    enum CodingKeys: String, CodingKey {
        case id
        case companyName = "company_name"
        case companyStatus = "company_status"
        case businessType = "business_type"
        case tradingStyle = "trading_style"
        case companyNumber = "company_number"
        case fundingPurpose = "funding_purpose"
        case otherFundingPurpose = "other_funding_purpose"
        case companyPhoneNumber = "company_phone_number"
        case companyAddress = "company_address"
    }
    var dictionaryRepresentation: [String: String] {
        return [
            "company_name": companyName,
            "company_status": "Active",
            "business_type": businessType,
            "trading_style": tradingStyle,
            "company_number": companyNumber,
            "funding_purpose": fundingPurpose,
            "other_funding_purpose": otherFundingPurpose
        ]
    }
}
struct AdditionalDataResponse: Codable {
    let data: AdditionalDataClass
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
struct AdditionalDataClass: Codable {
    let id: Int
    let companyName, businessType, tradingStyle, companyNumber: String
    let fundingPurpose, modeOfApplication : String
    let representatives : String?
    let agreeAuthorization, isPendingThreatenedOrRecently, applyForFundingAssisted: Bool
    let otherFundingPurpose: String?

    enum CodingKeys: String, CodingKey {
        case id
        case companyName = "company_name"
        case businessType = "business_type"
        case tradingStyle = "trading_style"
        case companyNumber = "company_number"
        case fundingPurpose = "funding_purpose"
        case otherFundingPurpose = "other_funding_purpose"
        case modeOfApplication = "mode_of_application"
        case representatives
        case agreeAuthorization = "agree_authorization"
        case isPendingThreatenedOrRecently = "is_pending_threatened_or_recently"
        case applyForFundingAssisted = "apply_for_funding_assisted"
    }
}
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
struct BusinessDataResponse: Codable {
    let data: BusinessDataClass
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
struct BusinessDataClass: Codable {
   // let id: Int
    let directors: [SelectedDirector]
    let businessType: String
    let numberOfDirectors: Int
    let hasStartedTrading: String
    let startTradingDate: String
    let isProfitable, acceptsCardPayment: String
    let averageWeeklyCardSales, averageMonthlyTurnover, businessSector, otherBusinessName: String

    enum CodingKeys: String, CodingKey {
        case directors
        case businessType = "business_type"
        case numberOfDirectors = "number_of_directors"
        case hasStartedTrading = "has_started_trading"
        case startTradingDate = "start_trading_date"
        case isProfitable = "is_profitable"
        case acceptsCardPayment = "accepts_card_payment"
        case averageWeeklyCardSales = "average_weekly_card_sales"
        case averageMonthlyTurnover = "average_monthly_turnover"
        case businessSector = "business_sector"
        case otherBusinessName = "other_business_name"
    }
}

// MARK: - Director
//struct DirectorResponse: Codable {
//    let title, firstName, lastName: String
//    let id : Int
//    enum CodingKeys: String, CodingKey {
//        case title
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case id
//    }
//}

struct PremiseDataResponse: Codable {
    let data: PremiseDataClass
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
struct PremiseDataClass: Codable {
    let id: Int
    let registeredAddress, tradingAddress: Address?
    let tradingSameAsRegistered: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case registeredAddress = "registered_address"
        case tradingAddress = "trading_address"
        case tradingSameAsRegistered = "trading_same_as_registered"
    }
}

// MARK: - Address
struct Address: Codable {
    let addressLine1, postCode: String?
    let premiseType: String?
    let leasehold: Leasehold?
    //let addressLine2,townCity
    enum CodingKeys: String, CodingKey {
        case addressLine1 = "address_line"
//        case addressLine2 = "address_line2"
//        case townCity = "town_city"
        case postCode = "post_code"
        case premiseType = "premise_type"
        case leasehold
    }
}

// MARK: - Leasehold
struct Leasehold: Codable {
    let startDate, endDate: String
    let document: String

    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
        case document
    }
}
struct DocumentsDataResponse: Codable {
    let data: DocumentsDataClass
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
struct DocumentsDataClass: Codable {
    let id: Int
    let photo, passport, utilityBillOfTradingBusiness,leaseDeed: [MultipleDocumentsDataClass]?
    let businessAccountStatement,otherFiles: [MultipleDocumentsDataClass]?
    let drivingLicense,councilTax : [MultipleDocumentsDataClass]?
    let documentUploadSelfDeclaration, isIdentityVerified: Bool

    enum CodingKeys: String, CodingKey {
        case id, photo
        case passport 
        case utilityBillOfTradingBusiness = "utility_bill"
        case leaseDeed = "lease_deed"
        case businessAccountStatement = "business_account_statements"
        case otherFiles = "other_files"
        case documentUploadSelfDeclaration = "document_upload_self_declaration"
        case isIdentityVerified = "is_identity_verified"
        case drivingLicense = "driving_license"
        case councilTax = "council_tax"
    }
}
struct MultipleDocumentsDataClass: Codable {
    let file: String
    enum CodingKeys: String, CodingKey {
        case file
    }
}
struct BankStatementsModel: Codable {
    let data: BankStatementData
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
struct BankStatementData: Codable {
//    let id, customer: String
    let businessAccountStatement: [MultipleDocumentsDataClass]

    enum CodingKeys: String, CodingKey {
//        case id, customer
        case businessAccountStatement = "business_account_statements"
    }
}

struct OtherDocumentsModel: Codable {
    let data: OtherData
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
struct OtherData: Codable {
   // let id, customer: String
    let otherFiles: [MultipleDocumentsDataClass]

    enum CodingKeys: String, CodingKey {
       // case id, customer
        case otherFiles = "other_files"
    }
}
struct ContractModel: Codable {
    let data: ContractData
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
struct ContractData: Codable {
    let id: Int?
    let envelopeTitle, envelopeFingerprint, envelopeStatus: String
    let signedPDF: String

    enum CodingKeys: String, CodingKey {
        case id
        case envelopeTitle = "envelope_title"
        case envelopeFingerprint = "envelope_fingerprint"
        case envelopeStatus = "envelope_status"
        case signedPDF = "signed_pdf"
    }
}

struct GuarantorDataResponse: Codable {
    let data: GuarantorDataClass
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
struct GuarantorDataClass: Codable {
    let id: Int
    var stay: [StayModel]
    var ownsOtherProperty: String
    var ownedProperty: [OwnedProperty]
    var ownedPropertyCount: Int

    let title, firstName, lastName: String
    let email: String?
    let phoneNumber: Int
    let guarantorAgreement: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, email
        case firstName = "first_name"
        case lastName = "last_name"
       // case address, pincode,
        case phoneNumber = "phone_number"
        case guarantorAgreement = "guarantor_agreement"
        case stay
        case ownedProperty = "owned_property"
        case ownsOtherProperty = "owns_other_property"
        case ownedPropertyCount = "owned_property_count"
    }
}
struct IdentityVerificationStatusModelForCustomer: Codable {
    let data: IdentityVerificationStatusData
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}
struct IdentityVerificationStatusModel: Codable {
    let data: [IdentityVerificationStatusData]
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}
struct IdentityVerificationStatusModelFromCustomer: Codable {
    let data: IdentityVerificationStatusData
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
struct IdentityVerificationStatusData: Codable {
    let id: String
    let sendKycMail, kycStatus: Bool
    let customer: CustomerNew
    let certificate,documentVerification, livenessCheck, faceMatch,kycAmlCheck: String
    enum CodingKeys: String, CodingKey {
        case id
        case sendKycMail = "send_kyc_mail"
        case kycStatus = "kyc_status"
        case customer, certificate
        case documentVerification = "document_Verification"
        case livenessCheck = "liveness_check"
        case faceMatch = "face_match"
        case kycAmlCheck = "kyc_aml_check"

    }
}
struct Guarantor: Codable {
    let id: Int
    let title, firstName, lastName, address: String
    let pincode, email: String
    let phoneNumber: Int
    let guarantorAgreement, isCompleted, underwriterVerified: Bool
    let customer: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case firstName = "first_name"
        case lastName = "last_name"
        case address, pincode, email
        case phoneNumber = "phone_number"
        case guarantorAgreement = "guarantor_agreement"
        case isCompleted = "is_completed"
        case underwriterVerified = "underwriter_verified"
        case customer
    }
}
struct DirectorNew: Codable {
    let id: Int
    let title, firstName, lastName, phoneNumber: String
    let email, ownsOtherProperty: String
    let ownedPropertyCount: Int
    let ownedProperty: [OwnedPropertyNew]
    let stay: [StayNew]

    enum CodingKeys: String, CodingKey {
        case id, title
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email
        case ownsOtherProperty = "owns_other_property"
        case ownedPropertyCount = "owned_property_count"
        case ownedProperty = "owned_property"
        case stay
    }
}
struct CustomerNew: Codable {
    let id: String
    let customerID: Int
    let title, firstName, lastName, phoneNumber: String
    let email, image, gender, dateOfBirth: String
    let companyName, location, description, agent: String
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
        case location, description, agent
        case modeOfApplication = "mode_of_application"
        case loanDetails = "loan_details"
    }
}

// MARK: - OwnedProperty
struct OwnedPropertyNew: Codable {
    let id: Int
    let pincode, address: String
}

// MARK: - Stay
struct StayNew: Codable {
    let id: Int
    let pincode, address, houseOwnership, startDate: String
    let endDate: String

    enum CodingKeys: String, CodingKey {
        case id, pincode, address
        case houseOwnership = "house_ownership"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}
struct GocardlessStatusModel: Codable {
    let data: [GocardlessData]
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
struct GocardlessData: Codable {
    let id: Int
    let bankName: String
       // let debit, credit: CreditUnion
        let debitSum, creditSum : CreditSum
        let startDate, endDate,totalPeriods: String
        let gocardlessStatus,isPrimaryAccount: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case bankName = "bank_name"
            //case debit, credit
            case debitSum = "debit_sum"
            case creditSum = "credit_sum"
            case totalPeriods = "total_periods"
            case startDate = "start_date"
            case endDate = "end_date"
            case gocardlessStatus = "gocardless_status"
            case isPrimaryAccount = "is_primary_account"
        }
}
enum CreditUnion: Codable {
    case creditElementArray([CreditElement])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([CreditElement].self) {
            self = .creditElementArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(CreditUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CreditUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .creditElementArray(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
struct CreditElement: Codable {
    let valueDate: String
    let debtorName: DebtorName?
    let bookingDate: String
    let debtorAccount: DebtorAccount?
    let transactionID: String
    let transactionAmount: TransactionAmount
    let bankTransactionCode: BankTransactionCode
    let remittanceInformationUnstructured: RemittanceInformationUnstructured

    enum CodingKeys: String, CodingKey {
        case valueDate, debtorName, bookingDate, debtorAccount
        case transactionID = "transactionId"
        case transactionAmount, bankTransactionCode, remittanceInformationUnstructured
    }
}

enum BankTransactionCode: String, Codable {
    case pmnt = "PMNT"
}

// MARK: - DebtorAccount
struct DebtorAccount: Codable {
    let iban: Iban
}

enum Iban: String, Codable {
    case gl4888530000088535 = "GL4888530000088535"
    case gl8240830000040838 = "GL8240830000040838"
}

enum DebtorName: String, Codable {
    case monMothma = "MON MOTHMA"
}

enum RemittanceInformationUnstructured: String, Codable {
    case forTheSupportOfRestorationOfTheRepublicFoundation = "For the support of Restoration of the Republic foundation"
    case paymentAlderaanCoffe = "PAYMENT Alderaan Coffe"
}

// MARK: - TransactionAmount
struct TransactionAmount: Codable {
    let amount: String
    let currency: Currency
}

enum Currency: String, Codable {
    case eur = "EUR"
}

enum CreditSum: Codable {
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
        throw DecodingError.typeMismatch(CreditSum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CreditSum"))
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

class MenuModel : Codable {
    var title: String
    var value: String
    var pincode: String
    var latitude: String
    var longitude: String
    var isError : Bool
    var error : String
    var apiKey : String
    var isExtended : Bool
    enum CodingKeys: String, CodingKey {
        case title,value,isError,error,apiKey,isExtended,pincode,latitude,longitude
    }
    init() {
        self.title = ""
        self.value = ""
        self.isError = false
        self.error = ""
        self.apiKey = ""
        self.isExtended = false
        self.pincode = ""
        self.latitude = ""
        self.longitude = ""
    }
    init(title: String,value: String,apiKey: String) {

//    init(title: String,value: String,isError: Bool, error: String,apiKey: String) {
        self.title = title
        self.value = value
//        self.isError = isError
//        self.error = error
//        self.apiKey = apiKey
        self.isError = false
        self.error = ""
        self.apiKey = apiKey
        self.isExtended = false
        self.pincode = ""
        self.latitude = ""
        self.longitude = ""

    }
}
struct DirectorsDataResponse: Codable {
    let data: [DirectorDataClass]
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
struct DirectorDataClass: Codable {
    let id: Int
    let stay: [String]?
    let title: String
    let firstName, lastName, phoneNumber, email: String?
    let ownsOtherProperty: String
    enum CodingKeys: String, CodingKey {
        case id, stay, title
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email
        case ownsOtherProperty = "owns_other_property"
    }
}
struct DirectorDictionary: Codable {
    let array: MenuModel
    let index: Int

    enum CodingKeys: String, CodingKey {
        case array,index
    }
}
struct SelectedDirectorResponse: Codable {
    let data: DirectorData
    let statusCode: Int
    let statusMessage, statusTitle: String

    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
}
struct DirectorData: Codable {
    let directors: [SelectedDirector]
    let businessType: String

    enum CodingKeys: String, CodingKey {
        case directors
        case businessType = "business_type"
    }
}
// MARK: - Datum
class SelectedDirector: Codable {
    var id: Int
    var title, firstName, lastName, phoneNumber: String
    var email, ownsOtherProperty: String
    var ownedProperty: [OwnedProperty]
    var ownedPropertyCount: Int
    var stay: [StayModel]
    var isExtended : Bool? = false

    enum CodingKeys: String, CodingKey {
        case id, title
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email
        case ownsOtherProperty = "owns_other_property"
        case ownedProperty = "owned_property"
        case ownedPropertyCount = "owned_property_count"
        case stay
        case isExtended
    }
    init(){
        self.id = 0
        self.title = ""
        self.firstName = ""
        self.lastName = ""
        self.phoneNumber = ""
        self.email = ""
        self.ownsOtherProperty = "No"
        self.ownedProperty = [OwnedProperty]()
        self.ownedPropertyCount = 0
        self.stay = [StayModel]()
    }
}
struct OwnedProperty: Codable {
    let id: Int
    let pincode, address: String
    var dictionaryRepresentation: [String: Any] {
            return [
                "id" : id,
                "pincode": pincode,
                "address": address
            ]
    }
}
// MARK: - Stay
struct StayModel: Codable {
    let id: Int
    let pincode, address, houseOwnership, startDate: String
    let endDate: String
    var dictionaryRepresentation: [String: Any] {
            return [
                "id" : id,
                "pincode": pincode,
                "address": address,
                "house_ownership": houseOwnership,
                "start_date": startDate,
                "end_date": endDate
            ]
    }
    enum CodingKeys: String, CodingKey {
        case id, pincode, address
        case houseOwnership = "house_ownership"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}
struct PhotoIDDataResponse: Codable {
    let data: PhotoIDDataClass?
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
struct PhotoIDDataClass: Codable {
    let id: String?
    let photo, passport,drivingLicense: String?
    let customer: String?

    enum CodingKeys: String, CodingKey {
        case id, photo
        case passport
        case drivingLicense = "driving_license"
        case customer
    }
}
struct AddressProofDataResponse: Codable {
    let data: AddressProofDataClass?
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
struct AddressProofDataClass: Codable {
    let id: String?
    let councilTax: String?
    let utilityBill: String?
    let leaseDeed: String?
    let customer: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case councilTax = "council_tax"
        case utilityBill = "utility_bill"
        case leaseDeed = "lease_deed"
        case customer
    }
}
struct BankModel: Codable {
    let data: [BankData]
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
struct BankData: Codable {
    var id, name, bic, transactionTotalDays: String
    let countries: [String]
    let logo: String

    enum CodingKeys: String, CodingKey {
        case id, name, bic
        case transactionTotalDays = "transaction_total_days"
        case countries, logo
    }
}
struct RequisitionModel: Codable {
    let data: RequisitionClass
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
struct RequisitionClass: Codable {
    let id, created: String
    let redirect: String
    let status, institutionID, agreement, reference: String
    let accounts: [JSONAny]
    let link: String
    let ssn: JSONNull?
    let accountSelection, redirectImmediate: Bool

    enum CodingKeys: String, CodingKey {
        case id, created, redirect, status
        case institutionID = "institution_id"
        case agreement, reference, accounts, link, ssn
        case accountSelection = "account_selection"
        case redirectImmediate = "redirect_immediate"
    }
}
struct InstantPaymentModel: Codable {
    let data: InstantPaymentDataClass
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
struct InstantPaymentDataClass: Codable {
    let id: String
    let autoFulfil: Bool
    let redirectURI: String
    let skipSuccessScreen: Bool
    let exitURI, authorisationURL: String
    let lockCustomerDetails, lockBankAccount: Bool
    let sessionToken: JSONNull?
    let expiresAt, createdAt: String
    let links: Links
    let config: Config
    let redirectFlowID: JSONNull?
    let showRedirectButtons, lockCurrency: Bool
    let prefilledCustomer, prefilledBankAccount, language: JSONNull?
    let showSuccessRedirectButton, customerDetailsCaptured: Bool
    let redirectOrigin: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id
        case autoFulfil = "auto_fulfil"
        case redirectURI = "redirect_uri"
        case skipSuccessScreen = "skip_success_screen"
        case exitURI = "exit_uri"
        case authorisationURL = "authorisation_url"
        case lockCustomerDetails = "lock_customer_details"
        case lockBankAccount = "lock_bank_account"
        case sessionToken = "session_token"
        case expiresAt = "expires_at"
        case createdAt = "created_at"
        case links, config
        case redirectFlowID = "redirect_flow_id"
        case showRedirectButtons = "show_redirect_buttons"
        case lockCurrency = "lock_currency"
        case prefilledCustomer = "prefilled_customer"
        case prefilledBankAccount = "prefilled_bank_account"
        case language
        case showSuccessRedirectButton = "show_success_redirect_button"
        case customerDetailsCaptured = "customer_details_captured"
        case redirectOrigin = "redirect_origin"
    }
}

// MARK: - Config
struct Config: Codable {
    let merchantContactDetails: MerchantContactDetails
    let schemeIdentifiers: [SchemeIdentifier]

    enum CodingKeys: String, CodingKey {
        case merchantContactDetails = "merchant_contact_details"
        case schemeIdentifiers = "scheme_identifiers"
    }
}

// MARK: - MerchantContactDetails
struct MerchantContactDetails: Codable {
    let email, phoneNumber, name: String

    enum CodingKeys: String, CodingKey {
        case email
        case phoneNumber = "phone_number"
        case name
    }
}

// MARK: - SchemeIdentifier
struct SchemeIdentifier: Codable {
    let scheme: String
    let advanceNotice: Int
    let name: Name
    let reference, address: String
    let bankStatementName, registeredName: Name

    enum CodingKeys: String, CodingKey {
        case scheme
        case advanceNotice = "advance_notice"
        case name, reference, address
        case bankStatementName = "bank_statement_name"
        case registeredName = "registered_name"
    }
}

enum Name: String, Codable {
    case goCardless = "GoCardless"
    case goCardlessLtd = "GoCardless Ltd"
}

// MARK: - Links
struct Links: Codable {
    let billingRequest: String

    enum CodingKeys: String, CodingKey {
        case billingRequest = "billing_request"
    }
}



struct BankAccountModel: Codable {
    let data: BankAccountData
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
struct BankAccountData: Codable {
    let id, created: String
    let redirect: String
    let status, institutionID, agreement, reference: String
    let accounts: [Account]
    let link: String
    let ssn: JSONNull?
    let accountSelection, redirectImmediate: Bool

    enum CodingKeys: String, CodingKey {
        case id, created, redirect, status
        case institutionID = "institution_id"
        case agreement, reference, accounts, link, ssn
        case accountSelection = "account_selection"
        case redirectImmediate = "redirect_immediate"
    }
}
struct Account: Codable {
    let accountid, accountNumber: String

    enum CodingKeys: String, CodingKey {
        case accountid = "id"
        case accountNumber = "account_number"
    }
}
struct UpcomingPaymentsModel: Codable {
    let data: PaymentData
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
struct PaymentData: Codable {
    let loanID: Int
    let fundingPayments: [FundingPayment]
    let fundingPaymentHistory: [FundingPaymentHistory]

    enum CodingKeys: String, CodingKey {
        case loanID = "loan_id"
        case fundingPayments = "funding_payments"
        case fundingPaymentHistory = "funding_payment_history"
    }
}

struct DashboardFundingPayment: Codable {
    let title, status, nextDue, dueDate: String
        let fundingAmount: String
        let instalmentPaid, remainingInstalment, totalInstalment, gocardlessMissedEmis: Int
        let upcomingEmiDates, completedEmiDates, gocardlessMissedEmiDates: [String]

        enum CodingKeys: String, CodingKey {
            case title, status
            case nextDue = "next_due"
            case dueDate = "due_date"
            case fundingAmount = "funding_amount"
            case instalmentPaid = "instalment_paid"
            case remainingInstalment = "remaining_instalment"
            case totalInstalment = "total_instalment"
            case gocardlessMissedEmis = "gocardless_missed_emis"
            case upcomingEmiDates = "upcoming_emi_dates"
            case completedEmiDates = "completed_emi_dates"
            case gocardlessMissedEmiDates = "gocardless_missed_emi_dates"
        }
}
// MARK: - FundingPayment
struct FundingPayment: Codable {
    let title, status, nextDue, dueDate: String
    let fundingAmount: String
    let instalmentPaid, remainingInstalment, totalInstalment: Int
    //let upcomingEmiDates: [JSONAny]
    let completedEmiDates: [CompletedEmiDate]
    let gocardlessMissedEmis: Int
    let gocardlessMissedEmiDates: [GocardlessMissedEmiDate]

    enum CodingKeys: String, CodingKey {
        case title, status
        case nextDue = "next_due"
        case dueDate = "due_date"
        case fundingAmount = "funding_amount"
        case instalmentPaid = "instalment_paid"
        case remainingInstalment = "remaining_instalment"
        case totalInstalment = "total_instalment"
        //case upcomingEmiDates = "upcoming_emi_dates"
        case completedEmiDates = "completed_emi_dates"
        case gocardlessMissedEmis = "gocardless_missed_emis"
        case gocardlessMissedEmiDates = "gocardless_missed_emi_dates"
    }
}
// MARK: - CompletedEmiDate
struct CompletedEmiDate: Codable {
    let id: Int
    let emiDate: String
    let amount: Float
    let status: String

    enum CodingKeys: String, CodingKey {
        case id
        case emiDate = "emi_date"
        case amount, status
    }
}


struct AllPaymentsModel: Codable {
    let data: [AllPaymentsData]
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
struct AllPaymentsData: Codable {
    let loanID: Int
    let company: CompanyObj
    let loan: Loan
    let fundingPayments: DashboardFundingPayment

    enum CodingKeys: String, CodingKey {
        case loanID = "loan_id"
        case company, loan
        case fundingPayments = "funding_payments"
    }
}

// MARK: - Company
struct CompanyObj: Codable {
    let id: String
    let companyID: Int
    let companyName, companyPhoneNumber, companyStatus,businessType: String
    let tradingStyle, companyNumber,fundingPurpose: String
    let otherFundingPurpose: String
    let companyAddress: CompanyAddress
    let gocardlessStatus: Bool?
   // let businessType, fundingPurpose: JSONNull?
    enum CodingKeys: String, CodingKey {
        case id
        case companyID = "company_id"
        case companyName = "company_name"
        case companyPhoneNumber = "company_phone_number"
        case companyStatus = "company_status"
        case businessType = "business_type"
        case tradingStyle = "trading_style"
        case companyNumber = "company_number"
        case fundingPurpose = "funding_purpose"
        case otherFundingPurpose = "other_funding_purpose"
        case companyAddress = "company_address"
        case gocardlessStatus = "gocardless_status"
    }
}
// MARK: - CompanyAddress
struct CompanyAddress: Codable {
    let postCode, addressLine: String

    enum CodingKeys: String, CodingKey {
        case postCode = "post_code"
        case addressLine = "address_line"
    }
}
struct Summary: Codable {
    let data: SummaryDataClass
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
struct SummaryDataClass: Codable {
    let summary: SummaryClass
    let loans: [SummaryLoan]
}

// MARK: - Loan
struct SummaryLoan: Codable {
    let loanNumber: Int
    let loanAmount: String
    let instalmentPaid, remainingInstalment, totalInstalment, gocardlessMissedEmis: Int
    let fundingPaymentHistory: [FundingPaymentHistory]
    let gocardlessMissedEmiDates: [GocardlessMissedEmiDate]

    enum CodingKeys: String, CodingKey {
        case loanNumber = "loan_number"
        case loanAmount = "loan_amount"
        case instalmentPaid = "instalment_paid"
        case remainingInstalment = "remaining_instalment"
        case totalInstalment = "total_instalment"
        case gocardlessMissedEmis = "gocardless_missed_emis"
        case fundingPaymentHistory = "funding_payment_history"
        case gocardlessMissedEmiDates = "gocardless_missed_emi_dates"
    }
}

// MARK: - FundingPaymentHistory
struct FundingPaymentHistory: Codable {
    let id: Int
    let date, amount, description: String
    enum CodingKeys: String, CodingKey {
        case id,date,amount,description
    }
    init(id: Int,date: String,amount: String,description: String){
        self.id = id
        self.date = date
        self.amount = amount
        self.description = description
    }
}

// MARK: - GocardlessMissedEmiDate
struct GocardlessMissedEmiDate: Codable {
    let id: Int
    let emiDate, amount, status, description: String

    enum CodingKeys: String, CodingKey {
        case id
        case emiDate = "emi_date"
        case amount, status, description
    }
}

// MARK: - SummaryClass
struct SummaryClass: Codable {
    let totalLoans, totalAmount, totalInstallments, totalRemainingInstallments: Int
    let totalGocardlessMissedInstallments: Int

    enum CodingKeys: String, CodingKey {
        case totalLoans = "total_loans"
        case totalAmount = "total_amount"
        case totalInstallments = "total_installments"
        case totalRemainingInstallments = "total_remaining_installments"
        case totalGocardlessMissedInstallments = "total_gocardless_missed_installments"
    }
}
class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if container.decodeNil() {
                    return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if let value = try? container.decodeNil() {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                    return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                    if let value = value as? Bool {
                            try container.encode(value)
                    } else if let value = value as? Int64 {
                            try container.encode(value)
                    } else if let value = value as? Double {
                            try container.encode(value)
                    } else if let value = value as? String {
                            try container.encode(value)
                    } else if value is JSONNull {
                            try container.encodeNil()
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                    let key = JSONCodingKey(stringValue: key)!
                    if let value = value as? Bool {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Int64 {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Double {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? String {
                            try container.encode(value, forKey: key)
                    } else if value is JSONNull {
                            try container.encodeNil(forKey: key)
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                    try container.encode(value)
            } else if let value = value as? Int64 {
                    try container.encode(value)
            } else if let value = value as? Double {
                    try container.encode(value)
            } else if let value = value as? String {
                    try container.encode(value)
            } else if value is JSONNull {
                    try container.encodeNil()
            } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
            }
    }

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                    self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try JSONAny.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: JSONCodingKey.self)
                    try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try JSONAny.encode(to: &container, value: self.value)
            }
    }
}
class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}
struct FundingOfferModel: Codable {
    let errorCode, errorMessage, moreInfo: String
    let statusCode, totalCount, numPages: Int
    let first, previous, next, last: String
    let data: [FundingOfferData]
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
struct FundingOfferData: Codable {
    let id: Int
    let customerLoan: String
    let offerCreatedBy: OfferCreatedBy
    let offerAmount: String
    let offerNumberOfWeeks: Int
    let offerWeeklyPaymentAmount, offerMerchantFactor: String
    let offerAccepted, offerRejected: Bool
    let offerDate, appliedLoanAmount: String
    let appliedFundDurationWeeks: Int
    let appliedWeeklyPaymentAmount, appliedMerchantFactor: String
    let isExpired: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerLoan = "customer_loan"
        case offerCreatedBy = "offer_created_by"
        case offerAmount = "offer_amount"
        case offerNumberOfWeeks = "offer_number_of_weeks"
        case offerWeeklyPaymentAmount = "offer_weekly_payment_amount"
        case offerMerchantFactor = "offer_merchant_factor"
        case offerAccepted = "offer_accepted"
        case offerRejected = "offer_rejected"
        case offerDate = "offer_date"
        case appliedLoanAmount = "applied_loan_amount"
        case appliedFundDurationWeeks = "applied_fund_duration_weeks"
        case appliedWeeklyPaymentAmount = "applied_weekly_payment_amount"
        case appliedMerchantFactor = "applied_merchant_factor"
        case isExpired = "is_expired"
    }
}

// MARK: - OfferCreatedBy
struct OfferCreatedBy: Codable {
    let id: Int
    let email, firstName, lastName, role: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case role
    }
}
struct PendingApprovalModel: Codable {
    let errorCode, errorMessage, moreInfo: String
    let statusCode, totalCount, numPages: Int
    let first, previous, next, last: String
    let data: [ProfileChange]
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

// MARK: - DataClass
struct PendingApprovalData: Codable {
    let profileChanges: [ProfileChange]
    let photoIDChanges: [PhotoIDChange]
    let addressProofChanges: [AddressProofChange]

    enum CodingKeys: String, CodingKey {
        case profileChanges = "profile_changes"
        case photoIDChanges = "photo_id_changes"
        case addressProofChanges = "address_proof_changes"
    }
}
struct AddressProofChange: Codable {
    let id, customer, councilTax, utilityBill: String
    let leaseDeed: String
    let isAdminApproved: Bool

    enum CodingKeys: String, CodingKey {
        case id, customer
        case councilTax = "council_tax"
        case utilityBill = "utility_bill"
        case leaseDeed = "lease_deed"
        case isAdminApproved = "is_admin_approved"
    }
}

// MARK: - PhotoIDChange
struct PhotoIDChange: Codable {
    let id, customer, photo, passport: String
    let drivingLicense: String
    let isAdminApproved: Bool

    enum CodingKeys: String, CodingKey {
        case id, customer, photo, passport
        case drivingLicense = "driving_license"
        case isAdminApproved = "is_admin_approved"
    }
}
// MARK: - ProfileChange
class ProfileChange: Codable {
    let id: String
    let addressProof: AddressProofUnion?
    let photoID: PhotoIdUnion?
    let company: Company?
    let isActive: Bool?
        let isAdminApproved: Bool?
        let customer: Customer?
        let isAdminReject: Bool
        let rejectionReason, type: String
        let changes: Changes

        enum CodingKeys: String, CodingKey {
            case id
            case addressProof = "address_proof"
            case isActive = "is_active"
            case isAdminApproved = "is_admin_approved"
            case customer
            case isAdminReject = "is_admin_reject"
            case rejectionReason = "rejection_reason"
            case type, changes
            case photoID = "photo_id"
            case company

        }
}
struct PhotoID: Codable {
    let id, unit, photo: String
    let passport: String
    let drivingLicense: String

    enum CodingKeys: String, CodingKey {
        case id, unit, photo, passport
        case drivingLicense = "driving_license"
    }
}
enum PhotoIdUnion: Codable {
    case photoID(PhotoID)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(PhotoID.self) {
            self = .photoID(x)
            return
        }
        throw DecodingError.typeMismatch(PhotoID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PhotoID"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .photoID(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
enum AddressProofUnion: Codable {
    case addressProofClass(AddressProofClass)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(AddressProofClass.self) {
            self = .addressProofClass(x)
            return
        }
        throw DecodingError.typeMismatch(AddressProofUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AddressProofUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .addressProofClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
struct AddressProofClass: Codable {
    let id, unit, councilTax, utilityBill: String
    let leaseDeed: String

    enum CodingKeys: String, CodingKey {
        case id, unit
        case councilTax = "council_tax"
        case utilityBill = "utility_bill"
        case leaseDeed = "lease_deed"
    }
}
struct Changes: Codable {
    let title, dateOfBirth, description: String?
    let councilTax: String?
    let passport: String?
    let drivingLicense: String?
    let companyName, companyStatus, businessType, tradingStyle: String?
    let fundingPurpose: String?

    enum CodingKeys: String, CodingKey {
        case title
        case dateOfBirth = "date_of_birth"
        case description
        case councilTax = "council_tax"
        case passport
        case drivingLicense = "driving_license"
        case companyName = "company_name"
                case companyStatus = "company_status"
                case businessType = "business_type"
                case tradingStyle = "trading_style"
                case fundingPurpose = "funding_purpose"
    }
}

struct GocardlessManualModel: Codable {
    let data: GocardlessManual
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
struct GocardlessManual: Codable {
    let continueWithGocardless: Bool
    let bankDetails: [BankDetail]

    enum CodingKeys: String, CodingKey {
        case continueWithGocardless = "continue_with_gocardless"
        case bankDetails = "bank_details"
    }
}

// MARK: - BankDetail
struct BankDetail: Codable {
    let id: Int
    let bankName: String
    let bankAccountNumber, bankSortCode: String
   // let debit, credit: [JSONAny]
   // let debitSum, creditSum: String
   // let totalPeriods: String
    let startDate, endDate: String
    let gocardlessStatus, isPrimaryAccount, allGrouped: Bool
    let bankCountryCode, accountHolderName: String
    let continueWithGocardless: Bool
    let businessAccountStatements: [JSONAny]
    let requisitionID: String
    let consentCompleted: Bool
    let institutionID: String
    let requisitionLink: String

    enum CodingKeys: String, CodingKey {
        case id
        case bankName = "bank_name"
        case bankAccountNumber = "bank_account_number"
        case bankSortCode = "bank_sort_code"
     //   case debit, credit
     //   case debitSum = "debit_sum"
       // case creditSum = "credit_sum"
      //  case totalPeriods = "total_periods"
        case startDate = "start_date"
        case endDate = "end_date"
        case gocardlessStatus = "gocardless_status"
        case isPrimaryAccount = "is_primary_account"
        case allGrouped = "all_grouped"
        case bankCountryCode = "bank_country_code"
        case accountHolderName = "account_holder_name"
        case continueWithGocardless = "continue_with_gocardless"
        case businessAccountStatements = "business_account_statements"
        case requisitionID = "requisition_id"
        case consentCompleted = "consent_completed"
        case institutionID = "institution_id"
        case requisitionLink = "requisition_link"
    }

}
// MARK: - StatementModel
struct StatementModel: Codable {
    let data: StatementDataClass
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
struct StatementDataClass: Codable {
    let companyInfo: [CompanyInfo]
    let date, companyName: String
    let loanNumber, advanceAmount, paybackAmount: Int
    let startDate, endDate: String
    let weeklyRepaymentAmount, noOfWeeklyInstallments: Int
    let installmentAmount: [Int]
    let weeklyRepaymentDays: [String]
    let statementData: [StatementDatum]

    enum CodingKeys: String, CodingKey {
        case companyInfo = "company_info"
        case date
        case companyName = "company_name"
        case loanNumber = "loan_number"
        case advanceAmount = "advance_amount"
        case paybackAmount = "payback_amount"
        case startDate = "start_date"
        case endDate = "end_date"
        case weeklyRepaymentAmount = "weekly_repayment_amount"
        case noOfWeeklyInstallments = "no_of_weekly_installments"
        case installmentAmount = "installment_amount"
        case weeklyRepaymentDays = "weekly_repayment_days"
        case statementData = "statement_data"
    }
}

// MARK: - CompanyInfo
struct CompanyInfo: Codable {
    let id: Int
    let name, logo, addressLine1, addressLine2: String
    let addressLine3: String

    enum CodingKeys: String, CodingKey {
        case id, name, logo
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case addressLine3 = "address_line3"
    }
}

// MARK: - StatementDatum
struct StatementDatum: Codable {
    let id: Int
    let date, day, narration, debit: String
    let credit, balance, customerLoan: String

    enum CodingKeys: String, CodingKey {
        case id, date, day, narration, debit, credit, balance
        case customerLoan = "customer_loan"
    }
}
