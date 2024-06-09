import AVKit
import SwiftUI
import UIKit
import React

@objc(RnPdfGenieViewManager)
class RnPdfGenieViewManager: RCTViewManager {

  override func view() -> (RnPdfGenieView) {
    return RnPdfGenieView()
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return false
  }
}

class RnPdfGenieView : UIView {
    
    override func layoutSubviews() {
        let pdfViewer = UIHostingController(rootView: ContentView())
        pdfViewer.view.frame = bounds
        addSubview(pdfViewer.view)
//        pdfViewer.view.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            pdfViewer.view.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor),
//            pdfViewer.view.trailingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor),
//            pdfViewer.view.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor),
//            pdfViewer.view.bottomAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
//        ])
        
    }
}
