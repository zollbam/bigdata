rm(list=ls())

# F분포
v<-rf(n=10000,df1=1,df2=30)
hist(v,col='steelblue')

x<-seq(0,15,length=200)
curve(df(x,df1=1,df2=30),0,15,col='tomato',lwd=2,lty=1,main='F distribution',xlab='x',ylab='y')
curve(df(x,df1=5,df2=50),0,15,col='skyblue',lwd=2,lty=1,add=T)
curve(df(x,df1=10,df2=80),0,15,col='magenta',lwd=2,lty=1,add=T)
legend('topright',legend=c('df1=1,df2=30','df1=5,df2=50','df1=10,df2=80'),col=c('tomato','skyblue','magenta'),lty=c(1,1,1))

# 확률로 f값 구하기
qf(p=0.95,df1=1,df2=30)
qf(p=0.9,df1=10,df2=15)

# f값으로 누적확률 구하기
pf(q=4.170877,df1=1,df2=30)
pf(q=4.170877,df1=1,df2=30,lower.tail=F)

# ADHD의 2가지 심리치료 방법에 따른 치료효과 차이 검정
adhd<-data.frame(score=c(95,105,98,103,107,110,125,105,113,120),
                 therapy=c(rep('A',5),rep('B',5)))
adhd

## 전체 평균
all.mean<-mean(adhd$score)
all.mean

## 심리치료별 평균 점수
th.mean<-tapply(adhd$score, adhd$therapy, mean)
th.mean

## 심리치료별 개수
th.cou<-table(adhd$therapy)
length(th.cou)

## 집단간 분산
grou_gan_var<-((th.mean['A']-all.mean)^2*th.cou['A']+(th.mean['B']-all.mean)^2*th.cou['B'])/(length(th.cou)-1)
comment('(집단별평균-전체평균)^2의 총합/(집단개수-1)=집단간분산
        ((101.6-108.1)^2*5+(114.6-108.1)^2*5)/(2-1)=422.5')

## 집단내 분산
A.sc<-adhd$score[1:5] # 심리치료 A의 데이터
B.sc<-adhd$score[6:10] # 심리치료 B의 데이터

grou_nae_var<-(sum((A.sc-th.mean[1])^2)+sum((B.sc-th.mean[2])^2))/(sum(th.cou-1))
comment('((그룹의 데이터-그룹내 평균)^2의 총합)/((그룹내개수-1)의 총합)
        ((95-101.6)^2+(105-101.6)^2+(98-101.6)^2+(103-101.6)^2+(107-101.6)^2+(110-114.6)^2+(125-114.6)^2+(105-114.6)^2+(113-114.6)^2+(120-114.6)^2)/8=44.05')

## F값
F.value<-grou_gan_var/grou_nae_var
F.value

## 분산분석
str(adhd)

adhd.aov<-aov(score~therapy,data=adhd) # 분산분석
summary(adhd.aov)

# F값은 두 개의 자유도에 의해 분포의 모양이 결정되는 F분포를 따름
x<-seq(0,4,length=100)
F.1<-df(x,df1=1,df2=30)
F.5<-df(x,df1=5,df2=25)
F.25<-df(x,df1=25,df2=5)
plot(x,F.1,lty=1,lwd=3,col='black',type='l',ylim=c(0,1),main='PDF of F distribution',ylab='y',xlab='x')
lines(x,F.5,lty=3,lwd=3,col='blue')
lines(x,F.25,lty=5,lwd=3,col='red')
legend('topright',lty=c(1,3,5),col=c('black','blue','red'),legend=c('df = 1, 30','df = 5, 25','df = 25, 5'))

# F(df= 4, 4)일 때 95%수준의 그래프
x<-seq(0,7,length=200)
y<-df(x,df1=1,df2=8)
plot(x,y,col='black',type='l',main='F distribution (df1=1, df2=8)')

f.95<-qf(0.05,df1=1,df2=8,lower.tail=F)

xlim<-x[x>=f.95]
ylim<-y[x>=f.95]
xlim<-c(xlim[1],xlim,tail(xlim,1))
ylim<-c(0,ylim,0)
polygon(xlim,ylim,col='grey')
