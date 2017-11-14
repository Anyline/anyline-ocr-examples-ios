//
//  AnylineBottlecapScanViewController.swift
//  AnylineExamples
//
//  Created by Philipp Müller on 08/11/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

import Foundation
import UIKit


// The controller has to conform to AnylineOCRModuleDelegate to be able to receive results
@objc class AnylineBottlecapScanViewController: UIViewController, AnylineOCRModuleDelegate  {
    let kBottlecapLicenseKey = kDemoAppLicenseKey;
    
    
    var anylineOCRView: AnylineOCRModuleView!;
    
    /*
     We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
     */
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Set the background color to black to have a nicer transition
        self.view.backgroundColor = UIColor.black;
        self.title = "Bottlecap";
        
        // Initializing the OCR module. Its a UIView subclass. We set its frame to fill the whole screen
        let frame : CGRect = CGRect(x: UIScreen.main.applicationFrame.origin.x, y: UIScreen.main.applicationFrame.origin.y + (self.navigationController?.navigationBar.frame.size.height)!, width: UIScreen.main.applicationFrame.size.width, height: UIScreen.main.applicationFrame.size.height);
        self.anylineOCRView = AnylineOCRModuleView(frame: frame);
        
        //Setup OCR Scan Config - See Anyline Documentation for more information.
        let config: ALOCRConfig = ALOCRConfig();
        config.scanMode = ALOCRScanMode.ALGrid;
        config.charHeight = ALRangeMake(21, 97);
        config.tesseractLanguages = ["bottlecap"];
        config.charWhiteList = "123456789ABCDEFGHJKLMNPRSTUVWXYZ";
        config.minConfidence = 75;
        config.validationRegex = "^[0-9A-Z]{3}\n[0-9A-Z]{3}\n[0-9A-Z]{3}";
        
        config.charCountX = 3;
        config.charCountY = 3;
        config.charPaddingXFactor = 0.3;
        config.charPaddingYFactor = 0.5;
        config.isBrightTextOnDark = true;
        
        do {
            // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
            // once we start receiving results.
            // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
            // we have to check the error object for the error message.
            try self.anylineOCRView.setup(withLicenseKey: self.kBottlecapLicenseKey, delegate: self, ocrConfig: config);
        } catch let error as NSError {
            // Something went wrong. The error object contains the error description
            UIAlertView.init(title: "Setup Error",
                             message: error.debugDescription,
                             delegate: self,
                             cancelButtonTitle: "OK").show();
        }
        //Setup Anyline View Configuration and add to ModuleView
        let bottlecapConfigPath : String = Bundle.main.path(forResource: "bottlecap_config", ofType: "json")!;
        let bottlecapConfig : ALUIConfiguration = ALUIConfiguration.cutoutConfiguration(fromJsonFile: bottlecapConfigPath)!;
        self.anylineOCRView.currentConfiguration = bottlecapConfig;
        
        // After setup is complete we add the module to the view of this view controller
        self.view.addSubview(self.anylineOCRView);
    }
    
    /*
     This method will be called once the view controller and its subviews have appeared on screen
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        // We use this subroutine to start Anyline. The reason it has its own subroutine is
        // so that we can later use it to restart the scanning process.
        self.startAnyline();
    }
    
    /*
     Cancel scanning to allow the module to clean up
     */
    override func viewWillDisappear(_ animated: Bool) {
        do {
            try self.anylineOCRView.cancelScanning();
        } catch let error as NSError {
            print("\(error.debugDescription)");
        }
        
        super.viewWillDisappear(animated);
    }
    
    /*
     This method is used to tell Anyline to start scanning. It gets called in
     viewDidAppear to start scanning the moment the view appears. Once a result
     is found scanning will stop automatically (you can change this behaviour
     with cancelOnResult:). When the user dismisses self.identificationView this
     method will get called again.
     */
    func startAnyline() {
        do {
            try self.anylineOCRView.startScanning();
        } catch let error as NSError {
            // Something went wrong. The error object contains the error description
            UIAlertView.init(title: "Start Scanning Error",
                             message: error.debugDescription,
                             delegate: self,
                             cancelButtonTitle: "OK").show();
        
        }
    }
    
    // MARK: AnylineOCRModuleDelegate
    
    /*
     This is the main delegate method Anyline uses to report its results
     */
    func anylineOCRModuleView(_ anylineOCRModuleView: AnylineOCRModuleView!, didFind result: ALOCRResult!) {
        // We are done. Cancel scanning
        do {
            try self.anylineOCRView.cancelScanning();
        } catch let error as NSError {
            print("\(error.debugDescription)");
        }
        
        // Display an overlay showing the result
        let image : UIImage = UIImage(imageLiteralResourceName: "bottle_background");
        let overlay : ALResultOverlayView = ALResultOverlayView(frame: self.view.bounds);
        
        weak var welf = self;
        weak var woverlay: ALResultOverlayView? = overlay;
        overlay.setImage(image);
        overlay.setText(result.result as String!);
        overlay.setTouchDownBlock( { () in
            // Remove the view when touched and restart scanning
            welf?.startAnyline();
            woverlay?.removeFromSuperview();
        });
        
        self.view.addSubview(overlay);
        
    }
}
