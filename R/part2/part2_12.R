rm(list=ls())
colors()

# cats셋으로 상관분석 => MASS패키지
## 데이터 확인
library(MASS)
str(cats)
class(cats)
summary(cats)
colSums(is.na(cats)) # 열마다 결측치 확인

## 몸무개와 심장무게 간의 산점도
plot(cats$Bwt,cats$Hwt,pch=19,col='gray75',main='Body Weight and Heart Weight of cats',ylab='Heart Weight(g)',xlab='Body Weight(kg)')

## 상관계수
cor(cats$Bwt,cats$Hwt) # 기본값은 피어슨
cor(cats$Bwt,cats$Hwt,method='pearson') # 기본값
cor(cats$Bwt,cats$Hwt,method='spearman') # 스피어만
cor(cats$Bwt,cats$Hwt,method='kendall') # 켄달

with(cats,cor(Bwt,Hwt))

## 상관계수 유의성 검증
comment('H0: 상관계수가 0임, H1: 상관계수가 0이 아님
        즉, 귀무가설이 기각되면 통계적으로 유의하다고 할 수 있음')

with(cats,cor.test(Bwt,Hwt,alternative='greater',conf.level=0.99))
comment('h0기각 => 상관계수는 0이 아님')

### 포뮬러 형식 이용
with(cats,cor.test(~Bwt+Hwt))

cor.test(~Bwt+Hwt,data=cats,subset=c(Sex=='F'))
comment('암컷 고양이만 빼서 상관테스트를 해봄
        h0기각 => 상관계수는 0이 아님')

with(cats,cor.test(~Bwt+Hwt,subset=c(Sex=='M')))
comment('수컷 고양이만 빼서 상관테스트를 해봄
        h0기각 => 상관계수는 0이 아님')

## 각 열의 요약 통계량
library(stargazer)
stargazer(cats,type='text')

# iris셋
## 상관계수 행렬 만들기
cor(iris[,-5])
comment('5열을 빼는 이유는 수치형이 아니라서 빼지 않고 돌리면 오류가 나옴')

cor.iris<-cor(iris[,-5])
class(cor.iris)
str(cor.iris)

cor.iris['Petal.Width','Petal.Length']
comment('행렬을 만들어 내가 원하는 변수들의 상관계수를 뽑아 볼 수도 있음')

cor.iris['Sepal.Width','Sepal.Length']
cor.iris['Petal.Width','Sepal.Width']
cor.iris['Petal.Length','Sepal.Length']

## 3개 이상 변수 간의 상간계수 유의성 검정
library(psych) # corr.test()와 pairs.panels()함수 사용하기 위한 패키지
corr.test(iris[,-5])
comment('상관계수와 함께 p값도 보여줌
        마지막 줄에 보면 print(short=F)를 이용하여 신뢰구간을 볼 수 있다고 함')

print(corr.test(iris[,-5]),short=F)

# state.x77 => 기본 내장 데이터셋
## 상관계수 행렬
options(digits=1)
comment('출력물로 나오는 수치형 값들의 소수점을 지정해줌
        1이면 소수둘째자리, 2이면 소수 셋째자리 ...1~22까지만 지정가능')

cor(state.x77)
comment('상관계수 값들이 소수둘째자리까지만 보여줌')

options(digits = 7) # 기본값이 7이므로 다시 원상 복귀
cor(state.x77) # 소수 8자리

## 상관계수 그래프
### 방법 1
cor.plot(state.x77,las=2)
comment('각 변수의 상관계수의 크기에 따라 색깔이나 크기가 다르게 나옴')

### 방법 2
pairs.panels(state.x77,main='Correlation Plot of US States Data',bg='red',pch=21,hist.col='gold')
comment('오른쪽 상단은 상관계수와 왼쪽 하단은 그래프')

### 방법 3
library(corrgram)
corrgram(state.x77,main='Corrgram of US States Data',order=T,lower.panel=panel.shade,upper.panel=panel.pie,text.panel=panel.txt)
comment('order=T는 순서대로 정렬해주는 옵션이고
        lower.panel=옵션은 하단쪽의 시각화를 어떻게 보여줄지 정해주는 옵션 => 그림자
        upper.panel=옵션은 상단쪽의 시각화를 어떻게 보여줄지 정해주는 옵션 => 원그래프')

### 방법 4
cols<-colorRampPalette(c('darkgoldenrod4','burlywood1','darkkhaki','darkgreen'))
cols
comment('grDevices패키지에 있는 colorRampPalette()함수는 색팔레트를 만들어 주는 함수로
        매개변수에 적은 2개 이상의 색깔의 지정한 숫자만큼 색을 반환해줌')

corrgram(state.x77,main='Corrgram of US States Data',order=F,col.regions=cols,lower.panel=panel.pie,upper.panel=panel.conf,panel.text=panel.txt)

#### colorRampPalette()함수 예시
colorRampPalette(c('darkgoldenrod4','burlywood1','darkkhaki','darkgreen'))(8)
colorRampPalette(c('white','red'))(16)
colorRampPalette(c('red','blue'))(3)

# mtcars셋 => 기본 내장 데이터셋
## 데이터 확인
colnames(mtcars)
mtcars2<-mtcars[,c('mpg','cyl','hp','wt')]
str(mtcars2) # 수치형만 있음

## 상관계수 행렬
cor(mtcars2)

## 편상관계수 구하기
### 연비와 마력 간의 편상관계수 구하기(실린더 개수와 무게의 영향을 통제)
cor(mtcars2[,c(1,3)])

library(ggm) # pcor()함수와 pcor.test()사용을 위한 패키지
pcor(c('mpg','hp','cyl','wt'),cov(mtcars2))
pcor(c(1,3,2,4),cov(mtcars2))

## 편상관계수의 유의성 검정
pcor.test(pcor(c(1,3,2,4),cov(mtcars2)),q=2,n=nrow(mtcars))
comment('q=옵션은 변수의 개수를 지정하고 n=행의 개수를 정해주는거 같음
        결과에는 tval: t값, df: 자유도, pvalue: p값이 나옴')

## ppcor패키지
library(ppcor) # 이 패키지에도 pcor과 pcor.test함수가 있음
pcor(mtcars2)
comment('ggm패키지의 pcor 결과값도 동일하게 나옴
        하지만 ggm 패키지의 pcor()함수에는 데프를 매개변수로 넣을 수 없음')

pcor.test(mtcars['mpg'],mtcars['hp'],mtcars[c('cyl','wt')])

### 참고
comment('만약 내장 데이터셋 이름에 잘못하고 저장하였다면 rm()함수를 이용하여 삭제하고 다시 부르면 됨')
