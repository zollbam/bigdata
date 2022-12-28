package sec04.exam05;

import java.util.Scanner; // Scanner클래스를 사용하기 위해 컴파일러에게 알려줌

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : 키보드에서 입력된 내용을 문자열로 얻기
*/
public class ScannerExample {
    public static void main(String[] args) throws Exception {
        // Scanner객체 생성
        Scanner scanner = new Scanner(System.in);

        // 입력될 문자열 저장 변수
        String inputData;

        // 무한루프
        while(true){
            inputData = scanner.nextLine();
            System.out.println("입력된 문자열: \"" + inputData + "\"");
            if(inputData.equals("q")|inputData.equals("Q")){
                break; // q나 Q이면 무한루프 종료
            }
        }
        scanner.close(); // Scanner를 닫아주어야 오류메세지가 안 나옴
        System.out.println("무한루프 종료!!!");
    }
}
