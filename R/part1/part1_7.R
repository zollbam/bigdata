rm(list=ls())

# R 1파트 7.데이터 전처리1.pdf
# 결측치를 포함한 벡터의 통계값 구하기
x<-c(45,NA,87,63,55,NA,72,61,59,68)
mean(x) # NA가 포함되므로 값은 NA로 나옴
mean(x,na.rm=T) # na.rm=T옵션으로 NA를 빼고 값을 구함
var(x,na.rm=T)
sd(x,na.rm=T)

# NA를 다른값으로 대체하기
is.na(x)
x[is.na(x)] # x벡터에서 NA값만 보여줌
x[!is.na(x)] # x벡터에서 NA값만 보여줌
x[is.na(x)] <- mean(x,na.rm=T)
x # x벡터의 NA값이 평균으로 대체

# airquality데이터 셋으로 데이터 결측치 처리
# NA값을 평균으로 할당하고 분석
aq_df <- airquality
str(aq_df)
class(aq_df)
summary(aq_df)
comment('Ozone열과 Solar.R열의 NA값이 각각 37개와 7개가 나오는 걸로 확인 할 수 있음')

attach(aq_df)

Ozone
mean(Ozone,na.rm = TRUE)
comment('NA를 제거하고 평균구하기')

is.na(Ozone)
comment('행마다 NA가 없으면 T, 있으면 F')

Ozone[is.na(Ozone)]
sum(is.na(Ozone)) # NA개수
sum(is.na(Solar.R))
comment('summary에서 보았던 NA개수와 같은 것을 확인 할 수 있음')
sum(is.na(Ozone) & is.na(Solar.R))

ozone <- Ozone
ozone[is.na(ozone)] <- mean(ozone,na.rm=T) # 평균값으로 대체
ozone

mean(Ozone,na.rm=T) # aq_df에 있는 Ozone열
mean(ozone) # ozone 그냥 변수

sd(Ozone,na.rm=T) # 대체되기전보다
sd(ozone) # 평균으로 대체된 후 분포가 적어진것을 확인

dim(aq_df)

detach(aq_df)

# NA값을 랜덤추출된 값으로 할당하여 분석
aq_df <- airquality

attach(aq_df)

ozone <- Ozone
ozone[is.na(ozone)] <- sample(na.omit(Ozone),37,replace = T)
comment('복원추출로 값을 집어 넣음
        na.omit(aq$Ozone) => Ozone열에서 na가 생략된 값들만 보아서 보여줌
        sample(~,37)은 37개의 랜덤값을 뽑아줌')

mean(Ozone,na.rm=T)
mean(ozone)
comment('랜덤으로 값을 집어넣었으므로 대체 전의 평균값과 대체 후 평균값의 값이 다름')

sd(Ozone,na.rm=T)
sd(ozone)

detach(aq_df)

# na값 빼고 분석
aq_df <- airquality

attach(aq_df)

complete.cases(aq_df)
comment('aq_df의 각 행에 NA가 하나라도 있으면 F 각 행의 값이 모두 NA가 아니라면 T 반환')

aq_df[!complete.cases(aq_df),]
comment('NA가 포함된 행을 반환')
aq_df_nax <- aq_df[complete.cases(aq_df),]
aq_df_nax
comment('NA가 없는 행을 반환')

sum(!complete.cases(aq_df)) # NA를 가진 행의 수 반환
comment('Ozone NA  37개, Solar.R NA 7개, 공통적으로 가지는 NA 2개
        37+7-2=42개의 행이 NA를 가짐')

detach(aq_df)

# 변수별 결측치의 분포와 발생패턴을 시각화
library(VIM)
?aggr
aggr(airquality,prop=F,numbers=T,sortVar=T)
comment('prop=옵션으로 F는 개수, T는 확률')

aggr(airquality,prop=T,numbers=T,sortVar=F)
comment('sortVar=옵션은 콘솔창에 정렬된 개수/확률이 출력되지 않게 해줌')

aggr(airquality,prop=F,numbers=F,sortVar=T)
comment('numbers=옵션을 F로 입력하면 combination그래프에서 개수에 대한 출력을 보여주지 않게 해줌')

# na.omit()함수
# 행에 NA가 하나라도 있으면 그 행 삭제
aq_df[complete.cases(aq_df),]
nrow(aq_df[complete.cases(aq_df),])
comment('행에 NA가 없는 개수는 111개')

air_omit<-na.omit(airquality)
air_omit
str(air_omit)

# mice패키지의 mice()함수
library(mice)
attach(aq_df)

result <- mice(aq_df,method='mean',m=2,maxit=2)
comment('iter열에는 1~2, imp열에는 1~2')
result
result$imp$Ozone
result$imp$Solar.R
comment('2개 열이 나옴')

result <- mice(aq_df,method='pmm',m=3,maxit=2)
comment('iter열에는 1~2, imp열에는 1~3')
result
result$imp$Ozone
result$imp$Solar.R
comment('3개 열이 나옴')

detach(aq_df)

# 이상치
st_df<-data.frame(state.x77)

attach(st_df)

boxplot(Income,col='tomato',pch=19,border = 'brown')
comment('border=옵션은 그래프 안의 선색깔을 지정할 때 사용
        제일 상단에 찍힌 점이 이상치')

# 소득이 너무 높게 나오는 이상치의 주이름은???
rownames(st_df[Income==max(Income),])

# 이상치에 대한 상세 확인
boxplot.stats(Income)
comment('리스트로 생성되고
        리스트안 이름이 stats는 사분위수가 순서대로 입력되어 있고
        n에는 데이터 개수
        conf는 신뢰구간
        out는 이상치가 출력')

outlier <- boxplot.stats(Income) # 이상치 정보를 변수에 할당
st_df[Income==outlier$out,]
comment('outlier$out이 이상치에 대한 데이터이므로 이상치에 대한 행이 출력이 됨')

detach(st_df)

# 이상치를 NA로 대체
st_df <- data.frame(state.x77)

attach(st_df)

st_df[Income==outlier$out,]<-NA
st_df[!complete.cases(st_df),] # NA인 행 출력

st_df_no<-na.omit(st_df)
nrow(st_df_no)
comment('이상치의 행이 NA가 되었으므로 NA인 행을 삭제한 행의 수를 보면 50에서 49가 된 것을 확인')

detach(st_df)

# 범주별로 이상치를 확인할 수 있음
boxplot(Sepal.Width~Species,data=iris,pch=19,col='orange',border='brown')
comment('Sepal.Width는 종속변수, Species는 독립변수인 formula')

# setosa데이터 Petal.Width열 이상치를 제거해보자
setosa_data<-with(iris,iris[Species=='setosa',])
comment('with는 조건에 맞는 행을 출력해주는 함수로써
        setosa_data에는 종류가 setosa인 데이터만 들어가 있음')

boxplot(setosa_data$Petal.Width)
outlier<-boxplot.stats(setosa_data$Petal.Width)
outlier
setosa_data_outx<-setosa_data[!setosa_data$Petal.Width %in% outlier$out,]
nrow(setosa_data_outx)
comment('이상치 값인 0.5와 0.6행이 제거 되어서 50-2인 48이라는 행을 찾음')

# iris데이터에서의 이상치
iris_df<-iris
boxplot(Petal.Width~Species,data=iris_df,pch=19,col='orange',border='brown')
comment('Species는 x축(독립변수), Petal.Width은 y축(종속변수)')

boxplot(Petal.Length~Species,data=iris_df,pch=19,col='orange',border='brown')
comment('Species는 x축(독립변수), Petal.Length은 y축(종속변수)')

outlier <- boxplot.stats(iris_df[iris_df$Species=='setosa',4])$out
iris_df[iris_df$Petal.Width %in% outlier,]

# 연습문제 7-1
# mice패키지 안의 nhanes데이터셋을 활용
nhanes_df<-nhanes
View(nhanes_df)
class(nhanes_df)
str(nhanes_df)

# 1) 변수와 관측치 개수??
nrow(nhanes_df)
ncol(nhanes_df)

# 2) NA가 없는 관측치 모두 출력
nhanes_df[complete.cases(nhanes_df),]

# 3) NA가 포함된 관측치 모두 출력
nhanes_df[!complete.cases(nhanes_df),]

# 4) NA가 포함된 관측치의 개수는??
nrow(nhanes_df[!complete.cases(nhanes_df),])

# 5) 각각의 변수별로 NA의 개수는 각각 몇개인가?
summary(nhanes_df)

# 왜 안될까??
comment("
        for(col in colnames(nhanes_df)) {
  cat(col,sum(is.na(nhanes_df$col)),'\n'
        ")

# 6) VIM패키지의 aggr()함수로 결측치 분포 확인
aggr(nhanes_df,numbers=T,prop=F,sortVar=T)

# 연습문제 7-2
# iris를 활용
# 1) Petal.Length에 대해서 박스플롯을 그려보시오
boxplot(Petal.Length~Species,data=iris,col='orange',border='brown',pch=19)

# 2) setosa 품종에서 Petal.Length의 이상치를 out.set변수에 저장
setosa_data<-with(iris,iris[iris$Species=='setosa',])
outlier<-boxplot.stats(setosa_data$Petal.Length)
out.set<-outlier$out
out.set

# 3) versicolor품종에서 Petal.Length의 이상치를 out.ver변수에 저장
versicolor_data<-iris[iris$Species=='versicolor',]
outlier<-boxplot.stats(versicolor_data$Petal.Length)
out.ver<-outlier$out
out.ver

# 4) iris데이터셋을 df라는 변수에 따로 저장
df<-iris
str(df)
class(df)

# 5) df셋에서 out.set과 out.ver에 저장된 이상치에 대해 행 전체를 NA로 변경 후 헹을 제거
df[(df$Petal.Length==out.set & df$Species=='setosa') | (df$Petal.Length==out.ver & df$Species=='versicolor'),]<-NA
df[!complete.cases(df),]
df<-na.omit(df)
nrow(df)
comment('NA인 2개 값이 빠져 148개가 나옴옴')
