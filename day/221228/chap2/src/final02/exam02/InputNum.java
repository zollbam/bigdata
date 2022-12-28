package final02.exam02;

import java.util.Scanner;

/*
작성자 : 조건영
작성일 : 2022/12/28
기능 : 키보드로 입력한 두 수를 덧셈하여 결과를 출력
*/
public class InputNum {
    public static void main(String[] args) throws Exception {
        // Scanner객체 생성
        Scanner scanner = new Scanner(System.in);

        // 입력된 문자 변수에 저장하기
        System.out.print("첫번째 수 : ");
        String str1 = scanner.nextLine();

        System.out.print("두번째 수 : ");
        String str2 = scanner.nextLine();

        // scanner 닫기
        scanner.close();

        // 입력된 문자를 숫자로 바꾸고 연산하기
        int intValue1 = Integer.parseInt(str1);
        int intValue2 = Integer.parseInt(str2);
        int result = intValue1 + intValue2;
        System.out.printf("%s + %s = %d\n\n", str1, str2, result);

        // result변수없이 연산하기
        int intValue3 = Integer.parseInt(str1);
        int intValue4 = Integer.parseInt(str2);
        System.out.printf("%s + %s = %d", str1, str2, intValue3 + intValue4);
    }
}
