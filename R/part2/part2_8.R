rm(list=ls())

# 카이제곱 분포
x.chisq<-rchisq(n=10000,df=1)
hist(x.chisq,col='red')

x<-seq(0,15,length=200)
curve(dchisq(x,df=1),0,15,col='red',lwd=2,lty=5)
curve(dchisq(x,df=5),0,15,col='blue',lwd=2,lty=10,add=T)
curve(dchisq(x,df=10),0,15,col='green',lwd=2,lty=15,add=T)
comment('카이제곱은 자유도가 커질수록 누워지는 그래프가 그려짐')

legend(12,1,legend=c('df=1','df=5','df=10'),lty=c(5,10,15),col=c('red','blue','green'))
comment('(12,1는 좌표를 의미해서 해당좌표에 범례가 보여짐')

legend('topright',legend=c('df=1','df=5','df=10'),lty=c(5,10,15),col=c('red','blue','green'))
comment('좌표가 아닌 top/bottom left/right을 활용하여 범례위치를 지정')

# 누적확률값으로 확류변수 구하기
qchisq(p=0.95,df=1)
qchisq(p=0.95,df=1,lower.tail=F)

# x값으로 누적확률 구하기
pchisq(q=2.5,df=1)
pchisq(q=3.841459,df=1)
pchisq(q=5,df=1)
pchisq(q=5,df=1,lower.tail=T)
comment('lower.tail=T이 기본값')

# 카이제곱 데이터 만들기
## 안전벨트 착용과 승객 안전 간의 관계분석
### 관측빈도
survivors<-matrix(c(1443,1781,151,312,47,135),nr=3,byrow=T)
dimnames(survivors)<-list(Status=c('minor','serious','dead'),Seatbelt=c('With Seatbelt','Without Seatbelt'))
survivors

## 각 행과 각 열의 총합 구하기
addmargins(survivors,margin = 1) # 열 기준
addmargins(survivors,margin = 2) # 행 기준
addmargins(survivors) # 전체

## 각 행과 각 열의 비율 구하기
addmargins(survivors,2)
comment('행 기준으로 총합을 구함')

prop.table(addmargins(survivors,2),2)
comment('열 기준으로 확률을 다 더하면 1')

addmargins(prop.table(addmargins(survivors,2),2),1)
comment('열 기준으로 총합을 구하면 1로 나옴')

### 기대빈도
expected<-matrix(c(1367,1855.9,196.9,267.4,77.1,104.7),nc=2,byrow=T)
dimnames(expected)<-list(Status=c('minor injury','serious injury','dead'),Seatbelt=c('With Seatbelt','Without Seatbelt'))
expected

### 카이제곱 값
sum((survivors-expected)^2/expected)
comment('(관측빈도-기대빈도)^2/기대빈도 의 총합=카이제곱값값')

## 막대 그래프 그리기
### 빈도수로 그래프
par(mfrow=c(1,2))
barplot(survivors,ylim=c(0,2500),las=1,col=c('yellowgreen','lightsalmon','orangered'),ylab='Frequency',main='Frequency of Survivors')
legend(0.2,2500,rownames(survivors),fill=c('yellowgreen','lightsalmon','orangered'))

### 빈도확률로 그래프
survivors.prop<-prop.table(survivors,2)
barplot(survivors.prop*100,las=1,col=c('yellowgreen','lightsalmon','orangered'),
        ylab='Percent',main='Prercent of Survisors')

## 데프로 바꾸어서 진행해보자
survivors.df<-data.frame(survivors)
survivors.df

## 열과 행이름 바꾸기
survi_chisq_df<-survivors.df
colnames(survi_chisq_df)<-c('With Seatbelt','Without Seatbelt')
rownames(survi_chisq_df)<-c('경상','중상','사망')
survi_chisq_df

## 안전벨트 존재 여부 모두 합쳐서 새로운 열 만들기
survi_chisq_df$sum<-survi_chisq_df$`With Seatbelt`+survi_chisq_df$`Without Seatbelt`
survi_chisq_df

## 확률표로 만들기
ex.freq<-survi_chisq_df/sum(survi_chisq_df$sum)
ex.freq
ex.freq$sum

x1.exval<-sum(survi_chisq_df$`With Seatbelt`) # 안전벨트O 총수
x2.exval<-sum(survi_chisq_df$`Without Seatbelt`) # 안전벨트X 총수

belto.exval<-x1.exval*ex.freq$sum 
belto.exval
comment('안전벨트O의 기대빈도')

beltx.exval<-x2.exval*ex.freq$sum
beltx.exval
comment('안전벨트O의 기대빈도')
(survivors.df$With.Seatbelt)
sum((survi_chisq_df$`With Seatbelt`-belto.exval)^2/belto.exval)+sum((survi_chisq_df$`Without Seatbelt`-beltx.exval)^2/beltx.exval) # 카이제곱값

# 신뢰수준 95%의 구간은 어디 인가??
## 일단 확률변수를 구해보자
x.chisq.95<-qchisq(0.05,df=2,lower.tail=F)

x<-seq(0,8,length=300)
y<-dchisq(x,df=2)
plot(x,y,col='black',lwd=1,type='l',main='CHISQ distribution(df=2)',xlab='x',ylab='y')
xlim<-x[x>=x.chisq.95]
ylim<-y[x>=x.chisq.95]
xlim<-c(xlim[1],xlim,tail(xlim,1))
ylim<-c(0,ylim,0)
polygon(xlim,ylim,col='grey')

# 카이제곱의 독립성 검정
comment('두범주형 변수를 비교하여 서로 독립인지 확인')

## 타이타닉셋
Titanic
class(Titanic) # df가 아닌 테이블 형식
str(Titanic)

## 생존여부와 좌석의 비교
mt_tat<-margin.table(Titanic,margin=c(4,1))
mt_tat
comment('4는 Survived, 1은 Class')

### 클래스별 생존 여부 그래프
barplot(mt_tat,col=c('red','green'))
legend('topleft',legend=c('사망','생존'),fill=c('red','green'))

### 교차표
addmargins(mt_tat) # 전체
addmargins(mt_tat,1) # 열기준
addmargins(mt_tat,2) # 행기준

addmargins(prop.table(addmargins(mt_tat,2),2),1)

## 카이제곱 테스트 => 독립성 검정
chisq.test(mt_tat)
comment('ho기각 => 두변수의 독립성 차이가 있음')

## 생존여부와 성별의 비교
mt_tat<-margin.table(Titanic,margin=c(4,2))
mt_tat
comment('4는 Survived, 2은 Sex')

barplot(mt_tat,col=c('red','green'))
legend('topright',fill=c('red','green'),legend=c('사망','생존'))

chisq.test(mt_tat)
comment('ho기각 => 생존여부와 성별은 종속관계')

## 생존여부와 나이의 비교
mt_tat<-margin.table(Titanic,margin=c(4,3))
mt_tat
comment('4는 Survived, 3은 Age')

barplot(mt_tat,col=c('red','green'))
legend('topleft',fill=c('red','green'),legend=c('사망','생존'))

chisq.test(mt_tat)
comment('ho기각 => 생존여부와 나이는 종속관계')

# 두범주형 변수 간의 관련성의 강도 평가
Titanic.margin<-margin.table(Titanic,margin=c(4,1))
Titanic.margin

library(vcd)
comment('assocstats(), mosaic() 함수를 사용 할 수 있게 해주는 패키지 불러오기')

assocstats(Titanic.margin)
comment('우도비,피어슨, phi-상관계수, 카멜v값 등을 보여줌')

# 두범주형 변수 간의 모자이크 그래프로 시각화
## 방법 1
mosaic(Titanic.margin,shade=T,legend=T)

## 방법 2
mosaic(~Survived+Class,data=Titanic.margin,shade=T,legend=T)

# survey셋 => MASS패키지
str(survey)

## 카이제곱 검정
### 방법 1
chisq.test(table(survey$Fold,survey$Sex))

### 방법 2
with(survey,chisq.test(Fold,Sex))

# 세이동통신사의 시장점유율의 검증
## 세이동통신사의 시장점유율이 동일한지 검정(50/50/50)
## 총 150개 중 A사 60명, B사 55명, C사 35명
chisq.test(c(60,55,35))
comment('ho기각 => 동일하지 않음')

## 세이동통신사의 시장점유율이 45%/30%/25%로 점유 하고 있는지 검정
chisq.test(c(60,55,35),p=c(0.45,0.3,0.25))
comment('ho기각X => 회사는 비율대로 점유하고 있음')

## 세이동통신사의 시장점유율이 작년과 비교하여 검정
chisq.test(c(60,55,35),p=c(45,25,15)/85)
comment('ho기각 => 작년과 비교하여 동일하지 않음')

# HairEyeColor셋 => 기본 내장 데이터셋
## 데이터 확인
str(HairEyeColor)
summary(HairEyeColor)
Hair.tab<-margin.table(HairEyeColor,margin=c(1))
Hair.tab

## 검은색/갈색/빨강색/금색 비율이 25%/50%/10%/15% 일 때 적합한지 검정
chisq.test(Hair.tab,p=c(0.25,0.5,0.1,0.15))
comment('h0기각 => 동일하지 않음')

# survey셋 => MASS패키지
## 데이터 확인
str(survey)
smoke.tab<-table(survey$Smoke)
smoke.tab

## 비흡연자 70%, 나머지 흡연유형 10%씩 동일한지 검증
chisq.test(smoke.tab,p=c(0.1,0.7,0.1,0.1))
comment('ho기각 => 비율대로 흡연 유형이 동일하지 않음')
