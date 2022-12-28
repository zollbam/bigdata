package final02.exam01;

/*
작성자 : 조건영
작성일 : 2022/12/28
기능 : 원하는 형태로 출력하기
*/
public class Introduce {
    public static void main(String[] args) throws Exception {
        // 변수 선언
        String name = "감자바";
        int age = 25;
        String tel = "010-123-4567";

        // 출력
        System.out.printf("이름: %s\n나이: %d\n전화: %s\n\n", name, age, tel);
        System.out.println("이름: " + name);
        System.out.println("나이: " + age);
        System.out.println("전화: " + tel);
    }
}
