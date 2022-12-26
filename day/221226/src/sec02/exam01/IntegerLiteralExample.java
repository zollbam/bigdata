package sec02.exam01;

public class IntegerLiteralExample {
    public static void main(String[] args){
        // int는 4바이트
        int var1 = 0b1011; // 2진수 => 1*1 + 1*2 + 0*4 + 1*8 = 11
        int var2 = 0206; // 8진수 => 6*1 + 0*8 + 2*64 = 134
        int var3 = 365; // 10진수 => 5*1 + 6*10 + 3*100 = 365
        int var4 = 0xB3; // 16진수 => 3*1 + 11*16 = 179

        // 진수 출력
        System.out.println("var1 : " + var1);
        System.out.println("var2 : " + var2);
        System.out.println("var3 : " + var3);
        System.out.println("var4 : " + var4);
        // n진수 형태로 저장되었지만 출력될 때는 10진수로 출력됨
    }
}
