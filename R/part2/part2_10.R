rm(list=ls())

# 일원분산분석(ANOVA)
## insectSprays데이터셋
df<-InsectSprays
str(df)
table(df$spray)

### 스프레이별 count열의 평균 구하기(소수점 3자리)
round(tapply(df$count,INDEX=list(df$spray),FUN=mean),3)

### 스프레이별 count열의 표준편차 구하기(소수점 3자리)
round(tapply(df$count,INDEX=list(df$spray),FUN=sd),3)

### 스프레이별 count열의 길이 구하기
tapply(df$count,INDEX=list(df$spray),length)
comment('table()함수와 비슷')

### 집단별 평균도표 그리기
library(gplots)
plotmeans(count ~ spray,data=df,col='yellow',lwd=3,barcol='blue',barwidth=4,main='Performance of Insect Sorays\nwith 95% CI of Mean',xlab='Type of Sprays',ylab='insect Count')
comment('main=옵션에서 \n을 쓰면 엔터기능이 됨')

### 집단별 상자도표 그리기
boxplot(count~spray,data=df,col=2:7,border=c('peru','black','pink'),main='Performance of Insect Sprays',xlab='Type of Sprays',ylab='Insect Count',las=1)

### 일원분산분석
aov.spray<-aov(count~spray,data=df)
summary(aov.spray)
comment('각 집단의 평균은 동일하지 않음')

comment('분산분석은 귀무가설만 기각하므로 개별 집단 간 평균 차이를 확인하기 위해서는 어떻게 해야할까???')

### 평균차이 확인
model.tables(aov.spray,type='mean')
comment('type=옵션은 mean과 effects임
        type=effects가 기본값임')

model.tables(aov.spray)

### 사후설계
comment('두 살충제 간의 살충효과가 통계적으로 유의한지 검정')
hsd.spray<-TukeyHSD(aov.spray)
hsd.spray

hsd.spray$spray['D-A',]
comment('내가 원하는 행을 뽑아서 볼 수 도 있음')

### 사후설계 그래프
plot(TukeyHSD(aov.spray),col='green',las=1)

### glht()함수로 사후설계 확인
library(multcomp)
tukey.hsd<-glht(aov.spray,linfct=mcp(spray='Tukey'))

plot(cld(tukey.hsd,level=0.05),col='orange')
comment('각 스프레이별 박스플롯')

### qqplot
library(car)
qqPlot(df$count,pch=20,col='orange',id=T,main='QQ Plot',xlab='Theoretical Quantiles',ylab='Sample Quantiles',las=1)
comment('id=옵션은 특정 행번호를 F/T로 보이게 안보이게 가능')

### 샤피로윌크 검정(정규성 검정)
shapiro.test(df$count)
comment('p값이 0.05보다 작으므로 정규성이 띄지 않음')

### 이상치 존재여부 검정
outlierTest(aov.spray)

### 각 집단 간 분산 동일성 검정
#### 레벤 검정
leveneTest(count~spray,data=df)
comment('p값이 0.05보다 작으므로 등분산성을 띄지 않음')

#### 바틀렛 검정
bartlett.test(count~spray,data=df)
comment('levene보다 더 낫게 등분산성에 따르지 않음')

### 등분산성 가정을 충족하지 못할 때 일원분산분석
oneway.test(count~spray,data=df)
comment('등분산성 가정이 없은 일원분산분석')

oneway.test(count~spray,data=df,var.equal=T)
comment('var.equal=T을 이용하면 등분산성을 가정한 일원분산분석을 할 수 있음')

summary(aov(count~spray,data=df))
comment('var.equal=T을 이용한 것과 같게 등분산성이 가정된 분산분석을 가능하게 해줌')

# 이원분산분석
comment('2개의 주효과와 1개의 상호작용효과를 검정')

## ToothGrowth셋 => 내장 기본 데이터셋
df<-ToothGrowth
str(df)
unique(df$dose) # 고유값 확인
df$dose<-factor(df$dose,levels=c(0.5,1.0,2.0),labels=c('low','mid','high')) # 타입변경
str(df) # 타입변경 확인

## supp별/dose별 len열의 요약 통계량 구하기
tapply(df$len,list(SUPP=df$supp,DOSE=df$dose),mean)
with(df,tapply(len,list(SUPP=supp,DOSE=dose),mean,na.rm=T))
with(df,tapply(len,list(SUPP=supp,DOSE=dose),sd,na.rm=T))
with(df,tapply(len,list(SUPP=supp,DOSE=dose),length))

aggregate(df$len,by=list(df$supp,df$dose),mean)

### 이원분산분석의 그래프
boxplot(len~supp*dose,dat=df,col=c('orange','tomato'))
boxplot(len~supp+dose+supp:dose,dat=df,col=c('orange','tomato'))
comment('위의 2개 코드는 동일한 결과를 출력해줌
        len~supp*dose==len~supp+dose+supp:dose
        supp열의 OJ는 orange, VC는 tomato')

### aov()함수를 이용한 이원분산분석
aov.TG<-aov(len~supp*dose,data=df)
summary(aov.TG)

TukeyHSD(aov.TG) # 사후설계
plot(TukeyHSD(aov.TG)) # 사후설계 그래프

### 각 효과에 따른 요약통계량 계산
model.tables(aov.TG,'means')
comment('주효과나 상호작용에 의한 평균값 구하기')

### 상자도표로 본 비타민C 보충제와 투여량의 조합에 따른 이빨 성장의 정도를 파악
boxplot(len~supp*dose,data=df,col=c('pink','yellowgreen'),las=1,xlab='Vitamin C Type', ylab='Tooth Growth',main='Effects of Vitamin C on Tooth Growth of Guinea Pigs')
comment('이원분산분석 그래프')

### 상호작용도표로 주효과와 상호작용효과 파악
interaction.plot(x.factor=df$dose,trace.factor=df$supp,response=df$len,las=1,type='b',pch=c(1,19),col=c('blue','red'),trace.label='Supplement',xlab='Dose Levels',ylab='Tooth Length',main='Interaction Plot For Thooth Growth of Guinea Pigs')
comment('x축에는 dose열, 선 그리는 기준은 supp열, 값은 len열')

interaction.plot(x.factor=df$supp,trace.factor=df$dose,response=df$len,las=1,type='b',pch=c(1,19),col=c('blue','red'),trace.label='Dose',xlab='Supplement Levels',ylab='Tooth Length',main='Interaction Plot For Thooth Growth of Guinea Pigs')
comment('x축에는 supp열, 선 그리는 기준은 dose열, 값은 len열')

### 평균도표
plotmeans(len~interaction(supp,dose,sep=" "),data=df,col=c('blue','red'),connect=list(c(1,3,5),c(2,4,6)),xlab='Supplement and Dose Combination',ylab='Tooth Length',main='Means Plot for Tooth Growth of Guinea Pigs\nwith 95% CI of Mean')
comment('interaction(supp,dose)로 하면 x축 눈금은 OJ.low/VC.low처럼 .이 중간에 있고
        interaction(supp,dose,sep=" ")로 하면 x축 눈금이 OJ low/VC low처럼 띄어쓰기로 되어 있음')

### 조건부도표
coplot(len~dose|supp,data=df,col='steelblue',pch=19,panel=panel.smooth,lwd=2,col.smooth='darkorange',xlab='Dose Level',ylab='Tooth Length')

coplot(len~supp|dose,data=df,col='red',pch=20,panel=panel.smooth,lwd=2,col.smooth='peru',xlab='Dose Level',ylab='Tooth Length')

### interaction2wt()함수로 주효과와 상호작용효과를 동시에 파악
library(HH)
interaction2wt(len~supp*dose,data=df)
comment('박스플롯이나 상호작용도표가 나옴')

### 사후설계
TukeyHSD(aov.TG)
comment('신뢰수준은 95%')

TukeyHSD(aov.TG,which='dose',conf.level=0.99)
comment('주효과 dose만 보고 신뢰수준은 99%')

TukeyHSD(aov.TG,which=c('dose','supp'),conf.level=0.99)
comment('주효과 dose와 supp를 보고 신뢰수준은 99%')
