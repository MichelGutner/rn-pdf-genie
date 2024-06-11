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
        self.matchesFound.append(selection)
        selection.color = .yellow
    }
    
    func clearMatches() {
        self.matchesFound.removeAll()
        self.pdfView.highlightedSelections = []
    }
    
    func highlightMatches() {
        self.pdfView.highlightedSelections = self.matchesFound
        if let firstMatch = self.matchesFound.first, let page = firstMatch.pages.first {
            self.pdfView.go(to: page)
        }
    }
}



struct PDFViewerControllerManager: UIViewControllerRepresentable {
    var url: String
    var searchTerm: String
    var callbackSearchCount: (Int) -> Void
    
    func makeUIViewController(context: Context) -> PDFViewerController {
        let controller = PDFViewerController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PDFViewerController, context: Context) {
        guard let documentUrl = URL(string: url) else { return }
        uiViewController.loadPDF(url: documentUrl)
        guard let pdfDocument = uiViewController.pdfView.document else { return }
        uiViewController.clearMatches()
        
        pdfDocument.beginFindString(searchTerm, withOptions: [.caseInsensitive, .diacriticInsensitive])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            uiViewController.highlightMatches()
            callbackSearchCount(uiViewController.matchesFound.count)
        }
    }
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var term = ""
    @State private var showSearch = false
    @State private var searchCount: Int? = nil;
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    print("testing")
                    showSearch.toggle()
                }) {
                    Image(systemName: "doc.text.magnifyingglass")
                }
                
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .opacity(showSearch ? 1 : 0)
                    .animation(.easeIn(duration: 0.35), value: showSearch)
                
                Button(action: {
                    print("forward")
                }){
                    Image(systemName: "chevron.right")
                }
                
                Text("\(String(describing: searchCount))")
                
                
            }
            .padding()
            PDFViewerControllerManager(url: "https://sanar-courses-platform-files.s3.sa-east-1.amazonaws.com/SISTEMANERVOSOAUTNOMO2-220704-212411-1657068657.pdf", searchTerm: searchText) { count in
                searchCount = count
            }
        }
    }
}
