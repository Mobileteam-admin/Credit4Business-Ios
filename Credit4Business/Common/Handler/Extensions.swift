//
//  Extensions.swift
//  Credit4Business
//
//  Created by MacMini on 04/03/24.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import Photos
import MobileCoreServices

//MARK:- Extensions
protocol ReusableView: AnyObject {}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
  
}


// UIViewController.swift
extension UIViewController: ReusableView { }

// UIStoryboard.swift
extension UIStoryboard {
    
    static var Main : UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    static var Login : UIStoryboard{
        return UIStoryboard(name: "Login", bundle: nil)
    }
    
    /**
     initialte viewController with identifier as class name
     - Author: Yamini
     - Returns: ViewController
     - Warning: Only ViewController which has identifier equal to class should be parsed
     */
    func instantiateViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier) as! T
    }
    /**
     initialte viewController with identifier as class name and suffix("ID")
     - Author: Yamini
     - Returns: ViewController
     - Warning: Only ViewController with "ID" in suffix should be parsed
     */
    func instantiateIDViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier + "ID") as! T
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionViewCell: ReusableView {}
extension UITableView{
    
    /**
    Registers UITableViewCell with identifier and nibName as class name
    - Author: Yamini
    - Parameters:
       - cell: the Cell class instance to be registered
    - Warning: Only UITableViewCell which has identifier equal to class should be parsed
    */
    func registerNib(forCell cell : ReusableView.Type){
        
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
        
        self.register(nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
  
    /**
     initialte UITableViewCell with identifier as class name
     - Author: Yamini
     - Returns: ReusableView(UITableViewCell)
     - Warning: Only UITableViewCell which has identifier equal to class should be parsed
     */
    func dequeueReusableCell<T>(for index : IndexPath) -> T where T : ReusableView{
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: index) as! T
    }
}

extension UICollectionView{
    /**
     Registers UICollectionViewCell with identifier and nibName as class name
     - Author: Yamini
     - Parameters:
        - cell: the Cell class instance to be registered
     - Warning: Only UICollectionViewCell which has identifier equal to class should be parsed
     */
    func registerNib(forCell cell : ReusableView.Type){
         
         let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
         
        self.register(nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
     }
    /**
     initialte UICollectionViewCell with identifier as class name
     - Author: Yamini
     - Returns: ReusableView(UITableViewCell)
     - Warning: Only UICollectionViewCell which has identifier equal to class should be parsed
     */
    func dequeueReusableCell<T>(for index : IndexPath) -> T where T : ReusableView{
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: index) as! T
    }
}
extension UIView {
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleTapGesture() {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    func currentFirstResponder() -> UIResponder? {
        
        if self.isFirstResponder {
            
            return self
        }
        
        for view in self.subviews {
            if let responder  = view.currentFirstResponder() {
                return responder
            }
        }
        return nil;
    }

}
extension Array{
    
    var isNotEmpty : Bool{
        return !self.isEmpty
    }
    
    func value(atSafe index : Int) -> Element?{
        guard self.indices.contains(index) else {return nil}
        return self[index]
    }
    func find(includedElement: @escaping ((Element) -> Bool)) -> Int? {
        for arg in self.enumerated(){
            let (index,item) = arg
            if includedElement(item) {
                return index
            }
        }
        
        return nil
    }
}
extension UIScrollView {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 11, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    
    // MARK: - Class Variables
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    
    func scrollToBottom(animated: Bool = true) {
        if self.contentSize.height < self.bounds.size.height { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
            self.setContentOffset(bottomOffset, animated: animated)
        }
    }
    
    func scrollToRight(animated: Bool) {
            if contentSize.width < bounds.size.width { return }
            let bottomOffset = CGPoint(x: contentSize.width - bounds.size.width, y: .zero)
            self.setContentOffset(bottomOffset, animated: animated)
    }
    
    func scrollToLeft(animated: Bool) {
            self.setContentOffset(.zero, animated: true)
    }
}
extension String {
    enum ValidationType: String {
        case alphabet = "[A-Za-z]+"
        case alphabetWithSpace = "[A-Za-z ]*"
        case alphabetNum = "[A-Za-z-0-9]*"
        case alphabetNumWithSpace = "[A-Za-z0-9 ]*"
        case userName = "[A-Za-z0-9 _]*"
        case name = "^[A-Z a-z]*$"
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        case number = "[0-9]+"
        case password = "^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$"
        case mobileNumber = "^[0-9]{8,11}$"
        case postalCode = "^[A-Za-z0-9- ]{1,10}$"
        case zipcode = "^[A-Za-z0-9]{4,}$"
        case currency = "^([0-9]+)(\\.([0-9]{0,2})?)?$"
        case amount = "^\\s*(?=.*[1-9])\\d*(?:\\.\\d{1,2})?\\s*$"
        case website = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    }
    
    func isValid(_ type: ValidationType) -> Bool {
        guard !isEmpty else { return false }
        let regTest = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        return regTest.evaluate(with: self)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func fullTrim() -> String {
        return self.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
    }
    var digits: String {
        return String(filter(("0"..."9").contains))
    }
    
    
    func removeCountryCodePrefix() -> String {
        var cleanedPhoneNumber = self
        
        // Check if the phone number starts with "+91"
        if self.hasPrefix("+91") {
            // Remove the "+91" prefix
            let index = self.index(self.startIndex, offsetBy: 3)
            cleanedPhoneNumber = String(self[index...])
        }
        
        return cleanedPhoneNumber
    }
    
    //Mobile number validation
    func isValidPhone() -> Bool {
        let phoneRegex = Validations.RegexType.validMobileNumber.rawValue
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    //Fake Mobile number validation
    func isFakeNumber() -> Bool {
        let phoneRegex = Validations.RegexType.fakeMobileNumber.rawValue
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    //Dummy Mobile number validation
    func isDummyNumber() -> Bool {
        let phoneRegex = Validations.RegexType.dummyMobileNumber.rawValue
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self.prefix(1))
    }
    
    //Name_validation
    func validateName() -> Bool {
        let REGEX: String
        REGEX = Validations.RegexType.nameValidation.rawValue
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
    }
    func toInt()->Int{
        
        return (self as NSString).integerValue
    }
    func toFloat()->Float{
        
        return (self as NSString).floatValue
    }
}
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius  }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderColor: UIColor {
        get { self.borderColor }
        set { self.layer.borderColor = newValue.cgColor }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { self.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { self.shadowRadius }
        set { self.layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { self.shadowOffset }
        set { self.layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get { self.shadowColor }
        set { self.layer.shadowColor = newValue.cgColor }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { self.shadowOpacity }
        set { self.layer.shadowOpacity = newValue }
    }
    var isClippedCorner : Bool{
        get{
            return self.layer.cornerRadius != 0
        }
        set(newValue){
            if newValue{
                self.clipsToBounds = true
                self.layer.cornerRadius = self.frame.height * (8/100)
            }else{
                self.layer.cornerRadius = 0
            }
        }
    }
    func dropShadow(scale: Bool = true, opacity: Float = 0.3) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension UIViewController{
    func convertDateFormat(inputDate: String,outputFormat: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = outputFormat//"dd-mm-yyyy h:mm a"

         return convertDateFormatter.string(from: oldDate!)
    }
    func isValidEmail(testStr:String)           -> Bool {
        let emailRegEx  = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"//"^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,4})$"
        let emailTest   = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result  = emailTest.evaluate(with: testStr)
        return result
    }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true)
    }
    func showAlert(title: String, message: String, options: String..., completion: ((String) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion?(options[index])
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    func sizePerMB(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    func sizePerKB(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    func mimeTypeForPath(fileType: String) -> String{
        var mimetype = ""
        // get the mime type from the uti which is coming from attachment types in the api response.
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,fileType as CFString, nil)?.takeRetainedValue() {
            mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() as! String
                return mimetype as String
        }
        else{
            return mimetype
        }
    }
    func getQueryItems(_ urlString: String) -> [String : String] {
           var queryItems: [String : String] = [:]
           let components: NSURLComponents? = getURLComonents(urlString)
           for item in components?.queryItems ?? [] {
               queryItems[item.name] = item.value?.removingPercentEncoding
           }
           return queryItems
       }
    func getURLComonents(_ urlString: String?) -> NSURLComponents? {
            var components: NSURLComponents? = nil
            let linkUrl = URL(string: urlString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
            if let linkUrl = linkUrl {
                components = NSURLComponents(url: linkUrl, resolvingAgainstBaseURL: true)
            }
            return components
        }
    func convertDateFormater(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as? TimeZone

        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as? TimeZone
        let timeStamp = dateFormatter.string(from: date)

        return timeStamp
    }
    func convertDateFormaterForDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as? TimeZone

        guard let date = dateFormatter.date(from: date) else {
            return nil
        }

//        dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as? TimeZone
//        let timeStamp = dateFormatter.string(from: date)

        return date
    }
    func fetchLoanIdStatus(loanId: String) -> (String,String) {
        if globalLoanModel != nil {
            if globalLoanModel?.data.count != 0 {
                for element in globalLoanModel!.data {
                    if element.id == loanId {
                        var model = element.customer.loanDetails.filter({$0.loanID == loanId}).first

                        return (model?.currentStatus ?? "",model?.upcomingStatus ?? "")
                    }
                }
            }
        }
        return ("","")
    }
    func checkLoanStatus(loanId: String) {
        if globalLoanModel != nil {
            if globalLoanModel?.data.count != 0 {
                for element in globalLoanModel!.data {
                    if element.id == loanId {
                        var model = element.customer.loanDetails.filter({$0.loanID == loanId}).first
                        if model?.currentStatus.lowercased() == "inprogress" && (model?.upcomingStatus.lowercased() == "submission_waiting" || model?.upcomingStatus == "Gocardless_Consent_Waiting") {
                            canEditForms = true
                        }else{
                            canEditForms = false
                        }
                    }
                }
            }
        }

    }
}
class RectangularDashedView: UIView {
    
    @IBInspectable var cornerRadius2: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius2
            layer.masksToBounds = cornerRadius2 > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius2).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
class RectangularDashedView2: UIStackView {
    
    @IBInspectable var cornerRadius2: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius2
            layer.masksToBounds = cornerRadius2 > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius2).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
struct Utilities {
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}
