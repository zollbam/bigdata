rm(list=ls())

# R 1파트 3.R의 기본문법.pdf
# 변수명
v.1 <- 1
v.2 <- 2
v.1
v.2
comment('.을 이용하여 변수명을 지정할수 있음')

# 타입 확인
class(T)
class(3)
class('Hello')

# 연산
x <- 2
y <- 2*((x+2)-(x+4))/2+3
y
comment('2*(-2)/2+3=-2+3=1')

7%/%3 # 몫
7%%3 # 나머지
10^3 # 거듭제곱
3<4
5>6
5==5

# 1~10 자연수 합
# 첫번째 방법
s<-0
i<-1
while (i<=10){
  s <- s+i
  i <- i+1
}
s

# 두번째 방법
s <- 0
for (i in 1:10){
  s <- s+i
}
s

# n의 약수 출력하고 약수 개수 구하기
n <- 32
count <- 0
for(i in 1:n){
  if (n%%i==0){
    cat(i,' ')
    count <- count +1
  }
}
count # 약수 개수

# 소수인지 아닌지 판단하기
n<-16
is.prime <- TRUE
for (i in 2:(n-1)){
  if (n%%i==0){ 
    is.prime <- FALSE
    break
  }
}
is.prime
comment('소수는 1과 자기 자신만 있어야 하므로 하나라도
        나누었을 때 나머지가 0이 되면 소수가 안됨')

# 중첩반복문
for(i in 1:3){
  cat(i,": ")
  for (j in 1:5){
    cat(j," ")
  }
  cat('\n')
}

# 파이썬range
v <- 1:100
sum(v)
# 1~100까지 총합

# if-elif문
score=79
if (score>=90){
  grade='A'
}else if (score>=80){
  grade='B'
}else{
  grade='F'
}
grade

# 연습문제 3-1
# 1)한변의 길이는 x이고 정사각형의 넓이를 area를 구하는 수식
nemo_area <- function(x){
  (x^2)
}
comment('return이 없는 경우 마지막줄이 리턴됨')
nemo_area(c(5,10,15))
sapply(c(5,10,15),nemo_area)
comment('동일한 결과가 나옴')

# 2)반지름의 길이가 r이고 원의 둘레round와 넓이area를 구하는 수식
one_round <- function(r) 2*r*3.141592
one_area <- function(r) (r^2)*3.141592
input <- c(5,10,15)
one_round(input) # 원 둘레
one_area(input) # 원 넓이
sapply(input,one_round) # 원 둘레
sapply(input,one_area) # 원 넓이

# 연습문제 3-2
n=15
if (n%%3==0){
  if (n%%5==0){
    order='피자나라치킨공주'
  }else{
    order='피자'
  }
}else if (n%%5==0){
  order='치킨'
}else{
  order='다이어트'
}
order

# 다른방법
n <- 10
if (n%%15==0){
  order='피자나라치킨공주'
}else if (n%%3==0){
  order='피자'
}else if (n%%5==0){
  order='치킨'
}else{
  order='다이어트'
}
order

n <- 2
order='다이어트'
if (n%%15==0){
  order='피자나라치킨공주'
}else if (n%%3==0){
  order='피자'
}else if (n%%5==0){
  order='치킨'
}
order

order <- function(n){
  order <- ifelse(n%%15==0,'PizzaChicken',
                  ifelse(n%%3==0,'Pizza',
                         ifelse(n%%5==0,'Chicken','Deit')))
  order
}
order(1:15)

# 연습문제 3-3
# 1) S=1^3+ ... +n^3 구하는 코드
three_jegum <- function(n){
  v<-1:n
  S=sum(v^3)
  
  return (S)
}
three_jegum(10)
three_jegum(15)
three_jegum(20)
sapply(c(10,15,20),three_jegum)

# 공식을 이용한 값구하기
three_jegum.1 <- function(n) (n*(n+1)/2)**2
sapply(c(10,15,20),three_jegum.1)

# 2)n!구하는 코드
n <- 20
result <- 1
for (i in 1:n){
  result <- result*i
}
result

# 연습문제 3-4
piz_chi <- function(n){
  pizza <- 0
  chicken <- 0
  combo <- 0
  diet <- 0
  for (i in 1:n){
    if (i%%15==0){
      order='피자나라치킨공주'
      combo <- combo+1
    }else if (i%%3==0){
      order='피자'
      pizza <- pizza+1
    }else if (i%%5==0){
      order='치킨'
      chicken <- chicken+1
    }else{
      order='다이어트'
      diet <- diet+1
    }
    cat(i,order,'\n')
  }
  cat('pizza =',pizza,'\n')
  cat('chicken =',chicken,'\n')
  cat('combo =',combo,'\n')
  cat('diet =',diet,'\n')
}
piz_chi(15)

# 연습문제 3-5
# *을 이용한 그림과 같이 출력
# n=5일때
# ***** *     *****
# ***** **    *
# ***** ***   *****
# ***** ****  *
# ***** ***** *****
star_pri <- function(n){
  for(i in 1:n){
    for(j in 1:n){
      cat('*')
    }
    cat('\t')
    
    for(k in 1:n){
      if (k<=i){
        cat('*')
      }else{
        cat(' ')
      }
    }
    cat('\t')
    
    if (i%%2==1){
      cat('*****')
    }else{
      cat('*')
    }
    cat('\n')
  }
}
star_pri(5)

# 연습문제 3-6
# 소수와 소수 개수 구하기
sosu_co <- function(n){
  sosu_count=0
  for (i in 2:n){
    if (i==2){
      cat(i,' ')
      sosu_count <- sosu_count + 1
    }else{
      for (j in 2:(i-1)){
        if(i%%j==0){
          break
        }else if (j==(i-1)){
          cat(i,' ')
          sosu_count <- sosu_count + 1
        }
      }
    }
  }
  return (sosu_count)
}
sosu_count <- sosu_co(10)
sosu_count
sosu_count <- sosu_co(100)
sosu_count
sosu_count <- sosu_co(1000)
sosu_count
comment('count라는 함수가 있으므로 변수명을 바꾸어줌')

# 연습문제 3-7
# 1부터 n까지 각 수의 약수의 개수를 출력하고
# 각 수 중 약수가 가장 많은 숫자를 찾아라
# 단, 약수의 개수가 가장 많은 숫자가 여러개라면 가장 큰수를 찾으시오
divsor_su <- function(n){
  maxval=0
  maxsu=0
  for (i in 1:n){
    v <- 1:i
    result=length(v[i%%v==0])
    cat(i,': ',result,'\n')
    
    if (maxsu<=result){
      maxsu <- result
      maxval <- i
    }
  }
  return (maxval)
}
maxval=divsor_su(10)
maxval
maxval=divsor_su(100)
maxval
maxval=divsor_su(1000)
maxval

# 빅오루트를 이용한 개념코드
div2 <- function(n){
  v <- c()
  for(i in 1:sqrt(n)){
    if(n%%i==0){
      if(i==n/i){
        v <- c(v,i)
      }else{
        v <- c(v,i,n/i)
      }
    }
  }
  sort(v)
}
div2(36)
