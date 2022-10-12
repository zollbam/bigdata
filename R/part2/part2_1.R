rm(list=ls())

# survey셋
library(MASS)
str(survey)
?survey

# 범주형자료의 levels확인
levels(survey$W.Hnd) # 오른손잡이,왼손잡이
levels(survey$Clap) # 박수치는 손

# 빈도표
## 잘쓰는 손을 조사
freq.tab<-table(survey$W.Hnd)
freq.tab

freq.prop<-prop.table(freq.tab)
freq.prop

## 박수치는 손
freq.tab_cl<-table(survey$Clap)
freq.tab_cl

freq.prop_cl<-prop.table(freq.tab_cl)
freq.prop_cl

# 빈도표로 막대그래프 그려보기
## W.Hnd
barplot(freq.tab,col='steelblue',xlab='Writing Hand',ylab='Frequency',main='Frequency table of writing hand')

## Clap
barplot(freq.prop_cl,col='pink',xlab='Clap Hand',ylab='Property',main='Property table of clap hand')

# 연속형 데이터 탐색
height<-survey$Height
length(height) # 길이
mean(height,na.rm=T) # 평균
median(height,na.rm=T) # 중앙값
max(height,na.rm=T)
min(height,na.rm=T)

quantile(height,probs=0.9,na.rm=T)
comment('90백분위수를 출력')

quantile(height,probs=c(0.25,0.75),na.rm=T)
comment('1사분위수/3사분위수를 출력')

comment('probs=옵션으로 내가 원하는 범위의 값을 출력 할 수도 있음
        na.rm=T로 na값을 제거하고 백분위수를 구해줌')

quantile(height,probs=c(0.45,0.95,0.99),na.rm=T)

## 히스토그램 그리기
hist(height,col='steelblue',breaks=15,xlim=c(140,210),ylim=c(0,50))

## 원하는 열만 빼서 통계량 요약
df<-subset(survey,select = c(2,3,6,10,12))
summary(df)

library(psych)
describe(df)

library(stargazer)
stargazer(survey,type='text',title='Summary of survey dataset')
comment('type=옵션이 html이면 html형식으로
        text이면 텍스트형식으로
        latex이면 라텍(라텍스) 라고 불리는 테이블이라는 형식으로 출력
        stargazer의 가장 좋은점은 데프에서 int나 num같은 수치형 열들로만 요약통계량을 보여주는 것에 있음')

# 집단별 기술 통계량
## 방법1
tapply(survey$Pulse,INDEX=survey$Sex,FUN=mean,na.rm=T)
comment('성별로 맥박수(Pulse)의 평균을 구한 것')

## 방법2
with(survey,tapply(Pulse,INDEX=Sex,FUN=mean,na.rm=T))
comment('with()함수에 데프를 넣으로써 tapply()함수에서는 $기호를 적을 필요가 없음')

with(survey,tapply(Pulse,list(Sex,Exer),mean,na.rm=T))
comment('list로 2개 열을 잡고 통계량을 구할 수도 있음')

## 방법3
attach(survey)
tapply(Pulse,Sex,mean,na.rm=T)

tapply(Pulse,Exer,sum,na.rm=T)
tapply(Pulse,Exer,sd,na.rm=T)
comment('다른 변수들과의 통계량도 확인 해봄')
detach(survey)

## 방법4
aggregate(survey$Pulse,by=list(survey$Exer),FUN=mean,na.rm=T)
with(survey,aggregate(Pulse,list(Exer,Sex),sum,na.rm=T))

with(survey,aggregate(Pulse,list(exer=Exer,sex=Sex),sum,na.rm=T))
comment('그룹으로 지정된 것의 이름을 지정해 줄 수 있음')

aggregate(survey$Pulse,list(survey$Exer,survey$Sex),mean,na.rm=T)

# 순서형 팩터 지정 방법
cr_rat<-c("AAA", "AA", "A", "BBB", "AA", "BBB", "A")
cr_factor_ord<-factor(cr_rat,ordered=TRUE,levels=c("AAA","AA","A","BBB"))
str(cr_factor_ord)

# Arthritis데이터셋
library(vcd)
str(Arthritis)

## 교차표
attach(Arthritis)
table(Improved,Treatment)
prop.table(table(Improved,Treatment,useNA='always')) # 전체
prop.table(table(Improved,Treatment),margin = 1) # 행 기준
prop.table(table(Improved,Treatment),margin = 2) # 열 기준
xtabs(~Improved+Treatment,data=Arthritis)

# 모자이크 그림
table(Arthritis$Improved,Arthritis$Treatment)
mosaic(Improved~Treatment,data=Arthritis,gp=shading_max)
detach(Arthritis)

xtabs(~(Sex+Improved)+Treatment,data=Arthritis)
comment('CrossTable같은 형식으로 볼 수 있음음')

cross.tab<-with(Arthritis,table(Improved,Treatment))
cross.tab
margin.table(cross.tab,margin = 1) # 행 기준
table(Arthritis$Improved)
margin.table(cross.tab,margin = 2) # 열 기준
table(Arthritis$Treatment)

prop.table(cross.tab) # 전체
prop.table(cross.tab,margin = 1) # 행 기준
prop.table(cross.tab,margin = 2) # 열 기준

# 교차표(합계도 보기)
sum_cross.tab<-addmargins(cross.tab)
sum_cross.tab

# CrossTable()
library(gmodels)
CrossTable(Arthritis$Improved,Arthritis$Treatment,
           prop.c = T,prop.r = T,prop.chisq = F,prop.t = T)
with(Arthritis,CrossTable(Improved,Treatment,prop.c = F,prop.r=F,prop.t=F,prop.chisq=F))

# 다차원 테이블
cross.tab_ist<-with(Arthritis,table(Improved,Sex,Treatment))
cross.tab_ist
comment('Treatment별 Improved와 Sex의 교차표를 보여줌')

ftable(cross.tab_ist)
comment('table()함수에 by=list()에 2개 열을 넣은것 처럼 보여줌')

ftable(cross.tab_ist,row.vars=c(3,1))
comment('3=>Treatment,
        1=>Improved,
        2=>Sex')
