import PDFKit
import SwiftUI
import AVKit
import VisionKit
import Vision

class PDFViewerController: UIViewController {
    var pdfView: PDFView!
    var matchesFound = [PDFSelection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoScales = true
        NotificationCenter.default.addObserver(self, selector: #selector(didFindMatch(_:)), name: Notification.Name.PDFDocumentDidFindMatch, object: nil)
        view.addSubview(pdfView)
    }
    
    func loadPDF(url: URL) {
        if (pdfView.document == nil) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let document = PDFDocument(url: url) {
                    DispatchQueue.main.async {
                        self.pdfView.document = document
                    }
                }
            }
        }
    }
    
    @objc private func didFindMatch(_ sender: Notification) {
        guard let selection = sender.userInfo?["PDFDocumentFoundSelection"] as? PDFSelection else { return }
        self.pdfView.highlightedSelections = []
        if (!matchesFound.isEmpty) {
            self.matchesFound.removeAll()
        }
        self.matchesFound.append(selection)
        selection.color = .yellow
        
        DispatchQueue.main.async { [self] in
            for index in 0..<matchesFound.count {
                print(matchesFound.count)
                    guard let select = matchesFound[0] as? PDFSelection else {return}
                    self.pdfView.highlightedSelections = self.matchesFound
                    
                    let page = select.pages.first
                    self.pdfView.go(to: page!)
                    
                    return
                
            }}
        

    }
}
    


struct PDFViewerControllerManager: UIViewControllerRepresentable {
    var url: String
    var searchTerm: String

    func makeUIViewController(context: Context) -> PDFViewerController {
        let controller = PDFViewerController()
        return controller
    }

    func updateUIViewController(_ uiViewController: PDFViewerController, context: Context) {
        guard let documentUrl = URL(string: url) else { return }
        uiViewController.loadPDF(url: documentUrl)
        guard let pdfDocument = uiViewController.pdfView.document else { return }
        pdfDocument.beginFindString(searchTerm, withOptions: [.caseInsensitive, .diacriticInsensitive])
    }
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var term = ""
    
    var body: some View {
        GeometryReader { geometry in
            PDFViewerControllerManager(url: "https://sanar-courses-platform-files.s3.sa-east-1.amazonaws.com/SISTEMANERVOSOAUTNOMO2-220704-212411-1657068657.pdf", searchTerm: term)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .overlay(
                    VStack{
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button(action: {
                                term = searchText
                                // Aqui você pode chamar a função de busca e destaque no PDF
                            }) {
                                Text("Search")
                            }
                        }
                        .padding()
                        Spacer()
                    }
                )
        }
    }
}
