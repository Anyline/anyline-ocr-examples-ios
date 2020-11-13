//
//  ElectricMeterBlackWhiteScanViewController.swift
//  AnylineExamples
//
//  Created by Daniel Albertini on 01/06/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

import Foundation
import UIKit

@objc class ElectricMeterBlackWhiteScanViewController: ALBaseScanViewController, ALMeterScanPluginDelegate {
    
    // The Anyline plugins used to scan
    var meterScanViewPlugin : ALMeterScanViewPlugin!;
    var meterScanPlugin : ALMeterScanPlugin!;
    var scanView : ALScanView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Set the background color to black to have a nicer transition
        self.view.backgroundColor = UIColor.black
        
        self.title = "Electric Meter";
    
    
        do {
            self.meterScanPlugin = try ALMeterScanPlugin.init(pluginID:"ENERGY", delegate: self);
            try self.meterScanPlugin.setScanMode(ALScanMode.analogMeter);
            
            self.meterScanViewPlugin = ALMeterScanViewPlugin.init(scanPlugin: self.meterScanPlugin);
            // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
            self.scanView = ALScanView.init(frame: self.view.bounds, scanViewPlugin: self.meterScanViewPlugin);
        } catch _ as NSError {
            //Handle error here
        }
      
        //Add Anyline to view hierachy
        self.view.addSubview(self.scanView);
        //Start Camera with Anyline
        self.scanView.startCamera();
        
        self.view.sendSubviewToBack(self.scanView);
        
        self.meterScanPlugin.enableReporting(UserDefaults.al_reportingEnabled());
        
        self.controllerType = ALScanHistoryElectricMeter;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        //Stop Anyline
        do {
            try self.meterScanViewPlugin.stop();
        } catch {}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        //Start Anyline
        do {
            try self.meterScanViewPlugin.start();
        } catch {}
    }
    
    func anylineMeterScanPlugin(_ anylineMeterScanPlugin: ALMeterScanPlugin, didFind scanResult: ALMeterResult) {
        self.anylineDidFindResult(scanResult.result as String, barcodeResult:"", image: scanResult.image, scanPlugin: anylineMeterScanPlugin, viewPlugin: self.meterScanViewPlugin, completion: {() in
            let vc = ALMeterScanResultViewController.init();
            
            vc.scanMode = scanResult.scanMode;
            vc.meterImage = scanResult.image;
            vc.result = scanResult.result as String;
            
            self.navigationController?.pushViewController(vc, animated: true);
        });
    }
}
