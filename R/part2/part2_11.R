rm(list=ls())
colors()

# CO2셋
str(CO2)

## Treatment가 childed인 데이터 추출
co2.chill<-subset(CO2,Treatment=='chilled')
co2.chill$conc<-factor(co2.chill$conc) # 타입변경(수치->요인)

## 반복측정 이원분산분석
co2.aov<-aov(uptake~Type*conc+Error(Plant/conc),data=co2.chill)
summary(co2.aov)
unique(co2.chill$conc)

## 상자도표로 주효과와 상호효과 확인
par(mar=c(6,4,4,2))
boxplot(uptake~Type*conc,data=co2.chill,
        col=c('deepskyblue','violet'),las=2,cex.axis=0.75,
        ylab='Carbon dioxide uptake rate',
        main='Effets of Plant Type and CO2 on Carbon Dixpxode Uptake')
legend('topleft',inset=0.0001,legend=c('Quebec','Mississippi'),fill=c('deepskyblue','violet'),cex=0.7)

## HH패키지의 interaction2wt()함수로 주/상호 효과 확인
library(HH)
interaction2wt(uptake~Type*conc,data=co2.chill)

# sexab셋
comment('아동기의 성폭력 경험이 성인의 정신건강에 미치는 영향 연구')

## 데이터 확인
library(faraway)
str(sexab)
class(sexab)
summary(sexab)

## 집단별 요약 통계량 확인
tapply(sexab$ptsd,INDEX=sexab$csa,mean) # csa별 ptsd 평균
tapply(sexab$ptsd,INDEX=sexab$csa,sd) # csa별 ptsd 표준편차

### csa열의 개수 확인
tapply(sexab$ptsd,INDEX=sexab$csa,length)
table(sexab$csa)

## 공분산 분석
sexab.aov<-aov(ptsd~cpa+csa,data=sexab)
summary(sexab.aov)

sexab.aov1<-aov(ptsd~csa+cpa,data=sexab)
summary(sexab.aov1)

sexab.aov2<-aov(ptsd~cpa*csa,data=sexab)
summary(sexab.aov2)

sexab.aov3<-aov(ptsd~csa*cpa,data=sexab)
summary(sexab.aov3)

## effects패키지 effect함수
library(effects)
effect('csa',sexab.aov)
comment('공변량의 영향 제거한 후 외상 후 스트레스 장애의 집단 평균 계산')

## 종속변수,공변량, 독립변수 간의 관계 그래프
library(HH)
ancova(ptsd~csa+cpa,data=sexab)
ancova(ptsd~cpa+csa,data=sexab)

ancova(Species~Sepal.Length+Sepal.Width,data=iris)
str(sexab)

# Skulls데이터셋
comment('이지브 지역에서 발굴된 인간의 두개골 크기 측정')

## 데이터 확인
library(heplots)
data(Skulls)
str(Skulls)
class(Skulls)
summary(Skulls)

## 행 랜덤 추출
library(dplyr)
sample_n(Skulls,10)
comment('Skulls 데이터에서 랜덤으로 10행을 뽑아줌')

## 두개골 크기가 시대별로 다른지 확인
y<-with(Skulls,cbind(mb,bh,bl,nh))
y

with(Skulls,aggregate(y,by=list(epoch),mean))
comment("epoch별 각 열의 평균 구하기")

## manova()함수
Skulls.manova<-with(Skulls,manova(y~epoch))
summary(Skulls.manova)
summary.aov(Skulls.manova)
