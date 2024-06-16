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
        
        // Configurar o botão flutuante
        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(UIImage(named: "pencil"), for: .normal)
        settingsButton.frame = CGRect(x: 170, y: 120, width: 50, height: 50)
        settingsButton.layer.cornerRadius = 25 // para tornar o botão circular, se desejado
        settingsButton.backgroundColor = .white // cor de fundo do botão
        settingsButton.layer.shadowColor = UIColor.black.cgColor // cor da sombra
        settingsButton.layer.shadowOffset = CGSize(width: 0, height: 2) // deslocamento da sombra
        settingsButton.layer.shadowOpacity = 0.5 // opacidade da sombra
        settingsButton.layer.shadowRadius = 3.0 // raio da sombra
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)

        
        view.addSubview(pdfView)
        pdfView.addSubview(settingsButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFindMatch(_:)), name: Notification.Name.PDFDocumentDidFindMatch, object: nil)
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name("SEARCH"), object: nil, queue: .main) { [self] notification in
            self.clearMatches()
            if let searchTerm = notification.userInfo?["search"] as? String {
                
                pdfView?.document?.beginFindString(searchTerm, withOptions: [.caseInsensitive, .diacriticInsensitive])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    updateCurrentMatchHighlight()
                }
            }
            
        }
    }
    
    @objc func settingsButtonTapped() {
        // Implemente aqui o que acontece quando o botão de configurações é tocado
        print("Botão de configurações tocado!")

        // Exemplo: Abrir uma tela de configurações
        let settingsViewController = UIViewController()
        settingsViewController.view.backgroundColor = .white
        settingsViewController.title = "Configurações"

        let navController = UINavigationController(rootViewController: settingsViewController)
        present(navController, animated: true, completion: nil)
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
