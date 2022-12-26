package sec02.exam03;

/*
작성자 : 조건영
작성일 : 2022/12/26
기능 : long타입 변수에 정수 리터럴을 저장할 때 L붙이기
*/
public class LongExample {
    public static void main(String[] args){
        // long 타입 => 8바이트 => -2^63 ~ 2^63 - 1
        long var1 = 10;
        long var2 = 20L; // int범위 내에 있는 숫자는 L을 붙여도 되고 안 붙여도 됨
        // long var3 = 1000000000; // L을 붙이지 않으면 오류가 발생
        long var4 = 1000000000L; // int범위에서 벗어난 숫자는 무조건 L을 붙여야 함

        // long 타입 출력
        System.out.println(var1);
        System.out.println(var2);
        // System.out.println(var3); // 범위 오류로 출력 불가
        System.out.println(var4);
    }
}
