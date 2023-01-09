//
//  ALSliderTableViewCell.swift
//  AnylineExamples
//
//  Created by Angela Brett on 22.07.20.
//

import Foundation

final class ALSliderTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let spacing:CGFloat = 8 //we could change this to use equalToSystemSpacingBelow: etc if we change the target to iOS 11
        let margin:CGFloat = 10 //this can't be too close to the edge, because moving the finger from the edge of the screen is also the 'go back' gesture, and we don't want to do that accidentally.
        contentView.addSubview(slider)
        contentView.addSubview(titleLabel)
        contentView.addSubview(currentValueLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -spacing),
            titleLabel.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
            currentValueLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0),
            currentValueLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -spacing),
            currentValueLabel.trailingAnchor.constraint(equalTo: slider.trailingAnchor, constant: -spacing),
            slider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
            slider.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: margin),
            slider.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant:-margin)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title:String? = nil {
        didSet {
            titleLabel.text = title
        }
    }
    
    var minimumValue:Float = 100 {
        didSet {
            slider.minimumValue = minimumValue
        }
    }
    
    var maximumValue:Float = 0 {
        didSet {
            slider.maximumValue = maximumValue
        }
    }
    
    //this will be called whenever the value changes
    var sliderValueDidChange:((ALSliderTableViewCell)->())? = nil
    
    var value:Float {
        set {
            slider.value = newValue
            updateValueDisplay()
        }
        get {
            return slider.value
        }
    }
    
    var isPercentage:Bool = true {
        didSet {
            //numberFormatter.numberStyle = isPercentage ? .percent : .none
            numberFormatter.positiveSuffix = isPercentage ? "%" : ""
            if (isPercentage) {
                minimumValue = 0
                maximumValue = 100
            }
            updateValueDisplay()
        }
    }
    
    var minimumValueImage:UIImage? = nil {
        didSet {
            slider.minimumValueImage = minimumValueImage
        }
    }
    
    var maximumValueImage:UIImage? = nil {
        didSet {
            slider.maximumValueImage = maximumValueImage
        }
    }
    
    private lazy var numberFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
    
    private func updateValueDisplay() {
        currentValueLabel.text = numberFormatter.string(from: NSNumber(value: slider.value))
    }
    
    // MARK: Reusing Cells
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    lazy private var slider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    lazy private var currentValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Handling Slider Input
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        slider.becomeFirstResponder()
    }
    
    @objc func sliderValueChanged() {
        updateValueDisplay()
        sliderValueDidChange?(self)
    }
}
