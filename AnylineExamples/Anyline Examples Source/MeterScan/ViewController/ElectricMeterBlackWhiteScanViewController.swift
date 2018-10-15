//
//  ElectricMeterBlackWhiteScanViewController.swift
//  AnylineExamples
//
//  Created by Daniel Albertini on 01/06/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

import Foundation
import UIKit

@objc class ElectricMeterBlackWhiteScanViewController: ALBaseScanViewController, AnylineEnergyModuleDelegate {
    
    var anylineEnergyView : AnylineEnergyModuleView!;
    
    let kELMeterScanLicenseKey = kDemoAppLicenseKey;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Set the background color to black to have a nicer transition
        self.view.backgroundColor = UIColor.black
        
        self.title = "Electric Meter";
        // Initializing the energy module. Its a UIView subclass. We set its frame to fill the whole screen
        
        self.anylineEnergyView = AnylineEnergyModuleView.init(frame: self.view.bounds);

        do {
            try self.anylineEnergyView.setup(withLicenseKey: kELMeterScanLicenseKey, delegate: self);
        } catch _ as NSError {
            
        }
    
        self.anylineEnergyView.translatesAutoresizingMaskIntoConstraints = false;
        do {
            try self.anylineEnergyView.setScanMode(ALScanMode.analogMeter);
        } catch {}
        
      
        self.view.addSubview(self.anylineEnergyView);
        self.view.sendSubview(toBack: self.anylineEnergyView);
        
        self.anylineEnergyView.enableReporting(UserDefaults.al_reportingEnabled());
        
        self.controllerType = ALScanHistoryElectricMeter;
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        do {
            try self.anylineEnergyView.cancelScanning()
        } catch {}
    }
    
    func anylineEnergyModuleView(_ anylineEnergyModuleView: AnylineEnergyModuleView, didFindScanResult scanResult: String, cropImage image: UIImage, fullImage: UIImage, in scanMode: ALScanMode) {
        
        self.anylineDidFindResult(scanResult, barcodeResult:"", image: image, module: anylineEnergyModuleView) {() in
            let vc = ALMeterScanResultViewController.init();
            
            vc.scanMode = scanMode;
            vc.meterImage = image;
            vc.result = scanResult;
            
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    func anylineEnergyModuleView(_ anylineEnergyModuleView: AnylineEnergyModuleView, didFind scanResult: ALEnergyResult) {
        self.anylineDidFindResult(String(scanResult.result), barcodeResult:"", image: scanResult.image, module: anylineEnergyModuleView) {() in
            let vc = ALMeterScanResultViewController.init();
            
            vc.scanMode = scanResult.scanMode;
            vc.meterImage = scanResult.image;
            vc.result = String(scanResult.result);
            
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
}
