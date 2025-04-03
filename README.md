[![Typing SVG](https://readme-typing-svg.demolab.com?font=Bungee+Tint&size=35&pause=1000&color=F73B98&width=435&lines=Calculator+II)](https://git.io/typing-svg)

# 프로젝트 소개
Swift 기반으로 제작된 간단한 사칙연산 계산기 애플리케이션입니다.

UIKit과 SnapKit을 사용하여 UI를 구성하였으며, 연산 기능을 포함한 기본적인 계산기 동작을 구현하였습니다.



# 주요 기능


+ 사칙연산 지원: +, -, *, / 연산 수행 가능
+ 결과 표시: 연산 후 결과를 UILabel에 출력
+ 입력 유효성 검사: 연산자 입력 오류 방지 (do-try-catch 활용)
+ "AC" 버튼: 입력 초기화 기능 제공
+ 예외 처리: do-try-catch를 사용하여 연산 중 발생할 수 있는 오류를 안전하게 처리



# 사용 기술


+ Swift
+ UIKit
+ SnapKit
+ NSExpression을 이용한 연산 처리



# 코드 설명


## 1. UI 구성 (configureUI, makeLabel, makeButtons 등)


+ UILabel을 사용하여 결과를 표시하는 화면을 구성
+ UIButton을 활용하여 숫자 및 연산자 버튼을 생성
+ UIStackView를 이용하여 버튼을 정렬
+ SnapKit을 이용하여 오토레이아웃 적용


## 2. 계산 기능 (calculate 메서드)


+ NSExpression을 활용하여 문자열로 입력된 수식을 계산
+ 계산 결과가 nil일 경우 예외 발생


## 3. 버튼 액션 처리 (handleButtonAction 메서드)


+ switch-case 문을 활용하여 버튼의 역할을 구분
+ AC 버튼 클릭 시 화면을 초기화
+ 숫자 버튼 클릭 시 입력값을 업데이트
+ 연산자 버튼 클릭 시 연산자가 연속적으로 입력되지 않도록 검사
+ = 버튼 클릭 시 do-try-catch를 활용하여 계산 수행 및 예외 처리


## 4. 예외 처리 (do-try-catch)


+ CalculateError 열거형을 정의하여 오류 유형을 구분
+ validateText 메서드를 통해 마지막 입력이 연산자인 경우 예외 처리
+ 연산 중 오류 발생 시 UIAlertController를 사용하여 사용자에게 알림 표시



# 실행 방법


1. Xcode에서 프로젝트를 열고 실행 (Cmd + R)
2. 화면의 버튼을 눌러 계산 기능을 테스트
3. 잘못된 입력이 있을 경우 경고 메시지가 나타나는지 확인



# 향후 개선 사항


+ 소수점 연산 지원
+ 연산 내역 저장 기능 추가
+ 디자인 개선 및 애니메이션 추가



# 개발자 정보


+ 이름: 김기태

+ 개발일: 2025-03-27
