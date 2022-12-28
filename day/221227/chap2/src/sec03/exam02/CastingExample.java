package sec03.exam02;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : 강제 타입 변환 => 큰 범위의 타입을 작은 범위 타입으로 변환
*/
public class CastingExample {
    public static void main(String[] args){
        // 강제 타입 변환(int => char)
        int intValue = 44032;
        char charValue = (char) intValue;
        System.out.println("int타입인 " + intValue + "를 char로 강제 타입 변환 시키면 \"" + charValue + "\"로 됨");

        // 강제 타입 변환(long => int)
        long longValue = 500;
        intValue = (int) longValue;
        System.out.println("long타입인 " + longValue + "를 int로 강제 타입 변환 시키면 \"" + intValue + "\"로 됨");

        // 강제 타입 변환(double => int)
        double doubleValue = 3.14;
        intValue = (int) doubleValue;
        System.out.println("double타입인 " + doubleValue + "를 int로 강제 타입 변환 시키면 \"" + intValue + "\"로 됨");
    }
}
