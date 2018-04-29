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
        return Int(self) != nil
    }

    func isDouble() -> Bool {
        return Double(self) != nil
    }
}

class ViewController: UIViewController {
    let operators: [String] = ["÷", "x", "-", "+", "="]
    var result: Double = 0 {
        didSet {
            if result == floor(result) {
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

    @IBAction func buttonWasPressed(_ sender: UIButton) {
        var buttonPressed = sender.currentTitle!

        if buttonPressed.isInt() || buttonPressed == "." {
            if let topOfStack = stack.popLast() {
                if topOfStack.isDouble() {
                    buttonPressed = topOfStack + buttonPressed
                }
                else {
                    stack.append(topOfStack)
                }
            }
            stack.append(buttonPressed)
        } else if buttonPressed == "C" {
            stack = ["0"]
        } else if buttonPressed == "+/-" {
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
        } else if operators.contains(buttonPressed) {
            if let topOfStack = stack.popLast() {
                if !operators.contains(topOfStack) {
                    stack.append(topOfStack)
                }
            }
            evaluateStack()
            if buttonPressed != "=" {
                updateUI()
                stack.append(buttonPressed)
            }
        } else {
            stack.append(buttonPressed)
        }

        updateUI()
    }

    func evaluateStack() {
        if stack.count == 3 {
            var left = Double(stack[0])!
            let op = stack[1]
            let right = Double(stack[2])!

            print(left)
            print(op)
            print(right)
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
    }

    func updateUI() {
        if let topOfStack = stack.last {
            print(topOfStack)
            if topOfStack.isDouble() {
                result = Double(topOfStack)!
            }
        }
    }
}

