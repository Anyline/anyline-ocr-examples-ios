import UIKit
import Anyline

/// Demo for a basic scanning workflow with a single plugin config
///
/// The view controller loads the BarcodeOverlay config JSON
///
/// NOTE: the value of `cancelOnResult` in config is ignored. Each result causes the plugin to stop.
class BarcodeOverlayScanViewController: UIViewController {

    struct Constants {
        static let barcodeHeightThreshold: CGFloat = 150
        static let barcodeMatchTolerance: CGFloat = 100

        static let greenColor: UIColor = .init(red: 19/255.0, green: 187/255.0, blue: 128/255.0, alpha: 1)
    }

    class TrackableBarcodeOverlayView: ALBarcodeOverlayView {

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        init(config: ALOverlayConfig, detectedBarcode: ALDetectedBarcode) {

            self.detectedBarcode = detectedBarcode
            super.init(config: config)
        }

        var detectedBarcode: ALDetectedBarcode

        // increase tappability.
        var tapAreaInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)

        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let largerFrame = self.bounds.inset(by: tapAreaInsets)
            return largerFrame.contains(point) ? self : nil
        }
    }

    // Some special error types.
    enum AnylineError: Error {
        case configError(msg: String)
    }

    private var configFileName: String

    private var scanView: ALScanView!

    private var totalScanned = 0

    private var isCancelOnResult: Bool {
        return true == scanView.scanViewConfig?.viewPluginConfig?.pluginConfig.cancelOnResult?.boolValue
    }

    private let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        if #available(iOS 13.0, *) {
            textView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        }
        return textView
    }()

    /// Used to track details about the barcode results which are currently showing on the ScanView
    private var scannedBarcodeDetails: [String: ALDetectedBarcode] = [:]

    private var selectedBarcodes = [ALDetectedBarcode]()

    @objc
    init(configFileName: String) {
        self.configFileName = configFileName
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        print("deinit BarcodeOverlayScanViewController")
    }

    init() {
        fatalError("call init with configFilename instead")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try setupAnyline(configFileName: configFileName)
        } catch {
            var errorMsg = "Anyline error: \(error.localizedDescription)"
            if let anylineError = error as? AnylineError {
                switch anylineError {
                case let .configError(msg):
                    errorMsg = "Unable to load Anyline config:\n\n\(msg)"
                }
            }
            showErrorAlert(errorMsg) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }

        addScanView(scanView: scanView)

        enableBarcodeOverlays()

        scanView.startCamera()
    }

    private func enableBarcodeOverlays() {

        scanView.enableBarcodeOverlays { [weak self] barcode in
            guard let self = self else { return [] }

            // (added block) new barcodes found; create and return views to be used as overlays
            self.scannedBarcodeDetails[barcode.label] = barcode
            return self.barcodeOverlayViews(for: barcode)

        } update: { [weak self] barcode, overlays in
            guard let self = self else { return }

            // (updated block) new barcode results; here is the chance to update related barcode overlay views
            var keyFound: String? = nil
            for (id, oldBarcode) in self.scannedBarcodeDetails {

                // found a barcode that is already being tracked
                if barcode.matches(otherBarcode: oldBarcode) {

                    // if this barcode's overlay need to be regenerated, call invalidate() on it.
                    if barcode.isSmall != oldBarcode.isSmall {
                        // one such case is when you need to show a different barcode because the size
                        // has changed.
                        keyFound = id
                        overlays.forEach { $0.invalidate() }
                    }
                }
            }
            if let keyFound = keyFound {
                // associated barcode view had been invalidated. The corresponding entry
                // should also be removed.
                self.scannedBarcodeDetails.removeValue(forKey: keyFound)
            }

        } delete: { [weak self] views in
            guard let self = self else { return }

            // (deleted block) views have been removed from the overlay container. Use this
            // to perform any related cleanup. Here, the tracking information for associated
            // barcode is removed.
            views.map { $0.label }.forEach { self.scannedBarcodeDetails.removeValue(forKey: $0) }
        }
    }

    /// Create and return a view for the barcode. Upon returning it, the SDK overlay engine will take
    /// over and manage the view's lifetime, so there is no need to keep a reference to the view.
    /// Modifying the view from this point on is also not advised.
    private func barcodeOverlayViews(for detectedBarcode: ALDetectedBarcode) -> [ALBarcodeOverlayView] {

        let overlayViewConfig = ALOverlayConfig(anchor: .center(),
                                                offsetX: .init(scaleType: .fixedPx(), scaleValue: 0),
                                                offsetY: .init(scaleType: .fixedPx(), scaleValue: 0),
                                                sizeX: .init(scaleType: .fixedPx(), scaleValue: 60),
                                                sizeY: .init(scaleType: .fixedPx(), scaleValue: 60))

        let overlayView = TrackableBarcodeOverlayView(config: overlayViewConfig, detectedBarcode: detectedBarcode)

        // create and lay out the subviews (imageView, label) for the overlayView, which alone has the overlay config
        // (which places it at the center of the detected barcode and is 60 by 60 large).
        let imageView = imageView(detectedBarcode: detectedBarcode)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        overlayView.addSubview(imageView)

        let label = label(detectedBarcode: detectedBarcode)
        label.translatesAutoresizingMaskIntoConstraints = false

        overlayView.addSubview(label)

        overlayView.addConstraints([
            imageView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: overlayView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: overlayView.heightAnchor),

            label.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        overlayView.addGestureRecognizer(tapGestureRecognizer)

        return [ overlayView ]
    }

    func isSelected(barcode: ALDetectedBarcode) -> Bool {
        return !selectedBarcodes
            .filter { $0.matches(otherBarcode: barcode) }
            .isEmpty
    }

    private func imageView(detectedBarcode: ALDetectedBarcode) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        if isSelected(barcode: detectedBarcode) {
            imageView.image = UIImage(named: detectedBarcode.isSmall ? "ic_far_green" : "ic_check_green")
        } else {
            imageView.image = UIImage(named: detectedBarcode.isSmall ? "ic_far_blue" : "ic_plus_blue")
        }
        return imageView
    }

    private func label(detectedBarcode: ALDetectedBarcode) -> UILabel {
        let label = PaddedLabel()
        label.text = detectedBarcode.barcode.value
        label.textColor = .white
        label.backgroundColor = Constants.greenColor.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center

        label.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.isHidden = detectedBarcode.isSmall || !isSelected(barcode: detectedBarcode)

        return label
    }

    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let overlayView = gestureRecognizer.view as? TrackableBarcodeOverlayView else {
            return
        }

        // the tap toggle the view between selected and unselected states, which is tracked in
        // selectedBarcodes.
        if let index = selectedBarcodes.firstIndex(where: { $0.matches(otherBarcode: overlayView.detectedBarcode) }) {
            selectedBarcodes.remove(at: index)
        } else {
            selectedBarcodes.append(overlayView.detectedBarcode)
        }

        // force a redraw of the overlay
        overlayView.invalidate()
    }

    private func setupAnyline(configFileName: String) throws {

        // Initialize the ScanViewConfig with an Anyline config read from a JSON file
        let scanViewConfigJSONStr = try type(of: self).anylineConfigString(from: configFileName)
        let scanViewConfig = try ALScanViewConfig.withJSONString(scanViewConfigJSONStr)

        // Initialize the ScanView.
        self.scanView = try ALScanView(frame: .zero,
                                       scanViewConfig: scanViewConfig)

        // Start the ScanViewPlugin. Remember to set the ScanPlugin delegate.
        if let scanViewPlugin = self.scanView.viewPlugin as? ALScanViewPlugin {
            scanViewPlugin.scanPlugin.delegate = self
        }

        try self.scanView.startScanning()
    }

    private static func anylineConfigString(from filename: String) throws -> String {
        // Passing filename with .json extension from previous VC
        guard let path = Bundle.main.path(forResource: filename, ofType: "", inDirectory: "AnylineConfigs.bundle") else {
            throw AnylineError.configError(msg: "no such path: \(filename)")
        }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path, isDirectory: false)),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw AnylineError.configError(msg: "unable to read config file from resource: \(path)")
        }
        return jsonString
    }

    private func addScanView(scanView: ALScanView) {
        self.view.addSubview(scanView)
        scanView.translatesAutoresizingMaskIntoConstraints = false
        scanView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scanView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scanView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scanView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}


extension BarcodeOverlayScanViewController: ALScanPluginDelegate {

    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {
        if isCancelOnResult {
            try? scanView.stopScanning()
        }
    }
}


extension BarcodeOverlayScanViewController: ResultViewControllerDelegate {

    func didDismissModalViewController(_ viewController: ResultViewController,
                                       restart: Bool) {
        guard restart else {
            self.navigationController?.popViewController(animated: false)
            return
        }
        try? self.scanView.startScanning()
    }
}


extension BarcodeOverlayScanViewController {

    private func showErrorAlert(_ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert: UIAlertController = .init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .default, handler: handler))
        self.navigationController?.present(alert, animated: true)
    }
}


fileprivate extension ALDetectedBarcode {

    func matches(otherBarcode: ALDetectedBarcode) -> Bool {
        let otherBarcodeMid = otherBarcode.logicalMidpoint()
        let midpoint = logicalMidpoint()
        let tolerance = BarcodeOverlayScanViewController.Constants.barcodeMatchTolerance
        return (otherBarcode.barcode.format == barcode.format &&
                otherBarcode.barcode.value == barcode.value &&
                hypot(otherBarcodeMid.x - midpoint.x, otherBarcodeMid.y - midpoint.y) <= tolerance)
    }

    func logicalMidpoint() -> CGPoint {
        let x = enclosingCGRect.origin.x + (enclosingCGRect.width) / 2
        let y = enclosingCGRect.origin.y + (enclosingCGRect.height) / 2
        return CGPoint(x: x, y: y)
    }

    var isSmall: Bool {
        return enclosingCGRect.height < 150
    }
}


fileprivate class PaddedLabel: UILabel {

    var padding: UIEdgeInsets

    init(padding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)) {
        self.padding = padding
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: padding)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
