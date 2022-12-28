package sec04.exam03;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : 입력된 키의 개수와 상관없이 키코드 읽기
*/
public class ContinueKeyCodeReadExample {
    public static void main(String[] args) throws Exception {
        int keyCode;

        // while문(무한루프)
        while(true){
            keyCode = System.in.read();
            System.out.println("keyCode : " + keyCode);
        }
        // 위에 뜨는 빨간색 네모 버튼인 강제 중지를 눌러 while문을 빠져 나오자
        // 네모 버튼을 누르기 전까지는 무한으로 문자를 입력해야 함
    }
}
