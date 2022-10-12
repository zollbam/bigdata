rm(list=ls())

# R 1파트 4.벡터의 이해.pdf
# 벡터 원소의 자료형
v1 <- vector(length=2)
v1
comment('값이 FALSE로 길이가 2만큼 들어감')

v2 <- 1:10
v2

v3 <- 10:1
v3

v4 <- c(1,2,3,5,7)
v4

v5 <- seq(1,10,2)
v5

v6 <- rep(1:3,each=2,times=2)
v6

v7 <- rep(1:5,each=3)
v7
comment('each=옵션은 하나의 숫자를 몇개 뽑을지 알려줌')

v8 <- rep(1:5,times=4)
v8
comment('times=옵션은 몇번을 반복할지 알려줌')

# c(): 여러개의 벡터를 결합하여 하나의 벡터 생성
v10 <- c(1,2,3:5)
v10

v11 <- c(5:6,seq(7,9,2))
v11

v12 <- c(v10,v11)
v12

# 벡터의 이해
comment('벡터는 같은 타입의 자료형을 가져야 하며
        논리형<숫자형<문자열 순으로 자동변환됨')
v21 <- c(T,T,F,F,T)
v21

v22 <- c(T,F,3,3.14)
v22
comment('논리형과 숫자형이 같이 있다면 모두 숫자형으로 변환')

v23 <- c(3,3.14,"PI-3.14")
v23
comment('숫자형과 문자형이 같이 있다면 모두 문자형으로 변환')

v23 <- c(T,F,3,"3.14")
v23
comment('논리형/숫자형/문자형이 같이 있다면 모두 문자형으로 변환')

# 벡터의 인덱싱
v <- c(10,20,30,40,50,60,70)
v
v[1]
v[7]
v[1:3]
v[3:6]
v[c(1,3,6,7)]
v[c(T,T,F,F,F,F,T)]
v[-1] # 첫번째 원소만 제외한 벡터 출력
v[-c(1,3,4,7)]
v[8] # 해당자리에 없는 값을 출력할때는 NA를 반환
v[6:8]
v[-(1:3)]

# 벡터의 값변경
v[7]=700
v
v[1:3]=c(100,200,300)
v
v[1:3]=seq(100,300,100)
v

# 벡터 연산
v <- c(10,20,30,40,50,60,70)
v+1
# 모든 요소에 1씩 더해줌

c(10,20)+c(20,40)
c(10,20)+20
v[c(T,F)]

# 벡터 조건
v>30
# 30보다 큰 요소만 T/F로 출력해줌

# rep
rep(1:3,times=3)

v[v>30]

# 피자나라치킨공주 벡터의 생성
v<-c()
for(i in 1:15){
  if (i%%3==0 && i %% 5 ==0){
    v <- c(v,'PZ')
  } else if (i%%3==0){
    v <- c(v,'P')
  } else if (i%%5==0){
    v <- c(v,'C')
  } else{
    v <- c(v,'D')
  }
}
v

# 궁금한점
# 빈벡터에 요소를 추가하면 어떻게 될까??
v <- c()
for(i in 1:10){
  v <- c(v,i)
}
v

v <- c()
for(i in 1:10){
  v[i] <- i
}
v

v <- c(10,20,30)
v[7] <- 70
v
# 4~6인덱스에는 NA값이 들어가고 길이는 7인 벡터가 생성

# 1에서 100까지 수 중에서 7의 배수의 합은?
# 벡터로
v <- 1:100
sum(v[v%%7==0])

# for문
s<-0
for(i in 1:100){
  if (i%%7==0){
    s<-s+i
  }
}
s
comment('하지만 for문은 너무 코드도 길고 사용하지 말자고 하였으니 가급적 하지말자')

# 팩터(factor)
c('Male','Female','Male','Female') # 벡터
factor(c('Male','Female','Male','Female')) # 팩터
f <- factor(c('Male','Female','Male','Female')) # 변수에 저장
f
levels(f)
f[f=='Male']
f[f=='Female']
f[6] <- 'Male'
f
comment('5인덱스에는 NA이고 6인덱스는 Male')
f[7] <- 'TG'
f
comment('TG는 levels에는 없으므로 값이 넣어지지 않고 NA가 저장')
f <- factor(c(1,2,1,2,NA,1),levels=1:3,labels=c('Male','Female','TG'))
f
f[7] <- 'TG'
f
comment('이제는 TG값이 들어감')

# 리스트
v.1 <- c(1,2,3)
v.2 <- c('F','F','M')
c(v.1,v.2)

lst <- list(id=v.1,gerder=v.2)
lst

lst[1]
comment('이렇게는 사용하지 말자!!')

lst[[1]]
comment('값만 추출')

lst$id
lst$gerder

# 행렬

# which()
v <- 1:10
which(v%%3==0)
comment('v가 3인 배수인 요소들만 출력')

which(v>5)
comment('v가 5보다 큰 요소들만 출력')

which(v %in% c(1,3))
comment('v가 1,3인 요소들만 출력')

# n의 약수를 모두 출력하시오.
# 반복문은 사용하지 마시오.
n <- 32
v <- 1:n
result <- n%%v
v[result==0]

# 행렬
str(iris)
View(iris)
iris[1:5,] # 위의 5행만 보고 싶을 때
comment('iris[:5,] iris[1:5,:]는 오류가 나옴옴')
iris[1:5,1]
iris[1:5,1:2]
iris[1:5,1:4]
iris[1:5,-5]
attach(iris)
iris[Sepal.Length<5,1]
iris[Sepal.Length>5,]
iris[Sepal.Length==5,5]
nrow(iris[Sepal.Length==5,])

# Petal.Length가 평균보다 큰 Petal.Length데이터의 Petal.Width 평균값은???
mean(iris[Petal.Length>mean(Petal.Length),4])

detach(iris)

# 함수
fun<-function(x){
  return(x+y+5)
}
y <- 5
fun(5)
comment('x+y+5=5+5+5=15')

my.fun <- function(x,y,z=1){
  cat(x,y,z,'\n')
  return (x+2*y+3*z)
}
my.fun
my.fun(1,2,3)
my.fun(1,5)
my.fun(z=4,x=4,y=2)
my.fun(4,5,x=4)
comment('x에는 4 앞에서 순서대로 y에는 4, z는 5가 들어감')

# 약수를 구해주는 함수
divisor <- function(n){
  v<-1:n
  return (v[n%%v==0])
}
divisor(32)
divisor(16)

# 약수의 개수를 구하는 함수
divisor_su <- function(n){
  v<-1:n
  length(v[n%%v==0])
}
# return문이 없으면 마지막 줄이 리턴됨됨
divisor_su(32)
divisor_su(16)

# 연습문제 4-1
# 1)1~15까지 각 인덱스 숫자의 약수의 개수 벡터div를 생성
divsor_su_v <- function(n){
  div <- c()
  for (i in 1:n){
    v <- 1:i
    div_su <- length(v[i%%v==0])
    div <- c(div,div_su)
  }
  return (div)
}
div=divsor_su_v(15)
cat('div:',div)

# 2)div에서 벡터의 인덱싱과 벡터연산을이용하시오
# 2-1)sum()함수를 이용하여 약수의 개수가 2인 원소개수 구하기
sum(div==2)

# 2-2)which()함수를 이용하여 약수의 개수가 2인 인덱스를 모두 출력하기
which(div==2)

# 2-3)1~15까지 소수의 개수는 몇개인가??
length(div[div==2])

# 연습문제 4-2
# 1)몸무게,키 벡터 height,weight를 생성하시오
height <- c(163,175,182,178,161)
weight <- c(65,87,74,63,51)

# 2)혈액형 팩터 blood를 생성하시오
blood <- factor(c(1,2,4,3,1),labels=c('A','B','O','AB'))
comment('levels=옵션이 없어도 숫자로 넣으면 A/B/O/AB로 저장됨')

# 3)height,weight,blood를 각각 원소이름으로 가진 리스트 lst를 생성하시오
lst <- list(height=height,weight=weight,blood=blood)
lst

# 4)키와 몸무게의 평균을 계산하시오
paste0('키의 평균은 ',mean(lst$height),'cm입니다.',sep='')
paste0('몸무게의 평균은 ',mean(lst$weight),'kg입니다.')
comment("sep=옵션의 기본옵션은 ''입니다.")

# 5)혈액형의 빈도표를 출력
table(lst$blood)
barplot(table(lst$blood))
