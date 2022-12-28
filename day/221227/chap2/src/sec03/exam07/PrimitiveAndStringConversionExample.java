package sec03.exam07;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : 기본 타입과 문자열 간의 변환
*/
public class PrimitiveAndStringConversionExample {
    public static void main(String[] args){
        // 문자열 "10"을 정수 10으로 변환 후 연산
        int value1 = Integer.parseInt("10");
        int result1 = value1 + 20;
        System.out.println("문자열을 정수로 바꾼 후 연산 : " + result1);

        // 문자열 "3.14"를 실수형으로 변환
        String str1 = "3.14";
        double result2 = Double.parseDouble(str1);
        System.out.println("문자열을 실수로 변환 : " + result2);

        // 문자열 "3.14"를 논리형으로 변환
        String str2 = "true";
        boolean result3 = Boolean.parseBoolean(str2);
        System.out.println("문자열을 논리로 변환 : " + result3);

        // (정수, 실수, 논리)를 문자열로 변환
        int intValue1 = 19;
        float floatValue1 = 158.15482f;
        boolean booleanValue1 = true;

        System.out.println("정수를 문자열로 : " + (String.valueOf(intValue1) + 1));
        System.out.println("실수를 문자열로 : " + (String.valueOf(floatValue1) + 21));
        System.out.println("논리를 문자열로 : " + (String.valueOf(booleanValue1) + "false"));
    }
}
