rm(list=ls())

# Prestige데이터셋
## 소득을 예측
library(car) # Prestige셋을 불러오기위한 패키지
data(Prestige)
Pres.df<-Prestige
str(Pres.df)

## type열의 빈도표
table(Pres.df$type)
barplot(table(Pres.df$type),col=c('orange','blue','red'))

## 연속형 히스토그램
hist(Pres.df$income,col='tomato',breaks=20) # 소득
hist(Pres.df$education,col='tomato',breaks=20) # 교육기간
hist(Pres.df$women,col='tomato',breaks=20) # 여성 재직자 비율
hist(Pres.df$prestige,col='tomato',breaks=20) # 직업에 대한 명성점수

## 정규성 검정
shapiro.test(Pres.df$income)
comment('h0: 정규성임, h1: 정규성아님
        h0기각 => 정규성 아님')

shapiro.test(Pres.df$education)
shapiro.test(Pres.df$women)
shapiro.test(Pres.df$prestige)
comment('모든 독립변수들은 h0를 기각 => 정규성 아님')

## 상관계수 행렬
cor(Pres.df[,-c(5,6)])
library(psych)
corr.test(Pres.df[,-c(5,6)])

## 상관 그래프
plot(Pres.df[,1:4],pch=19,col='skyblue')

## 단순회귀분석
### 소득과 교육기간
model1<-lm(income~education,data=Pres.df)
cor(Pres.df$income,Pres.df$education)
summary(model1)

plot(income~education,data=Pres.df,col='skyblue',pch=5,main='EDUCATION <-> INCOME')
plot(Pres.df$education,Pres.df$income,col='red',pch=2,main='education과 income')
abline(model1,lwd=2,lty=2)

resid(model1) # 각 행의 잔차를 보여줌
summary(resid(model1)) # 잔차의 요약통계량을 보여줌
confint(model1) # 회귀계수에 대한 신뢰구간

anova(model1)

### 소득과 여성 재직자 비율
model2<-lm(income~women,data=Pres.df)
cor(Pres.df$income,Pres.df$women)
summary(model2)
plot(income~women,data=Pres.df,col='red',main='women과 income')
abline(model2,lty=5,lwd=2)

## 소득과 명성점수
model3<-lm(income~prestige,data=Pres.df)
cor(Pres.df$income,Pres.df$prestige)
summary(model3)
plot(income~prestige,data=Pres.df,col='red',main='prestige와 income')
abline(model3,lty=2,lwd=2)

## 다중회귀분석
### 종속변수: income, 독립변수: education, women, prestige
mulaov.df<-subset(Pres.df,select=c(2,1,3,4))
cor(mulaov.df) # 상관계수 행렬
plot(mulaov.df,pch=20,col='blue') # 상관 그래프

mul.model1<-lm(income~.,data=mulaov.df)
summary(mul.model1)
coef(mul.model1) # 회귀계수

### 요약통계량을 이쁘게 보여줌
library(stargazer)
stargazer(Pres.df,type='text',no.space=T)
comment('데프에 stargazer쓰기
        no.space=옵션은 빈 행을 제거하는지 여부를 알려줌')

stargazer(mul.model1,type='text',no.space=T)
comment('회귀모델에 stargazer쓰기
        빈 행을 제거함')

## 독립변수의 수나 열을 바꾸어 가며 회귀분석 해보기
make.lm<-function(df_te,form){
  model<-lm(formula = form,data=df_te)
  print(summary(model))
  plot(form,data=df_te,col='red')
}
comment('회귀분석 함수를 만들어봄
        모델을 생성해 summary로 결과를 보고 그래프를 만들어 봄')

make.lm(Pres.df,income~education+women+prestige)
comment('education열의 p값이 너무 높음')

make.lm(Pres.df,income~women+prestige)
comment('education열을 빼고 해보고')

make.lm(Pres.df,income~education+women)
comment('prestige열을 빼고 해보고')

make.lm(Pres.df,income~education)
comment('단순회귀분석도 함수를 써서 가능')

## plot(model)
par(mfrow=c(2,2))
plot(mul.model1)
comment('residual vs fitted, normalqq, scale-location, residual vs leverage 4개가 나옴')

par(mfrow=c(3,2))
plot(mul.model1,which=1:6)
comment('6개의 그래프로 모델의 정규성, 등분산성 등을 확인')

par(mfrow=c(1,1))

## 다항 선형회귀
poly.model1<-lm(income~education+I(education^2),data=Pres.df)
summary(poly.model1)

library(dplyr) # arrange 함수를 쓰기 위한 패키지
plot(income~education,data=Pres.df,col='steelblue',pch=19)

### 다항그래프 그리기
with(Pres.df,lines(arrange(data.frame(education,fitted(poly.model1)),education),lty=1,lwd=3,col='tomato'))

#### 다항 그래프 그리기 코드 파헤쳐보기
fitted(poly.model1) # 예측값
data.frame(Pres.df$education,fitted(poly.model1)) # 데프로 만들기
comment('x축은 education, y축은 예측값')

arrange(data.frame(Pres.df$education,fitted(poly.model1)),Pres.df$education)
comment('education을 기준으로 오름차순')

lines(arrange(data.frame(Pres.df$education,fitted(model)),Pres.df$education),lty=1,lwd=3,col='tomato')
comment('다항 그래프 그리기')
