rm(list=ls())
colors()

# 포아송 분포
x<-0:100
y<-dpois(x,lambda=10)
plot(x,y,col='salmon',type='l',las=1,lwd=3,main="POISSON Distribution (lambda=10)")

# breslow.dat셋
comment('뇌전증 환자의 투약 전/후 8주간의 발작횟수')
library(robust) # breslow.dat셋 불러오기 위한 함수
data(breslow.dat)
bre.df<-breslow.dat

## 데이터 확인
class(bre.df)
str(bre.df)
summary(bre.df)

## 항뇌전증제를 투약 후 8주 동안 발생하는 발작 횟수에 미치는 영향분석
### 필요한 열만 추출
seizure<-bre.df[,c('Base','Age','Trt','sumY')]
summary(seizure)
comment('Base열이 투약 전이고 sumY가 투약 후 인데
        2개 열의 평균이 중앙값보다 크므로 그래프가 왼쪽에 치우친 모양이 보일 것으로 예상 => 포아송')

### 히스토그램
hist(seizure$sumY,breaks=20,col='cornflowerblue',xlab='Seizure Count',main='Distribution of Seizures')

### 일반화 회귀분석(포아송분포)
seizure.poisson<-glm(sumY~.,data=seizure,family=poisson)
summary(seizure.poisson)
comment('회귀계수들의 p값이 모두 유의 수준보다 작으므로 회귀계수가 0이 아니므로 각 독립변수는 종속변수에 관계가 있다고 볼 수 있음')

coef(seizure.poisson) # 회귀계수
exp(coef(seizure.poisson))
comment('ln으로 있던 단위를 exp()를 이용하여 원래 단위로 변환
        0.85838634는 Trtprogabide의 회귀계수
        (1-0.8583864)*100으로 항뇌전증제를 처방 받은 환자는 위약(가짜약)을 복용한 환자보다 발작 횟수가 14.2%감소')

# 이항 로지스틱 회귀분석
z<-seq(-6,6,length=200)
p<-1/(1+exp(1)^(-z))
plot(z,p,type='l',main='PDF of Logistic Function')

# split()함수 예시
df_spe<-split(iris,f=iris$Species)
class(df_spe)
df_spe
comment('각 종별로 리스트로 만들어 줌')

df_spe$setosa
df_spe$versicolor
df_spe$virginica
comment('이런식으로 각 데이터를 뽑아서 볼 수 도 있음')

df<-rbind(df_spe$setosa,df_spe$versicolor) # 행결합
plot(df[,c(3,5)])
comment('y축은 1이면 setosa, 2이면 versicolor')

df$Species<-as.factor(df$Species,levels=c('setosa','versicolor'),labels=c(0,1)) # 수치형으로 변경
str(df) # 변경 확인

model<-glm(Species~Petal.Length,data=df,family=binomial(link='logit'))
summary(model)
comment('Petal.Length의 p값이 0.999라서 획귀계수 값이 0이라고 봄')

# mlc_churn데이터셋
comment('이동통신회사의 고객이탈 데이터')

## 데이터 불러오기
library(modeldata) # mlc_churn셋 불러오기
data(mlc_churn)
str(mlc_churn)
class(mlc_churn)
summary(mlc_churn)
colSums(is.na(mlc_churn))

## 데이터 정제
comment('거주지역, 지역코드 삭제')

churn<-mlc_churn[,-c(1,3)] # 열 삭제
levels(churn$churn)
comment('churn열의 값이 no이면 2, yes이면 1
        no가 이탈자, yes가 미이탈자')

churn$churn<-factor(ifelse(churn$churn=='no',1,2),levels=c(1,2),labels=c('no','yes'))
levels(churn$churn)
comment('churn열의 값이 no이면 1, yes이면 2
        no가 이탈자, yes가 미이탈자')

## 훈련데이터와 시험용데이터 나누기
churn.train<-churn[1:3333,]
churn.test<-churn[3334:5000,]

### 훈련용데이터 비율
table(churn.train$churn)
prop.table(table(churn.train$churn))

### 시험용데이터 비율
table(churn.test$churn)
prop.table(table(churn.test$churn))

#### 테이블 계산
table(churn.test$churn,churn.test$international_plan)

margin.table(table(churn.test$churn,churn.test$international_plan),margin=2)

addmargins(table(churn.test$churn,churn.test$international_plan),margin=2)

## 로지스틱 회귀분석
str(churn.train)
churn.logit<-glm(churn~.,data=churn.train,family=binomial(link='logit'))
comment('churn가 종속변수고 나머지 열은 독립변수
        international_plan, voice_mail_plan에는 1(no)과 2(yes)가 있음')

summary(churn.logit)
coef(churn.logit) # 회귀계수

exp(coef(churn.logit)) # 오즈비
comment('international_planyes가 1증가하면 성공/실패비가 7.711821배 증가')

### 범주형 2개를 더비변수로 변환하여 고객 이탈확률 계산
churn.test$international_plan<-ifelse(churn.test$international_plan=='no',0,1)
churn.test$voice_mail_plan<-ifelse(churn.test$voice_mail_plan=='no',0,1)

z<-coef(churn.logit)[1]+(as.matrix(churn.test[-18])%*%coef(churn.logit)[-1])
comment('z는 회귀식')

p<-1/(1+exp(-z))
head(p)
comment('p는 이탈 확률로 낮을수록 미이탈자임
        오즈비로 구할 때는 요인형을 수치형으로 바꾸어야함')

### predict()함수를 이용한 예측
churn.test<-churn[3334:5000,]
churn.logit.pred<-predict(churn.logit,churn.test,type='response')
head(churn.logit.pred)
comment('predict()로 구할때는 범주형으로 요인을 다시 변경해주어야함')

### 오즈비와 predict() 비교
sum(!(round(as.numeric(p),4)==round(as.numeric(churn.logit.pred),4)))
comment('0이 나왔다는 얘기는 모든 숫자가 동일하다는 뜻으로
        오즈비로 구한 확률이나 predict로 구한 확률은 값은 값이 나옴')

### 혼동행렬 만들기
pred_churn<-factor(churn.logit.pred>0.5,levels=c(FALSE,TRUE),labels=c('no','yes'))
comment('0.5보다 작으면 FALSE로 미이탈자, 0.5보다 크면 TRUE는 이탈자')
confu_tab<-table(pred_churn,churn.test$churn,dnn=c('pred','actu'))
mean(pred_churn==churn.test$churn)

confu_tab
TP=confu_tab[2,2]
TN=confu_tab[1,1]
FP=confu_tab[2,1]
FN=confu_tab[1,2]

#### 정확도(Accuracy)
Accuracy<-(TP+TN)/(TP+TN+FP+FN)
Accuracy

#### 정밀도(precision)
comment('예측이 참일때 실제도 참인 경우')
precision<-TP/(TP+FP)
precision

#### 민감도(sensitivity), 재현율(recall)
comment('실제가 참일 때 예측도 참인 경우')
recall<-TP/(TP+FN)
recall

#### 특이도(specificity)
comment('실제가 거짓인 경우 예측도 거짓인 경우')
specificity<-TN/(TN+FP)
specificity

#### F1점수
2*precision*recall/(precision+recall)

# 펭귄셋
## 데이터 확인
library(palmerpenguins)
pg<-penguins
str(pg)

pg<-pg[complete.cases(pg),-8] # NA값 및 year열 삭제
str(pg)
dim(pg)

## 새로운 열 생성
pg$is.adelie<-factor(ifelse(pg$species=='Adelie','Yes','No'))

barplot(table(pg$is.adelie),col=c('red','blue'),main='Adelie')
comment('빈도 그래프')

barplot(prop.table(table(pg$is.adelie)),col=c('red','blue'),main='Adelie')
comment('확률 그래프')

## species열 삭제
pg_spx<-pg[,-1]
str(pg_spx)

## 이항 로지스틱 분석(adelie인지 아닌지 예측)
model<-glm(is.adelie~.,data=pg_spx,family=binomial(link='logit'))
summary(model)

## 예측값
model$fitted
pg$pred<-factor(ifelse(model$fitted.values>0.5,'Yes','No'))
table(pg$is.adelie,pg$pred)

## ROC
library(pROC)
pg$pred
ROC <- roc(as.numeric(pg$is.adelie), as.numeric(pg$pred))
plot.roc(ROC,xlim=c(0,1),
         col = "royalblue",
         print.auc = TRUE,
         max.auc.polygon = TRUE,
         print.thres = TRUE, print.thres.pch = 19, print.thres.col = "red",
         auc.polygon = TRUE, auc.polygon.col = "lightblue")

comment('잘못 예측된 값이 없어서 다른 데이터로 해보자!!!')

# iris셋
df<-iris
df$Species<-factor(ifelse(df$Species=='virginica','Yes','No'))

model<-glm(Species~.,data=df,family=binomial(link='logit'))
summary(model)

df$pred<-factor(ifelse(model$fitted.values>0.5,'Yes','No'))
tab<-table(df$Species,df$pred,dnn=c('Actu','Pred'))
tab

TN<-tab[1,1] # TN
TP<-tab[2,2] # TP
FP<-tab[1,2] # FN
FN<-tab[2,1] # FP

auccuacy<-(TP+TN)/(TP+TN+FP+FN);auccuacy # 정확도
precison<-TP/(TP+FP);precison # 정밀도
recall<-TP/(TP+FN);recall # 재현율(민감도)
F1.score<-2*recall*precison/(recall+precison);F1.score # F1점수

library(pROC)
roc(df$Species,model$fitted.values,plot=T,main='ROC CURVE',col='tomato')
roc(Species~model$fitted.values,data=df,plot=T,main='ROC CURVE',col='tomato')

# PID셋
comment('미국 유권자 944명의 정치성향 데이터')

## 데이터 확인
library(EffectStars) # PID셋 불러오기 위한 패키지
data(PID)
str(PID)
head(PID)

## 다항로지스틱회귀분석
library(VGAM)
pid.mlogit<-vglm(PID~.,data=PID,family=multinomial())
summary(pid.mlogit)
comment('종속변수가 요인요소가 3개 있음
        Names of linear predictors: log(mu[,1]/mu[,3]), log(mu[,2]/mu[,3])는
        levels순서대로 1은 Democrat, 2는 Independent, 3은 Republican임')

### 회귀계수 구하기
exp(coef(pid.mlogit))
comment('TVnews:1에서는 1이 증가할수록 Democrat가능성이 Republican보다 4.5% 증가
        Income:2에서는 1이 증가 할수록 Independent가능성이 Republican보다 0.02418% 감소')

### 예측 확률 계산
pid.mlogit.pred<-fitted(pid.mlogit)
pid.mlogit.pred

### 가상데이터셋 만들기(교육수준 변화, 다른 변수 고정)
testdf<-data.frame(Education=c('low','high'),
                   TVnews=mean(PID$TVnews),
                   Income=mean(PID$Income),
                   Age=mean(PID$Age),
                   Population=mean(PID$Population))
testdf

### 가상데이터로 예측
predict(pid.mlogit,newdata=testdf,type='response')
comment('교육수준이 높을수록 Republican일 확률이 높음')

### 가상데이터셋 만들기(소득 변화, 다른 변수 고정)
testdf1<-data.frame(Education=rep('low',5),
                   TVnews=mean(PID$TVnews),
                   Income=c(10,20,40,60,100),
                   Age=mean(PID$Age),
                   Population=mean(PID$Population))
testdf1

### 가상데이터로 예측
predict(pid.mlogit,newdata=testdf1,type='response')
comment('소득이 높아질수록 Independent/Republican일 확률이 증가')
