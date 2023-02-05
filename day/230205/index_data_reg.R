# 환경 변수 모두 삭제
rm(list=ls())

# 라이브러리 불러오기
library(ggplot2)
library(GGally)
library(corrplot)
library(ggcorrplot)
library(MASS)
library(gridExtra)

# csv파일 불러오기
# data <- read.csv("D:/R/data/index_tradecount_data.csv") # 회사
data <- read.csv("C:/Users/HOME/Desktop/solideoswork/index_tradecount_data.csv") # 집
View(data)

# 데이터 구조 확인
str(data)
## 59행 10열

# YEAR_MM열을 chr형에서 Date형으로 바꾸기
data$YEAR_MM <- as.Date(data$YEAR_MM)
str(data)

# 열별 통계값 확인
## 숫자형 : 최대값, 최소값, 1/2/3사분위수와 평균값
## 문자형 : 행의 개수
## 범주형 : 해당 열의 값 개수
summary(data)

# 테이블 앞부분 보기
head(data)

# 열이름 확인
names(data)

aa = data$YEAR_MM                      #년월
ab = data$LON_INRST                    #이율 
ac = data$APT_TRDE_IDEX             #아파트매매지수
ad = data$PCLND_IDEX                   #토지지수
ae = data$HOUSE_CNSMP_TRL_IDEX     #주택소비심리지수
af = data$LAD_CNSMP_TRL_IDEX        #토지소비심리지수
ag = data$CNSMR_PRICES_IDEX          #소비자물가지수
ah = data$HOUSE_TRDE_COUNT        #주택매매거래현황
ai = data$LAB_TRDE_COUNT          #순수토지매매거래현황
aj = data$TOTAL_TRDE_COUNT      #매매거래현황(주택+순수토지)









# 회귀분석 연계성 정리 해보기

# 함수 만들기
## n개월 후 데이터 프레임 만들기 함수(매매지수 한함)
n_after_data_make <- function(n){
  n_after_df <- cbind(data[1:(59-n),1:2], APT_TRDE_IDEX_ch=data[(1+n):59,3], PCLND_IDEX_ch=data[(1+n):59,4])
  return(n_after_df)
}

# 1. 상관계수
## 표
cor(data[c(2:7,10)]) # 전체에 대한 상관계수
cor(data[2],data[3:4]) # 이율과 매매지수의 상관계수

### 분석
comment("이율 증가 => 매매거래현황 감소
                   => 주택소비심리지수 감소
                   => 소비자물가지수 증가 => 아파트 매매지수 증가 => 부동산매매거래현황 감소
                                          => 토지지수 증가 => 부동산매매거래현황 감소")

comment("이율이 증가하면 부동산에 투자하기가 어렵기 때문에 집값이 떨어져서 매매 지수가 낮아져야 하는거 아닌가라는 의문이 듬
         하지만 상관계수를 보면 이율과 아파트/토지매매지수는 0.1366, 0.10660으로 선형이 낮다고 볼 수 있음")

comment("이율 변동 후 몇 개월이 지나야 매매지수가 반영되지 않을까??") # 시사점

## 이율 n개월 후 아파트/토지 매매지수
for(n in 0:24){
  data_idex <- n_after_data_make(n)
  cat("이율 ", n, "개월 후 아파트/토지매매지수 상관계수",sep='',end='\n')
  cat("행의 개수: ", nrow(data_idex), "개", sep="", end='\n')
  print(cor(data_idex[,2], data_idex[,3:4]))
  cat(end='\n')
}

### 분석
comment("10개월까지는 상관(선형)이 약하다가 그 이후부터 음의 상관되어
         20개월에서 정점을 찍고 차츰 다시 내려가는 것을 확인
         이율 변동 후 10~20개월이 지나야 아파트/토지의 매매지수가 변동 확인")

### 확인
cbind(data[1:49,1:4], APT_TRDE_IDEX_ch=data[11:59,3], PCLND_IDEX_ch=data[11:59,4]) # 10개월 후(18년 1월 ~ 22년 1월)
cbind(data[1:44,1:4], APT_TRDE_IDEX_ch=data[16:59,3], PCLND_IDEX_ch=data[16:59,4]) # 15개월 후(18년 1월 ~ 21년 8월)
cbind(data[1:39,1:4], APT_TRDE_IDEX_ch=data[21:59,3], PCLND_IDEX_ch=data[21:59,4]) # 20개월 후(18년 1월 ~ 21년 3월)
### 이율이 떨어지면 n개월 후  매매지수는 올라가고 이율이 올라가면 n개월 후 매매지수가 내려가는 것을 어느 정도 확인

comment("시각화를 통해 확실하게 알아보기") # 시사점

## 시각화 해보기
### 월변동 없는 그래프
ggplot(data=data) +
  geom_line(mapping=aes(x=YEAR_MM, y=APT_TRDE_IDEX)) +
  geom_line(mapping=aes(x=YEAR_MM, y=PCLND_IDEX), colour="burlywood4") +
  geom_line(mapping=aes(x=YEAR_MM, y=LON_INRST*25), colour='red') +
  scale_y_continuous(sec.axis=sec_axis(~./25, name="LON_INRST"))

### 10개월 후
data_idex_after_10 <- n_after_data_make(10) # 지수를 10개월 후 반영
ggplot(data=data_idex_after_10) +
  geom_line(mapping=aes(x=YEAR_MM, y=APT_TRDE_IDEX_ch)) +
  geom_line(mapping=aes(x=YEAR_MM, y=PCLND_IDEX_ch), colour='burlywood4') +
  geom_line(mapping=aes(x=YEAR_MM, y=LON_INRST*27.13), colour='red') +
  scale_y_continuous(sec.axis=sec_axis(~./27.13, name="LON_INRST"))

#### 20개월 후
data_idex_after_20 <- n_after_data_make(20) # 지수를 10개월 후 반영
ggplot(data=data_idex_after_20) +
  geom_line(mapping=aes(x=YEAR_MM, y=APT_TRDE_IDEX_ch)) +
  geom_line(mapping=aes(x=YEAR_MM, y=PCLND_IDEX_ch), colour='burlywood4') +
  geom_line(mapping=aes(x=YEAR_MM, y=LON_INRST*30), colour='red') +
  scale_y_continuous(sec.axis=sec_axis(~./30, name="LON_INRST"))

## 상관계수 그래프
### GGally방법
ggpairs(data[2:7])

### corrplot방법
corrplot.mixed(cor(data[2:7]),upper = "circle", lower = "number", tl.col="blue", tl.cex = 0.3)

### ggcorrplot방법
ggcorrplot(cor(data[2:7]),tl.cex = 5,method='circle',lab=TRUE,type="upper")

### 분석
comment("이율-주택소비심리지수 => 음(-0.768)
         이율-소비자물가지수 => 양(0.666)
         아파트매매지수-토지매매지수 => 양(0.969)
         아파트매매지수-소비자물가지수 => 양(0.751)
         토지매매지수-소비자물가지수 => 양(0.755)
         아파트소비심리지수-토지소비심리지수 => 양(0.727)")

## 이율 n개월 후 소비심리지수
for(n in 0:24){
  data_trl_idex <- cbind(data[1:(59-n),1:2], HOUSE_CNSMP_TRL_IDEX=data[(1+n):59,5], LAD_CNSMP_TRL_IDEX=data[(1+n):59,6])
  cat("이율 ", n, "개월 후 주택/토지소비심리지수 상관계수",sep="", end='\n')
  cat("행의 개수: ", nrow(data_trl_idex), "개", sep="", end='\n')
  print(cor(data_trl_idex[,2], data_trl_idex[,3:4]))
  cat(end='\n')
}

## 2. 회귀분석
### 전체(전진선택법)
all_model_fo <- lm(TOTAL_TRDE_COUNT ~ 1, data=data) # 회귀분석
all_model_forward <- stepAIC(all_model_fo, direction="forward", scope=TOTAL_TRDE_COUNT~ YEAR_MM + LON_INRST + APT_TRDE_IDEX + PCLND_IDEX + HOUSE_CNSMP_TRL_IDEX + LAD_CNSMP_TRL_IDEX + CNSMR_PRICES_IDEX) # stepAIC는 MASS패키지가 필요로 함
summary(all_model_forward)

### 전체(후진선택법)
all_model_ba <- lm(TOTAL_TRDE_COUNT~ YEAR_MM + LON_INRST + APT_TRDE_IDEX + PCLND_IDEX + HOUSE_CNSMP_TRL_IDEX + LAD_CNSMP_TRL_IDEX + CNSMR_PRICES_IDEX, data=data)
all_model_backward <- stepAIC(all_model_ba, direction="backward") # stepAIC는 MASS패키지가 필요로 함
summary(all_model_backward)
coeff=coef(all_model_backward) # 절편/회귀계수 저장 0: 절편, 1: APT_TRDE_IDEX, 2: HOUSE_CNSMP_TRL_IDEX, 3: LAD_CNSMP_TRL_IDEX 
anova(all_model_backward) # 분산분석을 통해 각 그룹의 평균차이가 유의미 한지 확인
par(mfrow=c(2,2)) # 그래프를 한 화면에 같이 보기 위해서
plot(all_model_backward) # 회귀식의 선형성, 정규성, 등분산성, 독립성 진단

### 회귀식(전체)
pred <- predict(all_model_backward,newdata = data) # 예측값(coeff[1]+coeff[2]*data$APT_TRDE_IDEX+coeff[3]*data$HOUSE_CNSMP_TRL_IDEX+coeff[4]*data$LAD_CNSMP_TRL_IDEX와 동일)
data |>
  ggplot() +
  geom_point(aes(x=YEAR_MM,y=TOTAL_TRDE_COUNT)) +
  geom_point(aes(x=YEAR_MM,y=pred),colour='green')

#### 분석(전체)
comment("전진선택법이나 후진선택법 모두
         주택소비심리지수, 아파트매매지수, 토지소비심리지수가 변수로 선택되었고
         토지소비심리지수는 0.05보다 커서 유의하지 않은 회귀계수로 나오고
         설명력도 0.69의 설명력이 있다고 볼 수 있어서 회귀식을 그려서 정확한지 확인해 볼 것
        
         분산분석에서도 토지소비심리지수가 0.05보다 크므로 유의하지 않다고 볼 수 있음
        
         plot(all_model_backward)에서 residual vs fitted plot(which=1)에서는 선형성
                                      QQplot(which=2)에서는 정규성
                                      scale-location plot(which=3)은 등분산성
                                      residuals vs leverage plot(which=5)은 독립성")

### 아파트 + 소비자물가지수(전진선택법)
apt_data <- data[c(1,2,3,5,7,8)]
apt_model_fo <- lm(HOUSE_TRDE_COUNT~1, data=apt_data)
apt_model_forward <- stepAIC(apt_model_fo,direction = "forward", scope=HOUSE_TRDE_COUNT~YEAR_MM+LON_INRST+APT_TRDE_IDEX+HOUSE_CNSMP_TRL_IDEX+CNSMR_PRICES_IDEX)
summary(apt_model_forward)

### 아파트 + 소비자물가지수(후진선택법)
apt_model_ba <- lm(HOUSE_TRDE_COUNT~YEAR_MM+LON_INRST+APT_TRDE_IDEX+HOUSE_CNSMP_TRL_IDEX+CNSMR_PRICES_IDEX, data=apt_data)
apt_model_backward <- stepAIC(apt_model_ba,direction = "backward", scope=HOUSE_TRDE_COUNT~1)
summary(apt_model_forward)
anova(apt_model_backward)
par(mfrow=c(2,2))
plot(apt_model_backward)

### 회귀식(아파트 + 소비자물가지수)
apt_pred <- predict(apt_model_backward, newdata = data)
data |>
  ggplot() +
  geom_point(aes(x=YEAR_MM,y=HOUSE_TRDE_COUNT)) +
  geom_point(aes(x=YEAR_MM,y=apt_pred),colour='blue')

#### 분석(아파트 + 소비자물가지수)
comment("회귀계수를 확인 했을 때 신뢰수준 99%에서는 모두 유의하다고 볼 수 있으나 99.9%에서는 절편이 유의하지 않음
         설명력도 0.6753으로 준수하고 p값도 유의하다고 볼 수 있음
         
         분산분석에도 p값이 낮아 유의함
         
         선형성, 정규성, 등분산성, 독립성 유의성 유무도 확인
        
         전체일때와 비슷하게 3, 24, 31 에서 잔차가 심함")

### 토지 + 소비자물가지수(전진선택법)
land_data <- data[c(1,2,4,6,7,9)]
land_model_fo <- lm(LAB_TRDE_COUNT~1,data=land_data)
land_model_forward <- stepAIC(land_model_fo, scope=LAB_TRDE_COUNT~LON_INRST+PCLND_IDEX+LAD_CNSMP_TRL_IDEX+CNSMR_PRICES_IDEX, direction = "forward")
summary(land_model_forward)

### 토지 + 소비자물가지수(후진선택법)
land_model_ba <- lm(LAB_TRDE_COUNT~LON_INRST+PCLND_IDEX+LAD_CNSMP_TRL_IDEX+CNSMR_PRICES_IDEX,data=land_data)
land_model_backward <- stepAIC(land_model_ba, scope=LAB_TRDE_COUNT~1, direction = "backward")
summary(land_model_backward)
anova(land_model_backward)
plot(land_model_backward)

### 회귀식(토지 + 소비자물가지수)
land_pred <- predict(land_model_backward,newdata = land_data)
land_data |>
  ggplot() + 
  geom_point(aes(x=YEAR_MM,y=LAB_TRDE_COUNT)) +
  geom_point(aes(x=YEAR_MM,y=land_pred),colour="blue")

#### 분석(토지 + 소비자물가지수)
comment("전진선택법은 이율만 독립변수로 선택
         하지만 유의는 하지만 종속변수를 설명하기에는 너무 낮은 결정계수를 가졌음
        
         후진선택법은 토지매매지수, 소비자물가지수가 선택되었는데
         회귀계수는 유의 하지만 전진선택법과 마찬가지로 결정계수가 너무 낮음
        
         회귀식은 설명력이 높고 독립변수의 개수가 2개인 후진선택법을 선택
        
         전체나 아파트 보다 이상치도 많고 잔차도 있어 실제값과 멀리 떨어진거처럼 보여
         토지는 예측하기가 어려워 보임")

# 열별 개월수 변동을 다르게 만들어 주는 함수
n_change_data <- function(a,b,c,d,e,f,g,h){ # a~h는 열별로 개월을 변동시킬 숫자를 입력
  new_data <- data
  n_ch <- c(a,b,c,d,e,f,g,h) # 열별 변동될 개월의 벡터
  cho_col <- c(1,2) # 선택될 변수 벡터
  
  # n개월 후 변동된 열만으로 데이터 프레임 만들기
  for(n in 1:8){
    if(n_ch[n]!=0){
      cho_col <- c(cho_col, n+2)
      new_data[n+2] <- data[n+2][c((1+n_ch[n]):59,1:n_ch[n]),]
    }
  }
  
  anal_data <- new_data[1:(59-max(a,b,c,d,e,f,g,h)),cho_col]
  
  # 만든 데이터 프레임으로 상관계수 확인 해보기
  a <- ggcorrplot(cor(anal_data[2:ncol(anal_data)]),tl.cex = 5,method='circle',type='upper',lab = TRUE) +
    ggtitle("CORR")
  
  # 변수 선택법

  y_formula <- names(anal_data)[ncol(anal_data)] # 종속변수
  x_formula <- names(anal_data)[!names(anal_data) %in% c("HOUSE_TRDE_COUNT","LAB_TRDE_COUNT","TOTAL_TRDE_COUNT")][-1] # 독립변수
  for_formula <- as.formula(paste(y_formula,"~",1)) # 전진선택법의 formula
  back_formula <- as.formula(paste(y_formula,"~",paste(x_formula,collapse = "+"))) # 후진선택법의 formula

  ## 전진선택법
  cat("전진선택법 시작",end="\n")
  anal_model_fo <- lm(for_formula, data = anal_data)
  anal_model_forward <- stepAIC(anal_model_fo, scope = back_formula, direction = "forward")
  forward_pred <- predict(anal_model_forward, new_data = anal_data)
  ## 전진선택법의 실제값/예측값 비교
  b <- anal_data |>
    ggplot() +
    geom_point(aes(x=YEAR_MM,y = anal_data[, y_formula])) +
    geom_point(aes(x=YEAR_MM,y=forward_pred),colour = "orange") +
    xlab("year_mm") + ylab(y_formula) + ggtitle("forward")
  
  ## 후진선택법
  cat("전진선택법 종료\n\n후진선택법 시작",end="\n")
  anal_model_ba <- lm(back_formula, data = anal_data)
  anal_model_backward <- stepAIC(anal_model_ba, scope = for_formula, direction = "backward")
  backward_pred <- predict(anal_model_backward, new_data = anal_data)
  ## 후진선택법의 실제값/예측값 비교
  c <- anal_data |>
    ggplot() +
    geom_point(aes(x=YEAR_MM,y=anal_data[, y_formula])) +
    geom_point(aes(x=YEAR_MM,y=backward_pred),colour = "green") +
    xlab("year_mm") + ylab(y_formula) + ggtitle("backward")
  
  grid.arrange(a, arrangeGrob(b,c,ncol=2))
}

# 함수 실행
n_change_data(8,0,5,0,5,4,0,0)















































