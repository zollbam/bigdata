package sec02.exam02;

/*
작성자 : 조건영
작성일 : 2022/12/26
기능 : 타입범위에 맞지 않으면 오류가 발생 => Type mismatch: cannot convert from int to byte
*/
public class ByteExample {
    public static void main(String[] args){
        // byte의 범위는 -128 ~ 127
        byte var1 = -128;
        byte var2 = -30;
        byte var3 = 0;
        byte var4 = 30;
        byte var5 = 127;
        // byte var6 = 128; // 타입 범위 오류

        // byte타입 출력
        System.out.println("var1 : " + var1);
        System.out.println("var2 : " + var2);
        System.out.println("var3 : " + var3);
        System.out.println("var4 : " + var4);
        System.out.println("var5 : " + var5);
        // System.out.println("var6 : " + var6);
    }
}
