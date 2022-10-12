rm(list=ls())

# R 1파트 5.함수의 이해.pdf
# 사용자 함수
add <- function(x,y){
  return (x+y)
}
add # 함수가 어떻게 생겼는지 확인
add(3,4)
add(1:3,4) # 1+4 2+4 3+4

func1 <- function(x,y,z){
  x+2*y+3*z
}
func1(1,2,3)
comment('매개변수명을 지정하지 않으면 순서대로 매개변수에 지정
        x=1,y=2,z=3이런식으로')
func1(x=1,y=2,z=3)
func1(3,2,1)
func1(z=3,x=2,y=1)
func1(1,z=2,y=3)

func2 <- function(x,y=1,z=0){
  x+2*y+3*z
}
func2(1,2,3)
func2(1) # x=1,y=1,z=0
func2(1,2) # x=1,y=2,z=0
func2(2,3,x=1) # x=1,y=2,z=3
func2(z=1,x=2) # x=2,y=1,z=1

# 기본값이 있는 함수는 생략가능
pi=3.141592
round(x=pi,digits=4)
round(pi,3)
round(digits=4,x=pi)

# head()
head(x=iris,n=3)
head(n=3,iris)

# 한줄로 함수
sadd3 <- function(x,y) x+y
sadd3(3,4)

square <- function(x) x^2
square(1:10)

vadd <- function(x,y) x+y
vadd(1:3,3:1)

vmult <- function(x,y=0) x*y
vmult(1:3)
vmult(1:3,3:1)

# ifelse()
score <- 88
grade<-ifelse(score>=90,'A',
              ifelse(score>=80,'B','C'))
grade
comment('90점 이상이면 A, 80점 이상이면 B, 다른 값들은 C')

# sapply
# 벡터의 각 원소에 어떤 함수를 적용한 결과를 벡터로 리턴
# 벡터의 값을 집어 넣고 벡터로 받기

# 짝수/홀수
is.odd <- function(n) n%%2==1
is.odd(7)
comment('짝수=>FALSE, 홀수=>TRUE')

# sapply없이 홀수 개수 구하기
odd.cnt.1 <- function(n,m){
  count<-0
  for(i in n:m){
    if(is.odd(i)) count <- count+1
  }
  count
}
odd.cnt.1(10,20)

# sapply를 사용하여 홀수 개수 구하기
odd.cnt.1 <- function(n,m) sum(sapply(n:m,is.odd))
odd.cnt.1(10,20)

# 연습문제 5-1
# 자연수n에 대해서
# 1) 약수의 개수를 구하는 div.cnt함수 만들기
div.cnt <- function(n) sum(n%%(1:n)==0)
div.cnt(10)

# 2) 1~15까지 n에 대해서 약수의 개수를 확인
sapply(1:15,div.cnt)

# 연습문제 5-2
# 1)1~n까지 소수의 개수를 리턴하는 prime.cnt()함수 만들기
# 입력값=임의의 자연수, 출력값=1~n까지의 소수의 개수
div_cou<-function(n) length(which(n%%(1:n)==0))
sapply(1:15,div_cou)
prime.cnt <- function(n) sum(sapply(1:n,div_cou)==2)
sapply(15,prime.cnt)

# 한줄로 소수 개수 찾기
div.cnt_sang_gun <- function(n) length((1:n)[sapply(1:n, function(n) length((1:n)[n %% (1:n) == 0])==2)])
div.cnt_sang_gun(100)

# 2)n <- c(10,100,1000,10000,100000) 일때 소수 개수
# 소수판단하는 is.prime()함수 만들기
is.prime<-function(n) length(which(n%%(1:n)==0))==2
prime.cnt <- function(n) sum(sapply(1:n,is.prime))
n <- c(10,100,1000,10000,100000)
sapply(n,prime.cnt)

# 3) 루트 n을 이용하여 is.prime을 수정
is.prime<-function(n) ifelse(n==1,FALSE,length(which(n%%(1:sqrt(n))==0)))==1
sapply(1:15,is.prime)
prime.cnt <- function(n) sum(sapply(1:n,is.prime))
n <- c(10,100,1000,10000,100000)
sapply(n,prime.cnt)
