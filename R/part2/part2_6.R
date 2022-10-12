rm(list=ls())

# t분포
## 자유도가 30/5/1 일때
x<-seq(-3,3,length=200)
curve(dt(x,df=30),min(x),max(x),col='darkblue',lty=1,lwd=3,main='PDF of t-distribution',xlab='x',ylab='density')
curve(dt(x,df=5),min(x),max(x),col='violet',lty=2,lwd=3,add=T)
curve(dt(x,df=1),min(x),max(x),col='tomato',lty=3,lwd=3,add=T)
legend('topleft',legend=c('df=30','df=5','df=1'),col=c('darkblue','violet','tomato'),lty=c(1,2,3))
comment('자유도가 클수록 정규분포를 따르고 점점 분포가 적어지는 것을 확인')

# t검정
## 학업 스트레스로 인한 대학원 박사과정 학생들의 혈압과 일반인의 혈압 비교
## H0: 일반평균=학생평균, H1: 일반평균!=학생평균
## n=20, 학생평균=135, s=25, 일반인 평균=115
## t값=(135-115)/(25/(루트20))=3.58
t<-(135-115)/(25/(sqrt(20)))
t

pt(t,df=19,lower.tail = F)*2
comment('자유도가 19일때 t값에 대한 양측 유의 수준을 구함')

qt(0.025,df=19,lower.tail=F)
comment('신뢰수준이 95%인 양측검정의 t값 구하기
        신뢰수준이 97.5인 상단측검정의 t값 구하기')

qt(0.005,df=19,lower.tail=F)
comment('신뢰수준이 99%인 양측검정의 t값 구하기')

# t분포 그래프
x<-seq(-4,4,length=200)
y<-dt(x,df=19)
plot(x,y,col='blue',type='l',main='t-distribution (df=19)')

xlim<-x[-4<=x & -2.09>=x] # -2.09는 95%신뢰수준의 왼쪽
ylim<-y[-4<=x & -2.09>=x]
xlim<-c(xlim[1],xlim,tail(xlim,1))
ylim<-c(0,ylim,0)
polygon(xlim,ylim,col='grey')

xlim<-x[4>=x & 2.09<=x] # -2/.09는 95%신뢰수준의 왼쪽
ylim<-y[4>=x & 2.09<=x]
xlim<-c(xlim[1],xlim,tail(xlim,1))
ylim<-c(0,ylim,0)
polygon(xlim,ylim,col='grey')

# 자유도가 다를 때 히스토그램과 t분포 비교
v<-rt(n=1000,df=29)
hist(v,col='pink',main="T Distribution",freq=F)

## 자유도가 1일 때
curve(dt(x,df=1),-4,4,col='black',lwd=3,lty=2,add=T)

## 자유도가 19일 때
curve(dt(x,df=19),-4,4,col='red',lwd=3,lty=2,add=T)

## 자유도가 29일 때
curve(dt(x,df=29),-4,4,col='yellow',lwd=3,lty=2,add=T)

## 표준정규분포를 t그래프에 겹쳐보기
curve(dnorm(x),-4,4,add=T,col='green',lwd=5,lty=4)
cooment('t분포의 자유도가 19/29일때는 거의 표준정규와 비슷')

# 단일표본 평균검정
## cats셋
## H0: 고양이의 몸무게는 2.6KG이다., H1: 2.6KG이 아니다.
library(MASS) # cats 데이터를 사용하기 위한 패키지 불러오기
str(cats)
mean(cats$Bwt)
comment('Sex는 팩터, Bwt/Hwt는 수치형')

### t검정
t.test(cats$Bwt,mu=2.6)
comment('p값이 0.05보다 작으므로 귀무가설 기각')

cats.t<-t.test(cats$Bwt,mu=2.6)
cats.t$p.value # p값
cats.t$conf.int # 신뢰구간
cats.t$estimate # 데이터의 평균 추정치

### t검정 => 추정치가 2.7..이라서 mu값을 높여봄
t.test(cats$Bwt,mu=2.7)
comment('p값이 0.05보다 크므로 귀무가설 기각안함')

## H0: 고양이의 몸무게는 2.6KG보다 작음, H1: 2.6KG보다 큼 => 상단측검정
t.test(cats$Bwt,mu=2.6,alternative='greater')
comment('ho기각 하므로 평균이 2.6보다 큼')

## 종속을 Bwt(수치형), 독립을 Sex(범주형)으로 두고 t검정
table(cats$Sex)

t.test(Bwt~Sex,data=cats)
comment('여성 자유도 46, 남성 자유도 96을 어떠한 공식을 써서 136.84라는 자유도가 나옴
        귀무가설은 성별의 평균이 동일함
        대립가설은 성별의 평균이 동일 하지 않음')

t.test(Bwt~Sex,data=cats,conf.level=0.99)
comment('이거는 신뢰수준이 99%인 t검정
        h0가 기각되므로 성별의 평균은 동일하지 않다는 것을 확인')

### 추정치의 평균이 맞는지 확인 해보자
mean(cats$Bwt)

#### 성별에 따른 Bwt의 평균
tapply(cats$Bwt,INDEX=list(Sex=cats$Sex),mean)
aggregate(cats$Bwt,by=list(cats$Sex),mean)

# sleep데이터셋
data(sleep)
str(sleep)
str(sleep)
t.test(extra~group,data=sleep,paired=T)
comment('paired=옵션은 무엇인가??')

# 자유도에 따른 pt()와 qt()함수
pt(q=2.04523,df=29) # 자유도가 29일때 95%
pt(q=2.09,df=19) # 자유도가 19일때 95%
pt(q=3.58,df=19) # 자유도가 19일때 99%

qt(p=0.975,df=29) # 자유도가 29일때 신뢰수준이 95%인 t값
qt(p=0.995,df=19) # 자유도가 19일때 신뢰수준이 99%인 t값
