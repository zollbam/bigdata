package sec02.exam07;

/*
작성자 : 조건영
작성일 : 2022/12/26
기능 : float => 4바이트, double => 8바이트
*/
public class FloatDoubleExample {
    public static void main(String[] args){
        // 실수값
        // float var1 = 3.14; // 실수 리터널 float타입으로 저장하고 싶다면 리터널 뒤에 F(f)를 붙여야 함
        float var2 = 3.14f;
        double var3 = 13.218432184;

        // 정밀도 테스트
        float var4 = 0.1234567890123456789f; // 소수점 8자리
        double var5 = 0.1234567890123456789f; // 소수점 16자리
        float var6 = 45.1234567890123456789f; // 소수점 6자리
        double var7 = 130.1234567890123456789f; // 소수점 13자리

        // e 사용하기
        double var8 = 3e6;
        float var9 = 3e6f;
        double var10 = 2156e-5;

        // 소수점 출력
        // System.out.println("var1 : " + var1); // 컴파일 오류
        System.out.println("var2 : " + var2);
        System.out.println("var3 : " + var3);
        System.out.println("var4 : " + var4);
        System.out.println("var5 : " + var5);
        System.out.println("var6 : " + var6);
        System.out.println("var7 : " + var7);
        System.out.println("var8 : " + var8);
        System.out.println("var9 : " + var9);
        System.out.println("var10 : " + var10);

    }
}
