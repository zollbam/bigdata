package sec02.exam06;

/*
작성자 : 조건영
작성일 : 2022/12/26
기능 : 이스케이프 문자
*/
public class EscapeExample {
    public static void main(String[] args){
        String str1 = "번호\t이름\t직업";
        String str2 = "행 단위 출력\n";
        String str3 = "열 단위 출력\n";
        String str4 = "우리는 \"개발자\" 입니다.";
        String str5 = "봄\\여름\\가을\\겨울";

        System.out.println(str1);
        System.out.print(str2);
        System.out.print(str3);
        System.out.println(str4);
        System.out.print(str5);
        System.out.println(" => 우리나라 4계절");
    }
}
