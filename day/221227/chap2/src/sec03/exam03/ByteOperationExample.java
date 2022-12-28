package sec03.exam03;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : 정수 타입의 연산
*/
public class ByteOperationExample {
    public static void main(String[] args){
        // 변수에 저장하지 않고 바로 정수 리터럴로 연산
        byte result1 = 10 + 20;
        System.out.println(result1);
        /*
         - 숫자는 정해진 타입이 없으므로 연산의 타입을 굳이 int로 해줄 필요성은 없다.
         - 즉, 피연산자가 변수가 아닐 경우에는 연산 결과 변수는 int가 아니어도 됨
        */

        // 피연산자가 변수일 경우 => int = byte + byte
        byte x = 10;
        byte y = 20;
        // byte result2 = x + y; // 컴파일 오류 => 연산 결과 변수의 타입은 int가 되어야 함
        int result3 = x + y;
        System.out.println(result3);
    }
}
