//
//  ALResultViewController.swift
//  AnylineExamples
//
//  Created by Aldrich Co on 3/11/22.
//

import Foundation

class ALResultViewController: UIViewController {

    enum Constants {
        static let disclaimerStr = """
The result fields above display a selection of scannable ID information only. Please review the documentation for a full list of scannable ID information.
"""
        static let idPluginDocumentationURL = "https://documentation.anyline.com/toc/products/id/index.html"

        static let keysToExclude = ["isArabic"]

        static let defaultSectionTitle = "Result Data"
    }

    // the keys can be used as titles for section headers, we choose not to display them
    var resultData: [String: [ALResultEntry]] = [:]

    @objc
    var imageFace: UIImage?

    @objc
    var imagePrimary: UIImage?

    @objc
    var imageSecondary: UIImage?

    @objc
    var showDisclaimer = false

    @objc
    var isRightToLeft = false

    private var tableViewHeightConstraint: NSLayoutConstraint!

    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .al_Background()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var faceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
        button.setTitle("Continue scanning", for: .normal)
        button.titleLabel?.font = .al_proximaBold(withSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .al_examplesBlue()
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var disclaimerTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.clipsToBounds = false
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ALResultCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.backgroundColor = .al_Background()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    @objc
    func confirmAction(_ button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc
    init(resultMap: [String: [ALResultEntry]]) {
        self.resultData = resultMap.excludingKeys(Constants.keysToExclude)
        super.init(nibName: nil, bundle: nil)
    }

    @objc
    convenience init(results: [ALResultEntry]) {
        self.init(resultMap: [ Constants.defaultSectionTitle: results ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true,
                                                    animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateLayout()
    }

    private func layout() {

        self.setupNavBar()

        self.view.backgroundColor = .al_Background()
        self.contentScrollView.delegate = self

        self.view.addSubview(self.contentScrollView)
        self.view.addSubview(self.confirmButton)

        self.faceImageView.image = self.imageFace
        self.firstImageView.image = self.imagePrimary
        self.secondImageView.image = self.imageSecondary

        contentScrollView.addSubview(self.faceImageView)
        contentScrollView.addSubview(self.firstImageView)
        contentScrollView.addSubview(self.secondImageView)

        self.tableView.delegate = self
        self.tableView.dataSource = self

        contentScrollView.addSubview(self.tableView)

        if showDisclaimer {
            contentScrollView.addSubview(self.disclaimerTextView)
            self.setDisclaimerTextViewContent()
        }

        setupConstraints()
        updateLayout()
    }

    private func setupNavBar() {
        self.title = "Result Data"
        let shareBarItem: UIBarButtonItem = .init(barButtonSystemItem: .action,
                                                  target: self,
                                                  action: #selector(askToShareItems(_:)))
        shareBarItem.tintColor = .al_LabelBlackWhite()
        self.navigationItem.rightBarButtonItem = shareBarItem
    }

    private func setupConstraints() {

        let verticalGap: CGFloat = 10.0
        let horizontalGap: CGFloat = 15.0

        var allConstraints: [NSLayoutConstraint] = [
            self.contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.contentScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ]

        var tableViewTopConstraint: NSLayoutYAxisAnchor = self.contentScrollView.topAnchor

        if self.imageFace != nil {
            var horizontalConstraint: NSLayoutConstraint = self.faceImageView.leadingAnchor
                .constraint(equalTo: self.tableView.leadingAnchor,
                            constant: horizontalGap - 5)
            if self.isRightToLeft {
                horizontalConstraint = self.faceImageView.trailingAnchor
                    .constraint(equalTo: self.tableView.trailingAnchor,
                                constant: -horizontalGap + 5)
            }

            allConstraints.append(contentsOf: [
                self.faceImageView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor,
                                                        constant: verticalGap),
                horizontalConstraint,
                self.faceImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
                self.faceImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            ])

            tableViewTopConstraint = self.faceImageView.bottomAnchor
        }

        // 100 is arbitrary, it will be updated to the fitting height after a runloop update
        self.tableViewHeightConstraint = self.tableView.heightAnchor.constraint(equalToConstant: 100)
        allConstraints.append(contentsOf: [
            self.tableView.topAnchor.constraint(equalTo: tableViewTopConstraint, constant: verticalGap),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: horizontalGap),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -horizontalGap),
            self.tableViewHeightConstraint
        ])

        var ratio = (self.imagePrimary?.size.height ?? 0) / (self.imagePrimary?.size.width ?? 0)
        let width = self.view.bounds.width - horizontalGap * 2.0
        var height = width * ratio

        allConstraints.append(contentsOf: [
            self.firstImageView.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: verticalGap),
            self.firstImageView.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor, constant: 10),
            self.firstImageView.trailingAnchor.constraint(equalTo:self.tableView.trailingAnchor, constant: -10),
            self.firstImageView.heightAnchor.constraint(lessThanOrEqualToConstant: height.isNaN ? 0 : height),
            self.firstImageView.widthAnchor.constraint(lessThanOrEqualToConstant: width.isNaN ? 0 : width),
            self.firstImageView.bottomAnchor.constraint(equalTo: self.secondImageView.topAnchor, constant: -verticalGap)
        ])
        ratio = (self.imageSecondary?.size.height ?? 0) / (self.imageSecondary?.size.width ?? 0)
        height = width * ratio

        let secondImageViewBottomAnchor = (self.showDisclaimer ?
                                           self.disclaimerTextView.topAnchor :
                                            self.contentScrollView.bottomAnchor)

        allConstraints.append(contentsOf: [
            self.secondImageView.topAnchor.constraint(equalTo: self.firstImageView.bottomAnchor, constant: verticalGap),
            self.secondImageView.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor, constant: 10),
            self.secondImageView.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: -10),
            self.secondImageView.heightAnchor.constraint(equalToConstant: height.isNaN ? 0 : height),
            self.secondImageView.widthAnchor.constraint(equalTo: self.firstImageView.widthAnchor),
            self.secondImageView.bottomAnchor.constraint(equalTo: secondImageViewBottomAnchor, constant: -verticalGap)
        ])

        if self.showDisclaimer {
            let size = self.disclaimerTextView.sizeThatFits(.init(width: width, height: 100))
            let disclaimerHeight = size.height

            allConstraints.append(contentsOf: [
                self.disclaimerTextView.topAnchor.constraint(equalTo: self.secondImageView.bottomAnchor, constant: verticalGap),
                self.disclaimerTextView.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor, constant: 10),
                self.disclaimerTextView.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: -10),
                self.disclaimerTextView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor, constant: -verticalGap),
                self.disclaimerTextView.heightAnchor.constraint(equalToConstant: disclaimerHeight)
            ])
        }

        allConstraints.append(contentsOf: [
            self.confirmButton.topAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor,
                                                    constant: verticalGap),
            self.confirmButton.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor),
            self.confirmButton.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 50),
            self.confirmButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                       constant: -verticalGap * 2)
        ])

        self.view.addConstraints(allConstraints)
        NSLayoutConstraint.activate(allConstraints)
    }

    private func updateLayout() {
        self.tableView.layoutIfNeeded()
        self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
    }

    private func setDisclaimerTextViewContent() {
        // sets the disclaimer text found at the bottom of the page, should you
        // wish to allow it to be shown (typically this is done on ID scans)
        let attrStr: NSMutableAttributedString = .init(string: Constants.disclaimerStr)
        let hyperlinkRange = attrStr.mutableString.range(of: "documentation")
        let idPluginDocumentationURL = URL(string: Constants.idPluginDocumentationURL)!
        attrStr.addAttribute(.link, value: idPluginDocumentationURL, range: hyperlinkRange)
        self.disclaimerTextView.attributedText = attrStr
        self.disclaimerTextView.textColor = .al_LabelBlackWhite()
    }

    @objc func askToShareItems(_ item: Any) {
        let resultArr = self.resultData["Result Data"] ?? []
        var shareText: String = "Anyline Scanner Result\n\n"
        for entry in resultArr {
            shareText.append(String(format: "%@: %@\n", entry.title, entry.value))
        }
        let items = [ shareText, self.imagePrimary as Any ].compactMap { $0 }
        let activityController = UIActivityViewController(activityItems: items,
                                                          applicationActivities: nil)
        activityController.setValue("Anyline Scanner Result", forKey: "Subject")
        if UIDevice().userInterfaceIdiom != .phone {
            activityController.modalPresentationStyle = .popover
        }
        self.present(activityController, animated: true, completion: nil)
    }
}

extension ALResultViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array<String>(self.resultData.keys)
        return self.resultData[keys[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ALResultCell ?? ALResultCell()
        let keys = Array<String>(self.resultData.keys)
        let key = keys[indexPath.section]
        if let section = self.resultData[key] {
            let entry = section[indexPath.row]
            resultCell.backgroundColor = .al_Background()
            resultCell.resultEntry = entry
            resultCell.alignLabels(.left)
            if self.isRightToLeft {
                resultCell.alignLabels(.right)
            }
            return resultCell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.resultData.keys.count
    }

    func tableView(_ tableView: UITableView,
                   shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, canPerformAction action: Selector,
                   forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, performAction action: Selector,
                   forRowAt indexPath: IndexPath, withSender sender: Any?) {
        let pasteboard = UIPasteboard.general
        let keys = Array<String>(self.resultData.keys)
        let section = self.resultData[keys[indexPath.section]]
        if let entry = section?[indexPath.row] {
            pasteboard.string = entry.value
        }
    }
}


extension Dictionary where Key == String, Value == Array<ALResultEntry> {

    /// This is run over the entries to be passed as input to this view controller,
    /// to remove excluded elements such as `isArabic`.
    ///
    /// - Parameter excludedKeys: array of keys to exclude
    /// - Returns: the dictionary with the given keys excluded / removed
    fileprivate func excludingKeys(_ excludedKeys: [String]) -> Dictionary<Key, Value> {
        var result = [String: [ALResultEntry]]()
        for k in self.keys {
            if let arr: [ALResultEntry] = self[k] {
                result[k] = arr.filter { entry in
                    let entryKey = entry.title ?? ""
                    return !excludedKeys.contains(entryKey)
                }
            }
        }
        return result
    }
}
