// 패키지 선언
package sec01.exam02;

/*
작성자 : 조건영
작성일 : 2022/12/26
기능 : 시간과 분을 변수에 저장하고 총 분을 계산함
*/
public class VariableUseExample {
    // 프로그램 실행 진입점
    public static void main(String[] args){
        // 변수 선언
        int hour, minute;
        hour =3; minute = 5;
        
        // 출력 (x시간 y분)
        System.out.println(hour + "시간 " + minute + "분");

        // 시간을 분으로
        int totalMinute = (hour * 60) + minute;

        // 출력 (z분)
        System.out.println("총 " + totalMinute + "분");
    }
}
