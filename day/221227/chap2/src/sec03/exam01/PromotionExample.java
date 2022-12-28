package sec03.exam01;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : 자동 타입 변환
*/
public class PromotionExample {
    public static void main(String[] args){
        // 자동 타입 변환(byte => int)
        byte byteValue = 10;
        int intValue = byteValue;
        
        System.out.println("byte => int");
        System.out.println("byteValue : " + byteValue);
        System.out.println("intValue : " + intValue);
        System.out.println();

        // 자동 타입 변환(char => int)
        char charValue = '가';
        intValue = charValue;
        
        System.out.println("char => int");
        System.out.println("charValue : " + charValue);
        System.out.println("intValue : " + intValue);
        System.out.println();

        // 자동 타입 변환(int => long)
        intValue = 50;
        long longValue = intValue;
        
        System.out.println("int => long");
        System.out.println("intValue : " + intValue);
        System.out.println("longValue : " + longValue);
        System.out.println();

        // 자동 타입 변환(long => float)
        longValue = 100;
        float floatValue = longValue;
        
        System.out.println("long => float");
        System.out.println("longValue : " + longValue);
        System.out.println("floatValue : " + floatValue);
        System.out.println();

        // 자동 타입 변환(float => double)
        floatValue = 100.5f;
        double doubleValue = floatValue;
        
        System.out.println("float => double");
        System.out.println("floatValue : " + floatValue);
        System.out.println("doubleValue : " + doubleValue);
        System.out.println();
    }
}
