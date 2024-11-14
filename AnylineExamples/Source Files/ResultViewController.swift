import UIKit

protocol ResultViewControllerDelegate: AnyObject {
    func didDismissModalViewController(_ viewController: ResultViewController, restart: Bool)
}


class CenteredCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                let collectionViewWidth = collectionView?.bounds.width ?? 0
                let contentWidth = collectionViewContentSize.width
                let offset = (collectionViewWidth - contentWidth) / 2
                layoutAttribute.frame.origin.x += max(0, offset)
            }
        }
        return attributes
    }
}


class ResultViewController: UIViewController {
    
    var images: [UIImage]?
    var resultText: String?
    
    weak var delegate: ResultViewControllerDelegate?
    
    private let jsonLabel = UILabel()
    private let headerLabel = UILabel()
    private let textView = UITextView()
    private let collectionView: UICollectionView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = CenteredCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 280, height: 175)
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let scanAgainButton = UIButton(type: .custom)

    let dismissButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        
        view.backgroundColor = UIColor.init(white: 0.35, alpha: 1)
        
        // Configure headerLabel
        headerLabel.text = "Scan Result"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerLabel.textColor = .white

        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)

        // Config dismissButton
        dismissButton.setTitle("Done", for: .normal)
        dismissButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        dismissButton.titleLabel?.textColor = .white
        dismissButton.addTarget(self, action: #selector(dismissScan), for: .touchUpInside)
        view.addSubview(dismissButton)

        // Configure collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        
        // Configure jsonLabel
        jsonLabel.text = "Result JSON"
        jsonLabel.font = UIFont.boldSystemFont(ofSize: 18)
        jsonLabel.textAlignment = .left
        jsonLabel.textColor = .white
        view.addSubview(jsonLabel)
        
        // Configure textView
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.text = "Scan result text"
        
        if #available(iOS 13.0, *) {
            textView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        }
        
        if let resultText = resultText {
            textView.text = resultText
        }
        view.addSubview(textView)
        
        // Configure dismissButton
        scanAgainButton.backgroundColor = .init(red: 0, green: 0.6, blue: 1, alpha: 1)
        scanAgainButton.setTitle("Scan Again", for: .normal)
        scanAgainButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        scanAgainButton.addTarget(self, action: #selector(restartScan), for: .touchUpInside)
        scanAgainButton.layer.cornerRadius = 4
        view.addSubview(scanAgainButton)
    }
    
    private func setupConstraints() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        jsonLabel.translatesAutoresizingMaskIntoConstraints = false
        scanAgainButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // HeaderLabel constraints
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 50),

            dismissButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 50),
            dismissButton.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: -10),

            // CollectionView constraints
            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 180),
            
            // JSONLabel constraints
            jsonLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            jsonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            jsonLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            jsonLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // TextView constraints
            textView.topAnchor.constraint(equalTo: jsonLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // DismissButton constraints
            scanAgainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scanAgainButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            scanAgainButton.heightAnchor.constraint(equalToConstant: 35),
            scanAgainButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    @objc private func restartScan() {
        delegate?.didDismissModalViewController(self, restart: true)
        dismiss(animated: true, completion: nil)
    }

    @objc private func dismissScan() {
        delegate?.didDismissModalViewController(self, restart: false)
        dismiss(animated: true, completion: nil)
    }
}

extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = UIImageView(image: images![indexPath.item])
        imageView.contentMode = .scaleAspectFit
        cell.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        return cell
    }
}

