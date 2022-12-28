package sec04.exam01;

/*
작성자 : 조건영
작성일 : 2022/12/27
기능 : printf()메소드 사용 방법
*/
public class PrintfExample {
    public static void main(String[] args){
        // printf()
        int value = 123;
        System.out.printf("상품의 가격:%d원\n",value);
        System.out.printf("상품의 가격:%6d원\n",value);
        System.out.printf("상품의 가격:%-6d원\n",value);
        System.out.printf("상품의 가격:%06d원\n",value);
        
        int radi = 10;
        double area = 3.14159 * radi * radi; // 원의 넓이
        System.out.printf("반지름이 %d인 원의 넓이:%7.2f\n", radi, area);
        System.out.printf("반지름이 %2$d인 원의 넓이:%1$10.2f\n", area, radi);

        String name = "홍길동";
        String job = "도적";
        System.out.printf("%6d | %-10s | %10s\n", 1, name, job);
        System.out.printf("%6d | %-10s | %10s\n", 2, "전우치", "도사");
        System.out.printf("%6d | %-10s | %10s\n", 3, "이순신", "장군");
    }
}
