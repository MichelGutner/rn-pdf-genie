import AVKit
import SwiftUI
import UIKit
import React
import PDFKit

@objc(RnPdfGenieViewManager)
class RnPdfGenieViewManager: RCTViewManager {
    
    override func view() -> (RnPdfGenieView) {
        return RnPdfGenieView()
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
}

class RnPdfGenieView : UIView, PDFDocumentDelegate {
    private var pdfView: PDFView!
    private static var cachedPDFView: PDFView?
    private static var cachedDocument: PDFDocument?
    
    @objc var direction: NSString = "VERTICAL"
    
    @objc var source: NSDictionary = [:]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let url = self.source["url"] as? String else { return }
        buildPDFWithCache(url)
        setDisplayDirection()
    }
    

}

// external funcs
extension RnPdfGenieView {
    @objc func setSearchTerm(_ searchTerm: String) {
        NotificationCenter.default.post(name: Notification.Name("SEARCH"), object: nil, userInfo: ["search": searchTerm])
    }
    
    func setDisplayDirection() {
        switch (direction) {
        case "HORIZONTAL":
           return pdfView.displayDirection = .horizontal
        default:
            pdfView.displayDirection = .vertical
        }
    }
}


//build
extension RnPdfGenieView {
    func buildPDFWithCache(_ url: String) {
        if RnPdfGenieView.cachedPDFView == nil {
            pdfView = PDFView(frame: self.bounds)
            pdfView.autoScales = true
            pdfView.clipsToBounds = true
            pdfView.document?.delegate = self
            RnPdfGenieView.cachedPDFView = pdfView
            loadPDFWithCache(url: URL(string: url)!)
        } else {
            pdfView = RnPdfGenieView.cachedPDFView
            pdfView.frame = bounds
            
            let pdf = UIHostingController(rootView: PDFViewerControllerManager(pdfView))
            pdf.view.frame = bounds
            
            addSubview(pdf.view)
        }
    }
    
    private func loadPDFWithCache(url: URL) {
        if RnPdfGenieView.cachedDocument == nil {
            DispatchQueue.global(qos: .userInitiated).async {
                if let document = PDFDocument(url: url) {
                    DispatchQueue.main.async {
                        self.pdfView.document = document
                        RnPdfGenieView.cachedDocument = document
                    }
                }
            }
        } else {
            pdfView.document = RnPdfGenieView.cachedDocument
        }
    }
}
