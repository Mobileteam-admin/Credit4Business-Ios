//
//  ConsentViewController.swift
//  Credit4Business
//
//  Created by MacMini on 14/03/24.
//

import UIKit
import StepProgressBar
import Alamofire

class ConsentViewController: UIViewController {

    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var firstConsentOption1: UIView!
    @IBOutlet weak var firstConsentOption1Image: UIImageView!
    @IBOutlet weak var firstConsentOption2: UIView!
    @IBOutlet weak var firstConsentOption2Image: UIImageView!
    @IBOutlet weak var firstConsentOption3: UIView!
    @IBOutlet weak var firstConsentOption3Image: UIImageView!
    @IBOutlet weak var firstConsentOption4: UIView!
    @IBOutlet weak var firstConsentOption4Image: UIImageView!
    @IBOutlet weak var firstConsentOption5: UIView!
    @IBOutlet weak var firstConsentOption5Image: UIImageView!

    @IBOutlet weak var firstConsentErrStack: UIStackView!
    @IBOutlet weak var firstConsentErrLabel: UILabel!
    
    @IBOutlet weak var secondConsentOption1: UIView!
    @IBOutlet weak var secondConsentOption1Image: UIImageView!
    @IBOutlet weak var secondConsentOption2: UIView!
    @IBOutlet weak var secondConsentOption2Image: UIImageView!
    @IBOutlet weak var secondConsentOption3: UIView!
    @IBOutlet weak var secondConsentOption3Image: UIImageView!
    @IBOutlet weak var secondConsentOption4: UIView!
    @IBOutlet weak var secondConsentOption4Image: UIImageView!
    @IBOutlet weak var secondConsentOption5: UIView!
    @IBOutlet weak var secondConsentOption5Image: UIImageView!

    @IBOutlet weak var secondConsentErrStack: UIStackView!
    @IBOutlet weak var secondConsentErrLabel: UILabel!

    @IBOutlet weak var thirdConsentOption1: UIView!
    @IBOutlet weak var thirdConsentOption1Image: UIImageView!
    @IBOutlet weak var thirdConsentOption2: UIView!
    @IBOutlet weak var thirdConsentOption2Image: UIImageView!
    @IBOutlet weak var thirdConsentOption3: UIView!
    @IBOutlet weak var thirdConsentOption3Image: UIImageView!
    @IBOutlet weak var thirdConsentOption4: UIView!
    @IBOutlet weak var thirdConsentOption4Image: UIImageView!
    @IBOutlet weak var thirdConsentOption5: UIView!
    @IBOutlet weak var thirdConsentOption5Image: UIImageView!
    
    @IBOutlet weak var thirdConsentErrStack: UIStackView!
    @IBOutlet weak var thirdConsentErrLabel: UILabel!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var commentButton: UIImageView!

    //MARK: -------------------- Class Variable --------------------

    var viewModel = HomeVM()
    var consent1Array = [String]()
    var consent2Array = [String]()
    var consent3Array = [String]()
    var selectedConsentResponse : DataClass?
    var customerId = ""
    var delegate : CellDelegate?
    var loanId = ""
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manageActionMethods()
        self.pageControl.numberOfPages = 9
        self.setPagNumber(currentPage: 4)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.selectedConsentResponse != nil {
            self.showModelValues()
        }
        if UserDefaults.standard.value(forKey: "role") as? String != "" && isFromIncomplete {
            self.fetchConsentDetails()
        }

    }
    func setPagNumber(currentPage : Int) {
        self.pageControl.currentPage = currentPage
    }
   //---------------------------------------
   // MARK: - Init With Story
   //---------------------------------------

    class func initWithStory(loanId: String) -> ConsentViewController {
       let vc : ConsentViewController = UIStoryboard.Main.instantiateViewController()
        vc.loanId = loanId
       return vc
   }
    func getOptionDescription(val: Int) -> String {
        var description = ""
        switch val{
        case 1:
            description = "Email"
        case 2:
            description = "Post"
        case 3:
            description = "SMS"
        case 4:
            description = "Social Media"
        case 5:
            description = "Telephone"
        default: break
        }
        return description
    }
    func changeImage(image: UIImageView,consentVal: Int,optionVal: Int){
        var optionalDescription = self.getOptionDescription(val: optionVal)
        switch consentVal{
        case 1:
            if self.consent1Array.contains(optionalDescription){
                if let itemToRemoveIndex = consent1Array.firstIndex(of: optionalDescription) {
                    consent1Array.remove(at: itemToRemoveIndex)
                    image.image = UIImage.init(named: "checkboxUnselected")
                }
            }else{
                self.consent1Array.append(optionalDescription)
                image.image = UIImage.init(named: "checkboxSelected")

            }
        case 2:
            if self.consent2Array.contains(optionalDescription){
                if let itemToRemoveIndex = consent2Array.firstIndex(of: optionalDescription) {
                    consent2Array.remove(at: itemToRemoveIndex)
                    image.image = UIImage.init(named: "checkboxUnselected")
                }
            }else{
                self.consent2Array.append(optionalDescription)
                image.image = UIImage.init(named: "checkboxSelected")

            }
        case 3:
            if self.consent3Array.contains(optionalDescription){
                if let itemToRemoveIndex = consent3Array.firstIndex(of: optionalDescription) {
                    consent3Array.remove(at: itemToRemoveIndex)
                    image.image = UIImage.init(named: "checkboxUnselected")
                }
            }else{
                self.consent3Array.append(optionalDescription)
                image.image = UIImage.init(named: "checkboxSelected")

            }
        default: break
        }
    }
    func manageActionMethods() {
        self.commentButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanId)
            vc.isRemarks = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.firstConsentOption1.addTapGestureRecognizer {
            self.changeImage(image: self.firstConsentOption1Image, consentVal: 1, optionVal: 1)
        }
        self.firstConsentOption2.addTapGestureRecognizer {
            self.changeImage(image: self.firstConsentOption2Image, consentVal: 1, optionVal: 2)
        }
        self.firstConsentOption3.addTapGestureRecognizer {
            self.changeImage(image: self.firstConsentOption3Image, consentVal: 1, optionVal: 3)
        }
        self.firstConsentOption4.addTapGestureRecognizer {
            self.changeImage(image: self.firstConsentOption4Image, consentVal: 1, optionVal: 4)
        }
        self.firstConsentOption5.addTapGestureRecognizer {
            self.changeImage(image: self.firstConsentOption5Image, consentVal: 1, optionVal: 5)
        }
        
        
        self.secondConsentOption1.addTapGestureRecognizer {
            self.changeImage(image: self.secondConsentOption1Image, consentVal: 2, optionVal: 1)
        }
        self.secondConsentOption2.addTapGestureRecognizer {
            self.changeImage(image: self.secondConsentOption2Image, consentVal: 2, optionVal: 2)
        }
        self.secondConsentOption3.addTapGestureRecognizer {
            self.changeImage(image: self.secondConsentOption3Image, consentVal: 2, optionVal: 3)
        }
        self.secondConsentOption4.addTapGestureRecognizer {
            self.changeImage(image: self.secondConsentOption4Image, consentVal: 2, optionVal: 4)
        }
        self.secondConsentOption5.addTapGestureRecognizer {
            self.changeImage(image: self.secondConsentOption5Image, consentVal: 2, optionVal: 5)
        }
        self.thirdConsentOption1.addTapGestureRecognizer {
            self.changeImage(image: self.thirdConsentOption1Image, consentVal: 3, optionVal: 1)
        }
        self.thirdConsentOption2.addTapGestureRecognizer {
            self.changeImage(image: self.thirdConsentOption2Image, consentVal: 3, optionVal: 2)
        }
        self.thirdConsentOption3.addTapGestureRecognizer {
            self.changeImage(image: self.thirdConsentOption3Image, consentVal: 3, optionVal: 3)
        }
        self.thirdConsentOption4.addTapGestureRecognizer {
            self.changeImage(image: self.thirdConsentOption4Image, consentVal: 3, optionVal: 4)
        }
        self.thirdConsentOption5.addTapGestureRecognizer {
            self.changeImage(image: self.thirdConsentOption5Image, consentVal: 3, optionVal: 5)
        }
        self.nextButton.addTapGestureRecognizer {
            self.checkLoanStatus(loanId: self.loanId)
            if (canEditForms && GlobalmodeOfApplication != .Representative) || self.delegate != nil {
                    self.updateModel()
                }else{
                    var vc = DocumentUploadViewController.initWithStory(loanId: self.loanId)
                self.navigationController?.pushViewController(vc, animated: true)
     
                }
        }
        self.skipButton.addTapGestureRecognizer {
            //self.updateModel()
            if self.delegate != nil {
                            self.delegate?.reload()
                            self.dismiss(animated: true)
                        }else {
                            var vc = DocumentUploadViewController.initWithStory(loanId: self.loanId)
                            self.navigationController?.pushViewController(vc, animated: true)

                        }
        }
        self.backButton.addTapGestureRecognizer {
            var model = GlobalFundingModelObject.business
            if model.remainingDirectorArray.count == 0 {
                if model.orderArray.count > 0 {
                    var index = model.orderArray.last
                    model.orderArray.removeLast()
                    var obj = model.directorArray.filter({$0.id == index}).first as! SelectedDirector
                    model.remainingDirectorArray.append(obj)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    func showModelValues() {
        var consent1 = self.selectedConsentResponse?.receivingMarketingInfo
        if consent1?.email == true {
            self.consent1Array.append("Email")
            self.firstConsentOption1Image.image = UIImage.init(named: "checkboxSelected")
        }
        if consent1?.post == true {
            self.consent1Array.append("Post")
            self.firstConsentOption2Image.image = UIImage.init(named: "checkboxSelected")
        }
        if consent1?.sms == true {
            self.consent1Array.append("SMS")
            self.firstConsentOption3Image.image = UIImage.init(named: "checkboxSelected")
        }
        if consent1?.socialMedia == true {
            self.consent1Array.append("Social Media")
            self.firstConsentOption4Image.image = UIImage.init(named: "checkboxSelected")

        }
        if consent1?.telephone == true {
            self.consent1Array.append("Telephone")
            self.firstConsentOption5Image.image = UIImage.init(named: "checkboxSelected")

        }
        var consent2 = self.selectedConsentResponse?.sendingMarketingInformation
        if consent2?.email == true {
            self.consent2Array.append("Email")
            self.secondConsentOption1Image.image = UIImage.init(named: "checkboxSelected")
        }
        if consent2?.post == true {
            self.consent2Array.append("Post")
            self.secondConsentOption2Image.image = UIImage.init(named: "checkboxSelected")
        }
        if consent2?.sms == true {
            self.consent2Array.append("SMS")
            self.secondConsentOption3Image.image = UIImage.init(named: "checkboxSelected")
        }
        if consent2?.socialMedia == true {
            self.consent2Array.append("Social Media")
            self.secondConsentOption4Image.image = UIImage.init(named: "checkboxSelected")

        }
        if consent2?.telephone == true {
            self.consent2Array.append("Telephone")
            self.secondConsentOption5Image.image = UIImage.init(named: "checkboxSelected")

        }
        var consent3 = self.selectedConsentResponse?.thirdPartySharing
        if consent3?.email == true {
            self.consent3Array.append("Email")
            self.thirdConsentOption1Image.image = UIImage.init(named: "checkboxSelected")
        }
        if consent3?.post == true {
            self.consent3Array.append("Post")
            self.thirdConsentOption2Image.image = UIImage.init(named: "checkboxSelected")
        }
        if consent3?.sms == true {
            self.consent3Array.append("SMS")
            self.thirdConsentOption3Image.image = UIImage.init(named: "checkboxSelected")
        }
        if consent3?.socialMedia == true {
            self.consent3Array.append("Social Media")
            self.thirdConsentOption4Image.image = UIImage.init(named: "checkboxSelected")

        }
        if consent3?.telephone == true {
            self.consent3Array.append("Telephone")
            self.thirdConsentOption5Image.image = UIImage.init(named: "checkboxSelected")

        }
    }
    func fetchConsentDetails() {
        APIService.shared.retrieveConsentFormDetails(loanId: self.loanId) { result in
            //AppLoader.shared.removeLoader()
            switch result {
            case .success(let data):
                //                    print(data)
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedConsentResponse = responseData
                        self.showModelValues()
//                            let productTypeDetails = profileMasterList.objProfileList
//                            if productTypeDetails.count > 0 {
//                                let encoder = JSONEncoder()
//                                if let encoded = try? encoder.encode(productTypeDetails) {
//                                    UserDefaults.standard.setValue(encoded, forKey: "ProductTypes")
//                                }
//                            }
                    }
                    catch {
                        
                    }
                }
                else {
                    //self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
                //self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func updateConsentDetails(json: JSON) {
        APIService.shared.updateConsentDetailsApi(endpoint: APIEnums.createConsent.rawValue,
                                      withLoader: true,
                                      method: .patch,
                                      params: json) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode.description.toInt() == 200 {
                    let responseData = data.data
                    self.selectedConsentResponse = responseData
                    self.showModelValues()
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }
    }
    func updateModel() {
        let model = GlobalFundingModelObject
        var initial = MarketingModel()
        initial.related = self.consent1Array
        initial.unrelated = self.consent2Array
        initial.thirdParty = self.consent3Array
       
        model.consents = initial
        var wholeDict = JSON()
        var dict1 = JSON()
        dict1["email"] = self.consent1Array.contains("Email")
        dict1["post"] = self.consent1Array.contains("Post")
        dict1["sms"] = self.consent1Array.contains("SMS")
        dict1["social_media"] = self.consent1Array.contains("Social Media")
        dict1["telephone"] = self.consent1Array.contains("Telephone")
        var result1 = self.encodeAnyDict(dictionary: dict1)

        wholeDict["receiving_marketing_info"] = dict1
        
        var dict2 = JSON()
        dict2["email"] = self.consent2Array.contains("Email")
        dict2["post"] = self.consent2Array.contains("Post")
        dict2["sms"] = self.consent2Array.contains("SMS")
        dict2["social_media"] = self.consent2Array.contains("Social Media")
        dict2["telephone"] = self.consent2Array.contains("Telephone")
        var result2 = self.encodeAnyDict(dictionary: dict2)

        wholeDict["sending_marketing_information"] = dict2
        
        var dict3 = JSON()
        dict3["email"] = self.consent3Array.contains("Email")
        dict3["post"] = self.consent3Array.contains("Post")
        dict3["sms"] = self.consent3Array.contains("SMS")
        dict3["social_media"] = self.consent3Array.contains("Social Media")
        dict3["telephone"] = self.consent3Array.contains("Telephone")
        var result3 = self.encodeAnyDict(dictionary: dict3)

        wholeDict["third_party_sharing"] = dict3

//        self.callConsentAPI(parms: wholeDict)
        print(wholeDict)
//        if self.selectedConsentResponse != nil {
//            updateConsentDetails(json: wholeDict)
//        }else{
            createConsentDetails(json: wholeDict)
//        }

    }
    func tokenRefreshApi(params: JSON) {
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

                    self.createConsentDetails(json: params)
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }

    }
    func updateFilledForms(){
        var params = JSON()
        params["complete_marketing_preference"] = "True"
        var url = APIEnums.updateFilledForms.rawValue
        if loanId != "" {
            url = url + "\(loanId)/"
        }
      
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                }
                else if data.statusCode == 401 {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }
    }
    func createConsentDetails(json: JSON) {
        var url = APIEnums.createConsent.rawValue
        if customerId != "" {
            url = url + "?customer_id=\(customerId)"
        }
        if loanId != "" {
            url = url + "\(loanId)/"
        }
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: json) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.updateFilledForms()
                    if self.delegate != nil {
                        self.delegate?.reload()
                        self.dismiss(animated: true)
                    }else{
                        var vc = DocumentUploadViewController.initWithStory(loanId: self.loanId)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(params: json)
                }
                else {
//                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
//                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }
    }
    func encodeAnyDict(dictionary: [String: Any?]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error encoding dictionary to JSON string: \(error)")
        }
        return nil
    }
    //---------------------------------------
    // MARK: - WS Function
    //---------------------------------------
    
    func callConsentAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .ConsentApicall(parms: parms){(result) in
                switch result{
                case .success:
                var vc = DocumentUploadViewController.initWithStory(loanId: self.loanId)
                self.navigationController?.pushViewController(vc, animated: true)

                case .failure(let error):
                    break
                }
            }
    }
}
