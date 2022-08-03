//
//  TireViewController.swift
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 31.01.22.
//

import Foundation
import Anyline

@objc(TireViewController)
class TireViewController: ALBaseScanViewController, ALTireScanPluginDelegate {
    
    var tireScanViewPlugin : ALTireScanViewPlugin?
    
    @objc public enum TireConfigType: NSInteger {
        case tinConfig
        case tireSizeConfig
        case commercialTireConfig
    }
    
    @objc public var configType: TireConfigType = .tinConfig
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTirePlugin()
        setupFlipOrientationButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScanner()
    }
    
    func startScanner() {
        do {
            try tireScanViewPlugin?.start()
        } catch let error {
            print("Start error: \(error.localizedDescription)")
        }
    }
    
    func stopScanner() {
        do {
            try tireScanViewPlugin?.stop()
        } catch let error {
            print("Stop error: \(error.localizedDescription)")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        do {
            try tireScanViewPlugin?.stop()
        } catch let error {
            print("Stop error: \(error.localizedDescription)")
        }
    }
    
    func setupTirePlugin() {
        do {
            var tireConfig: ALBaseTireConfig = .init()
            
            let scanViewPluginConfig = ALScanViewPluginConfig.defaultTIN()
            scanViewPluginConfig.cutoutConfig.backgroundColor = .clear
            
            switch configType {
            case .tinConfig:
                tireConfig = ALTINConfig()
            case .tireSizeConfig:
                tireConfig = ALTireSizeConfig()
                scanViewPluginConfig.scanFeedbackConfig.style = .rect
            case .commercialTireConfig:
                tireConfig = ALCommercialTireIdConfig()
            }
            
            let tireScanPlugin = try ALTireScanPlugin.init(pluginID: "TIRE", delegate: self, tireConfig: tireConfig)
            tireScanViewPlugin = ALTireScanViewPlugin.init(scanPlugin: tireScanPlugin, scanViewPluginConfig: scanViewPluginConfig)
            
            if let scanView = ALScanView(frame: view.bounds, scanViewPlugin: tireScanViewPlugin) {
                scanView.flashButtonConfig = ALFlashButtonConfig(flashMode: .manualOff,
                                                                 flashAlignment: .topLeft,
                                                                 flashOffset: .zero)
                view.addSubview(scanView)
                scanView.translatesAutoresizingMaskIntoConstraints = false
                if #available(iOS 11.0, *) {
                    scanView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
                } else {
                    scanView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                }
                scanView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                scanView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                scanView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                scanView.startCamera()
            }
        } catch let error {
            print("Initialization error: \(error.localizedDescription)")
            showAlert(withTitle: "Initialization error", message: error.localizedDescription)
            self.stopScanner()
        }
    }
        
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: "Please try scanning again", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.startScanner()
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ALTireScanPluginDelegate
    func anylineTireScanPlugin(_ anylineTireScanPlugin: ALTireScanPlugin, didFind result: ALTireResult) {
        var resultData = [ALResultEntry]()
        resultData.append(ALResultEntry(title: title,
                                        value: String(result.result),
                                        shouldSpellOutValue: true))
        let jsonString = self.jsonString(fromResultData: resultData)
        enableLandscapeOrientation(false)
        self.anylineDidFindResult(jsonString, barcodeResult: "", image: result.image!, scanPlugin: anylineTireScanPlugin, viewPlugin: self.tireScanViewPlugin) {
            let vc = ALResultViewController(results: resultData)
            vc.imagePrimary = result.image
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

@objc class TireSizeViewController: TireViewController {
    
    override func viewDidLoad() {
        configType = TireConfigType.tireSizeConfig
        super.viewDidLoad()
    }
}

@objc class CommercialTireIdViewController: TireViewController {
    
    override func viewDidLoad() {
        configType = TireConfigType.commercialTireConfig
        super.viewDidLoad()
    }
}
