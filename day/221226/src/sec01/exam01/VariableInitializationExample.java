// 패키지 선언
package sec01.exam01;

/*
작성자 : 조건영
작성일 : 2022/12/26
기능 : 변수에 초기값을 저장하지 못하여 발생하는 오류 => The local variable value may not have been initialized Java
*/
public class VariableInitializationExample {
    // 프로그램 실행 진입점
    public static void main(String[] args){
        // 변수 선언
        // int value;

        // 변수 value 값을 읽고 10을 더하는 산술 연산을 수행
        // 연산의 결과값을 변수 result의 초기값으로 저장
        // int result = value + 10;
        // value 변수에 초기값이 없으므로 오류가 발생
        int result = 10;

        // 콘솔 출력
        System.out.println(result);
    }
}
