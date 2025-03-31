//
//  ViewController.swift
//  calculatorApp2
//
//  Created by 김기태 on 3/27/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let resultLabel = UILabel()
    let buttonRows = [
        ["7", "8", "9", "+"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "*"],
        ["AC", "0", "=", "/"]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeLabel()
        
        let stackView = makeVerticalStackView()
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(350)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(resultLabel.snp.bottom).offset(60)
        }
    }
    
    //UI 구성하는 메서드
    func configureUI() {
        view.backgroundColor = .black
        
    }
    
    // 레이블 생성 메서드
    func makeLabel() {
        resultLabel.text = "0"
        resultLabel.backgroundColor = .black
        resultLabel.textColor = .white
        resultLabel.textAlignment = .right
        resultLabel.font = .boldSystemFont(ofSize: 60)
        
        view.addSubview(resultLabel)
        
        resultLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalToSuperview().offset(200)
            $0.height.equalTo(100)
        }
    }
    // 버튼 생성 메서드
    func makeButtons(titles: [String]) -> [UIButton] {
        return titles.map { title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 30)
            
            let operators = ["+", "-", "*", "/", "AC", "="]
            if operators.contains(title) {
                button.backgroundColor = .orange
            } else { button.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)
            }
            
            button.layer.cornerRadius = 40
            
            button.addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
            
            button.snp.makeConstraints {
                $0.height.equalTo(80)
                $0.width.equalTo(80)
            }
            return button
        }
    }
    
    
    // 가로 스택뷰 생성 메서드
    func makeHorizontalStackView(buttonTitles: [String]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: makeButtons(titles: buttonTitles))
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }
    
    // 세로 스택뷰 생성 메서드
    func makeVerticalStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttonRows.map { makeHorizontalStackView(buttonTitles: $0) } )
        stackView.axis = .vertical
        stackView.backgroundColor = .black
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
        
    }
    
    func calculate(expression: String) -> Int? {
        let expression = NSExpression(format: expression)
        if let result = expression.expressionValue(with: nil, context: nil) as? Int {
            return result
        } else {
            return nil
        }
    }
    //    let regex = try NSRegularExpression(pattern: pattern)
    
    // 연산자 두번연속 오지않게, 마지막에 연산자 오지않게( = 전에 숫자)
    //    @objc
    //    func handleButtonAction(_ sender: UIButton) {
    //        guard let buttonText = sender.currentTitle else { return }
    //        if buttonText == "AC" {
    //            resultLabel.text = "0"
    //
    //        } else if buttonText == "=" {
    //            if let text = resultLabel.text,
    //               let result = calculate(expression: text) {
    //                resultLabel.text = String(result)
    //            }
    //
    //        } else {
    //            if resultLabel.text == "0" {
    //                resultLabel.text = buttonText
    //            } else {
    //                resultLabel.text! += buttonText
    //            }
    //        }
    //    }
    @objc
    func handleButtonAction(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        switch buttonText {
        case "AC": resultLabel.text = "0"
        case "=":
            if let text = resultLabel.text,
               let result = calculate(expression: text) {
                resultLabel.text = String(result)
            }
        case "0":
            guard let currentText = resultLabel.text else { return }
            
            // 맨 앞 0이면 추가 x
            if currentText == "0" {
                return
            }
            
            // 연산자 뒤 0이면 추가 x
            let operators: Set<Character> = ["+", "-", "*", "/"]
            if let last = currentText.last, operators.contains(last) {
                return
            }
            
            // 나머지는 0 추가
            resultLabel.text! += "0"
            
            //            guard let buttonText = sender.currentTitle else { return }
            //
            //            // 맨 앞 0이면 추가 x
            //            if buttonText == "0" {
            //                return
            //            }
            
            //            // 연산자 뒤 0이면 추가 x
            //            let operators: Set<Character> = ["+", "-", "*", "/"]
            //            if let last = buttonText.last, operators.contains(last) {
            //                return
            //            }
            //            // 나머지는 0 추가
            //            resultLabel.text! += "0"
            
        case "+", "-", "*", "/":
            // 맨 앞 0이면 못들어옴.
            guard let currentText = resultLabel.text else { return }
            if currentText == "0" {
                return
            }
            // 연산자 뒤 못들어옴.
            let operators: Set<Character> = ["+", "-", "*", "/"]
            if let last = currentText.last, operators.contains(last) {
                return
            }
            // 입력된 연산자 그대로 추가
            resultLabel.text! += buttonText


            
        default:
            // 처음 누르는 경우 기본값(0)을 해당 숫자로 변경, 처음이 아니면 추가.
            if resultLabel.text! == "0" {
                resultLabel.text = buttonText
            } else {
                resultLabel.text! += buttonText
            }
            
        }
        
    }
    
    
}
