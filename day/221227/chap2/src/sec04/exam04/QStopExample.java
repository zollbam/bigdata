package sec04.exam04;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : q를 입력하여 무한루프 종료
*/
public class QStopExample {
    public static void main(String[] args) throws Exception {
        int keyCode;

        // 무한루프
        while(true) {
            keyCode = System.in.read();
            System.out.println("keyCode : " + keyCode);
            if(keyCode==113 | keyCode==81) { // Q는 81, q는 113
                break; // while문 종료
            }
        }
        System.out.println("무한루프 종료!!!");
    }
}
