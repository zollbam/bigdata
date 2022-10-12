rm(list=ls())

# 균등분포
## 평균=> (b-a)/2, 분산 => (b-a)^2/12
runif(1000,min=0,max=100)
unif_me<-100/2
unif_sd<-sqrt(10000/12)

x.unif<-runif(1000,0,100)
mean(x.unif) # 균일분포 평균
sd(x.unif) # 균일분포 분산

## 균등분포 그래프
hist(runif(1000,min=0,max=100),col='orange',main='Histogram of runif(100,0,100)')
hist(runif(10000,min=0,max=100),col='green',main='Histogram of runif(1000,0,100)')
hist(runif(100000,min=0,max=100),col='red',main='Histogram of runif(10000,0,100)')
hist(runif(100000,min=0,max=100),col='salmon',prob=T)
hist(runif(100000,min=25,max=50),col='salmon',prob=T,break=25)

# survey데이터셋
library(MASS) # survey데이터셋을 불러오기 위한 패키지 설치
height<-na.omit(survey$Height) # Height열의 NA제거
length(height)
hist(height,col='skyblue',breaks=20)

samp<-sample(height,size=30) # 비복원
X.bar<-mean(samp) # 표본의 평균
X.sd<-sd(samp) # 표본의 표준편차 => 표준오차

# 실제 평균이나 표준편차와 비교
mean(height)
X.bar

sd(height)
X.sd 

# 30개를 랜덤 추출하는 방법을 100000번 해보기
X.bar_100000<-c()
for(i in 1:100000){
  samp<-sample(height,size=30)
  X.bar_100000[i]<-mean(samp)
}

hist(X.bar_100000,col='skyblue',breaks=20,prob=T)
curve(dnorm(x,mean(X.bar_100000),sd(X.bar_100000)),160,180,col='tomato',add=T,lwd=3,lty=3)

# 남녀 체중
x.1<-rnorm(n=5000,mean=70,sd=5) # 남체중
x.2<-rnorm(n=5000,mean=50,sd=5) # 여체중
x<-c(x.1,x.2) # 벡터형식으로 합치기

hist(x,col='skyblue',breaks=20)

X.bar_kg<-c()
for(i in 1:100000){
  samp_kg<-sample(x,size=300)
  X.bar_kg[i]<-mean(samp_kg)
}

hist(X.bar_kg,col='skyblue',breaks=20,prob=T)
curve(dnorm(x,mean(X.bar_kg),sd(X.bar_kg)),50,70,col='tomato',add=T,lwd=3,lty=3)
comment('여기에 있는 x는 변수 x가 아닌 람다함수처럼 자기자신을 쓰는 함수라고 알면 됨')

# 이항분포
rbinom(1,1,0.5)
rbinom(1,10,0.5)
rbinom(10,10,0.5)
rbinom(100,10,0.5)

## 이항분포 그래프
X<-rbinom(10000,100,0.5)
hist(X,col='blue',freq=F)
curve(dbinom(x,100,0.5),30,70,add=T,col='red')

# 정규분포
## 경북대 학생 키의 평균이 172이고 표준편차가 10이라고 가정
X<-rnorm(1000,172,10)
hist(X,col='skyblue',freq=F,breaks=30)
curve(dnorm(x,172,10),152,192,add=T,col='peru',lwd=3)

### 학생키가 160보다 크거나 180보다 작을 확률
#### 방법1
pnorm(q=180,172,10)-pnorm(q=160,172,10)

#### 방법2
1-pnorm(180,172,10,lower.tail=F)-pnorm(q=160,172,10)

### 상위 5%/하위 5%의 학생 키는??
qnorm(0.95,172,10) # 상위 5% 키
qnorm(0.05,172,10) # 하위 5% 키

qnorm(c(0.05,0.95),172,10) # 상위 5%/하위 5% 키

## 표준정규분포 => N(0,1^2)
x<-seq(-3,3,length.out=200)
x1<-seq(-3,3,length=200)
comment('length=와 length.out=은 별 차이는 없는거 같음')

plot(dnorm(x,0,1),col='red',xlab='x',ylab='dnorm(x)',type='l',lwd=3)

### qnorm(), pnorm()
qnorm(c(0.025,0.975),0,1) # 유의수준 95%
pnorm(c(-1.96,1.96),0,1) # 유의수준 약 95%

qnorm(c(0.005,0.995),0,1) # 유의수준 99%
pnorm(c(-2.58,2.58),0,1) # 유의수준 약 99%

1-pnorm(-1,0,1)-pnorm(1,0,1,lower.tail=F) # 약 90퍼 수준
1-pnorm(-1.96)-pnorm(1.96,lower.tail=F) # 약 95퍼 수준
1-pnorm(-2.58)-pnorm(2.58,lower.tail=F) # 약 99퍼 수준

# 신뢰수준
x<-seq(-3,3,length=100)
y<-dnorm(x)
plot(x,y,col='black',type='l',lwd=3)
xlim<-x[-2.58<x & x<2.58]
ylim<-y[-2.58<x & x<2.58]
xlim.new<-c(xlim[1],xlim,tail(xlim,1))
ylim.new<-c(0,ylim,0)

polygon(xlim.new,ylim.new,col='yellow')

xlim<-x[-1.96<x & x<1.96]
ylim<-y[-1.96<x & x<1.96]
xlim.new<-c(xlim[1],xlim,tail(xlim,1))
ylim.new<-c(0,ylim,0)

polygon(xlim.new,ylim.new,col='blue')

xlim<-x[-1<x & x<1]
ylim<-y[-1<x & x<1]
xlim.new<-c(xlim[1],xlim,tail(xlim,1))
ylim.new<-c(0,ylim,0)

polygon(xlim.new,ylim.new,col='pink')

# 중심극한정리
X.norm<-rnorm(10000,50,25)
hist(X.norm,col='orange',freq=F,ylim=c(0,0.02))
mean(X.norm)
sd(X.norm)

X.bar<-c()
for (i in 1:10000){
  X.bar<-c(X.bar,mean(sample(X.norm,size=100)))
}
hist(X.bar,col='blue',freq=F,breaks=20)















