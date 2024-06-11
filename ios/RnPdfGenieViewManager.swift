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
        superview?.addSubview(pdfViewer.view)
    }
}
