rm(list=ls())

# 반복시행(이항분포)
rbinom(n=10,size=10,prob=.5)
rbinom(n=100,size=10,prob=.5)
comment('n은 몇번시도할지 정해주는 옵션
        size는 1번 시도에서 몇번 시행할지 정해주는 옵션
        prob는 성공의 확률로 기본값은 0.5
        여기서 1번 시도에 나오는 숫자는 10번했을 시 성공 횟수를 의미함')

rbinom(n=100,size=10,prob=c(0.9,0.1,0.5))
comment('성공확률을 0.9, 0.1, 0.5 이런식으로 반복되면서 이항분포를 시행하고 있음')

# 윈도우 창 띄우기
windows(height=7,width=5)
comment('창에서 마우스 오른쪽을 눌러서 "맨위에 있도록 합니다를 눌러주어야함"')

v<-rbinom(n=10,size=1000,prob=.5)
v
hist(v,col='orange',breaks=20,freq=F)
hist(v,col='orange',breaks=20,freq=T)
?hist

# sample()
## 비복원 추출
sample(1:10,5)
comment('실행할 때마다 값이 바뀌어서 출력이 됨
        같은 숫자는 절대 같이 나올수 없음
        추출될 값인 1~10인 10개를 넘어서 추출할수는 없음 => sample(1:10,11)는 오류가 나옴')

## 복원 추출
sample(1:10,5,replace=T)
comment('비복원추출과 다르게 같은 숫자도 나올수 있으므로 뽑을 개수를 높게 잡아도 상관없음
        => sample(1:10,1000,replace=T)')

# 난수 생성(균등분포)
runif(n=100,min=0,max=100)
comment('0~100에서 소수점을 포함한 값을 100개 뽑아줌')

set.seed(2022)
v<-runif(n=500000,min=0,max=100)
hist(v,col='tomato',breaks=50,freq=T)
comment('500000개/50구간으로 거의 평균적으로 10000개가 나오게 됨')
hist(v,col='tomato',breaks=100,freq=T)
comment('500000개/100구간으로 거의 평균적으로 5000개가 나오게 됨')
comment('hist()에도 add=T옵션을 넣을 수 있음
        구간을 설정을 해서 y축의 빈도 개수를 줄일 수 있음')

mean(v)
sd(v)
comment('freq=이 T이면 빈도수, F이면 빈도확률')

hist(v,col='tomato',breaks=100,freq=F)
hist(v,col='tomato',breaks=50,freq=F)
comment('구간이 아무리 변해도 빈도의 확률은 1/(max-min)으로 나오게 됨')

# 색깔 변수
colors()

# 몬테카를로 시물레이션으로 원주율 계산하기
n_sim<-1000
x<-vector(length=n_sim) # FALSE가 1000개인 벡터
y<-vector(length=n_sim) # FALSE가 1000개인 벡터

res<-0 # 원넓이 안에 들어 가 있으면 1을 추가 해주는 변수
for (i in 1:n_sim){
  x[i]<-runif(1)
  y[i]<-runif(1)
  if ((x[i]^2+y[i]^2)<1){ # 해당 좌표가 반지름 길이가 1인 넓이 안에 있다면
    res<-res+1
  }
}
4*res/n_sim # 4*(원안에 있는 점의 수)/(총 시도 수)

circle<-function(x) sqrt(1-x^2)
plot(x,y,xlab='X',ylab='Y',col='blue')
curve(circle,0,1,add=T,col='red',lwd=2)

# 주사위를 던져 홀수가 나왔을 경우(A)에 5가 나올(B) 확률
## 조건부 확률률
n_sim<-10000
n_odd<-0
n_five<-0

for (i in 1:n_sim){
  trial=sample(1:6,1)
  if (trial %% 2==1) n_odd<-n_odd+1 # 홀수
  if (trial == 5) n_five<-n_five+1 # 5가 나올 확률
}
(2*0.99*0.99)/(0.99+0.99)
n_five/n_odd
comment('P(5|홀)로 0.3333에 근사')

p_odd<-n_odd/n_sim
comment('P(홀)로 0.5에 근사')

p_five<-n_five/n_sim
comment('P(5)로 0.16666에 근사')

p_five/p_odd
comment('P(5|홀)로 0.3333에 근사
        n_five/n_odd와 같은 값이 나옴')

# 질병 진단 시물레이션
## 유병율이 0.1%인 질병 검사를 몬테카를로 시물레이션으로 검사하기
## 단, 이 검삼의 민감도와 특이도는 둘다 99%라고 가정
n_sim<-10000 # 검사횟수
prevalence<-0.001 # 유병률
sensitivity<-0.99 # 민감도(=재현률)
specificity<-0.99 # 특이도
n_total_positive<-0 # 전체 질환 케이스 수
n_true_positive<-0 # 실제 환자수
n_false_positive<-0 # 오진 케이스 수

for(i in 1:n_sim){
  disease<-rbinom(1,1,prevalence) # 유병률 확률에 맞는 베르누이분포
  
  if (disease==0){ # 실제 병이 안 걸렸을 때
    diagnosis<-rbinom(1,1,1-specificity) # 오진율을 포함한 베르누이 분포
    if (diagnosis==1){
      n_total_positive<-n_total_positive+1
      n_false_positive<-n_false_positive+1
    }
  }
  
  if (disease==1){ # 실제 병이 걸렸을 때
    diagnosis<-rbinom(1,1,sensitivity) # 정확하게 잔단할 베르누이 분포
    if (diagnosis==1){
      n_total_positive<-n_total_positive+1
      n_true_positive<-n_true_positive+1
    }
  }
}
n_total_positive # 양성의 수
n_true_positive # 진양성의 수
n_false_positive # 위양성의 수

n_false_positive/n_total_positive # 오류율
n_true_positive/n_total_positive # 암판정받고 실제 암환자인 사람 
