//
//  ViewController.swift
//  Calculator
//
//  Created by Randy on 4/28/18.
//  Copyright © 2018 Randy Jimenez. All rights reserved.
//

import UIKit

extension String {
    func isInt() -> Bool {
        return isDouble() && Double(self)!.isInt()
    }

    func isDouble() -> Bool {
        return Double(self) != nil
    }
}

extension Double
{
    func isInt() -> Bool {
        return self == floor(self)
    }
}

class ViewController: UIViewController {
    var result: Double = 0 {
        didSet {
            if result.isInt()  {
                resultDisplay.text  = String(Int(result))
            } else {
                resultDisplay.text = String(result)
            }
        }
    }
    var stack: [String] = ["0"]

    @IBOutlet weak var resultDisplay: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultDisplay.adjustsFontSizeToFitWidth = true
        updateUI()
    }

    @IBAction func digitOrDecimalPressed(_ sender: UIButton) {
        var buttonPressed = sender.currentTitle!

        if let topOfStack = stack.popLast() {
            if topOfStack.isDouble() {
                buttonPressed = topOfStack + buttonPressed
            }
            else {
                stack.append(topOfStack)
            }
        }
        stack.append(buttonPressed)
        updateUI()
    }

    @IBAction func operatorPressed(_ sender: UIButton) {
        let buttonPressed = sender.currentTitle!
        
        if let topOfStack = stack.popLast() {
            if !["÷", "x", "-", "+", "="].contains(topOfStack) {
                stack.append(topOfStack)
            }
        }

        if stack.count == 3 {
            var left = Double(stack[0])!
            let op = stack[1]
            let right = Double(stack[2])!
            
            switch(op) {
            case "÷":
                left /= right
            case "x":
                left *= right
            case "-":
                left -= right
            default:
                left += right
            }
            stack = [String(left)]
        }

        updateUI()
        if buttonPressed != "=" {
            stack.append(buttonPressed)
        }
    }

    @IBAction func clearPressed(_ sender: UIButton) {
        stack = ["0"]
        updateUI()
    }
    
    @IBAction func negatePressed(_ sender: UIButton) {
        if var topOfStack = stack.popLast() {
            if topOfStack.isDouble() && Double(topOfStack) != 0 {
                if topOfStack.starts(with: "-") {
                    topOfStack = String(topOfStack.dropFirst())
                } else {
                    topOfStack = "-" + topOfStack
                }
                stack.append(topOfStack)
            }
        }
        updateUI()
    }

    @IBAction func percentPressed(_ sender: UIButton) {
        if let topOfStack = stack.popLast() {
            if topOfStack.isDouble() && Double(topOfStack) != 0 {
                stack.append(String(Double(topOfStack)! / 100))
            }
        }
        updateUI()
    }

    func updateUI() {
        if let topOfStack = stack.last {
            if topOfStack.isDouble() {
                result = Double(topOfStack)!
            }
        }
    }
}

