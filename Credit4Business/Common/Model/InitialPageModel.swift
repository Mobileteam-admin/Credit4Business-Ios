//
//  InitialPageModel.swift
//  Credit4Business
//
//  Created by MacMini on 07/03/24.
//

import Foundation
import UIKit
class Common : Codable {
    var id : Int
    var description : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
    }
    init() {
        self.id = 0
        self.description = ""
    }
    init(id: Int, description: String) {
        self.id = id
        self.description = description
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.description = container.safeDecodeValue(forKey: .description)
    }
}
class PropertyAddressModel : Codable {
    var address : String
    var postCode : String
    var isExtended = false
    enum CodingKeys: String, CodingKey {
        case address,isExtended,postCode
    }
    init() {
        self.address = ""
        self.isExtended = false
        self.postCode = ""
    }
}
class AddressAloneModel : Codable {
    var address : String
    var postCode : String?
    var houseOwnership : Common?
    var yearsOfStay : Int
    var startDate : String?
    var startDateObj : Date?
    var endDateObj : Date?
    var endDate : String?
    var monthsOfStay : Int
    var isHouseExtended : Bool
    var isPostcodeExtended : Bool
    enum CodingKeys: String, CodingKey {
        case address,postCode,houseOwnership,yearsOfStay,monthsOfStay,isHouseExtended,isPostcodeExtended,startDate,endDate,startDateObj,endDateObj
    }
    
    init() {
        self.address = ""
        self.postCode = ""
        self.houseOwnership = Common()
        self.yearsOfStay = 0
        self.monthsOfStay = 0
        self.isPostcodeExtended = false
        self.isHouseExtended = false
    }
}
//class NameModel : Codable {
//    var firstName : String
//    var lastName : String
//    var isExtended : Bool
//    var title : String
//    var id : Int
//    enum CodingKeys: String, CodingKey {
//        case firstName
//        case lastName
//        case isExtended,title,id
//    }
//    
//    init() {
//        self.firstName = ""
//        self.lastName = ""
//        self.isExtended = false
//        self.title = ""
//        self.id = 0
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.firstName = container.safeDecodeValue(forKey: .firstName)
//        self.lastName = container.safeDecodeValue(forKey: .lastName)
//        self.isExtended = container.safeDecodeValue(forKey: .isExtended)
//        self.title = container.safeDecodeValue(forKey: .title)
//        self.id = container.safeDecodeValue(forKey: .id)
//    }
//}
class FundingModel : Codable {
    var initial = InitialModel()
    var business = BusinessModel()
    var registeredAddress = AddressModel()
    var tradingAddress = AddressModel()
    var directors = [DirectorModel]()
    var consents = MarketingModel()
    var documents = DocumentsModel()
    var guarantor = GuarantorModel()
    enum CodingKeys: String, CodingKey {
        case business,initial,registeredAddress,tradingAddress,directors,consents,documents,guarantor
    }
    
    init() {
        
    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//    }
}
class MenuItemModel{
    var title : String
    var imgName : String?
    var viewController : UIViewController?
    init(withTitle title :String,image : String? = nil,VC : UIViewController? ){
        self.title = title
        self.imgName = image
        self.viewController = VC
    }
}
class CommonModel : Codable {
    let statusCode, statusMessage: String
    var isSuccess : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
    init(statusCode: String, statusMessage: String) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.isSuccess = self.statusCode != "0"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.isSuccess = self.statusCode != "0"
    }
}
class InitialModel : Codable {
    var companyName: String
    var businessType : Common?
    var email : String
    var tradingStyle : String
    var companyNumber : String
    var firstName : String
    var lastName : String
    var title : String
    var phone : String
    var fundingProcess : String
    var otherFunding : String
    var fundRequest : String
    var duration : String
    var modeOfApplication : String
    var representative : String
    var repaymentDay : String
    enum CodingKeys: String, CodingKey {
        case companyName,businessType,email
        case firstName,lastName,tradingStyle,companyNumber
        case title,phone,fundingProcess,fundRequest,duration,modeOfApplication,otherFunding,representative,repaymentDay
    }
    
    init() {
        self.companyName = ""
        self.businessType = Common()
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.tradingStyle = ""
        self.companyNumber = ""
        self.title = ""
        self.phone = ""
        self.fundingProcess = ""
        self.fundRequest = ""
        self.duration = ""
        self.modeOfApplication = ""
        self.otherFunding = ""
        self.representative = ""
        self.repaymentDay = ""
    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.companyName = container.safeDecodeValue(forKey: .companyName)
//        self.businessType = container.safeDecodeValue(forKey: .businessType)
//        self.email = container.safeDecodeValue(forKey: .email)
//        self.firstName = container.safeDecodeValue(forKey: .firstName)
//        self.lastName = container.safeDecodeValue(forKey: .lastName)
//        self.tradingStyle = container.safeDecodeValue(forKey: .tradingStyle)
//        self.companyNumber = container.safeDecodeValue(forKey: .companyNumber)
//        self.title = container.safeDecodeValue(forKey: .title)
//        self.phone = container.safeDecodeValue(forKey: .phone)
//        self.fundingProcess = container.safeDecodeValue(forKey: .fundingProcess)
//        self.fundRequest = container.safeDecodeValue(forKey: .fundRequest)
//        self.duration = container.safeDecodeValue(forKey: .duration)
//        self.modeOfApplication = container.safeDecodeValue(forKey: .modeOfApplication)
//        self.otherFunding = container.safeDecodeValue(forKey: .otherFunding)
//    }
}
class BusinessModel : Codable {
    var businessType: String
    var numberOfDirectors: String
    var directorArray = [SelectedDirector]()
    var remainingDirectorArray = [SelectedDirector]()
    var orderArray = [Int]()
    var isStartedTrading : Bool
    var tradingDate : String
    var isProfitable : Bool
    var isAcceptCard : Bool
    var turnOver: String
    var salesTurnOver: String
    var businessSector : String
    var otherBusinessSector : String

    enum CodingKeys: String, CodingKey {
        case numberOfDirectors,businessType,directorArray,remainingDirectorArray
        case isStartedTrading,tradingDate,isProfitable,isAcceptCard
        case turnOver,salesTurnOver,businessSector,otherBusinessSector,orderArray
    }
    
    init() {
        self.numberOfDirectors = ""
        self.businessType = ""
        self.directorArray = [SelectedDirector]()
        self.remainingDirectorArray = [SelectedDirector]()
        self.isStartedTrading = false
        self.tradingDate = ""
        self.isProfitable = false
        self.isAcceptCard = false
        self.turnOver = ""
        self.salesTurnOver = ""
        self.businessSector = ""
        self.otherBusinessSector = ""
        self.orderArray = [Int]()
    }
}
class AddressModel : Codable {
    var address1: String
    var address2: String
    var town : String
    var postcode : String
    var premiseType : String
    var leaseStartDate : String
    var leaseEndDate : String
    var leaseDocumentURL : String
    var isSameForTrade : Bool

    enum CodingKeys: String, CodingKey {
        case address1,address2,town
        case postcode,premiseType,leaseStartDate,leaseEndDate
        case leaseDocumentURL,isSameForTrade
    }
    init() {
        self.address1 = ""
        self.address2 = ""
        self.town = ""
        self.postcode = ""
        self.premiseType = ""
        self.leaseStartDate = ""
        self.leaseEndDate = ""
        self.leaseDocumentURL = ""
        self.isSameForTrade = false
    }
}
class DirectorModel : Codable {
    var name: String
    var phone: String
    var email : String
    var addressCollection = [AddressCollection]()
    var isOwnProperty : Bool
    var stayAddress = [String]()
    var ownPropertyAddress = [String]()
    var id : Int

    enum CodingKeys: String, CodingKey {
        case name,phone,email
        case isOwnProperty,stayAddress,ownPropertyAddress,id
    }
    init() {
        self.name = ""
        self.phone = ""
        self.email = ""
        self.addressCollection = [AddressCollection]()
        self.isOwnProperty = false
        self.stayAddress = [String]()
        self.ownPropertyAddress = [String]()
        self.id = 0
    }
}
class AddressCollection : Codable {
    var postcode : String
    var address : String
    var houseOwnership : String
    var stayMonth : String
    var stayYear : String

    enum CodingKeys: String, CodingKey {
        case postcode,address,houseOwnership,stayMonth,stayYear
    }
    init() {
       
        self.postcode = ""
        self.address = ""
        self.houseOwnership = ""
        self.stayMonth = ""
        self.stayYear = ""
       
    }
}
class MarketingModel : Codable {
    var related = [String]()
    var unrelated = [String]()
    var thirdParty = [String]()
    

    enum CodingKeys: String, CodingKey {
        case related,unrelated,thirdParty
    }
    init() {
        self.related = [String]()
        self.unrelated = [String]()
        self.thirdParty = [String]()
    }
}
class DocumentsModel : Codable {
    var photo : String
    var passport : String
    var bill : String
    var premise : String
    var account : String
    var other : String
    var councilTax : String
    var drivingLicense : String
    var isAgreed = false

    enum CodingKeys: String, CodingKey {
        case photo,passport,bill,premise,account,other,isAgreed,councilTax,drivingLicense
    }
    init() {
        self.photo = ""
        self.passport = ""
        self.bill = ""
        self.premise = ""
        self.account = ""
        self.other = ""
        self.councilTax = ""
        self.drivingLicense = ""
        self.isAgreed = false
    }
}
class GuarantorModel : Codable {
    var name : String
    var address : String
    var phone : String
    var email : String
    var isAgreed = false

    enum CodingKeys: String, CodingKey {
        case name,address,phone,email
    }
    init() {
        self.name = ""
        self.address = ""
        self.phone = ""
        self.email = ""
    }
}
class ItemsModel : Codable {
    var Items : [PostcodeModel]
    var NumItems : Int
    enum CodingKeys: String, CodingKey {
        case Items,NumItems
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.Items = try container.decodeIfPresent([PostcodeModel].self, forKey: .Items) ?? [PostcodeModel]()
        self.NumItems = container.safeDecodeValue(forKey: .NumItems)
    }
    init () {
        self.Items = [PostcodeModel]()
        self.NumItems = 0
    }
}
class DataModel : Codable {
    var Status : String
    var QueryStr : String
    var Results : ItemsModel
    enum CodingKeys: String, CodingKey {
        case Status
        case QueryStr
        case Results
    }
    required init(from decoder : Decoder) throws{
             let container = try decoder.container(keyedBy: CodingKeys.self)
        self.Status = container.safeDecodeValue(forKey: .Status)
        self.QueryStr = container.safeDecodeValue(forKey: .QueryStr)
        self.Results = try container.decodeIfPresent(ItemsModel.self, forKey: .Results) ?? ItemsModel()
    }
    init () {
        self.Status =  ""
        self.QueryStr = ""
        self.Results = ItemsModel()
    }
}
class CompanyNameModel: Codable {
    let companyStatus, companyNumber, companyName: String
    let companyAddress : CompanyAddress
    enum CodingKeys: String, CodingKey {
        case companyStatus = "Company_Status"
        case companyNumber = "Company_Number"
        case companyName = "Company_Name"
        case companyAddress = "Company_Address"
    }
    required init(from decoder : Decoder) throws{
             let container = try decoder.container(keyedBy: CodingKeys.self)
        self.companyStatus = container.safeDecodeValue(forKey: .companyStatus)
        self.companyNumber = container.safeDecodeValue(forKey: .companyNumber)
        self.companyName = container.safeDecodeValue(forKey: .companyName)
        self.companyAddress = try container.decodeIfPresent(CompanyAddress.self, forKey: .companyAddress) ?? CompanyAddress(postCode: "", addressLine: "")
    }
    init () {
        self.companyStatus =  ""
        self.companyNumber = ""
        self.companyName = ""
        self.companyAddress = CompanyAddress(postCode: "", addressLine: "")
    }
}
class CompanyLookupModel : Codable {
    var statusCode : String
    var statusMessage : String
    var statusTitle : String
    var data : [CompanyNameModel]
    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent([CompanyNameModel].self, forKey: .data) ?? [CompanyNameModel]()
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.statusTitle = container.safeDecodeValue(forKey: .statusTitle)
    }
    init () {
        self.data = [CompanyNameModel]()
        self.statusCode = ""
        self.statusMessage = ""
        self.statusTitle = ""
    }
}
class LookupModel : Codable {
    var statusCode : String
    var statusMessage : String
    var statusTitle : String
    var data : DataModel
    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent(DataModel.self, forKey: .data) ?? DataModel()
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.statusTitle = container.safeDecodeValue(forKey: .statusTitle)
    }
    init () {
        self.data = DataModel()
        self.statusCode = ""
        self.statusMessage = ""
        self.statusTitle = ""
    }
}
class PostcodeModel : Codable {
    var Sid : String
    var ItemText : String
    var IsExpandable : String
    var IsComplete : String
    var Selected : String
    var ExpandsTo : String?
    var Label1 : String
    var Label2 : String
    var Label3 : String
    var Label4 : String
    var Label5 : String
    let fullAddress, companyName, companyCategory, companyStatus: String?
    let companyNumber: String?

    enum CodingKeys: String, CodingKey {
        case Sid,ItemText,IsExpandable,IsComplete,Selected,ExpandsTo,Label1,Label2,Label3,Label4,Label5
        case fullAddress = "full_address"
        case companyName = "Company_Name"
        case companyCategory = "Company_Category"
        case companyStatus = "Company_Status"
        case companyNumber = "Company_Number"

    }
    init(json:JSON) {
        self.Sid = json.string("Sid")
        self.ItemText = json.string("ItemText")
        self.IsExpandable = json.string("IsExpandable")
        self.IsComplete = json.string("IsComplete")
        self.Selected = json.string("Selected")
        self.ExpandsTo = json.string("ExpandsTo")
        self.Label1 = json.string("Label1")
        self.Label2 = json.string("Label2")
        self.Label3 = json.string("Label3")
        self.Label4 = json.string("Label4")
        self.Label5 = json.string("Label5")
        self.fullAddress = ""
        self.companyName = ""
        self.companyCategory = ""
        self.companyStatus = ""
        self.companyNumber = ""

    }
    init () {
        self.Sid = ""
        self.ItemText = ""
        self.IsExpandable = ""
        self.IsComplete = ""
        self.Selected = ""
        self.ExpandsTo = ""
        self.Label1 = ""
        self.Label2 = ""
        self.Label3 = ""
        self.Label4 = ""
        self.Label5 = ""
        self.fullAddress = ""
        self.companyName = ""
        self.companyCategory = ""
        self.companyStatus = ""
        self.companyNumber = ""

    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.Sid = container.safeDecodeValue(forKey: .Sid)
        self.ItemText = container.safeDecodeValue(forKey: .ItemText)
        self.IsExpandable = container.safeDecodeValue(forKey: .IsExpandable)
        self.IsComplete = container.safeDecodeValue(forKey: .IsComplete)
        self.Selected = container.safeDecodeValue(forKey: .Selected)
        self.ExpandsTo = container.safeDecodeValue(forKey: .ExpandsTo)
        self.Label1 = container.safeDecodeValue(forKey: .Label1)
        self.Label2 = container.safeDecodeValue(forKey: .Label2)
        self.Label3 = container.safeDecodeValue(forKey: .Label3)
        self.Label4 = container.safeDecodeValue(forKey: .Label4)
        self.Label5 = container.safeDecodeValue(forKey: .Label5)
        self.fullAddress = container.safeDecodeValue(forKey: .fullAddress)
        self.companyName = container.safeDecodeValue(forKey: .companyName)
        self.companyCategory = container.safeDecodeValue(forKey: .companyCategory)
        self.companyStatus = container.safeDecodeValue(forKey: .companyStatus)
        self.companyNumber = container.safeDecodeValue(forKey: .companyNumber)

    }
}
//struct CompanyPostcodeLookupModel: Codable {
//    let data: CompanyPostcodeModel
//    let statusCode: Int
//    let statusMessage, statusTitle: String
//
//    enum CodingKeys: String, CodingKey {
//        case data
//        case statusCode = "status_code"
//        case statusMessage = "status_message"
//        case statusTitle = "status_title"
//    }
//}
//
//// MARK: - DataClass
//struct CompanyPostcodeModel: Codable {
//    let status, queryStr: String
//    let results: Results
//
//    enum CodingKeys: String, CodingKey {
//        case status = "Status"
//        case queryStr = "QueryStr"
//        case results = "Results"
//    }
//}
//
//// MARK: - Results
//struct Results: Codable {
//    let numItems: Int
//    let items: [Item]
//
//    enum CodingKeys: String, CodingKey {
//        case numItems = "NumItems"
//        case items = "Items"
//    }
//}
//
//// MARK: - Item
//struct Item: Codable {
//    let sid,itemText,isExpandable, isComplete, selected: String
//    let label1, label2, label3, label4: String?
//    //let extra: Extra?
//    let fullAddress, companyName, companyCategory, companyStatus: String?
//    let companyNumber: String?
//
//    enum CodingKeys: String, CodingKey {
//        case sid = "Sid"
//        case itemText = "ItemText"
//        case isExpandable = "IsExpandable"
//        case isComplete = "IsComplete"
//        case selected = "Selected"
//        case label1 = "Label1"
//        case label2 = "Label2"
//        case label3 = "Label3"
//        case label4 = "Label4"
//      //  case extra = "Extra"
//        case fullAddress = "full_address"
//        case companyName = "Company_Name"
//        case companyCategory = "Company_Category"
//        case companyStatus = "Company_Status"
//        case companyNumber = "Company_Number"
//    }
//    init() {
//        self.sid = ""
//        self.isExpandable = ""
//        self.isComplete = ""
//        self.selected = ""
//        self.label1 = ""
//        self.label2 = ""
//        self.label3 = ""
//        self.label4 = ""
//       // self.extra = Extra()
//        self.fullAddress = ""
//        self.companyName = ""
//        self.companyCategory = ""
//        self.companyStatus = ""
//        self.companyNumber = ""
//        self.itemText = ""
//    }
//}
//
//// MARK: - Extra
//struct Extra: Codable {
//    let records: [Record]
//
//    enum CodingKeys: String, CodingKey {
//        case records = "Records"
//    }
//    init() {
//        self.records = [Record]()
//    }
//}
//
//// MARK: - Record
//struct Record: Codable {
//    let extraHPWORDINAL, extraUDPRNINDEX, extraCHNUM, extraADDRESSKEY: String
//    let extraCompanyName, extraCHCategory, extraCHStatus, extraCHCtryOrigin: String
//    let extraCHIncorpDate, extraCHAcctRefDay, extraCHAcctRefMon, extraCHAcctDueDate: String
//    let extraCHAcctLastDate, extraCHAcctCategory, extraCHRtrnDueDate, extraCHRtrnLastDate: String
//    let extraCHMortCharges, extraCHMortOutstanding, extraCHMortPartSatfd, extraCHMortSatisfied: String
//    let extraCHSICCode1, extraCHLtdGenPartners, extraCHLtdLtdPartners: String
//    let extraCHURI: String
//    let extraCHCondate1, extraCHPrevName1, extraCHCondate2, extraCHPrevName2: String
//    let extraCHNextDueDate, extraCHLastUpdate: String
//
//    enum CodingKeys: String, CodingKey {
//        case extraHPWORDINAL = "Extra_HPWORDINAL"
//        case extraUDPRNINDEX = "Extra_UDPRNINDEX"
//        case extraCHNUM = "Extra_CHNUM"
//        case extraADDRESSKEY = "Extra_ADDRESS_KEY"
//        case extraCompanyName = "Extra_Company_Name"
//        case extraCHCategory = "Extra_CH_Category"
//        case extraCHStatus = "Extra_CH_Status"
//        case extraCHCtryOrigin = "Extra_CH_CtryOrigin"
//        case extraCHIncorpDate = "Extra_CH_IncorpDate"
//        case extraCHAcctRefDay = "Extra_CH_Acct_Ref_Day"
//        case extraCHAcctRefMon = "Extra_CH_Acct_Ref_Mon"
//        case extraCHAcctDueDate = "Extra_CH_Acct_Due_Date"
//        case extraCHAcctLastDate = "Extra_CH_Acct_Last_Date"
//        case extraCHAcctCategory = "Extra_CH_Acct_Category"
//        case extraCHRtrnDueDate = "Extra_CH_Rtrn_Due_Date"
//        case extraCHRtrnLastDate = "Extra_CH_Rtrn_Last_Date"
//        case extraCHMortCharges = "Extra_CH_Mort_Charges"
//        case extraCHMortOutstanding = "Extra_CH_Mort_Outstanding"
//        case extraCHMortPartSatfd = "Extra_CH_Mort_Part_Satfd"
//        case extraCHMortSatisfied = "Extra_CH_Mort_Satisfied"
//        case extraCHSICCode1 = "Extra_CH_SIC_Code_1"
//        case extraCHLtdGenPartners = "Extra_CH_Ltd_Gen_Partners"
//        case extraCHLtdLtdPartners = "Extra_CH_Ltd_Ltd_Partners"
//        case extraCHURI = "Extra_CH_URI"
//        case extraCHCondate1 = "Extra_CH_Condate_1"
//        case extraCHPrevName1 = "Extra_CH_Prev_Name_1"
//        case extraCHCondate2 = "Extra_CH_Condate_2"
//        case extraCHPrevName2 = "Extra_CH_Prev_Name_2"
//        case extraCHNextDueDate = "Extra_CH_Next_Due_Date"
//        case extraCHLastUpdate = "Extra_CH_Last_Update"
//    }
//    init() {
//        self.extraHPWORDINAL = "Extra_HPWORDINAL"
//        self.extraUDPRNINDEX = "Extra_UDPRNINDEX"
//        self.extraCHNUM = "Extra_CHNUM"
//        self.extraADDRESSKEY = "Extra_ADDRESS_KEY"
//        self.extraCompanyName = "Extra_Company_Name"
//        self.extraCHCategory = "Extra_CH_Category"
//        self.extraCHStatus = "Extra_CH_Status"
//        self.extraCHCtryOrigin = "Extra_CH_CtryOrigin"
//        self.extraCHIncorpDate = "Extra_CH_IncorpDate"
//        self.extraCHAcctRefDay = "Extra_CH_Acct_Ref_Day"
//        self.extraCHAcctRefMon = "Extra_CH_Acct_Ref_Mon"
//        self.extraCHAcctDueDate = "Extra_CH_Acct_Due_Date"
//        self.extraCHAcctLastDate = "Extra_CH_Acct_Last_Date"
//        self.extraCHAcctCategory = "Extra_CH_Acct_Category"
//        self.extraCHRtrnDueDate = "Extra_CH_Rtrn_Due_Date"
//        self.extraCHRtrnLastDate = "Extra_CH_Rtrn_Last_Date"
//        self.extraCHMortCharges = "Extra_CH_Mort_Charges"
//        self.extraCHMortOutstanding = "Extra_CH_Mort_Outstanding"
//        self.extraCHMortPartSatfd = "Extra_CH_Mort_Part_Satfd"
//        self.extraCHMortSatisfied = "Extra_CH_Mort_Satisfied"
//        self.extraCHSICCode1 = "Extra_CH_SIC_Code_1"
//        self.extraCHLtdGenPartners = "Extra_CH_Ltd_Gen_Partners"
//        self.extraCHLtdLtdPartners = "Extra_CH_Ltd_Ltd_Partners"
//        self.extraCHURI = "Extra_CH_URI"
//        self.extraCHCondate1 = "Extra_CH_Condate_1"
//        self.extraCHPrevName1 = "Extra_CH_Prev_Name_1"
//        self.extraCHCondate2 = "Extra_CH_Condate_2"
//        self.extraCHPrevName2 = "Extra_CH_Prev_Name_2"
//        self.extraCHNextDueDate = "Extra_CH_Next_Due_Date"
//        self.extraCHLastUpdate = "Extra_CH_Last_Update"
//    }
//}
class PaymentModel : Codable {
    var description : String
    var date : String
    var amount : String
    enum CodingKeys: String, CodingKey {
        case description
        case date
        case amount
    }
    
    init() {
        self.description = ""
        self.date = ""
        self.amount = ""
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = container.safeDecodeValue(forKey: .description)
        self.date = container.safeDecodeValue(forKey: .date)
        self.amount = container.safeDecodeValue(forKey: .amount)
    }
}
class PaymentHistoryModel : Codable {
    var isExtended : Bool
    var payments = [PaymentModel]()
    enum CodingKeys: String, CodingKey {
        case isExtended
        case payments
    }
    
    init() {
        self.isExtended = false
        self.payments = [PaymentModel]()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isExtended = container.safeDecodeValue(forKey: .isExtended)
        self.payments = container.safeDecodeValue(forKey: .payments)
    }
}
class RefreshTokenModel : Codable {
    var statusCode : Int
    var statusMessage : String
    var statusTitle : String
    var refresh : String
    var access : String
    
    enum CodingKeys: String, CodingKey {
        case refresh,access
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.statusTitle = container.safeDecodeValue(forKey: .statusTitle)
        self.refresh = container.safeDecodeValue(forKey: .refresh)
        self.access = container.safeDecodeValue(forKey: .access)
    }
    init () {
        self.statusCode = 0
        self.statusMessage = ""
        self.statusTitle = ""
        self.refresh = ""
        self.access = ""
    }
}
class LoginModel : Codable {
    var statusCode : Int
    var statusMessage : String
    var statusTitle : String
    var refresh : String
    var access : String
    var role : String
    var username : String
    var fullName : String
    var image : String
    var address : String
    
    enum CodingKeys: String, CodingKey {
        case refresh,access,role,username,fullName = "full_name",image,address
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.statusTitle = container.safeDecodeValue(forKey: .statusTitle)
        self.refresh = container.safeDecodeValue(forKey: .refresh)
        self.access = container.safeDecodeValue(forKey: .access)
        self.role = container.safeDecodeValue(forKey: .role)
        self.username = container.safeDecodeValue(forKey: .username)
        self.fullName = container.safeDecodeValue(forKey: .fullName)
        self.image = container.safeDecodeValue(forKey: .image)
        self.address = container.safeDecodeValue(forKey: .address)
    }
    init () {
        self.statusCode = 0
        self.statusMessage = ""
        self.statusTitle = ""
        self.refresh = ""
        self.access = ""
        self.role = ""
        self.username = ""
        self.fullName = ""
        self.image = ""
        self.address = ""
    }
}
struct OTPVerificationModel: Codable {
    let statusCode: Int
    let statusMessage, statusTitle, access, refresh: String
    let loan: Loan

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case statusTitle = "status_title"
        case access, refresh, loan
    }
}

// MARK: - Loan
struct Loan: Codable {
    let id: String
    let loanStatus: CurrentStatusModel
    let createdOn: String
    let expectedCompletionDate: String

    enum CodingKeys: String, CodingKey {
        case id
        case loanStatus = "loan_status"
        case createdOn = "created_on"
        case expectedCompletionDate = "expected_completion_date"
    }
}
struct CurrentStatusModel: Codable {
    let currentStatus: String

    enum CodingKeys: String, CodingKey {
        case currentStatus = "current_status"
    }
}
class DocumentModel : Codable {
    var isSelected : Bool
    var type : String
    var fileName : String
    var fileSize : String
    var fileString : String
    var apiKey : String
    var fileData : Data?
    var fileType : String
    var mimeType : String
    var fileURL : String
    enum CodingKeys: String, CodingKey {
        case isSelected
        case type,fileName,fileSize,fileString,fileData,apiKey,fileType,mimeType,fileURL
    }
    
    init() {
        self.isSelected = false
        self.fileName = ""
        self.fileSize = ""
        self.type = ""
        self.fileString = ""
        self.apiKey = ""
        self.mimeType = ""
        self.fileType = ""
        self.fileURL = ""
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isSelected = container.safeDecodeValue(forKey: .isSelected)
        self.fileName = container.safeDecodeValue(forKey: .fileName)
        self.fileSize = container.safeDecodeValue(forKey: .fileSize)
        self.type = container.safeDecodeValue(forKey: .type)
        self.fileString = container.safeDecodeValue(forKey: .fileString)
        self.apiKey = container.safeDecodeValue(forKey: .apiKey)
        self.mimeType = container.safeDecodeValue(forKey: .mimeType)
        self.fileType = container.safeDecodeValue(forKey: .fileType)
        self.fileURL = container.safeDecodeValue(forKey: .fileURL)
    }
}
struct Director {
    let id : Int
    var title, firstName, lastName, phoneNumber: String
    var email, ownsOtherProperty: String
    var ownedProperty: [OwnedProperty]
    var ownedPropertyCount: Int
    var stay: [StayModel]

    var dictionaryRepresentation: [String: Any] {
        if id > 0 {
            return [
                "id" : id,
                "title": title,
                "first_name": firstName,
                "last_name": lastName,
                "phone_number": phoneNumber,
                "email": email,
                "owns_other_property": ownsOtherProperty,
                "stay": stay.map { $0.dictionaryRepresentation },
                "owned_property": ownedProperty.map { $0.dictionaryRepresentation },
                "owned_property_count": ownedPropertyCount
            ]
        }else{
            return [
                "title": title,
                "first_name": firstName,
                "last_name": lastName,
                "phone_number": phoneNumber,
                "email": email,
                "owns_other_property": ownsOtherProperty,
                "stay": stay.map { $0.dictionaryRepresentation },
                "owned_property": ownedProperty,
                "owned_property_count": ownedPropertyCount
            ]
        }
        
    }
}
struct Stay {
    let pincode: String
    let address: String
    let houseOwnership: String
    let startDate: String
    let endDate: String

    var dictionaryRepresentation: [String: String] {
        return [
            "pincode": pincode,
            "address": address,
            "house_ownership": houseOwnership,
            "start_date": startDate,
            "end_date": endDate
        ]
    }
}
struct Property {
    let pincode: String
    let address: String
    var dictionaryRepresentation: [String: String] {
        return [
            "pincode": pincode,
            "address": address
        ]
    }
}
struct UploadDocumentModel {
    let data: Data
    let fileName: String
    let mimeType: String
    let fileType: String
}
