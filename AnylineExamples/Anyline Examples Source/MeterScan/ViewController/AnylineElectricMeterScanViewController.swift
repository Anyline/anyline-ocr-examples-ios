//
//  AnylineElectricMeterScanViewController.swift
//  AnylineExamples
//
//  Created by Philipp Müller on 08/11/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

import Foundation
import UIKit

@objc class AnylineElectricMeterScanViewController: UIViewController, AnylineEnergyModuleDelegate  {
    let kELMeterScanLicenseKey = kDemoAppLicenseKey;
    
    
    var anylineEnergyView: AnylineEnergyModuleView!;
    
    /*
     We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
     */
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Set the background color to black to have a nicer transition
        self.view.backgroundColor = UIColor.black;
        self.title = "Electric Meter";
        
        // Initializing the energy module. Its a UIView subclass. We set its frame to fill the whole screen
        let frame : CGRect = CGRect(x: UIScreen.main.applicationFrame.origin.x, y: UIScreen.main.applicationFrame.origin.y + (self.navigationController?.navigationBar.frame.size.height)!, width: UIScreen.main.applicationFrame.size.width, height: UIScreen.main.applicationFrame.size.height);
        self.anylineEnergyView = AnylineEnergyModuleView(frame: frame);
        
        do {
            // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
            // once we start receiving results.
            // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
            // we have to check the error object for the error message.
            try self.anylineEnergyView.setup(withLicenseKey: kELMeterScanLicenseKey, delegate: self);
        } catch let error as NSError {
            // Something went wrong. The error object contains the error description
            UIAlertView.init(title: "Setup Error",
                             message: error.debugDescription,
                             delegate: self,
                             cancelButtonTitle: "OK").show();
        }
        
        self.anylineEnergyView.translatesAutoresizingMaskIntoConstraints = false;
        
         // After setup is complete we add the module to the view of this view controller
        self.view.addSubview(self.anylineEnergyView);
        
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[moduleView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["moduleView" : self.anylineEnergyView]));
        
        let topGuide = self.topLayoutGuide;
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topGuide]-0-[moduleView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["moduleView" : self.anylineEnergyView, "topGuide" : topGuide]));
        
    }
    
    /*
     This method will be called once the view controller and its subviews have appeared on screen
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        /*
         This is the place where we tell Anyline to start receiving and displaying images from the camera.
         Success/error tells us if everything went fine.
         */
        do {
            try self.anylineEnergyView.startScanning();
        } catch let error as NSError {
            // Something went wrong. The error object contains the error description
            UIAlertView.init(title: "Start Scanning Error",
                             message: error.debugDescription,
                             delegate: self,
                             cancelButtonTitle: "OK").show();
        }
        
    }
    
    /*
     Cancel scanning to allow the module to clean up
     */
    override func viewWillDisappear(_ animated: Bool) {
        do{
            try self.anylineEnergyView.cancelScanning();
        } catch let error as NSError {
            print("\(error.debugDescription)");
        }
        
       super.viewWillDisappear(animated);
    }
    
    // MARK: AnylineEnergyModuleDelegate Methodes
    /*
     The main delegate method Anyline uses to report its scanned codes
     */
    func anylineEnergyModuleView(_ anylineEnergyModuleView: AnylineEnergyModuleView!, didFindScanResult scanResult: String!, cropImage image: UIImage!, fullImage: UIImage!, in scanMode: ALScanMode) {
        let resultVC : ALMeterScanResultViewController = ALMeterScanResultViewController();
        /*
         To present the scanned result to the user we use a custom view controller.
         */
        resultVC.scanMode = scanMode;
        resultVC.meterImage = image;
        resultVC.result = scanResult;
        
        self.navigationController?.pushViewController(resultVC, animated: true);
    }
}
