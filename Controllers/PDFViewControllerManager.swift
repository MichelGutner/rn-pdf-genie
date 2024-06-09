import PDFKit
import SwiftUI
import AVKit

class PDFViewerController: UIViewController {
    var pdfView: PDFView!

    override func viewDidLoad() {
        super.viewDidLoad()
        pdfView = PDFView(frame: self.view.bounds)
//        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    

        
        view.addSubview(pdfView)
    }
    
    func loadPDF(url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let document = PDFDocument(url: url) {
                DispatchQueue.main.async {
                    self.pdfView.document = document
                }
            }
        }
    }
}

struct PDFViewerControllerManager: UIViewControllerRepresentable {
    var url: String

    func makeUIViewController(context: Context) -> PDFViewerController {
        let controller = PDFViewerController()
        return controller
    }

    func updateUIViewController(_ uiViewController: PDFViewerController, context: Context) {
        guard let documentUrl = URL(string: url) else { return }
        uiViewController.loadPDF(url: documentUrl)
    }
}

struct ContentView: View {
    @State private var searchText = ""
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                PDFViewerControllerManager(url: "")
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
    }
}
