//
//  ViewController.swift
//  QRScanner
//
//  Created by Mac mini on 02/11/16.
//  Copyright © 2016 SIPL. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CodeScanDelegate {

    @IBOutlet var scanCode: CodeScan! = CodeScan.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ScanClicked(_ sender: AnyObject) {
        scanCode.codeScanDelegate = self
        scanCode.ScanCode()
    }
    
    //MARK:- CodeScanDelegate
    
    func CodeScanSuccedd(Code: String) {
        // Implementation After Getting Code
        print("\(Code)")
    }
    
    func CodeScanFail(ErrorMessage: String) {
        // Sacn Fail/Error
        print("\(ErrorMessage)")
    }

}

