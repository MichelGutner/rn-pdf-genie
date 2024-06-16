import PDFKit
import UIKit

class PDFViewerController: UIViewController, PDFViewDelegate {
    var pdfView: PDFView!
    private var matchesFound = [PDFSelection]()
    var currentMatchIndex = 0
    
    init(_ pdfView: PDFView) {
        self.pdfView = pdfView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pdfView)
        NotificationCenter.default.addObserver(self, selector: #selector(didFindMatch(_:)), name: Notification.Name.PDFDocumentDidFindMatch, object: nil)
        
        getNotification("SEARCH") { [self] notification in
            Task { @MainActor in
                clearMatches()
                if let searchTerm = notification.userInfo?["search"] as? String {
                    pdfView?.document?.beginFindString(searchTerm, withOptions: [.caseInsensitive, .diacriticInsensitive])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                        updateCurrentMatchHighlight()
                    }
                }
            }
        }
    }
        
    @objc private func didFindMatch(_ sender: Notification) {
        guard let selection = sender.userInfo?["PDFDocumentFoundSelection"] as? PDFSelection else { return }
        if (selection.pages.first === pdfView.currentPage) {
            self.matchesFound.insert(selection, at: 0)
        } else {
            self.matchesFound.append(selection)
        }
        selection.color = .yellow
    }
    
    
    
    @objc private func nextMatchButtonTapped() {
        goToNextMatchField()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if ((previousTraitCollection?.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) != nil) {
            pdfView.backgroundColor = self.pdfView.backgroundColor
        }
    }
}

extension PDFViewerController {
    private func updateCurrentMatchHighlight() {
        pdfView.highlightedSelections = []
        
        for (index, match) in matchesFound.enumerated() {
            match.color = (index == currentMatchIndex) ? .green : .yellow
        }
        
        goToMatchField(at: currentMatchIndex)
        pdfView.highlightedSelections = matchesFound
        let count = matchesFound.count
        sendNotification("SEARCH_COUNT", userInfo: ["count": count])
    }
    
    func clearMatches() {
        self.matchesFound.removeAll()
    }
    
    
    func goToNextMatchField() {
        guard !matchesFound.isEmpty else { return }
        currentMatchIndex = (currentMatchIndex + 1) % matchesFound.count
        updateCurrentMatchHighlight()
    }
    
    private func goToMatchField(at index: Int) {
        guard index < matchesFound.count else { return }
        let selection = matchesFound[index]
        if let page = selection.pages.first {
            pdfView.go(to: page)
        }
    }
}
