import Foundation

class ALModeSelectionButton: UIButton {

    @objc var didPressButton: (() -> (Void))?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @objc init(title: String) {
        super.init(frame: .init(origin: .zero, size: Constants.buttonSize))
        setup()
        setTitle(title, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum Constants {
        static let buttonSize: CGSize = .init(width: 98, height: 36)
        static let borderWidth = 0.6
    }

    private func setup() {
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)

        self.layer.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.75).cgColor
        self.layer.cornerRadius = round(Constants.buttonSize.height / 2.0)
        self.layer.borderWidth = Constants.borderWidth
        self.layer.borderColor = UIColor.white.cgColor
        self.isSelected = false
        self.titleLabel!.font = .al_proximaRegular(withSize: 14)
        self.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height).isActive = true
        self.widthAnchor.constraint(equalTo: self.titleLabel!.widthAnchor, constant: 40).isActive = true
    }

    @objc func tapped() {
        didPressButton?()
    }
}
