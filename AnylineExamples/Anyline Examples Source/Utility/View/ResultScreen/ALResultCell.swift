//
//  ALResultCell.swift
//  AnylineExamples
//
//  Created by Aldrich Co on 3/18/22.
//

import UIKit

class ALResultCell: UITableViewCell {

    enum Alignment { case left, right }

    var resultEntry: ALResultEntry? {
        didSet {
            updateResultEntry()
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .al_proximaRegular(withSize: 14)
        label.textColor = .lightGray
        if #available(iOS 13.0, *) {
            label.textColor = .secondaryLabel
        }
        label.numberOfLines = 0
        label.tag = 12
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .al_proximaRegular(withSize: 16)
        label.textColor = .al_LabelBlackWhite()
        label.numberOfLines = 0
        label.tag = 13
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func customInit() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.valueLabel)
        self.setupConstraints()
    }

    func alignLabels(_ alignment: Alignment) {
        switch alignment {
        case .left:
            self.titleLabel.textAlignment = .left
            self.valueLabel.textAlignment = .left
        case .right:
            self.titleLabel.textAlignment = .right
            self.valueLabel.textAlignment = .right
        }
    }

    private func setupConstraints() {
        let constraints = [
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.valueLabel.topAnchor),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 24),
            self.valueLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.valueLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            self.valueLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
        ]
        self.contentView.addConstraints(constraints)
        NSLayoutConstraint.activate(constraints)
    }

    private func updateResultEntry() {
        var titleStr = (self.resultEntry?.title ?? "") as NSString
        let titleRange = NSMakeRange(0, titleStr.length)

        if titleStr.localizedCaseInsensitiveContains("@ara") {
            titleStr = titleStr.replacingOccurrences(of: "@ara", with: " Arabic", options: .caseInsensitive, range: titleRange) as NSString
        } else if titleStr.localizedCaseInsensitiveContains("@zho") { // ACO i saw it said "@aho", but I doubt it
            titleStr = titleStr.replacingOccurrences(of: "@zho", with: " Chinese", options: .caseInsensitive, range: titleRange) as NSString
        } else if titleStr.localizedCaseInsensitiveContains("@cyr") {
            titleStr = titleStr.replacingOccurrences(of: "@cyr", with: " Cyrillic", options: .caseInsensitive, range: titleRange) as NSString
        }

        // Tire recall error message changes in TIN results https://anyline.atlassian.net/browse/SHOW-65
        // make title color: red & font: bold, and the value normal, if "Tire on Recall" = "YES"
        if titleStr == "Tire on Recall" {
            if self.resultEntry?.value == "YES" {
                self.titleLabel.attributedText = .init(string: String("⚠ Attention - Tire on recall in the U.S."), attributes: [.foregroundColor : UIColor.red, .font: UIFont.boldSystemFont(ofSize: 16)])
                self.valueLabel.attributedText = .init(string: "Please contact manufacturer for instructions on returning/replacing recalled tires")
            }
        } else {
            self.titleLabel.text = String(titleStr)
            self.valueLabel.text = self.resultEntry?.value.replacingOccurrences(of: "\\n", with: "\n")
        }

        if self.resultEntry?.shouldSpellOutValue == true && self.resultEntry?.isAvailable == true {
            if #available(iOS 13.0, *) {
                // Make sure VoiceOver reads the result letter-by-letter for codes/license plates/etc.
                // The user can use the rotor to do this manually (and the character setting in the rotor
                // even uses the phonetic alphabet to make things clearer), but if we can save them from
                // switching between rotor settings when we know something won't make sense read as a word,
                // it's a bit smoother.
                //
                // Unfortunately, VoiceOver reads "comma space" before the value, for unknown reasons
                self.valueLabel.accessibilityAttributedLabel = .init(string: self.resultEntry?.value ?? "",
                                                                     attributes: [.accessibilitySpeechSpellOut : true])

                // Also use a monospaced font so it's easier to distinguish between O and 0, I and 1, etc.
                self.valueLabel.font = .monospacedSystemFont(ofSize: UIFont.labelFontSize, weight: .regular)

            } else {
                // in earlier versions of iOS, we could try adding spaces between characters, but this is not
                // ideal as some characters will be pronounced as single-letter words or Roman numerals.
            }
        }
    }
}
