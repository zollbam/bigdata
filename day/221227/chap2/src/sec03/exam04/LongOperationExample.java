package sec03.exam04;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : 정수 타입의 연산
*/
public class LongOperationExample {
    public static void main(String[] args){
        // 피연산자가 큰 타입으로 연산 결과 타입을 정해야 한다.
    // 즉, long = long + int, float = float + int, ...
    byte value1 = 10;
    int value2 = 100;
    long value3 = 1000L;
    long result = value1 + value2 + value3;
    System.out.println(result);
    }
}
