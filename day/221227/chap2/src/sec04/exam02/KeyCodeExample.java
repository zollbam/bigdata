package sec04.exam02;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : 입력된 키코드를 변수에 저장 => System.in.read()
*/
public class KeyCodeExample {
    public static void main(String[] args) throws Exception{
        int keyCode;

        // 표준입력장치
        keyCode = System.in.read();
        System.out.println("keyCode : " + keyCode);

        keyCode = System.in.read();
        System.out.println("keyCode : " + keyCode);

        keyCode = System.in.read();
        System.out.println("keyCode : " + keyCode);
    }
}
