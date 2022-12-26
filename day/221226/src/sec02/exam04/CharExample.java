package sec02.exam04;

/*
작성자 : 조건영
작성일 : 2022/12/26
기능 : char타입 => 2바이트
*/
public class CharExample {
    public static void main(String[] args){
        // 'A' => 유니코드 65
        char c1 = 'A';
        char c2 = 65;
        char c3 = 0101; // 8진수로 저장
        char c4 = 0X0041; // 16진수로 저장
        char c5 = '\u0041'; // 16진수로 저장
        
        // '가' => 유니코드 44032
        char c6 = '가';
        char c7 = 44032;
        char c8 = 0126000; // 8진수로 저장
        char c9 = 0Xac00; // 16진수로 저장
        char c10 = '\uac00'; // 16진수로 저장

        // 'A' 출력
        System.out.println(c1);
        System.out.println(c2);
        System.out.println(c3);
        System.out.println(c4);
        System.out.println(c5);

        // '가' 출력
        System.out.println(c6);
        System.out.println(c7);
        System.out.println(c8);
        System.out.println(c9);
        System.out.println(c10);
    }
}
