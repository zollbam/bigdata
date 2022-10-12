rm(list=ls())

# 1.R과 Rstudio.pdf
# 출력문 연습
3+4
print('Hello, R!')

# 변수 값 할당
x=3
x <- 3
3 -> y

# =, <- , -> 로 값을 할당 할 수있음

# 값 출력
x <- 3
y <- 5
z<-x+y
z
print(z)

# 폴더 경로 출력
getwd()

# 데이터셋 보기
data()

#그래프 그리기
plot(iris)

# 도움말
?iris

# 데이터셋 보기
View(iris)
# 행렬(데프) 형태로 보여줌

library(cowsay)
library(ggplot2)

say("안녕, 난 주니온이야!")
say("안녕, 난 주니온이야!",by='chicken')
say("안녕",by='cat')
say("이혜진 바보!!!",by='shark')
say("이혜진 바보!!!",by='pig')
# say("안녕",by='dog') => 여러 by옵션을 보여줌
