// 패키지 선언
package sec01.exam03;

/*
작성자 : 조건영
작성일 : 2022/12/26
기능 : 2개의 변수값 교환
*/
public class VariableExchangeExample {
    public static void main(String[] args){
        // 초기 변수값 설정
        int x = 3;
        int y = 5;

        // 초기 변수값 출력
        System.out.println("x:" + x + ", y:" + y);

        // 변수값 교환
        int temp = x;
        x = y;
        y = temp;

        // 교환된 변수값 출력
        System.out.println("x:" + x + ", y:" + y);
    }
}
