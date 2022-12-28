# 1. 변수는 값을 저장할 수 있는 메모리의 특정 번지에 붙이는 이름
## - 하나의 변수에는 하나의 값만 저장할 수 있음
## - 예약어는 변수명으로 사용 불가능
## - 변수명의 첫글자는 문자 또는 _, $이여야하고 숫자는 첫 글자로 올 수 없음
## - 변수명은 대소문자를 구분 => Age와 age는 다른 변수
## - 변수명은 한글을 포함하지 않는 것이 좋음
## - 변수는 선언된 블록 내에서만 사용가능

# 2. 자바의 기본 타입은 총 8개
## - 정수타입 : byte(1바이트), char(2바이트), short(2바이트), int(4바이트), long(8바이트)
## - 실수타입 : float(4바이트), double(8바이트)
## - 논리타입 : boolean(1바이트)
## - long balance = 30000000000;은 오류가 나오므로 long balance = 30000000000L;이라고 해주어야 함
## - float는 소수점 7자리, double은 소수점 15자리
## - boolean타입은 숫자로는 표현안되고 무조건 false/true만 가능

# 3. String타입
## - 작은 따옴표로 감싼 문자는 char타입 변수에 저장되어 유니코드로 저장
## - 하지만 큰 따옴표로 감싼 문자 또는 여러 개의 문자들은 유니코드로 변환되지 않음
## - 큰 따옴표로 감싼 문자들은 "문자열"이라고 함
## - String타입은 자바의 기본 타입이 아니라 클래스 타입

# 4. 진수
## - 2진수 : 0b 또는 0B로 시작하고 0과 1로 구성
## - 8진수 : 0으로 시작하고 0 ~ 7로 구성
## - 10진수 : 소수점이 없는 0 ~ 9로 구성
## - 16진수 : 0x 또는 0X로 시작하고 0 ~ 9와 A(a) ~ F(f)로 구성

# 5. 이스케이프 문자
## - \t : 탭만큼 띄움
## - \n : 줄바꿈(라인 피드)
## - \r : 캐리지리턴
## - \" : "출력
## - \' : '출력
## - \\ : \출력
## - \u16진수 : 16진수 유니코드에 해당하는 문자 출력

# 6. 출력
## - System.out.println() : 마지막에 엔터기능이 있어 다음 출력문은 다음줄부터 출력됨
## - System.out.print() : 마지막에 엔터기능이 없어 \n이 없는 이상 해당 줄에 계속 출력됨

# 7. 자동 타입 변환
## - 허용 범위가 작은 타입이 혀용 범위가 큰 타입으로 저장될 때 발생
## - byte < short < int < long < float < double
## - char타입의 허용 범위는 음수를 포함하지 않는데 byte 타입은 음수를 포함하기 때문에 자동 타입 변환이 안 됨
## - char타입은 byte와 short로는 자동 타입 변환 불가

# 8. 문자열을 기본 타입으로 강제 타입 변환
## - ex) "12", "3.5"를 정수 및 실수 타입으로 변환
## - String => byte : Byte.parseByte(변수명)
## - String => short : Short.parseShort(변수명)
## - String => int : Integer.parseInt(변수명)
## - String => long : Long.parseLong(변수명)
## - String => float : Float.parseFloat(변수명)
## - String => double : Double.parseDouble(변수명)
## - String => boolean : Boolean.parseBoolean(변수명)
## - String => (byte, short, char, int, long, float, double, boolean) : String.valueOf(변수명)
## - String은 char로 강제 타입 변환은 불가능

# 9. 표준 입출력
## - 표준 입력 장치 : System.in.read()
### * throws Exception는 System.in.read()에 대한 예외 처리 코드
### * 단점은 키코드를 하나씩 읽기 때문에 2개 이상의 키가 조합된 한글을 읽을 수 없고 키보드로부터
###   입력된 내용을 문자열로 읽지 못함 이러한 단점을 보완하기 위해 Scanner클래스를 사용함
### * Resource leak: 'scanner' is never closed가 나올 때는 생성한 객체를 close()를 이용해 닫아주어야함
## - 표준 출력 장치 : System.out.println(), System.out.print(), System.out.printf()

# 10. 동일값 비교
## - 기본 타입의 값이 동일한지 비교할 때에는 ==를 사용함
## - 문자열이 동일한지 비교할 때에는 equals()메소드를 사용함
