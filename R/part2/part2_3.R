rm(list=ls())
colors()

# 표준정규분포 그리기
x<-seq(-3,3,length=100)
comment('여기서 x는 확률변수
        seq(-3,3,100)로만하면 100개의 값을 뽑지않고 1개의 값만 추출함
        100이 증감값이 되기 때문에')

dnorm(x,0,1)
comment('x에 있는 확률변수의 정규분포의 확률을 구한값을 반환해줌
        평균은 0, 표준편차가 1인 정규분포 => 표준정규분포')

plot(x,dnorm(x,mean=0,sd=1),type='l',main='Nomarl Distibution',col='peru',lwd=3,ylab='norm properity')

# x의 범위가 바뀌면 어떤 모양이 나올까??
x<-seq(0,100,length=100)
comment('확률변수의 값이 0~100으로 바뀜')

plot(x,dnorm(x,mean=0,sd=1),type='l',col='yellow4',lwd=3)
comment('확률변수의 값은 0~100으로 넓게 퍼져 있는데 평균과 표준편차는 정규분포 그래로 쓰니까 그래프가 왼쪽으로 치우친 그래프가 그려짐')

plot(x,dnorm(x,mean=50,sd=10),type='h',col='darkblue',ylab='p')
comment('type에 관한 옵션은 파트2 3장 9쪽에 적어둠 => p,l,o 등 다양함')

plot(x,dnorm(x,mean=80,sd=5),type='o',col='springgreen1',ylab='p')
comment('이번에는 오른쪽으로 치우쳐진 정규분포를 그려봄')

# 평균키 표준정규그래프
x<-seq(140,200,length=500)
y<-dnorm(x,mean=170,sd=20)
plot(x,y,main='Height Norm',col='blue',pch='^')

# 연습문제
## 국민평균 소득의 평균은 30000달러, 표준편차는 10000달러인 정규분포 따름
## X는 개인의 소득을 나타냄 확률변수
## 25000달러에서 35000달러 사이에 있을 확률은???
pnorm(35000,30000,10000)
comment('정규분포에서 35000달러이하의 누적 확률을 구해줌')

pnorm(25000,30000,10000)
comment('정규분포에서 25000달러이하의 누적 확률을 구해줌')

result<-pnorm(35000,30000,10000)-pnorm(25000,30000,10000)
cat(paste0('어떤 사람의 소득이 25000~35000달러 사이에 있을 확률은 ',result,'입니다.'))
comment('정규분포에서 25000달러초과 35000달러이하의 누적 확률을 구해줌')

## 소득의 그래프 그리기
x<-seq(10000,50000,length=1000)
y<-dnorm(x,30000,10000)
plot(x,y,type='l',main='$25000~$35000 사이에 있을 확률')
xlim<-x[x>25000 & x<35000]
ylim<-y[x>25000 & x<35000]
comment('x확률변수를 이용해 인덱스를 구해 y범위를 구할 수 있음')

ylim<-c(0,ylim,0)
comment('y의 범위의 양쪽에 0을 넣어주지 않으면 아래면적은 색칠이 안됨')

xlim<-c(xlim[1],xlim,tail(xlim,1))
comment('ylim과 범위를 맞추기 위해 추가해줌')

polygon(xlim,ylim,col='peru')
comment('xlim과 ylim의 범위를 색칠함')

## 소득이 25000보다 작을 확률
pnorm(25000,30000,10000)

x<-seq(10000,50000,length=1000)
y<-dnorm(x,30000,10000)
plot(x,y,type='l',col='darkblue')
xlim<-x[x<25000]
ylim<-y[x<25000]
xlim<-c(x[1],xlim,tail(xlim,1))
ylim<-c(0,ylim,0)
polygon(xlim,ylim,col='black')

## 소득이 35000보다 클 확률
pnorm(35000,30000,10000,lower.tail=F)

x<-seq(10000,50000,length=1000)
y<-dnorm(x,30000,10000)
plot(x,y,type='l',col='darkblue')
xlim<-x[x>35000]
ylim<-y[x>35000]
xlim<-c(xlim[1],xlim,tail(xlim,1))
ylim<-c(0,ylim,0)
polygon(xlim,ylim,col='pink')

# 균등분포 그리기
x<-seq(0,100,length=100)
y<-dunif(x,max=100,min=0)
plot(x,y,main='Unif Distibution',col='red',pch='*')
plot(x,y,main='Unif Distibution',col='red',pch='-')
plot(x,y,main='Unif Distibution',col='red',pch='o')

# 표준정규분포 유의확률 구간간
pnorm(1,0,1)-pnorm(-1,0,1) # 68%구간
pnorm(2)-pnorm(-2) # 95%구간
pnorm(2.56)-pnorm(-2.56) # 99%구간

# 내 점수에 따른 상위 몇퍼인지 등수가 궁금해만들어봄
1-pnorm(87,mean=68,sd=10)
comment('내 점수가 87점인데 평균이 68이고 표준편차가 10인 경우 나는 상위 몇 프로 인가를 알려주는 코딩')

(1-pnorm(87,mean=68,sd=10))*200
comment('200명 학생중에 몇등인지 알아보기 위한 코딩')

# 연습문제
## 수학
pnorm(70,60,10,lower.tail = F)
comment('lower.tail=옵션은 누적확률을 왼쪽으로 할지 오른쪽으로 할지 정해주는 것
        상위 15퍼를 위미')

## 영어
pnorm(80,70,20,lower.tail = F)
comment('상위 30퍼를 의미')

# 확률밀도함수
x<-seq(-3,3,length=5000)
curve(dnorm(x),-3,3,xlab='X',ylab='Y',main='Probability Density Function')

# 누적확률밀도함수
curve(pnorm(x),-3,3,xlab='X',ylab='Y',main='Cumulative Density Function')

# 연습문제
## 동전이 앞면이 나올 확률이 0.5일때 100회 던지기
## 앞면이 나오는 횟수를 X가 그래프 그려보자
x<-rbinom(10000,size=100,prob=0.5)
comment('prob=옵션을 쓰지 않으니 오류가 나옴
        이항분포의 평균은 np, 분산은 np(1-p), 표준편차는 sqrt(np(1-p))이므로
        평균은 50, 분산은 25, 표준편차는 5')

hist(x,col='skyblue',breaks=20,freq=F,xlab='X',ylab='MASS',main='B(100,0.5)')
comment('hist()에서는 prob=, plot()에서는 freq=옵션을 사용함')

curve(dnorm(x,50,5),25,75,add=T,lty=2,lwd=2,col='red')
comment('x의 최대값은 75, 최소값은 25')
