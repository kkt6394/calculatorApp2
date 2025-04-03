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
    let operators: Set<Character> = ["+", "-", "*", "/"]
    
    
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
    
    // UI 구성하는 메서드
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
        
        let operators: Set<String> = ["+", "-", "*", "/", "AC", "="] // Set으로 탐색 속도 향상
        
        return titles.map { title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 30)
            
            //            if operators.contains(title) {
            //                button.backgroundColor = .orange
            //            } else { button.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)
            //            }
            //삼항 연산자로 간결하게 표현
            button.backgroundColor = operators.contains(title) ?
                .orange : UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)
            
            button.layer.cornerRadius = 40
            
            button.addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
            
            button.snp.makeConstraints { $0.size.equalTo(80) }
            
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
    
    // 계산 메서드
    func calculate(expression: String) throws -> Int {
        let expression = NSExpression(format: expression)
        if let result = expression.expressionValue(with: nil, context: nil) as? Int {
            return result
        } else {
            throw CalculateError.calculationIsNil
        }
    }
    
    // 알럿 메서드
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
        
    }
    
    // 커스텀 에러
    enum CalculateError: Error {
        case invalidOperator
        case calculationIsNil
    }
    
    // resultLabel에 띄워져 있는 마지막 문자가 연산자일 경우 유효성 검사해보는 메서드
    func validateText(_ text: String) throws {
        if let lastText = text.last, operators.contains(lastText) {
            throw CalculateError.invalidOperator
        }
    }
    
    // 버튼 액션 담당
    @objc
    func handleButtonAction(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        
        switch buttonText {
        case "AC": resultLabel.text = "0"
            
            // do try catch 사용해보기 ( 레이블의 마지막이 연산자인 경우 알럿띄우기 )
        case "=":
            // do 안에서 발생할 수 있는 모든 오류들을 처리해줘야 함.
            do {
                guard let text = resultLabel.text else { return }
                
                try validateText(text) // 마지막 문자가 연산자인 경우
                // 에러가 발생하지 않으면 do의 나머지 부분 실행됨.
                let result = try calculate(expression: text)
                resultLabel.text = String(result)
                
                
            } catch {
                switch error as? CalculateError {
                case .invalidOperator:
                    showAlert(message: "마지막에 연산자가 올 수 없습니다.") // validateText 메서드 오류 시 catch
                case .calculationIsNil:
                    showAlert(message: "연산이 틀렸습니다.")
                default:
                    showAlert(message: "")
                    
                }
            }
            
            
        case "0":
            // 레이블에 띄워져 있는 숫자
            guard let currentText = resultLabel.text else { return }
            
            // 맨 앞 0이면 추가 x
            if currentText == "0" {
                return
            }
            
            // 연산자 뒤  추가 x
            if let last = currentText.last, operators.contains(last) {
                //                resultLabel.text = String(currentText.dropLast()) + buttonText
                return
            } else {
                
                // 나머지는 0 추가
                resultLabel.text! += "0"
            }
            
        case "+", "-", "*", "/":
            // 맨 앞 0이면 못들어옴.
            guard let currentText = resultLabel.text else { return }
            if currentText == "0" {
                return
            }
            //            let operators: Set<Character> = ["+", "-", "*", "/"]    // 전역함수로 뺌.
            
            // 연산자 뒤면 현재로 바꾸기
            if let last = currentText.last, operators.contains(last) {
                resultLabel.text = String(currentText.dropLast()) + buttonText
            } else {
                // 입력된 연산자 그대로 추가
                resultLabel.text! += buttonText
            }
            
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
