rm(list=ls())
colors()

# mtcars셋
## 필요한 열만 뽑아서 새로운 데이터셋을 만듬
mtcar_df<-subset(mtcars,select=c(1:6))
str(mtcar_df)
comment('모든 열이 수치형')

## 상관계수 행렬
cor(mtcar_df)
plot(mtcar_df,col='green',pch=19)

## 상관계수 그래프
library(corrgram)
corrgram(mtcar_df)

## 산점도 행렬(plot+abline이 모두 그려져 있음)
library(car)
scatterplotMatrix(mtcar_df,pch=19,col='steelblue',cex=1,regLine=list(method=lm,lwd=2,col='tomato'),smooth=list(smoother=loessLine,spread=F,lwd.smooth=2,col.smooth='orange'))
comment('cex=옵션은 숫자를 입력하면 점의 크기가 조절됨
        regLine=옵션은 회귀선을 만듬')

## 회귀분석
model1<-lm(mpg~.,data=mtcar_df) # 다중
summary(model1)
comment('h0: 회귀계수가 0임, h1: 회귀계수가 0이 아님
        cyl/disp/drat는 p값이 높아 h0가 기각 안됨
        cyl/disp/drat열을 빼고 회귀분석을 해봄')

model2<-lm(mpg~hp+wt,data=mtcar_df) # 다중
summary(model2)

## 변수선택법
model3<-lm(mpg~., data=mtcar_df) # 다중
step(model3)
comment('변수선택법으로 선택된 3개열을 회귀분석함')

model4<-lm(mpg~cyl+hp+wt,data=mtcar_df)
summary(model4)
comment('hp열이 p값이 높아서 h0이 기각 안됨')

## 모델 2개를 만들어 비교
mtcars.model1<-lm(mpg~hp+wt,data=mtcar_df)
mtcars.model2<-lm(mpg~hp+wt+disp+drat,data=mtcar_df)

anova(mtcars.model1,mtcars.model2)
comment('h0기각X => 2개 모델의 평균이 동일')

## AIC지표
comment('모델의 적합도와 파라미터의 개수를 함께 고려한 정보량의 척도')

AIC(mtcars.model1,mtcars.model2)

## 후진선택법
mtcars.lm <- lm(mpg~hp+wt+disp+drat,data=mtcar_df)
step(mtcars.lm,direction='backward')

final.mtcar.model<-lm(mpg ~ hp + wt, data = mtcar_df)
summary(final.mtcar.model)

# InsectSprays셋 => 기본 내장 데이터셋
## 데이터 확인
insect_df<-InsectSprays
str(insect_df)

## 회귀분석
comment('spray는 범주형으로 자동적으로 더미변수로 변환됨')

insect.model<-lm(count~spray,data=insect_df)
summary(insect.model)

## 더미변수
contrasts(insect_df$spray) 
insect_df

## 더미변수 기준 범주 바꾸기
insect_df$spray<-relevel(insect_df$spray,ref=6)
comment('6인 sprayF가 기준 범주가 됨
        IF 5가 되면 E가 범주가 되고 2가 되면 B가 범주가 됨')

spray.lm<-lm(count~spray,data=insect_df)
summary(spray.lm)

contrasts(insect_df$spray)
comment('F스프레이가 00000이 된것으로 확인')

## 다른 범주로 기준 바꾸어보기
insect_df$spray<-relevel(insect_df$spray,ref=3)
contrasts(insect_df$spray)

# mtcars
df<-mtcars[,1:6]
str(df)

df$cyl<-factor(df$cyl) # cyl 타입변경
table(df$cyl) # 빈도표

model<-lm(mpg~.,data=df)
comment('cyl열은 범주형이니까 회귀분석하려면 더미변수로 자동 변환되어 분석함')

summary(model)

contrasts(df$cyl) # cyl의 4가 기준인 것을 확인

# 연습문제
## 캐글의 House Price데이터 셋에서 다중 선형 회귀의 변수 선택을 통해 최적의 독립변수 조합을 찾아보세요.
## SalePrice~1 : 상수항만 찾는 것
### 0. 데이터 불러오기
house<-read.csv('./train.csv',header=T)
View(house)
class(house)
str(house)
summary(house)

### 1. 수치형 열만 추출
idx<-c()
for (i in 1:ncol(house)){
  if (class(house[,i])=='integer'){
    idx<-c(idx,i)
  }
}

int_house<-house[,idx]
int_house<-int_house[,-1] # id열 삭제
int_house_nax<-na.omit(int_house) # NA행 삭제
str(int_house_nax)
class(int_house_nax)
summary(int_house_nax)

### 2. 전진선택법으로 찾은 조합은?
model_house<-lm(SalePrice~1,data=int_house_nax)
full_house<-lm(SalePrice~.,data=int_house_nax)

house_for_step<-step(model_house,scope=list(lower=model_house,upper=full_house),direction='forward')
house_for_step

forward_final_model<-lm(SalePrice ~ OverallQual + GrLivArea + BsmtFinSF1 + GarageCars + MSSubClass + YearRemodAdd + MasVnrArea + LotArea + KitchenAbvGr + BedroomAbvGr + TotRmsAbvGrd + YearBuilt + OverallCond + BsmtFullBath + ScreenPorch + PoolArea + WoodDeckSF + Fireplaces + FullBath + LotFrontage + TotalBsmtSF, data = int_house_nax)
summary(forward_final_model)

#### R2와 Adjusted R2의 값은??
comment('Multiple R-squared:  0.809
        Adjusted R-squared:  0.8054')

### 3. 후진선택법으로 찾은 조합은?
model_house<-lm(SalePrice~.,data=int_house_nax)
house_back_step<-step(model_house,direction = 'backward')
house_back_step

backward_final_model<-lm(SalePrice ~ MSSubClass + LotFrontage + LotArea + OverallQual + OverallCond + YearBuilt + MasVnrArea + BsmtFinSF1 + X1stFlrSF + X2ndFlrSF + BsmtFullBath + FullBath + BedroomAbvGr + KitchenAbvGr + TotRmsAbvGrd + Fireplaces + GarageCars + WoodDeckSF + ScreenPorch + PoolArea,data=int_house_nax)
summary(backward_final_model)

#### R2와 Adjusted R2의 값은??
comment('Multiple R-squared:  0.8083
        Adjusted R-squared:  0.8048')
