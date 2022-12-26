// 패키지 선언
package sec01.exam04;

/*
작성자 : 조건영
작성일 : 2022/12/26
기능 : 선언된 블록 내에서만 사용 가능한 변수 
*/
public class VariableScopeExample {
    // 프로그램 실행 진입점
    public static void main(String[] args){ // 메서드 블록 시작
        // v1 초기값 설정
        int v1 = 15; // 메서드 블록 내에서만 사용 가능
        if(v1 > 10){ // if블록 시작
            // v2 초기값 설정
            int v2 = 10; // if블록 내에서만 사용 가능
            
            // v2 출력
            System.out.println("v2의 초기값 : " + v2);

            // v2변수값 변경
            v2 = v1 - 10; // v1은 메서드 블럭 안에 있으므로 사용 가능

            // 변경된 v2값 출력
            System.out.println("변경된 v2값 : " + v2);
        } // if블록 종료
        // v3초기값 설정
        // int v3 = v1 + v2 + 5; // v2는 if블록을 벗어나서 사용 불가
    } // 메서드 블록 종료
}
