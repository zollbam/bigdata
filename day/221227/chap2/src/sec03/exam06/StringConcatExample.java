package sec03.exam06;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : 문자열 결합 연산
*/
public class StringConcatExample {
    public static void main(String[] args){
        // 숫자 연산
        int value = 10 + 2 + 8;
        System.out.println(value);

        // 문자열 결합 연산
        String str1 = 10 + 2 + "8"; // 12 + "8" = "128"
        System.out.println("10 + 2 + \"8\" = " + str1);

        String str2 = 10 + "2" + 8; // "102" + 8 = "1028"
        System.out.println("10 + \"2\" + 8 = " + str2);

        String str3 = "10" + 2 + 8; // "102" + 8 = "1028"
        System.out.println("\"10\" + 2 + 8                                                                                                 = " + str3);

        String str4 = "10" + (2 + 8); // "10" + 10 = "1010"
        System.out.println("\"10\" + (2 + 8) = " + str4);
    }
}
