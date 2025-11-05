//
//  ProfileCollectionViewCell.swift
//  Credit4Business
//
//  Created by MacMini on 17/04/24.
//

import UIKit
import PDFKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}
class PaymentHistoryCell: UITableViewCell {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    @IBOutlet weak var innerTableHeight: NSLayoutConstraint!
    @IBOutlet weak var innerTable: UITableView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var imageActionView: UIView!
    
    @IBOutlet weak var downloadStatementBtn: UIButton!
    @IBOutlet weak var outerView: UIStackView!
    var isDirector = false
    var directorModel = [MenuModel]()
    var innerTableHidden = true
    var viewModel = HomeVM()
    var model = [FundingPaymentHistory]()
    var delegate : CellDelegate!
    var isExtended = false
    var statmentModel: StatementDataClass?
    var controllerObj = ProfileDetailsVC()
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDelegates()
        self.updateUI()
    }
    
    @IBAction func downloadStatementAction(_ sender: Any) {
        var pdfdata = self.generatePDFData()
        self.savePDFToDocumentsDirectory(pdfData: pdfdata ?? Data(), fileName: "\(self.statmentModel?.companyName ?? "")".replacingOccurrences(of: " ", with: "_") + "_Statement.pdf")

    }
    func generatePDFData() -> Data? {
        let pageSize = CGSize(width: 612, height: 792) // Standard Letter size
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))

        
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        let contentWidth = pageWidth - 2 * margin
        let rowHeight: CGFloat = 40
        let columnWidths: [CGFloat] = [contentWidth * 0.3, contentWidth * 0.7]

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
 
        let pdfData = renderer.pdfData { context in
            context.beginPage()

            // Draw content on the page
//            let text = "This is a sample PDF generated without preview."
//            let font = UIFont.systemFont(ofSize: 18)
//            let attributes: [NSAttributedString.Key: Any] = [.font: font]
//            text.draw(at: CGPoint(x: 50, y: 50), withAttributes: attributes)

            // Add more content as needed (images, shapes, etc.)
            /*
            let initialCursor: CGFloat = 32

            var cursor = context.addCenteredText(fontSize: 32, weight: .bold, text: "Cocktail Menu 🍹", cursor: initialCursor, pdfSize: pageSize)

            cursor+=42 // Add white space after the Title
            let leftMargin: CGFloat = 74
            cursor = context.addSingleLineText(fontSize: 12, weight: .thin, text: " • hiiiii", indent: leftMargin, cursor: cursor, pdfSize: pageSize, annotation: nil, annotationColor: nil)
            cursor+=2
            cursor+=8
             */
            
            /*
            let cgContext = context.cgContext

                       // Define your column widths and row heights
                       let columnWidths: [CGFloat] = [300, 150, 120, 80] // Example widths
                       let rowHeight: CGFloat = 30

                       // Define your data (e.g., a 2D array of strings)
                       let spreadsheetData = [
                           ["Contract No", "10001000110002"],
                           ["Row 1, Col 1", "Row 1, Col 2", "Row 1, Col 3", "Row 1, Col 4"],
                           ["Row 2, Col 1", "Row 2, Col 2", "Row 2, Col 3", "Row 2, Col 4"]
                       ]

                       var currentY: CGFloat = 50 // Starting Y position for the table

                       // Draw headers and rows
                       for (rowIndex, rowData) in spreadsheetData.enumerated() {
                           var currentX: CGFloat = 50 // Starting X position for the table

                           for (colIndex, cellText) in rowData.enumerated() {
                               let cellRect = CGRect(x: currentX, y: currentY, width: columnWidths[colIndex], height: rowHeight)

                               // Draw cell borders
                               cgContext.stroke(cellRect)

                               // Draw text
                               let paragraphStyle = NSMutableParagraphStyle()
                               paragraphStyle.alignment = .center // Example alignment
                               let attributes: [NSAttributedString.Key: Any] = [
                                   .font: UIFont.systemFont(ofSize: 12),
                                   .paragraphStyle: paragraphStyle
                               ]
                               let attributedString = NSAttributedString(string: cellText, attributes: attributes)
                               attributedString.draw(in: cellRect.insetBy(dx: 5, dy: 5)) // Inset for padding

                               currentX += columnWidths[colIndex]
                           }
                           currentY += rowHeight
                       }
                   */
            
//            let data = [
//                ["JD MARGATE EXPRESS LTD"],
//                ["Contract No", "CAP4B 00123/032025",""],
//                ["Advance Amount", "£25,000","Payback Amount", "£31,000"],
//                ["Repayment Terms"],
//                ["Start Date", "20/03/2025","","End Date","31/07/2025"],
//                ["Weekly Repayment Amount","£1,550"],
//                ["No of Weekly Instalments","1"],
//                ["Instalment Amount", "£1,550"],
//                ["Weekly Repayment Day(s)","Thursday"]
//            ]
            if let model = self.statmentModel {
                
                
                let data = [
                    [model.companyName ?? ""],
                    ["Contract No", "---",""],
                    ["Advance Amount", "£" + "\(model.advanceAmount.description ?? "")","Payback Amount", "£" + "\(model.paybackAmount.description ?? "")"],
                    ["Repayment Terms"],
                    ["Start Date", model.startDate ?? "","","End Date",model.endDate ?? ""],
                    ["Weekly Repayment Amount","£" + "\(model.weeklyRepaymentAmount.description ?? "")"],
                    ["No of Weekly Instalments",model.noOfWeeklyInstallments.description ?? ""],
                    ["Instalment Amount", "£" + "\(model.installmentAmount.description ?? "")"],
                    ["Weekly Repayment Day(s)",model.weeklyRepaymentDays.joined(separator: ",") ?? ""]
                ]
                let tablewidth = [
                    [contentWidth],
                    [contentWidth * 0.25, contentWidth * 0.40,contentWidth * 0.35],
                    [contentWidth * 0.25, contentWidth * 0.2,contentWidth * 0.2,contentWidth * 0.35],
                    [contentWidth],
                    [contentWidth * 0.25, contentWidth * 0.2,contentWidth * 0.2,contentWidth * 0.175,contentWidth * 0.175],
                    [contentWidth * 0.45,contentWidth * 0.2],
                    [contentWidth * 0.45,contentWidth * 0.2],
                    [contentWidth * 0.45,contentWidth * 0.2],
                    [contentWidth * 0.45,contentWidth * 0.55]
                ]
                var currentY: CGFloat = margin
                
                // Draw header
                // drawHeaderRow(at: CGPoint(x: margin, y: currentY), columnWidths: columnWidths, context: context.cgContext)
                //  currentY += rowHeight
                
                // Draw data rows
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"//DateTimeFormaterEnum.ddMMMyyyy.rawValue
                let fromDateString = dateFormatter.string(from: Date())
                let text = "Date : \(fromDateString)"
                let font = UIFont.systemFont(ofSize: 14)
                let attributes: [NSAttributedString.Key: Any] = [.font: font]
                text.draw(at: CGPoint(x: pageWidth - 150, y: currentY), withAttributes: attributes)
                currentY += 15

                let imageRect = CGRect(x: pageWidth / 2 - 100, y: currentY,
                                        width: 200, height: 100)
                var image = UIImage(named: "AppLogo")
                image?.draw(in: imageRect)
                
                currentY += 120
                
                var first = CGFloat()
                var last = CGFloat()
                for (index,rowData) in data.enumerated() {
                    if currentY + rowHeight > pageHeight - margin {
                        context.beginPage()
                        currentY = margin
                        //   drawHeaderRow(at: CGPoint(x: margin, y: currentY), columnWidths: columnWidths, context: context.cgContext)
                        // currentY += rowHeight
                    }
                    drawDataRow(rowData: rowData, at: CGPoint(x: margin, y: currentY), columnWidths: tablewidth[index], context: context.cgContext)
                    if index == 0 {
                        first = currentY
                    }else {
                        last = currentY
                    }

                    currentY += rowHeight
                    

                }
                let cellRect = CGRect(x: margin, y: 185, width: contentWidth, height: last - first)
//                var width = rowData.count == 1 ? contentWidth : 150
//                let cellRect = CGRect(x: currentX, y: origin.y, width: CGFloat(width), height: rowHeight)

                context.cgContext.stroke(cellRect) // Draw cell border

                currentY += rowHeight * 2
                
                let statementData = [
                    ["","Date","Day","Narration","Debit","Credit","Balance"],
                    ["1","13/03/2025", "Thursday","Advance","£25,000","£25,000","£25,000"],
                    ["1","13/03/2025", "Thursday","Advance","£25,000","£25,000","£25,000"],
                    ["1","13/03/2025", "Thursday","Advance","£25,000","£25,000","£25,000"],
                    ["1","13/03/2025", "Thursday","Advance","£25,000","£25,000","£25,000"],
                    ["1","13/03/2025", "Thursday","Advance","£25,000","£25,000","£25,000"],
                    ["1","13/03/2025", "Thursday","Advance","£25,000","£25,000","£25,000"],
                    ["1","13/03/2025", "Thursday","Advance","£25,000","£25,000","£25,000"]
                ]
                var statementInnerModel = [[String]]()
                var arr = [String]()
                arr.append("")
                arr.append("Date")
                arr.append("Day")
                arr.append("Narration")
                arr.append("Debit")
                arr.append("Credit")
                arr.append("Balance")
                statementInnerModel.append(arr)
                for (index,item) in self.statmentModel!.statementData.enumerated() {
                    var arr = [String]()
                    arr.append(index.description)
                    arr.append(item.date)
                    arr.append(item.day)
                    arr.append(item.narration)
                    arr.append(item.debit)
                    arr.append(item.credit)
                    arr.append(item.balance)
                    statementInnerModel.append(arr)
                }
                let tablewidth2 = [contentWidth * 0.05,contentWidth * 0.2,contentWidth * 0.2,contentWidth * 0.2,contentWidth * 0.13,contentWidth * 0.13,contentWidth * 0.13]
                
                for (index,rowData) in statementInnerModel.enumerated() {
                    if currentY + rowHeight > pageHeight - margin {
                        context.beginPage()
                        currentY = margin
                        //   drawHeaderRow(at: CGPoint(x: margin, y: currentY), columnWidths: columnWidths, context: context.cgContext)
                        // currentY += rowHeight
                    }
                    drawDataRow(rowData: rowData, at: CGPoint(x: margin, y: currentY), columnWidths: tablewidth2, context: context.cgContext)
                    currentY += rowHeight
                }
                let text2 =  "C4B FINCORP LTD, T/A Credit4business\n"
                + "86-90 Paulstreet, London- EC2A 4NE\n" + "info@credit4business.co.uk\n"
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center

                let attributes2: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 14),.paragraphStyle: paragraphStyle]
                //text2.draw(at: CGPoint(x: pageWidth / 2, y: 700), withAttributes: attributes2)
                
                text2.draw(in: CGRect(x: pageWidth / 2 - 150 , y: 700, width: 300, height: 100), withAttributes: attributes2)
            }
        }
        return pdfData
    }
     func drawHeaderRow(at origin: CGPoint, columnWidths: [CGFloat], context: CGContext) {
            let headers = ["Header 1", "Header 2"]
            let rowHeight: CGFloat = 40

            // Draw cells and text for headers
            var currentX = origin.x
            for i in 0..<headers.count {
                let cellRect = CGRect(x: currentX, y: origin.y, width: columnWidths[i], height: rowHeight)
                context.stroke(cellRect) // Draw cell border

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 12),
                    .paragraphStyle: paragraphStyle
                ]
                headers[i].draw(in: cellRect, withAttributes: attributes)
                currentX += columnWidths[i]
            }
        }

         func drawDataRow(rowData: [String], at origin: CGPoint, columnWidths: [CGFloat], context: CGContext) {
            let rowHeight: CGFloat = 40
             let pageWidth: CGFloat = 612
             let pageHeight: CGFloat = 792
             let margin: CGFloat = 50
             let contentWidth = pageWidth - 2 * margin
           //  let columnWidths: [CGFloat] = [contentWidth * 0.3, contentWidth * 0.7]

            // Draw cells and text for data
            var currentX = origin.x
            for i in 0..<rowData.count {
                let cellRect = CGRect(x: currentX, y: origin.y, width: columnWidths[i], height: rowHeight)
//                var width = rowData.count == 1 ? contentWidth : 150
//                let cellRect = CGRect(x: currentX, y: origin.y, width: CGFloat(width), height: rowHeight)

                context.stroke(cellRect) // Draw cell border

                let paragraphStyle = NSMutableParagraphStyle()
                if rowData.count == 1 {
                    paragraphStyle.alignment = .center
                }else{
                    paragraphStyle.alignment = .left
                }

                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14),
                    .paragraphStyle: paragraphStyle
                ]
                rowData[i].draw(in: cellRect.insetBy(dx: 5, dy: 10), withAttributes: attributes) // Add some padding
                currentX += columnWidths[i]
            }
        
    }
    func savePDFToDocumentsDirectory(pdfData: Data, fileName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Could not find documents directory.")
            self.controllerObj.showAlert(title: "Info", message: "Could not find documents directory")
            return
        }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            try pdfData.write(to: fileURL)
            print("PDF saved successfully to: \(fileURL.lastPathComponent)")
            self.controllerObj.showAlert(title: "Info", message: "PDF saved successfully to: \(fileURL.lastPathComponent)")
        } catch {
            print("Error saving PDF: \(error.localizedDescription)")
            self.controllerObj.showAlert(title: "Info", message: "Error saving PDF: \(error.localizedDescription)")
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func setDelegates() {
        self.innerTable.delegate = self
        self.innerTable.dataSource = self
        self.addObserverOnHeightTbl()
    }
    
    func updateUI()
    {
        self.outerView.layer.borderWidth = 0.5
        self.outerView.layer.borderColor = UIColor(named: "separator")?.cgColor

    }
    func showHideTable() {
            if self.innerTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
    }
}
extension PaymentHistoryCell {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                    self.innerTable.isHidden = false
                    self.iconImage.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//                    self.nameTableHeight.constant = CGFloat(self.viewModel.nameArray.count * 50)
                    self.innerTable.reloadData()
                    self.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.innerTable.isHidden = true
                self.iconImage.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//                self.nameTableHeight.constant = 0
                self.innerTable.reloadData()
        }, completion: nil)
    }
}
extension PaymentHistoryCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if isDirector {
            count = self.directorModel.count
        }else{
            count = self.model.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDirector{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsDetailsCell", for: indexPath) as? LeadsDetailsCell else {
                return UITableViewCell()
            }

            cell.titleLabel.text = self.directorModel.value(atSafe: indexPath.row)?.title
            cell.valueLabel.text = self.directorModel.value(atSafe: indexPath.row)?.value
            return cell
        }else{
            
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as? PaymentCell else {
            return UITableViewCell()
        }
        var modelObj = self.model.value(atSafe: indexPath.row)
        cell.descriptionLabel.text = modelObj?.description
        cell.amountLabel.text = modelObj?.amount
        cell.dateLabel.text = modelObj?.date
            if modelObj?.description == "Payment Failed" {
                cell.amountLabel.textColor = .red
               // cell.galleryLabel.font = UIFont(name: "Poppins-Medium", size: 14)
            }else{
                cell.amountLabel.textColor = .black
            }
        return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isDirector {
            return UITableView.automaticDimension
        }else{
            return 50
        }
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension PaymentHistoryCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.innerTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.innerTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.innerTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.innerTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

class PaymentCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
extension UIGraphicsPDFRendererContext {
    
    // 1
    func addCenteredText(fontSize: CGFloat,
                         weight: UIFont.Weight,
                         text: String,
                         cursor: CGFloat,
                         pdfSize: CGSize) -> CGFloat {
        
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let pdfText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: textFont])
        
        let rect = CGRect(x: pdfSize.width/2 - pdfText.size().width/2, y: cursor, width: pdfText.size().width, height: pdfText.size().height)
        pdfText.draw(in: rect)
        
        return self.checkContext(cursor: rect.origin.y + rect.size.height, pdfSize: pdfSize)
    }
    
    // 2
    func addSingleLineText(fontSize: CGFloat,
                           weight: UIFont.Weight,
                           text: String,
                           indent: CGFloat,
                           cursor: CGFloat,
                           pdfSize: CGSize,
                           annotation: PDFAnnotationSubtype?,
                           annotationColor: UIColor?) -> CGFloat {
        
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let pdfText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: textFont])
        
        let rect = CGRect(x: indent, y: cursor, width: pdfSize.width - 2*indent, height: pdfText.size().height)
        pdfText.draw(in: rect)
        
        if let annotation = annotation {
            let annotation = PDFAnnotation(
                bounds: CGRect.init(x: indent, y: rect.origin.y + rect.size.height, width: pdfText.size().width, height: 10),
                forType: annotation,
                withProperties: nil)
            annotation.color = annotationColor ?? .black
            annotation.draw(with: PDFDisplayBox.artBox, in: self.cgContext)
        }
        
        return self.checkContext(cursor: rect.origin.y + rect.size.height, pdfSize: pdfSize)
    }
    
    // 3
    func addMultiLineText(fontSize: CGFloat,
                          weight: UIFont.Weight,
                          text: String,
                          indent: CGFloat,
                          cursor: CGFloat,
                          pdfSize: CGSize) -> CGFloat {
        
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping

        let pdfText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: textFont])
        let pdfTextHeight = pdfText.height(withConstrainedWidth: pdfSize.width - 2*indent)
        
        let rect = CGRect(x: indent, y: cursor, width: pdfSize.width - 2*indent, height: pdfTextHeight)
        pdfText.draw(in: rect)

        return self.checkContext(cursor: rect.origin.y + rect.size.height, pdfSize: pdfSize)
    }
    
    // 4
    func checkContext(cursor: CGFloat, pdfSize: CGSize) -> CGFloat {
        if cursor > pdfSize.height - 100 {
            self.beginPage()
            return 40
        }
        return cursor
    }
}

extension NSAttributedString {

    // 5
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
    
        return ceil(boundingBox.height)
    }
}
