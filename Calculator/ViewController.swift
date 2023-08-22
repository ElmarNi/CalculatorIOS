//
//  ViewController.swift
//  Calculator
//
//  Created by Elmar Ibrahimli on 27.07.23.
//

import UIKit

class ViewController: UIViewController {

    let buttonsStackView = UIStackView()
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    var firstNumber = ""
    var secondNumber = ""
    var operation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(buttonsStackView)
        view.addSubview(label)
    }
    override func viewDidLayoutSubviews() {
        configureViews()
    }
    
    private func configureViews() {
        label.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: 200)
        buttonsStackView.frame = CGRect(x: 0,
                                        y: view.safeAreaInsets.top + 200,
                                        width: view.frame.width,
                                        height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 200)
        
        let buttonWidth = buttonsStackView.frame.width / 4
        let buttonHeight = buttonsStackView.frame.height / 5
        let operations = ["÷", "x", "-", "+", "="]
        let clearAndZero = ["clear", "0"]
        for i in 0...(clearAndZero.count - 1) {
            let button: UIButton = {
                let btn = UIButton()
                btn.setTitle(clearAndZero[i], for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .gray.withAlphaComponent(0.8)
                btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
                btn.layer.borderWidth = 1
                return btn
            }()
            buttonsStackView.addSubview(button)
            button.frame = CGRect(x: 0,
                                  y: i == 0 ? 0 : buttonsStackView.frame.height - buttonHeight,
                                  width: buttonWidth * 3,
                                  height: buttonHeight)
            
            button.addTarget(self, action: #selector(buttonsHoldDown(_:)), for: .touchDown)
            
            if i == 0 {
                button.addTarget(self, action: #selector(clearButtonTapped(_:)), for: .touchUpInside)
            }
            else {
                button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
            }
        }
        
        for i in 0...(operations.count - 1) {
            let button: UIButton = {
                let btn = UIButton()
                btn.setTitle(operations[i], for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .systemOrange
                btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
                btn.layer.borderWidth = 1
                return btn
            }()
            buttonsStackView.addSubview(button)
            button.frame = CGRect(x: view.frame.width - buttonWidth, y: buttonHeight * CGFloat(i), width: buttonWidth, height: buttonHeight)
            button.addTarget(self, action: #selector(operationButtonTapped(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(operationButtonsHoldDown(_:)), for: .touchDown)
        }
        
        for i in 1...9 {
            let button: UIButton = {
                let btn = UIButton()
                btn.setTitle("\(i)", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .gray.withAlphaComponent(0.8)
                btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
                btn.layer.borderWidth = 1
                return btn
            }()
            
            var buttonX: CGFloat = 0
            var buttonY: CGFloat = 0
            if i >= 1 && i <= 3 {
                buttonX = buttonWidth * CGFloat(i - 1)
                buttonY = buttonsStackView.frame.height - buttonHeight * 2
            }
            else if i >= 4 && i <= 6 {
                buttonX = buttonWidth * CGFloat(i - 4)
                buttonY = buttonsStackView.frame.height - buttonHeight * 3
            }
            else {
                buttonX = buttonWidth * CGFloat(i - 7)
                buttonY = buttonsStackView.frame.height - buttonHeight * 4
            }
            button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonsHoldDown(_:)), for: .touchDown)
            buttonsStackView.addSubview(button)
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        }
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        if operation == "=" {
            firstNumber = ""
            secondNumber = ""
            operation = ""
            label.text = nil
        }
        if let btnText = sender.titleLabel?.text {
            if var text = label.text {
                text += "\(btnText)"
                label.text = text
            }
            else {
                if btnText != "0" {
                    label.text = "\(btnText)"
                }
            }
        }
        sender.backgroundColor = .gray.withAlphaComponent(0.8)
    }
    
    @objc private func clearButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = .gray.withAlphaComponent(0.8)
        label.text = nil
        operation = ""
        firstNumber = ""
        secondNumber = ""
    }
    
    @objc private func buttonsHoldDown(_ sender: UIButton) {
        sender.backgroundColor = .gray.withAlphaComponent(1)
    }
    
    @objc private func operationButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = .systemOrange

        if let btnText = sender.titleLabel?.text, btnText != "=" {
            firstNumber = label.text ?? ""
            operation = btnText
            label.text = nil
        }
        if let btnText = sender.titleLabel?.text, btnText == "=", !firstNumber.isEmpty, !operation.isEmpty {
            if operation == "=" {
                firstNumber = ""
                secondNumber = ""
                operation = ""
                label.text = nil
                return
            }
            
            secondNumber = label.text ?? ""
            if let firstNumber = Int(firstNumber),
               let secondNumber = Int(secondNumber)
            {
                switch operation {
                case "+":
                    label.text = "\(firstNumber + secondNumber)"
                case "-":
                    label.text = "\(firstNumber - secondNumber)"
                case "x":
                    label.text = "\(firstNumber * secondNumber)"
                default:
                    if firstNumber % secondNumber == 0 {
                        label.text = "\(firstNumber / secondNumber)"
                    }
                    else {
                        label.text = "\(Float(firstNumber) / Float(secondNumber))"
                    }
                }
            }
            operation = btnText
        }
    }
    
    @objc private func operationButtonsHoldDown(_ sender: UIButton) {
        sender.backgroundColor = .systemOrange.withAlphaComponent(0.8)
    }
    
}

