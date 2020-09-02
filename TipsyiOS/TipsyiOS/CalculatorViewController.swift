//
//  ViewController.swift
//  TipsyiOS
//
//  Created by Souvik Biswas on 02/09/20.
//  Copyright © 2020 Souvik Biswas. All rights reserved.
//

import UIKit
import Flutter

class CalculatorViewController: UIViewController {

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    var currentPct: Float = 0.1
    var stepperValue: Int = 2
    var finalBill: Float = 0.0

    @IBAction func tipChanged(_ sender: UIButton) {
        billTextField.endEditing(true)
        
        if sender.currentTitle == "0%" {
            zeroPctButton.isSelected = true
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = false
            currentPct = 0.0
        }
        if sender.currentTitle == "10%" {
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = true
            twentyPctButton.isSelected = false
            currentPct = 0.1
        }
        if sender.currentTitle == "20%" {
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = true
            currentPct = 0.2
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        stepperValue = Int(sender.value)
        splitNumberLabel.text = stepperValue.description
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let billAmount = ((billTextField.text ?? "0.0") as NSString).floatValue
        let billSplit = billAmount / Float(stepperValue)
        finalBill = billSplit + billSplit * currentPct
        
        let finalBillString = String(format: "%.2f", finalBill)
        
        print("Amount: \(finalBill), Count: \(Float(stepperValue)), Percent: \(currentPct*100)")
        
        let flutterEngine = ((UIApplication.shared.delegate as? AppDelegate)?.flutterEngine)!;
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil);
        self.present(flutterViewController, animated: true, completion: nil)
        
        let resultDataChannel = FlutterMethodChannel(name: "com.souvikbiswas.tipsy/result", binaryMessenger: flutterViewController.binaryMessenger)
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()

        jsonObject.setValue(finalBillString, forKey: "amount")
        jsonObject.setValue(stepperValue, forKey: "count")
        jsonObject.setValue(currentPct * 100, forKey: "percent")
        
        var convertedString: String? = nil
        
        do {
            let billData =  try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            convertedString = String(data: billData, encoding: String.Encoding.utf8)
            
        } catch let myJSONError {
            print(myJSONError)
        }
            
        resultDataChannel.invokeMethod("getCalculatedResult", arguments: convertedString)
    }
}


