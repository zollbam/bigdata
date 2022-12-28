package sec03.exam05;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : 연산식에서 자동 타입 변환
*/
public class OperationPromotionExample {
    public static void main(String[] args){
        // int = byte + byte
        byte byteValue1 = 10;
        byte byteValue2 = 20;
        // byte result1 = byteValue1 + byteValue2; // 컴파일 오류
        int result2 = byteValue1 + byteValue2;
        System.out.println("int = byte + byte식 : " + result2);

        // int = char + char
        char charValue1 = 'A';
        char charValue2 = 1;
        int result3 = charValue1 + charValue2;
        System.out.println("int = char + char식(유니코드) : " + result3);
        System.out.println("int = char + char식(출력문자) : " + (char) result3);

        // int = int / int
        int intValue1 = 10;
        int result4 = intValue1/4; // 2.5을 원하지만 int라서 2가 저장됨
        System.out.println("int = int / int식 : " + result4);

        // double = int / double
        // int result5 = intValue1 / 4.0; // 연산결과는 소수인데 저장되는 변수 타입은 int라서 컴파일 오류
        double result6 = intValue1 / 4.0;
        System.out.println("double = int / double식 : " + result6);

        // double = (double) int / int
        int intValue2 = 1;
        int intValue3 = 2;
        double result7 = (double) intValue2 / intValue3;
        System.out.println("double = (double) int / int식 : " + result7);

        // double = int / (double) int
        int intValue4 = 10;
        int intValue5 = 7;
        double result8 = intValue4 / (double) intValue5;
        System.out.println("double = int / (double) int식 : " + result8);

        // double = (double) int / (double) int
        int intValue6 = 133;
        int intValue7 = 5875;
        double result9 = (double) intValue6 / (double) intValue7;
        System.out.println("double = (double) int / (double) int식 : " + result9);
    }
}
