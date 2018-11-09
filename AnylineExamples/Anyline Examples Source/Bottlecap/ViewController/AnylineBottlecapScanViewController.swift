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
@objc class AnylineBottlecapScanViewController: UIViewController, ALOCRScanPluginDelegate  {
    let kBottlecapLicenseKey = "eyJzY29wZSI6WyJBTEwiXSwicGxhdGZvcm0iOlsiaU9TIiwiQW5kcm9pZCIsIldpbmRvd3MiXSwidmFsaWQiOiIyMDE3LTA4LTMwIiwibWFqb3JWZXJzaW9uIjoiMyIsImlzQ29tbWVyY2lhbCI6ZmFsc2UsInRvbGVyYW5jZURheXMiOjYwLCJpb3NJZGVudGlmaWVyIjpbImlvLmFueWxpbmUuZXhhbXBsZXMuYnVuZGxlIl0sImFuZHJvaWRJZGVudGlmaWVyIjpbImlvLmFueWxpbmUuZXhhbXBsZXMuYnVuZGxlIl0sIndpbmRvd3NJZGVudGlmaWVyIjpbImlvLmFueWxpbmUuZXhhbXBsZXMuYnVuZGxlIl19CkIxbU5LZEEvb0JZMlBvRlpsVGV4d3QraHltZTh1S25ON1ZYUStXbE1DY2dYc3RjTnJTL2ZOWVduSHJaSUVORk0vbmNFYWdlVU9Vem9tbmhFNG1tTFY1c3Mxbi8zc2tBQjdjM3pmd25MNkV2Mmx4Y1k4L0htN3Bna2t0K01NanRYODdXMTdWNjBGZWdXTmpXbWF0dmNJSHRFMkhmTEdjUkprQ3BHNFpacm5KWEltVnlkSVJtQmNsamwvWktuZzY1Nm5Rb3ZhMUZzc1p5Q2Vsb3VXSVhpRi9Odk1EcmVraUlaR2JreWVTRk9TT0VxLzgra0xFdHlmZG1yUy8vRjNVZ055YWtXN3NRQXFlNjlUQmN6ak5kVXdQU1lnY3BnSXd0d2puVUJsV2FmdGJ3aW9EKzlNRkowc1JFR2p0OFd5REJ6RHRZSi9EL3NRUm5sSXA2akFjQTNBQT09";
    
    
    var anylineOCRView: AnylineOCRModuleView!;
    
    // The Anyline plugins used to scan
    var ocrScanPlugin : ALOCRScanPlugin!;
    var ocrScanViewPlugin : ALOCRScanViewPlugin!;
    var scanView : ALScanView!;
    
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
        
        //Setup OCR Scan Config - See Anyline Documentation for more information.
        let config: ALOCRConfig = ALOCRConfig();
        config.scanMode = ALOCRScanMode.ALGrid;
        config.charHeight = ALRangeMake(21, 97);
        
        do {
            //Set Language files used for scanning
            let languagePath : String = Bundle.main.path(forResource: "bottlecap", ofType: "traineddata")!;
            try config.setLanguages([languagePath], error: ());
        } catch _ as NSError {
          //Handle errors here.
        }
        config.charWhiteList = "123456789ABCDEFGHJKLMNPRSTUVWXYZ";
        config.minConfidence = 75;
        config.validationRegex = "^[0-9A-Z]{3}\n[0-9A-Z]{3}\n[0-9A-Z]{3}";
        
        config.charCountX = 3;
        config.charCountY = 3;
        config.charPaddingXFactor = 0.3;
        config.charPaddingYFactor = 0.5;
        config.isBrightTextOnDark = true;
        
        //Load Anyline ScanViewPluginConfig
        let bottlecapConfigPath : String = Bundle.main.path(forResource: "bottlecap_config", ofType: "json")!;
        let bottlecapUIConfig : ALScanViewPluginConfig = ALScanViewPluginConfig.init(jsonFilePath: bottlecapConfigPath)!;

        
        // Initializing the energy module. Its a UIView subclass. We set its frame to fill the whole screen
        do {
            // Init. ScanPlugin with ID, licenseKey, OCRConfig and delegate
            self.ocrScanPlugin = try ALOCRScanPlugin.init(pluginID: "OCR", licenseKey: kBottlecapLicenseKey, delegate: self, ocrConfig: config);
            
            //Set ScanViewPluginConfig and scanPluin for the ALOCRScanViewPlugin
            self.ocrScanViewPlugin = ALOCRScanViewPlugin.init(scanPlugin: self.ocrScanPlugin, scanViewPluginConfig: bottlecapUIConfig);
            
            //Setup ScanView with frame size and the ocrScanViewPlugin
            self.scanView = ALScanView.init(frame: frame, scanViewPlugin: self.ocrScanViewPlugin);
        } catch _ as NSError {
            //Handle error here
        }
        
        self.scanView.translatesAutoresizingMaskIntoConstraints = false;
        
        //Add Anyline to view hierachy
        self.view.addSubview(self.scanView);
        //Start Camera with Anyline
        self.scanView.startCamera();
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
            try self.ocrScanViewPlugin.stop();
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
            try self.ocrScanViewPlugin.start();
        } catch let error as NSError {
            // Something went wrong. The error object contains the error description
            UIAlertView.init(title: "Start Scanning Error",
                             message: error.debugDescription,
                             delegate: self,
                             cancelButtonTitle: "OK").show();
        
        }
    }
    
    // MARK: ALOCRScanPluginDelegate
    
    /*
     This is the main delegate method Anyline uses to report its results
     */
    func anylineOCRScanPlugin(_ anylineOCRScanPlugin: ALOCRScanPlugin, didFind result: ALOCRResult) {
        // We are done. Cancel scanning
        do {
            try self.ocrScanViewPlugin.stop();
        } catch let error as NSError {
            print("\(error.debugDescription)");
        }
        
        // Display an overlay showing the result
        let image : UIImage = UIImage(imageLiteralResourceName: "bottle_background");
        let overlay : ALResultOverlayView = ALResultOverlayView(frame: self.view.bounds);
        
        weak var welf = self;
        weak var woverlay: ALResultOverlayView? = overlay;
        overlay.setImage(image);
        overlay.setText(result.result as String);
        overlay.setTouchDownBlock( { () in
            // Remove the view when touched and restart scanning
            welf?.startAnyline();
            woverlay?.removeFromSuperview();
        });
        
        self.view.addSubview(overlay);
    }
}
