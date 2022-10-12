rm(list=ls())

# survey셋
##단일표본 평균검정
### H0: 호주 대학생의 평균키는 175임, H1: 호주 대학생의 평균키는 175가 아님
library(MASS)
t.test(survey$Height,mu=175)
comment('ho기각 => 평균키는 175라 할 수 없음')

### H0: 호주 대학생의 평균키는 172임, H1: 호주 대학생의 평균키는 172가 아님
t.test(survey$Height,mu=172)
comment('ho기각 안함 => 평균키는 172라고 볼 수 있음')

t.height<-t.test(survey$Height,mu=172)
t.height

t.height$statistic # t값
t.height$p.value # p값
t.height$conf.int # 신뢰구간
t.height$estimate # 추정치

### H0: 호주 대학생의 평균키는 171임, H1: 호주 대학생의 평균키는 171가 아님
t.test(survey$Height,mu=171)
comment('ho기각 => 평균키는 171라 할 수 없음')

### H0: 호주 대학생의 평균키는 173보다 작거나 같음, H1: 호주 대학생의 평균키는 173보다 큼 => 상단측검정
t.test(survey$Height,mu=173,alternative='greater')
comment('ho기각 안함 => 173보다 작거나 같음')

### H0: 호주 대학생의 평균키는 174보다 크거나 같음, H1: 호주 대학생의 평균키는 174보다 작음 => 하단측검정
t.test(survey$Height,mu=174,alternative='less')
comment('ho기각 => 174보다 작음')

# cats셋
library(MASS)
str(cats)

## 요약통계량
library(stargazer)
stargazer(cats,type='text')

## 성별 Bwt의 평균
class(with(cats,tapply(Bwt,INDEX=Sex,mean)))

## 성별 Hwt의 평균
class(with(cats,aggregate(Hwt,by=list(Sex),mean)))

## 독립표본 평균검정
### H0:성별에 따른 몸무게 평균에 차이가 없음 ,H1: 성별에 따른 몸무게 평균에 차이가 있음
t.test(Bwt~Sex,data=cats)
comment('h0기각 => 성별에 따른 몸무게 평균 차이가 있음')

### H0:성별에 따른 심장무게 평균에 차이가 없음 ,H1: 성별에 따른 심장무게 평균에 차이가 있음
t.test(Hwt~Sex,data=cats)
comment('h0기각 => 성별에 따른 심장무게 평균 차이가 있음')

comment('attach(cats)을 하여 t.test(Bwt~Sex)해도됨')

## 대응표본 평균검정
comment('ex) 하나의 사람이 아침먹고도 시험치고 아침 않먹고도 시험쳐 봄')

### sleep데이터셋
library(tidyr) # spread()함수를 쓰기 위한 패키지 불러오기
sleep # 기본 내장 데이터셋
str(sleep)

#### spread()
sleep.wide<-spread(sleep,key=group,value=extra)
names(sleep.wide)<-c('ID','group.1','group.2')
comment('세로 형태로 되어있던 것을 그룹별로 묶어서 보기 쉽게 만듬
        ID의 각 사람이 1도 하고 2도 해서 대응표본 평균검정을 할 수 있음')

str(sleep.wide)
summary(sleep.wide)

#### spread예시
df<-data.frame(name=c('a','c','b','b','c'),sex=c('F','M','F','M','F'),
               age=c(12,16,12,16,25),point=c(50,60,60,70,80))
spread(df,key=sex,value=point)

### ID별 extra의 평균
tapply(sleep$extra,INDEX=sleep$ID,FUN=mean)

### H0: 약물 전후의 환자의 수면시간의 차이가 없음 ,H1: 약물 전후의 환자의 수면시간의 차이가 있음
####방법 1
t.test(extra~group,data=sleep,paired=T)
comment('h0 기각 => 수면시간의 차이가 있음')

####방법 2
t.test(sleep.wide$group.1,sleep.wide$group.2,paired=T)
comment('2개의 t검정은 동일한 결과가 나오게 됨
        paired=옵션은 대응표본을 하겠다는 의미')
