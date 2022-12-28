package final02.exam03;

import java.util.Scanner;

/*
작성자 : 조건영
작성일 : 2022/12/28
기능 : Scanner를 이용해서 이름, 주민번호, 전화번호를 키보드에 입력받고 출력
*/
public class ScannerIntroduce {
    public static void main(String[] args) throws Exception {
        // Scanner 객체 생성
        Scanner scanner = new Scanner(System.in);

        // 키보드에 문자열 입력
        System.out.print("[필수 정보 입력]\n1. 이름: ");
        String name = scanner.nextLine();
        System.out.print("2. 주민번호 앞 6자리: ");
        String ymd = scanner.nextLine();
        System.out.print("3. 전화번호: ");
        String tel = scanner.nextLine();

        // Scanner객체 닫기
        scanner.close();

        // 입력된 키보드 문자열 출력
        System.out.printf("[입력한 내용]\n%s\n%s\n%s\n", name, ymd, tel);
    }
}
