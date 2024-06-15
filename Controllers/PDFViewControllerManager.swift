import PDFKit
import SwiftUI
import AVKit
import VisionKit
import Vision


struct PDFViewerControllerManager: UIViewControllerRepresentable {
    var pdfView: PDFView
    init(_ pdfView: PDFView) {
        self.pdfView = pdfView
    }
    
    func makeUIViewController(context: Context) -> PDFViewerController {
        let controller = PDFViewerController(pdfView)

        return controller
    }
    
    func updateUIViewController(_ uiViewController: PDFViewerController, context: Context) {
        //
    }
}
