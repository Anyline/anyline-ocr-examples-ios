import UIKit

class InfoScrollBox: UIView {

    enum Mode {
        case none, collapsed, result, resultWithText(String), configuration
    }

    struct Constants {
        static let imageLabelHeight = CGFloat(20)
        static let imageViewMaxWidth = CGFloat(280)
        static let imageViewMaxHeight = CGFloat(220)
        static let textViewLabelHeight = CGFloat(20)
        static let textViewHeight = CGFloat(700)
        static let margin = CGFloat(10)
        static let margin2x = CGFloat(20)
        static let infoBoxHeightResult: CGFloat = 480
        static let infoBoxHeightConfig: CGFloat = 680
    }

    var visibility: InfoScrollBox.Mode = .none {
        didSet {
            showInfoBox(visibility)
        }
    }

    var text: String? {
        didSet {
            textView.text = text
        }
    }

    var images: [UIImage]? {
        didSet {
            collectionView.reloadData()
            if let images = images, !images.isEmpty {
                collectionViewHeightConstraint.constant = Constants.imageViewMaxHeight
                collectionView.isHidden = false
            } else {
                collectionViewHeightConstraint.constant = 0
                collectionView.isHidden = true
            }
        }
    }
    
    var infoString: String? = nil {
        didSet {
            extraTextLabel.isHidden = infoString == nil
            if let str = infoString {
                extraTextLabel.text = str
            }
        }
    }

    var scrollBoxVisibilityChanged: ((Bool) -> Void)?

    let containerView = UIView()
    
    private var infoBoxYConstraint: NSLayoutConstraint!
    
    private var infoBoxHeightConstraint: NSLayoutConstraint!

    private var isConfig: Bool = true {
        didSet {
            textViewHeaderLabel.text = isConfig ? "Configuration" : "Latest Result"
        }
    }

    private var infoBoxHeight: CGFloat {
        images == nil ? Constants.infoBoxHeightConfig : Constants.infoBoxHeightResult
    }

    @objc private func didPressDismiss(_ btn: UIButton) {
        visibility = .collapsed
    }

    private lazy var dismissButton: UIButton = {
        let button = ButtonWithInsets()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.init(named: "dismiss-btn")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didPressDismiss), for: .touchUpInside)
        return button
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let collectionView: UICollectionView = {
        let layout = CenterCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black.withAlphaComponent(0.3)
        collectionView.layer.cornerRadius = 8
        collectionView.layer.masksToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let extraTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textViewHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Latest Result"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        if #available(iOS 13.0, *) {
            textView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        } else {
            // Fallback on earlier versions
        }
        return textView
    }()

    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        blurEffectView.layer.cornerRadius = 8
        blurEffectView.layer.masksToBounds = true
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()

    private var collectionViewHeightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        addSubview(scrollView)

        let bottomConstraint = scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomConstraint.priority = .defaultLow

        let trailingConstraint = scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailingConstraint.priority = .defaultLow

        infoBoxYConstraint = scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        infoBoxHeightConstraint = scrollView.heightAnchor.constraint(equalToConstant: Constants.infoBoxHeightResult)
        infoBoxHeightConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor, constant: -20),
            infoBoxYConstraint,
            infoBoxHeightConstraint,

            scrollView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10),
        ])

        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -5),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10),
        ])

        containerView.addSubview(collectionView)
        containerView.addSubview(extraTextLabel)
        containerView.addSubview(textViewHeaderLabel)
        containerView.addSubview(textView)

        let spacer1 = spacer()
        containerView.addSubview(spacer1)

        let spacer2 = spacer()
        containerView.addSubview(spacer2)

        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            extraTextLabel.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 10),
            extraTextLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor),
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionViewHeightConstraint,
            spacer1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            spacer1.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            spacer1.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            spacer1.heightAnchor.constraint(equalToConstant: Constants.margin2x),
            textViewHeaderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            textViewHeaderLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            textViewHeaderLabel.topAnchor.constraint(equalTo: spacer1.bottomAnchor),
            spacer2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            spacer2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            spacer2.topAnchor.constraint(equalTo: textViewHeaderLabel.bottomAnchor),
            spacer2.heightAnchor.constraint(equalToConstant: 0),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: spacer2.bottomAnchor),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
        ])

        addSubview(blurEffectView)

        NSLayoutConstraint.activate([
            blurEffectView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            blurEffectView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            blurEffectView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            blurEffectView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        addSubview(dismissButton)

        NSLayoutConstraint.activate([
            dismissButton.rightAnchor.constraint(equalTo: blurEffectView.rightAnchor, constant: -20),
            dismissButton.topAnchor.constraint(equalTo: blurEffectView.topAnchor, constant: 20),
            dismissButton.heightAnchor.constraint(equalToConstant: 24),
            dismissButton.widthAnchor.constraint(equalToConstant: 24),
        ])

        sendSubviewToBack(blurEffectView)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
    }

    private func showInfoBox(_ mode: InfoScrollBox.Mode = .result) {

        // while not 'visible', the view still occupies the whole scan view - this
        // would eat up the user taps and gestures meant for the ScanView components.
        var shouldHide = false

        var isConfigMode = false
        var shouldAnimate = true
        var debugTextDisplayed = false

        switch mode {
        case .configuration:
            isConfigMode = true
        case .resultWithText(let str):
            debugTextDisplayed = true
            infoString = str
        case .none:
            shouldHide = true
            shouldAnimate = false
        case .collapsed:
            shouldHide = true
        default: break
        }

        isUserInteractionEnabled = !shouldHide

        extraTextLabel.isHidden = !debugTextDisplayed
        extraTextLabel.textColor = (debugTextDisplayed && infoString?.contains("f/s") == true) ? .yellow : .white
        extraTextLabel.font = (debugTextDisplayed && infoString?.contains("f/s") == true) ? .systemFont(ofSize: 13) : .systemFont(ofSize: 15)

        isConfig = isConfigMode
        infoBoxHeightConstraint.constant = isConfigMode ? Constants.infoBoxHeightConfig : Constants.infoBoxHeightResult

        let animated = shouldAnimate

        containerView.isHidden = false
        dismissButton.isHidden = false

        guard !shouldHide else {
            scrollView.setContentOffset(.zero, animated: false)
            infoBoxYConstraint.constant = infoBoxHeightConstraint.constant + 10
            guard animated else {
                superview?.layoutIfNeeded()
                return
            }
            UIView.animate(withDuration: 0.3) {
                self.superview?.layoutIfNeeded()
            }
            scrollBoxVisibilityChanged?(false)
            containerView.isHidden = true
            dismissButton.isHidden = true
            return
        }

        self.infoBoxYConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.superview?.layoutIfNeeded()
        }
        scrollBoxVisibilityChanged?(true)
    }

    private func spacer() -> UIView {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let pointInSubview = self.convert(point, to: containerView)
        if !containerView.bounds.contains(pointInSubview) {
            return nil
        }
        return super.hitTest(point, with: event)
    }
}

extension InfoScrollBox: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageView.image = images?[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.imageViewMaxWidth, height: Constants.imageViewMaxHeight)
    }
}

internal class ImageCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

internal class ButtonWithInsets: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -40, dy: -40).contains(point)
    }
}

internal class CenterCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        let collectionViewWidth = collectionView?.bounds.width ?? 0

        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                let itemCount = collectionView?.numberOfItems(inSection: layoutAttribute.indexPath.section) ?? 0
                if itemCount == 1 {
                    let itemWidth = layoutAttribute.frame.width
                    let inset = (collectionViewWidth - itemWidth) / 2
                    sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
                } else {
                    sectionInset = .zero
                }
            }
        }
        return attributes
    }
}
