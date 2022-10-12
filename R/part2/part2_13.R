rm(list=ls())
colors()

# GaltonFamilies셋
comment('부모와 자녀의 키는 관계가 있을까??')

## 데이터 확인
library(HistData) # GaltonFamilies셋을 불러오기 위한 패키지 불러오기
df<-GaltonFamilies
str(df)
comment('childHeight열은 종속, midparentHeight열은 독립')

## 상관계수
cor(df$midparentHeight,df$childHeight)

## 상관 그래프 
plot(childHeight~midparentHeight,data=df, col=adjustcolor('red',alpha=.1),pch=19)
comment('alpha=옵션은 값이 낮을수록 투명도가 높아짐')

plot(jitter(childHeight)~jitter(midparentHeight),data=df, col=adjustcolor('steelblue',alpha=.3),pch=19)
comment('jitter()함수로 조금의 노이즈를 두어 그래프를 조금 흔들리게 만듬')

### jitter()함수 예시
x.r=rep(1.5,100)
x.r.j<-jitter(x.r)
plot(x.r.j,x.r,col='red',pch=20,ylim=c(1.45,1.55))

## 회귀분석
model<-lm(childHeight~midparentHeight,data=df)
model

## 회귀분석 그래프
plot(childHeight~midparentHeight,data=df,pch=20,col=adjustcolor('blue',alpha.f=0.1))
abline(model,col='tomato',lty=1,lwd=3)
comment('이전에 그려진 그래프에 추가되어 그려짐')

## 자녀의 성별에 따라 키의 분포도 달라지지 않을까??
color.m<-adjustcolor('steelblue',0.3) # 남성일 때 색깔
color.f<-adjustcolor('orange',0.3) # 여성일 때 색깔

with(df,plot(midparentHeight,childHeight,pch=19,col=ifelse(gender=='male',color.m,color.f)))

### 남성데이터만 회귀분석
model.m<-lm(childHeight~midparentHeight,data=subset(df,gender=='male'))
model.m
abline(model.m,lty=1,lwd=3,col='steelblue')

### 여성데이터만 회귀분석
model.f<-lm(childHeight~midparentHeight,data=subset(df,gender=='female'))
model.f
abline(model.f,col='orange',lty=1,lwd=3)

# 회귀분석
x<-runif(n=100,min=0,max=10) # 균일분포의 확률분포
y<-3+2*x+rnorm(100,0,5)
round(x,2)
round(y,2)

plot(x,y,pch=19,col='skyblue')
cor(x,y)

model1<-lm(y~x)
abline(model1)
comment('정직한 직선 그래프')

summary(model1)
coef(model1) # 회귀계수만 보여줌
intercept<-coef(model1)[1] # 절편
slope<-coef(model1)[2] # 기울기
y.hat<-intercept+slope*x

r<-y-y.hat # 잔차
r

# 회귀분석(그래프를 조금더 흔들어봄)
x<-runif(n=100,min=0,max=10)
y<-x+-45 +rnorm(100,0,5)

plot(x,y,pch=19,col='skyblue')
cor(x,y)

model2<-lm(y~x)
abline(model2)
comment('그래프가 조금 흔들림')

summary(model2)
coef(model2)

# 회귀분석(그래프가 많이 흔들림)
x<-runif(n=100,min=0,max=10)
y<-3*x+5 +rnorm(100,0,20)

plot(x,y,pch=19,col='skyblue')
cor(x,y)

model3<-lm(y~x)
abline(model3)

summary(model3)

intercept<-coef(model3)[1]
slope<-coef(model3)[2]

abline(model3,col='peru',lwd=1,lty=2)
abline(a=intercept+5,b=slope,col='red',lwd=1,lty=3)
abline(a=intercept-5,b=slope,col='black',lwd=1,lty=4)
abline(a=intercept,b=slope+1,col='green',lwd=1,lty=5)
abline(a=intercept,b=slope-1,col='yellow',lwd=1,lty=6)
legend('topleft',legend=c('peru','red','black','green','yellow'),col=c('peru','red','black','green','yellow'),lty=c(2,3,4,5,6),cex=0.4)

# 회귀분석(설명변수가 2개)
x<-runif(n=100,min=0,max=100)
x1<-runif(n=100,min=0,max=30)
y<-3*x+x1+5 +rnorm(100,0,20)

plot(x,y,pch=19,col='skyblue')
cor(x,y)

model4<-lm(y~x+x1)
summary(model4)
comment('abline(model4)는 기울기 회귀계수가 2개이므로 두번째 설명변수의 회귀계수는 사용하지 않음')
