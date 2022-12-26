package sec02.exam08;

/*
작성자 : 조건영
작성일 : 2022/12/26
기능 : boolean타입 => 1바이트
*/
public class BooleanExample {
    public static void main(String[] args){
        // 논리값 설정
        boolean stop = false;
        // stop이 true이면 "중지합니다."
        // stop이 flase이면 "시작합니다."
        if(stop){
            System.out.println("중지합니다.");
        }else{
            System.out.println("시작합니다.");
        }
    }
}
