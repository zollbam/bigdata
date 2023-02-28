rm(list=ls())

colors()

# 주석
comment("

")

# 라이브러리 설치
# install.packages("")

# 라이브러리 불러오기
library(dplyr)
library(tidyr)
library(plotly)

# 필요함수
## 해당열 n개월 만큼 열 밀기(설명변수)
## -------------------------------------------
## 매개변수
## df: 데이터 프레임
## var: 설명변수 열이름
## n: 변동될 개월
## 반환
## n개월만큼 변동된 설명변수 데이터
## -------------------------------------------
x_n_var <- function(df, var, n){
  x <- df[var][1:(nrow(df)-n),]
  
  return(x)
}

## 해당열 n개월 만큼 열 밀기(종속변수)
## -------------------------------------------
## 매개변수
## df: 데이터 프레임
## var: 종속변수 열이름
## n: 변동될 개월
## 반환
## n개월만큼 변동된 종속변수 데이터
## -------------------------------------------
y_n_var <- function(df, var, n){
  y <- df[var][(1+n):nrow(df),]
  
  return(y)
}

## 시각화로 설명변수와 종속변수의 경향 비교
## -------------------------------------------
## 매개변수
## df: 데이터 프레임
## x_val: n개월 변동된 설명변수 데이터(벡터타입)
## y_val: n개월 변동된 종속변수 데이터(벡터타입)
## -------------------------------------------
x_y_plot <- function(df, x_val, y_val){
  plot(x = df[1:length(x_val),"YEAR_MM"], y = x_val, col = "red", type = "l", lwd=3)
  # abline(h=100) # 소비자물가지수 100(기준년도 2020년) 수평선을 그리기위한 코드 
  par(new = T)
  plot(x = df[1:length(x_val),"YEAR_MM"], y= y_val, col = "green", type = "l", axes = F, lwd=3)
}

## 시각화로 설명변수와 종속변수의 경향 비교
## -------------------------------------------
## 매개변수
## df: 데이터 프레임
## x_val: n개월 변동된 설명변수 데이터(벡터타입 + 범주형)
## y_val: n개월 변동된 종속변수 데이터(벡터타입)
## -------------------------------------------
xfa_y_plot <- function(df, x_val, y_val){
  plot(x = df[1:length(x_val),"YEAR_MM"], y = x_val, col = "red", type = "p", lwd=3)
  # abline(h=100) # 소비자물가지수 100(기준년도 2020년) 수평선을 그리기위한 코드 
  par(new = T)
  plot(x = df[1:length(x_val),"YEAR_MM"], y= y_val, col = "green", type = "l", axes = F, lwd=3)
}

## train과 test 나누기 함수
## -------------------------------------------
## 매개변수
## df: 데이터 프레임
## 반환
## list형태로 저장된 train과 test
## -------------------------------------------
tra_tes_split <- function(df){
  train_anal_data <- df[1:(nrow(df)-20),] # 마지막 10개행 제외한 모든 행은 train
  test_anal_data <- df[(nrow(df)-19):nrow(df),] # 마직막 10행은 test
  
  return(list(train = train_anal_data, test = test_anal_data)) # 여러개의 return
}

## 예측값과 실제값 비교
## -------------------------------------------
## 매개변수
## df: 데이터 프레임(예측하고자하는 설명변수의 데이터가 있어야함)
## pred: 예측값
## meth: 문자형 형태로 그래프 제목이 될 예정
## 반환
## 예측값과 실제값의 비교 그래프
## -------------------------------------------
pred_tru <- function(df, pred, meth){
  # 그래프 기본 틀
  plt_pred_tru <- ggplot(data = df) +
    geom_point(aes(x = YEAR_MM, y = pred), 
               colour = "green",
               size = 4) # 예측값
  
  # 기본 틀에 추가
  if(names(df)[ncol(df)] == "APT_TRDE_IDEX"){
    plt_pred_tru <- plt_pred_tru + geom_point(aes(x = YEAR_MM, y = APT_TRDE_IDEX), size = 3) # 실제값
  } else {
    plt_pred_tru <- plt_pred_tru + geom_point(aes(x = YEAR_MM, y = PCLND_IDEX), size = 3) # 실제값
  }
  
  # 타이틀 추가
  plt_pred_tru <- plt_pred_tru + ggtitle(meth)
  
  return(ggplotly(plt_pred_tru)) # 그래프
}

## formula생성
## -------------------------------------------
## 매개변수
## df: 데이터 프레임
## 반환
## x와 y의 formula (리스트 형태)
## ------------------------------------------
formula_mk <- function(df){
  y <- colnames(df)[ncol(df)]
  x <- colnames(df)[!colnames(df) %in% c("YEAR_MM", "APT_TRDE_IDEX")]
  
  y_formula <- paste(y,"~ 1")
  x_formula <- paste(y,"~",paste(x, collapse = " + "))
  
  return(list(y_formula, x_formula))
}

## mse계산
## -------------------------------------------
## 매개변수
## df: 데이터 프레임
## pred: 예측값
## 반환
## mse
## ------------------------------------------
mse <- function(df, pred){
  return(mean((df[,"APT_TRDE_IDEX"]-pred)**2))
}

## 데이터프레임으로 최종모델 반환받기
## -------------------------------------------
## 매개변수
## df: 데이터 프레임
## 반환
## mse가 가장 낮은 모델
## -------------------------------------------
model_return <- function(df){
  # mse저장시킬 벡터
  mses <- c()
  
  # train/test 반환
  data_train <<- tra_tes_split(df)[[1]]
  data_test <<- tra_tes_split(df)[[2]]
  
  # formula 생성
  fo_formula <- formula_mk(df)[[1]]
  ba_formula <- formula_mk(df)[[2]]
  
  # 전체변수를 사용하여 예측
  data_mo <- lm(ba_formula, data = data_train)
  data_pred <- predict(data_mo, newdata = data_test)
  data_mse <- mse(data_test, data_pred)
  mses <- c(mses, data_mse)
  cat("전체 변수를 사용하여 예측을 했을 때 mse는 ", data_mse, "입니다.", sep = "", end = "\n\n")
  
  # 전진선택법으로 예측
  fo_data_mo <- lm(fo_formula, data = data_train)
  forward_data_mo <- stepAIC(fo_data_mo, scope = ba_formula, direction = "forward")
  fo_data_pred <- predict(forward_data_mo, newdata = data_test)
  fo_data_mse <- mse(data_test, fo_data_pred)
  mses <- c(mses, fo_data_mse)
  cat("전진선택법으로 예측을 했을 때 mse는 ", fo_data_mse, "입니다.", sep = "", end = "\n\n")
  
  # 후진선택법으로 예측
  ba_data_mo <- lm(ba_formula, data = data_train)
  backward_data_mo <- stepAIC(ba_data_mo, scope = fo_formula, direction = "backward")
  ba_data_pred <- predict(backward_data_mo, newdata = data_test)
  ba_data_mse <- mse(data_test, ba_data_pred)
  mses <- c(mses, ba_data_mse)
  cat("후진선택법으로 예측을 했을 때 mse는 ", ba_data_mse, "입니다.", sep = "", end = "\n\n")
  
  # mses중에서 최소 mse 찾기
  mses_min <- min(mses)
  
  # 최소 mse의 모델 반환
  if (mses_min == data_mse){
    cat("선택된 모델은 전체 변수를 사용한 것으로 선택(mse: ", data_mse, ")\n회귀계수의 유의성은???", sep = "", end = "\n")
    return(forward_data_mo)
  } else if (mses_min == fo_data_mse){
    cat("전진선택법 모델로 선정(mse: ", fo_data_mse, ")\n회귀계수의 유의성은???", sep =, end = "\n")
    return(forward_data_mo)
  } else{
    cat("후진선택법 모델로 선정(mse: ", ba_data_mse, ")\n회귀계수의 유의성은???", sep = "", end = "\n")
    return(backward_data_mo)
  }
}

## 열별 변동개월수 다르한 데이터 프레임 만들기
## -------------------------------------------
## 매개변수
## df: 데이터 프레임
## n_col_vec: 종속변수에 영향을 미치는 개월 벡터((df의 열 개수 -1 만큼의 길이가 되어야 함))
## 반환
## 개월 수 변동이 완료된 df
## -------------------------------------------
n_change_data <- function(df, n_col_vec){ # a ~ g는 열별로 개월을 변동시킬 숫자를 입력
  if((length(n_col_vec) + 1) != ncol(df)){
    return("df와 열의 개수가 맞지 않습니다. 개월 벡터를 다시 확인해 주세요.")
  }
  
  re_data <- df
  max_n <- max(n_col_vec) # 함수 내에서 필요한 상수값
  cho_col <- c(1) # 1은 YEAR_MM를 의미
  
  # n개월 후 변동된 데이터를 다시 열에 저장
  for(n in 2:(ncol(df)-1)){ # n은 열 숫자를 의미
    cho_col <- c(cho_col, n) # 필요한 열 추가한 벡터
    if(n_col_vec[n-1] != max_n){
      re_data[n] <- re_data[n][c((1 + max_n - n_col_vec[n-1]):nrow(df), 1:(max_n - n_col_vec[n-1])),]
    } else{
      re_data[n] <- re_data[n]
    }
  }
  re_data[ncol(df)] <- re_data[ncol(df)][c((1 + max_n):nrow(df), 1:max_n),]
    
  # 사용할 데이터 프레임 만들기
  cho_col <- c(cho_col, ncol(df))
  anal_data <- re_data[1:(nrow(df) - max_n), cho_col] # 밀린 행 데이터 삭제
  
  return(anal_data) # 내가 사용할 최종 df
}

# 데이터 불러오기
## 11년 7월부터 22년 11월까지
data <- read.csv("D:/R/final_anal_pred/data/anal_data.csv")
data$YEAR_MM <- as.Date(data$YEAR_MM)
str(data)
colSums(is.na(data)) # 결측치 확인

## 00년 1월부터 23년 1월까지
all_data <- read.csv("D:/R/final_anal_pred/data/all_anal_data.csv", fileEncoding = "euc-kr")  # 한글인코딩
all_data$YEAR_MM <- as.Date(all_data$YEAR_MM)
str(all_data)
colSums(is.na(all_data)) # 결측치 확인
na.omit(all_data) # data와 같은 내용의 df생성


# 변동된 데이터의 상관계수
## 기준금리와 아파트매매지수 상관계수 비교
cor(x_n_var(data, "STAN_INTR", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 0개월 변동
x_y_plot(data, x_n_var(data, "STAN_INTR", 0), y_n_var(data, "APT_TRDE_IDEX", 0)) # 2개 변수의 경향을 비교할 시각화(0개월)
title("0개월")
abline(v = data$YEAR_MM[14], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[61], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[78], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[90], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[98], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[108], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[123], lty = 2, col = "violetred4")

cor(x_n_var(data, "STAN_INTR", 6), y_n_var(data, "APT_TRDE_IDEX", 6)) # 6개월 변동
x_y_plot(data, x_n_var(data, "STAN_INTR", 6), y_n_var(data, "APT_TRDE_IDEX", 6)) # 2개 변수의 경향을 비교할 시각화(6개월)
title("6개월")
abline(v = data$YEAR_MM[14], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[61], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[78], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[90], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[98], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[108], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[123], lty = 2, col = "violetred4")

cor(x_n_var(data, "STAN_INTR", 11), y_n_var(data, "APT_TRDE_IDEX", 11)) # 11개월 변동
x_y_plot(data, x_n_var(data, "STAN_INTR", 11), y_n_var(data, "APT_TRDE_IDEX", 11)) # 2개 변수의 경향을 비교할 시각화(11개월)
title("11개월")
abline(v = data$YEAR_MM[14], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[61], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[78], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[90], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[98], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[108], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[123], lty = 2, col = "violetred4")

cor(x_n_var(data, "STAN_INTR", 17), y_n_var(data, "APT_TRDE_IDEX", 17)) # 17개월 변동
x_y_plot(data, x_n_var(data, "STAN_INTR", 17), y_n_var(data, "APT_TRDE_IDEX", 17)) # 2개 변수의 경향을 비교할 시각화(17개월)
title("17개월")
abline(v = data$YEAR_MM[14], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[61], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[78], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[90], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[98], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[108], lty = 2, col = "violetred4")
abline(v = data$YEAR_MM[123], lty = 2, col = "violetred4")

for(i in 0:30){
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "STAN_INTR", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
16개월에서 가장 높은 상관계수(-0.9033386)를 보이지만
시각화 경향으로 보면 11개월이 반비례 성향을 가장 잘 나타내고 있음
2개월 부터는 -0.7이 넘으므로 이때부터 예측을 해도 상관은 없을 걸로 예상
")

## 주택담보대출과 아파트매매지수 상관계수 비교
for(i in 0:30){
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "HOUSE_MORT_LOAN", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
x_y_plot(data, x_n_var(data, "HOUSE_MORT_LOAN", 0), y_n_var(data, "APT_TRDE_IDEX", 0)) # 0개월
x_y_plot(data, x_n_var(data, "HOUSE_MORT_LOAN", 6), y_n_var(data, "APT_TRDE_IDEX", 6)) # 6개월
x_y_plot(data, x_n_var(data, "HOUSE_MORT_LOAN", 9), y_n_var(data, "APT_TRDE_IDEX", 9)) # 9개월
x_y_plot(data, x_n_var(data, "HOUSE_MORT_LOAN", 17), y_n_var(data, "APT_TRDE_IDEX", 17)) # 17개월
x_y_plot(data, x_n_var(data, "HOUSE_MORT_LOAN", 26), y_n_var(data, "APT_TRDE_IDEX", 26)) # 26개월
comment("
26개월에서 -0.842332로 가장 높은 상관계수가 나옴
왜 이렇게 나올까... 주택담보대출 연리와 기준금리를 비교 해봄

상식적으로 생각을 해보면 연리가 오르면 대출이자가 많아져 몇개월 안에 매매지수가 떨어질거 같지만
0개월의 시각화를 보면 연리가 오르는 경향이 보여도 한참이 지나야 매매지수가 떨어짐
")

x_y_plot(data, x_n_var(data, "HOUSE_MORT_LOAN", 0), y_n_var(data, "APT_MONY_IDEX", 0)) # 주택담보대출 연리와 아파트 실거래가지수
comment("
실거래가지수로 봐도 반영되는 기간이 너무 김

담보대출 자체가 한국은행의 기준금리와는 아에 다른 개념의 금리를 씀
대출금리 = 대출기준금리 + 가산금리
이 영향으로 담보대출연리과 아파트매매지수의 관계가 긴 반영 기간을 가지는 걸로 예상상
")

x_y_plot(data, x_n_var(data, "HOUSE_MORT_LOAN", 0), y_n_var(data, "STAN_INTR", 0)) # 주택담보대출 연리와 기준금리 시각화(변동없음)
x_y_plot(data, x_n_var(data, "HOUSE_MORT_LOAN", 3), y_n_var(data, "STAN_INTR", 3)) # 3개월 변동
x_y_plot(data, x_n_var(data, "HOUSE_MORT_LOAN", 9), y_n_var(data, "STAN_INTR", 9)) # 9개월 변동
for(i in 0:30){ # 주택담보대출 연리와 기준금리를 비교
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "HOUSE_MORT_LOAN", i), y_n_var(data, "STAN_INTR", i)),"입니다.", sep = "", end="\n")
}
comment("
기준금리변경이 되고 주택담보대출에 영향을 미칠것으로 생각했지만
시각화를 보면 주택담보대출이 먼저 선행이 되고 기준금리에 영향을 미치는 것으로 확인
9개월에서 0.9441322높게 나오고 아까 기준금리와 아파트매매지수의 상관계수가 17개월이 나옴
17개월+9개월이 되서 26개월에서 가장 높게 나왔다고 생각
주택담보대출=====(9개월)=====>기준금리=====(17개월)=====>아파트매매지수
주택담보대출==================(26개월)==================>아파트매매지수
")

## 부동산소비심리지수와 아파트매매지수 상관계수 비교
fa_REAL_CNSMP_TRL_IDEX <- as.factor(ifelse(data$REAL_CNSMP_TRL_IDEX < 95, 0, ifelse(data$REAL_CNSMP_TRL_IDEX < 115, 1, 2))) # 범주형으로 변경
table(fa_REAL_CNSMP_TRL_IDEX) # 빈도표(빈도)
prop.table(table(fa_REAL_CNSMP_TRL_IDEX))*100 # 빈도표(확률)
comment("
빈도표를 보면 하강일때 11번, 보합일 때 47번, 상승일 때 79번으로 나타남
하강의 데이터가 너무 부족한거 아닌가... 나중에 분석시 삭제시켜 분석하거나
하강데이터만 따로 분석을 해보고 싶은데 너무 데이터가 작아 가능할지는 의문...
")

for(i in 0:30){
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "REAL_CNSMP_TRL_IDEX", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}

for(i in 0:30){
  cat(i, "개월의 상관계수는", cor(as.numeric(fa_REAL_CNSMP_TRL_IDEX[1:(length(fa_REAL_CNSMP_TRL_IDEX)-i)]), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
범주형이나 실수형이나 1~30개월 모든 상관계수를 확인해보면 절댓값이 0.2이상인 것들이 없음
2개의 변수는 선형관계는 없음
")

plot(x=data$YEAR_MM, y=data$APT_TRDE_IDEX, type="l", col="green")
par(new=T)
plot(x=data$YEAR_MM, y=fa_REAL_CNSMP_TRL_IDEX, col="red", ylim=c(1,4))
text(as.Date("2012-01-01"),3.1,"상승",cex=2)
text(as.Date("2012-01-01"),2.1,"보합",cex=2)
text(as.Date("2012-01-01"),1.1,"하강",cex=2)
comment("
범주형 소비자심리지수와 아파트매매지수의 관계는 초반에는 상관이 없어보이지만
13년 8월부터는 소비심리지수 범주형의 기준에 맞게 아파트매매지수가 상승/하강/유지 형태를 보이는 것을 확인
")

plot(data$YEAR_MM, data$APT_TRDE_IDEX, col = "green", type = "s",axes=F)
par(new = T)
plot(x = data$YEAR_MM, y = data$REAL_CNSMP_TRL_IDEX, col = "red", type = "s", ylim = c(70,150))
abline(h=115, lwd = 1, lty =2)
abline(h=95, lwd = 1, lty =2)
text(as.Date("2017-01-01"),125,"상승",cex=3)
text(as.Date("2017-01-01"),105,"보합",cex=3)
text(as.Date("2017-01-01"),85,"하강",cex=3)
comment("
소비심리지수를 실수형으로 그리고 95/95~115/115로 블록을 
나누었는데 시각적으로 너무 뒤죽박죽으로 되어있어 보기 불편
")

## 주택소비심리지수와 아파트매매지수 상관계수 비교
fa_HOUSE_CNSMP_TRL_IDEX <- as.factor(ifelse(data$HOUSE_CNSMP_TRL_IDEX < 95, 0, ifelse(data$HOUSE_CNSMP_TRL_IDEX < 115, 1, 2))) # 범주형으로 변경
table(fa_HOUSE_CNSMP_TRL_IDEX) # 빈도표(빈도)
prop.table(table(fa_HOUSE_CNSMP_TRL_IDEX))*100 # 빈도표(확률)
comment("
부동산 소비심리지수와 거의 비슷한 양상을 보임
빈도표를 보면 하강일때 11번, 보합일 때 42번, 상승일 때 84번으로 나타남

하강부분의 데이터가 너무 부족한 현상
")

for(i in 0:30){
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "HOUSE_CNSMP_TRL_IDEX", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}

for(i in 0:30){
  cat(i, "개월의 상관계수는", cor(as.numeric(fa_HOUSE_CNSMP_TRL_IDEX[1:(length(fa_HOUSE_CNSMP_TRL_IDEX)-i)]), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
상관계수를 보면 아파트매매지수와 선형성이 전혀 없다고 나옴
")

plot(x=data$YEAR_MM, y=data$APT_TRDE_IDEX, type="l", col="green")
par(new=T)
plot(x=data$YEAR_MM, y=fa_HOUSE_CNSMP_TRL_IDEX, col="red", ylim=c(1,4))
text(as.Date("2012-01-01"),3.1,"상승",cex=2)
text(as.Date("2012-01-01"),2.1,"보합",cex=2)
text(as.Date("2012-01-01"),1.1,"하강",cex=2)
comment("
부동산소비심리지수와 별 차이는 없어 보임
")

## 주택매매심리지수와 아파트매매지수 상관계수 비교
fa_TRDE_CNSMP_TRL_IDEX <- as.factor(ifelse(data$TRDE_CNSMP_TRL_IDEX < 95, 0, ifelse(data$TRDE_CNSMP_TRL_IDEX < 115, 1, 2))) # 범주형으로 변경
table(fa_TRDE_CNSMP_TRL_IDEX) # 빈도표(빈도)
prop.table(table(fa_TRDE_CNSMP_TRL_IDEX))*100 # 빈도표(확률)
comment("
부동산 소비심리지수와 거의 비슷한 양상을 보임
빈도표를 보면 하강일때 7번, 보합일 때 39번, 상승일 때 91번으로 나타남

이제껏본 소비심리지수 중에서도 하강부분의 데이터가 더 부족한 현상
")

for(i in 0:30){
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "HOUSE_CNSMP_TRL_IDEX", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}

for(i in 0:30){
  cat(i, "개월의 상관계수는", cor(as.numeric(fa_TRDE_CNSMP_TRL_IDEX[1:(length(fa_TRDE_CNSMP_TRL_IDEX)-i)]), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
매매소비심리지수의 실수형은 다른 소비심리지수들과 마찬가지로 선형성이 없다고 나오지만
매매소비심리지수의 범주형은 11개월부터 +0.4이상으로 나오고 16개월에서 0.4436618로 가장 높게 나옴
")

plot(x=data$YEAR_MM, y=data$APT_TRDE_IDEX, type="l", col="green") # 월변동X
par(new=T)
plot(x=data$YEAR_MM, y=fa_TRDE_CNSMP_TRL_IDEX, col="red", ylim=c(1,4))
text(as.Date("2012-01-01"),3.1,"상승",cex=2)
text(as.Date("2012-01-01"),2.1,"보합",cex=2)
text(as.Date("2012-01-01"),1.1,"하강",cex=2)

plot(x=data$YEAR_MM[1:121], y=data$APT_TRDE_IDEX[17:137], type="l", col="green") # 16개월 변동
par(new=T)
plot(x=data$YEAR_MM[1:121], y=fa_TRDE_CNSMP_TRL_IDEX[1:121], col="red", ylim=c(1,4))
text(as.Date("2012-01-01"),3.1,"상승",cex=2)
text(as.Date("2012-01-01"),2.1,"보합",cex=2)
text(as.Date("2012-01-01"),1.1,"하강",cex=2)

## 주택전세심리지수와 아파트매매지수 상관계수 비교
fa_SECU_CNSMP_TRL_IDEX <- as.factor(ifelse(data$SECU_CNSMP_TRL_IDEX < 95, 0, ifelse(data$SECU_CNSMP_TRL_IDEX < 115, 1, 2))) # 범주형으로 변경
table(fa_SECU_CNSMP_TRL_IDEX) # 빈도표(빈도)
prop.table(table(fa_SECU_CNSMP_TRL_IDEX))*100 # 빈도표(확률)
comment("
부동산 소비심리지수와 거의 비슷한 양상을 보임
빈도표를 보면 하강일때 14번, 보합일 때 60번, 상승일 때 63번으로 나타남

다른 3개의 소비심리지수보다 하강의 데이터가 많고 보합과 상승도 비슷한 개수로
데이터를 보유하고 있어 분석시 좋은 결과를 얻을 수 있을거라 예상되고 있음
")

for(i in 0:30){
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "SECU_CNSMP_TRL_IDEX", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}

for(i in 0:30){
  cat(i, "개월의 상관계수는", cor(as.numeric(fa_SECU_CNSMP_TRL_IDEX[1:(length(fa_SECU_CNSMP_TRL_IDEX)-i)]), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
신기한 결과가 나옴
범주든 실수든 0개월에서 -0.5정도의 값이 나옴
높은 수는 아니지만 이것을 보고 전세소비심리지수가 높으면 아파트매매지수는 떨어진다는 선형관계가 조금 있다고 할 수 있음
")

plot(x=data$YEAR_MM, y=data$APT_TRDE_IDEX, type="l", col="green") # 범주형 + 월변동X
par(new=T)
plot(x=data$YEAR_MM, y=fa_SECU_CNSMP_TRL_IDEX, col="red", ylim=c(1,4))
text(as.Date("2012-01-01"),3.1,"상승",cex=2)
text(as.Date("2012-01-01"),2.1,"보합",cex=2)
text(as.Date("2012-01-01"),1.1,"하강",cex=2)
comment("
주택전세매매지수가 상승이면 아파트매매지수가 증가할 수도 감소할 수도 있다는 의미
")

x_y_plot(data, x_n_var(data, "SECU_CNSMP_TRL_IDEX", 0), y_n_var(data, "APT_TRDE_IDEX", 0)) # 실수형 + 월변동X
comment("
짧은 기간 안에서 소비심리가 좋았다가 나빴다가 해서 그래프가 너무 뾰족뾰족하게 되어 있음
시각적으로도 너무 보기 불편하고 종속변수와의 관계성 찾기도 어려움
")

## 소비자물가지수와 아파트매매지수 상관계수 비교
cor(x_n_var(data, "CNSMR_PRICES_IDEX", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 11년 07월 ~ 22년 11월 + 0개월 변동 의 상관계수
for(i in 0:30){ # n개월 변동
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "CNSMR_PRICES_IDEX", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n") # n개월 변동
}
x_y_plot(data, x_n_var(data, "CNSMR_PRICES_IDEX", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 11년 07월 ~ 22년 11월
x_y_plot(data, x_n_var(data, "CNSMR_PRICES_IDEX", 24), y_n_var(data, "APT_TRDE_IDEX",24)) # 11년 07월 ~ 22년 11월 + 월변동 24개월
comment("
0개월부터 0.92로 나오며 24개월에서 가장 높게 나옴
24개월은 너무 비상식적이라 0개월로도 충분히 예측모델 생성 가능할 듯
")

cor(x_n_var(all_data[47:277,], "CNSMR_PRICES_IDEX", 0), y_n_var(all_data[47:277,], "APT_TRDE_IDEX",0)) # # 03년 11월 ~ 23년 1월 + 0개월 변동 의 상관계수
plot(all_data$YEAR_MM[47:277], all_data$CNSMR_PRICES_IDEX[47:277],type="l", col="red", lwd=3) # 03년 11월 ~ 23년 1월
par(new=T)
plot(all_data$YEAR_MM[47:277], all_data$APT_TRDE_IDEX[47:277],type="l",col="green", lwd=3)
comment("
기간을 늘려서 보아도 별 차이가 없음
소비자물가지수가 너무 증가하는 형태만 보임
")

x <- c(1,35) # 2020년 1월 ~ 22년 11월 의 기울기
y <- c(data$APT_TRDE_IDEX[103], data$CNSMR_PRICES_IDEX[137])
df <- data.frame(x,y)
df
lm(y~x,df) # 기울기 0.4062
comment("
최근 3년(20년 1월 ~ 22년 11월)간의 소비자물가지수 상승률을 알아보고 싶어
기울기는 0.4062
")

x <- c(1,102) # 2011년 7월 ~ 19년 12월 의 기울기
y <- c(data$APT_TRDE_IDEX[1], data$CNSMR_PRICES_IDEX[102])
df <- data.frame(x,y)
df
lm(y~x,df)
comment("
11년 1월부터 19년 12월의 소비자물가지수 상승률을 알아보고 싶어
기울기는 0.1964
최근 3년간의 상승폭의 절반이하인 것으로 분석
이정도면 최근 3년간의 상승폭이 심상치 않다는 것으로 분석 할 수 있음
")

## 주택실거래가지수와 아파트매매지수 상관계수 비교
cor(x_n_var(data, "HOUSE_MONY_IDEX", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: 0.9733316
x_y_plot(data, x_n_var(data, "HOUSE_MONY_IDEX", 0), y_n_var(data, "APT_TRDE_IDEX",0))
abline(v=as.Date("2012-12-01"))
abline(v=as.Date("2015-12-01"))
abline(v=as.Date("2017-07-01"))
abline(v=as.Date("2018-10-01"))
abline(v=as.Date("2020-04-01"))
abline(v=as.Date("2021-10-01"))
abline(v=as.Date("2022-04-01"))
comment("
상관계수가 0.97로 거의 1에 근접하고 있음
시각화로 봐도 변화하는 경향이 거의 일치 하지만 실거래가지수가 1~3달 정도 앞서있는 걸로 보여
n갸월 변동을 통해 상관계수 확인해보고자 함
")

for(i in 0:30){ # n개월 변동 상관계수
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "HOUSE_MONY_IDEX", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
x_y_plot(data, x_n_var(data, "HOUSE_MONY_IDEX", 1), y_n_var(data, "APT_TRDE_IDEX",1)) # 1개월
abline(v=as.Date("2012-12-01"))
abline(v=as.Date("2015-12-01"))
abline(v=as.Date("2017-07-01"))
abline(v=as.Date("2018-10-01"))
abline(v=as.Date("2020-04-01"))
abline(v=as.Date("2021-10-01"))
abline(v=as.Date("2022-04-01"))

x_y_plot(data, x_n_var(data, "HOUSE_MONY_IDEX", 2), y_n_var(data, "APT_TRDE_IDEX", 2)) # 2개월
abline(v=as.Date("2012-12-01"))
abline(v=as.Date("2015-12-01"))
abline(v=as.Date("2017-07-01"))
abline(v=as.Date("2018-10-01"))
abline(v=as.Date("2020-04-01"))
abline(v=as.Date("2021-10-01"))
abline(v=as.Date("2022-04-01"))

x_y_plot(data, x_n_var(data, "HOUSE_MONY_IDEX", 3), y_n_var(data, "APT_TRDE_IDEX",3)) # 3개월
abline(v=as.Date("2012-12-01"))
abline(v=as.Date("2015-12-01"))
abline(v=as.Date("2017-07-01"))
abline(v=as.Date("2018-10-01"))
abline(v=as.Date("2020-04-01"))
abline(v=as.Date("2021-10-01"))
abline(v=as.Date("2022-04-01"))
comment("
변동이 없을 때 상관계수가 가장 크게 나옴
시각화를 하면 1개월 때가 가장 비슷해보임
주택매매실거래가지수가 아파트매매지수에는 바로 반영이 안 되는 거고 1개월 뒤에 되는 거라고 보고 있음
주택이나 아파트도 별 차이 없어보이는데 개월수 변동에 영향을 미치는 이런 분석이 나와 신기함
")

## 아파트실거래가지수와 아파트매매지수 상관계수 비교
cor(x_n_var(data, "APT_MONY_IDEX", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: 0.9698102
x_y_plot(data, x_n_var(data, "APT_MONY_IDEX", 0), y_n_var(data, "APT_TRDE_IDEX",0))
abline(v=as.Date("2012-12-01"))
abline(v=as.Date("2015-12-01"))
abline(v=as.Date("2017-07-01"))
abline(v=as.Date("2018-10-01"))
abline(v=as.Date("2020-04-01"))
abline(v=as.Date("2021-10-01"))
abline(v=as.Date("2022-04-01"))
comment("
아파트실거래가격지수도 시각화로만 보면 1개월 변동이 가장 영향을 미치는 것으로 보임
데이터가 잘못 되었나 싶어 확인 해봐도 데이터는 정확히 입력 및 저장 되어 있음
왜 이렇게 보일까 인터넷을 찾아보니 https://www.ajunews.com/view/20201013212824693
매매가격지수는 전체 집 중 일부만 뽑아서 산출하는 것이고
실거래가격지수는 해당 월의 실제 계약이 된 것을 바탕으로 산출하는 것
")

data |> # 데이터 확인용 코드
  select("YEAR_MM", "HOUSE_MONY_IDEX", "APT_MONY_IDEX") |>
  View()

for(i in 0:30){ # n개월 변동 상관계수
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "APT_MONY_IDEX", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
아파트실거래가격지수는 1개월에서 0.9707927로 가장 높은 상관계수가 나옴
")

x_y_plot(data, x_n_var(data, "APT_MONY_IDEX", 1), y_n_var(data, "APT_TRDE_IDEX", 1)) # 1개월
abline(v=as.Date("2012-12-01"))
abline(v=as.Date("2015-12-01"))
abline(v=as.Date("2017-07-01"))
abline(v=as.Date("2018-10-01"))
abline(v=as.Date("2020-04-01"))
abline(v=as.Date("2021-10-01"))
abline(v=as.Date("2022-04-01"))

data$APT_TRDE_IDEX[data$YEAR_MM=="2017-07-01"]
data$APT_TRDE_IDEX[data$YEAR_MM=="2017-08-01"]
data$APT_TRDE_IDEX[data$YEAR_MM=="2017-09-01"]

## 경제심리지수와 아파트매매지수 상관계수 비교
cor(x_n_var(data, "ECO_CENT_IDEX", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: -0.07621927
x_y_plot(data, x_n_var(data, "ECO_CENT_IDEX", 0), y_n_var(data, "APT_TRDE_IDEX",0))
abline(v=as.Date("2014-04-01"))
abline(v=as.Date("2015-06-01"))
abline(v=as.Date("2018-07-01"))
abline(v=as.Date("2019-07-01"))
abline(v=as.Date("2019-11-01"))
comment("
경제심리지수는 세월호, 한일무역분쟁, 미중무역전쟁 등 경제적 사건들을 바탕으로 영향을 받고
이런 사건들로 인해 아파트매매지수수에 영향을 미친다고는 볼 수 없다고 판단
")

## 예금액과 아파트매매지수 상관계수 비교 
cor(x_n_var(data, "BANK_DEPO", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: 0.9597947
x_y_plot(data, x_n_var(data, "BANK_DEPO", 0), y_n_var(data, "APT_TRDE_IDEX",0))
comment("
같이 올라가는 경향이지만 아파트매매지수가 하락할 때는 예금액에 의해 영향을 받을지는 미지수
상관관계가 높다고 좋은 것은 아니니 주의하자
")

for(i in 0:30){ # n개월 변동 상관계수
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "BANK_DEPO", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
0개월에서 가장 큰 상관계수수
")

## 대출액과 아파트매매지수 상관계수 비교
cor(x_n_var(data, "BANK_LOAN", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: 0.960392
x_y_plot(data, x_n_var(data, "BANK_LOAN", 0), y_n_var(data, "APT_TRDE_IDEX",0))
comment("
예금액과 마찬가지로 상관관계가 높다고 좋은 것은 아니니 변수 선택시 주의하자
")

for(i in 0:30){ # n개월 변동 상관계수
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "BANK_LOAN", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
14개월에서 0.9670734로 가장 높음
")

x_y_plot(data, x_n_var(data, "BANK_DEPO", 0), y_n_var(data, "BANK_LOAN",0)) # 예금액과 대출액 비교
DEPO_LOAN_DIFF <- data$BANK_LOAN - data$BANK_DEPO
DEPO_LOAN_DIFF_fa <- ifelse(DEPO_LOAN_DIFF>0,0,1)
table(DEPO_LOAN_DIFF_fa)
comment("
대출액이 예금액보다 높은 경우는 없었음
무조건 예금액이 컸음
")

DEPO_LOAN_data <- data |>
  gather(DEPO_LOAN, values, -YEAR_MM) |> # long형태로 바꾸어 줌
  filter(DEPO_LOAN %in% c('BANK_DEPO', 'BANK_LOAN')) # DEPO_LOAN열에서 BANK_DEPO와 BANK_LOAN만 추출
comment("
gather(data, key, value, -var1, -var2)
data = 데이터
key = long형태로 나열하게될 열명
value = key변수에 대한 값을 받는 열명
-var1/-var2 = 고려하지 않는 변수
")

DEPO_LOAN_data |> # 데이터 프레임
  ggplot() + # ggplot설정
  geom_line(aes(YEAR_MM, values, col=DEPO_LOAN), lwd = 2) + # x축: YEAR_MM, y축: values, 색구분: DEPO_LOAN(BANK_DEPO + BANK_LOAN)
  theme_classic() + # grid설정
  theme(legend.position = "bottom", legend.title = element_blank()) # 범례위치/범례title삭제
comment("
실행하면 예금액/대출액의 선이 다른 색으로 생기고
범례도 그에 맞는 색으로 보여줌

theme에 대해 자세히 설명되어 있음
https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=coder1252&logNo=221014092166
")

## 고용률과 아파트매매지수 상관계수 비교
cor(x_n_var(data, "EMPL_RAT", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: -0.2030842
x_y_plot(data, x_n_var(data, "EMPL_RAT", 0), y_n_var(data, "APT_TRDE_IDEX",0))
comment("
고용률은 변동폭의 상승과 하락의 주기가 너무 짧음
주기가 짧은 열들을 어떻게 처리해야할지 고민 해봐야 할듯!!!
")

for(i in 0:30){ # n개월 변동 상관계수
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "EMPL_RAT", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
0~30개월 까지 상관계수들이 -0.1~-0.3으로 높지는 않음
")

data |>
  plot_ly() |>
  add_boxplot(y = ~ EMPL_RAT)
EMPL_RAT_vector <- data$EMPL_RAT
EMPL_RAT_vector_sort <- sort(EMPL_RAT_vector)
comment("
고용률 데이터를 범주로 바꾸기 위한 기준점 찾기
")
example("quantile")
fdata <- data # 범주형으로 바뀌기 위한 df 복사
quantile(fdata$EMPL_RAT,probs = c(0.2, 0.5))
fdata$EMPL_RAT <- as.factor(ifelse(fdata$EMPL_RAT < 59, 0, # 범주형 변경
                                   ifelse(fdata$EMPL_RAT < 60.5, 1, 2)))
xfa_y_plot(fdata, x_n_var(fdata,"EMPL_RAT", 0), y_n_var(fdata,"APT_TRDE_IDEX", 0))
EMPL_RAT_fa.aov <- aov(APT_TRDE_IDEX ~ EMPL_RAT, data = fdata)
summary(EMPL_RAT_fa.aov)
comment("
고용률과 아파트매매지수는 비례관계로 예상을 했지만 개월 변동을 해도 관계성을 찾을 수 없음
기간을 길게하면 관계성을 찾을 수 있을까 싶어 all_data를 이용용
")

all_fdata <- all_data[47:277,] # 범주형으로 바뀌기 위한 df 복사 (03년 11월 ~ 23년 1월)
quantile(all_fdata$EMPL_RAT, na.rm = T)
all_fdata$EMPL_RAT <- ifelse(all_fdata$EMPL_RAT < 59.5, 0, # 범주형 변경
                                       ifelse(all_fdata$EMPL_RAT < 60.5, 1, 2))
all_EMPL_RAT_fa.aov <- aov(APT_TRDE_IDEX ~ EMPL_RAT, data = all_fdata)
summary(all_EMPL_RAT_fa.aov)
comment("
p값이 5.77e-05로 99.9%에서 유의 하다고 나옴
")

for(i in 0:30){ # n개월 변동 상관계수
  cat(i, "개월의 상관계수는", cor(x_n_var(all_fdata, "EMPL_RAT", i), y_n_var(all_fdata, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
9개월 변동에서 -0.3234345로 가장 높음
고용률과 아파트매매지수는 비례관계일거라고 예상 했지만 반비례가 나옴
")

## 실업률과 아파트매매지수 상관계수 비교
cor(x_n_var(data, "UN_EMPL_RAT", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: 0.03705117
x_y_plot(data, x_n_var(data, "UN_EMPL_RAT", 0), y_n_var(data, "APT_TRDE_IDEX",0))
comment("
고용률은 변동폭의 상승과 하락의 주기가 너무 짧음
주기가 짧은 열들을 어떻게 처리해야할지 고민 해봐야 할듯!!!
")

for(i in 0:30){ # n개월 변동 상관계수
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "EMPL_RAT", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
comment("
0~30개월 까지 상관계수들이 -0.1~-0.3으로 높지는 않음
실업률도 범주형으로 고쳐서 예측을 진행해 보자
")

# 고용률과 실업률의 관계
cor(x_n_var(data, "EMPL_RAT", 0), y_n_var(data, "UN_EMPL_RAT",0)) # 상관계수: -0.6353074
x_y_plot(data, x_n_var(data, "EMPL_RAT", 0), y_n_var(data, "UN_EMPL_RAT",0))
comment("
예상대로 시각화를 보면 고용률이 올라가면 실업률이 떨어지고 고용율이 내려가면 실업률이 올라감
")

for(i in 0:30){ # n개월 변동 상관계수
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "EMPL_RAT", i), y_n_var(data, "UN_EMPL_RAT", i)),"입니다.", sep = "", end="\n")
}
comment("
변동 없을 때 -0.6353074으로 상관계수가 가장 큼
")

## 주택거래현황과 아파트매매지수 상관계수 비교
cor(x_n_var(data, "HOUSE_COUNT", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: -0.04225507
x_y_plot(data, x_n_var(data, "HOUSE_COUNT", 0), y_n_var(data, "APT_TRDE_IDEX",0))
comment("
거래현황도 변동폭의 주기가 심함...
박스플롯을 확인하여 범주형 기준점을 정해보자
")

data |>
  plot_ly() |>
  add_boxplot(y = ~ HOUSE_COUNT)
HOUSE_COUNT_vector <- data$HOUSE_COUNT
HOUSE_COUNT_vector_sort <- sort(HOUSE_COUNT_vector)
quantile(HOUSE_COUNT_vector) # 0/25/50/75/100%의 값 확인
comment("
최소값: 4982
제1사분위수: 11568
제2사분위수: 16968
제3사분위수: 23128
최대값: 37221
")

fa_HOUSE_COUNT_data <- data
fa_HOUSE_COUNT_data$HOUSE_COUNT <- ifelse(fa_HOUSE_COUNT_data$HOUSE_COUNT < 11568, 0, 
                                          ifelse(fa_HOUSE_COUNT_data$HOUSE_COUNT <= 23128, 1, 2)) # 상관계수를 구해보아야 해서 as.factor은 안함!!
cor(x_n_var(fa_HOUSE_COUNT_data, "HOUSE_COUNT", 0), y_n_var(fa_HOUSE_COUNT_data, "APT_TRDE_IDEX",0)) # 상관계수: -0.0338125
fa_HOUSE_COUNT_data$HOUSE_COUNT <- as.factor(fa_HOUSE_COUNT_data$HOUSE_COUNT)
x_y_plot(fa_HOUSE_COUNT_data, x_n_var(fa_HOUSE_COUNT_data, "HOUSE_COUNT", 0), y_n_var(fa_HOUSE_COUNT_data, "APT_TRDE_IDEX",0))
aggregate(APT_TRDE_IDEX ~ HOUSE_COUNT, data = fa_HOUSE_COUNT_data, 
          function(x) c(n = length(x), mean = mean(x), median = median(x), sd = sd(x), mad = mad(x)))
fa_HOUSE_COUNT.aov <- aov(APT_TRDE_IDEX ~ HOUSE_COUNT, data = fa_HOUSE_COUNT_data)
anova(fa_HOUSE_COUNT.aov)
summary(fa_HOUSE_COUNT.aov)
comment("
p값이 너무 높게 나와 기준의 변동이 필요해보임
")

ch_fa_HOUSE_COUNT_data <- data
ch_fa_HOUSE_COUNT_data$HOUSE_COUNT <- ifelse(ch_fa_HOUSE_COUNT_data$HOUSE_COUNT < 14000, 0, # 11568 => 13000 임의로 변경
                                          ifelse(ch_fa_HOUSE_COUNT_data$HOUSE_COUNT < 17000, 1, 2)) # 23128 => 17000 임의로 변경
cor(x_n_var(ch_fa_HOUSE_COUNT_data, "HOUSE_COUNT", 0), y_n_var(ch_fa_HOUSE_COUNT_data, "APT_TRDE_IDEX",0)) # 상관계수: -0.1965399
ch_fa_HOUSE_COUNT_data$HOUSE_COUNT <- as.factor(ch_fa_HOUSE_COUNT_data$HOUSE_COUNT)
xfa_y_plot(ch_fa_HOUSE_COUNT_data, x_n_var(ch_fa_HOUSE_COUNT_data, "HOUSE_COUNT", 0), y_n_var(ch_fa_HOUSE_COUNT_data, "APT_TRDE_IDEX",0))
ch_fa_HOUSE_COUNT.aov <- aov(APT_TRDE_IDEX ~ HOUSE_COUNT, data = ch_fa_HOUSE_COUNT_data)
summary(ch_fa_HOUSE_COUNT.aov)
comment("
p값을 줄이기 위해 계속 기준값 변경을 시도한 결과 0.03까지 낮추어 봄
")

cbind(data$HOUSE_COUNT, fa_HOUSE_COUNT_data$HOUSE_COUNT, ch_fa_HOUSE_COUNT_data$HOUSE_COUNT)
comment("
기준값 변경에 따라 범주형 비교 결과를 한눈에 보기 위해
")

## 아파트거래현황과 아파트매매지수 상관계수 비교
cor(x_n_var(data, "APT_COUNT", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: -0.09391063
x_y_plot(data, x_n_var(data, "APT_COUNT", 0), y_n_var(data, "APT_TRDE_IDEX",0))
comment("
거래현황 데이터들은 모두 변동폭 주기가 짧아
주택거래 현황과 같이 범주형 기준을 확실하게 잡아서
분석을 진행해봐야 될 것으로 예상
")

quantile(data$APT_COUNT)
comment("
최소값: 1773
Q1: 6128
중앙값: 9770
Q3: 13648
최대값: 24038
")

fa_APT_COUNT_data <- data
fa_APT_COUNT_data$APT_COUNT <- ifelse(fa_APT_COUNT_data$APT_COUNT < 5000, 0, 
                                          ifelse(fa_APT_COUNT_data$APT_COUNT < 12000, 1, 2)) # 상관계수를 구해보아야 해서 as.factor은 안함!!
cor(x_n_var(fa_APT_COUNT_data, "APT_COUNT", 0), y_n_var(fa_APT_COUNT_data, "APT_TRDE_IDEX",0)) # 상관계수: -0.08924593
fa_APT_COUNT_data$APT_COUNT <- as.factor(fa_APT_COUNT_data$APT_COUNT)
xfa_y_plot(fa_APT_COUNT_data, x_n_var(fa_APT_COUNT_data, "APT_COUNT", 0), y_n_var(fa_APT_COUNT_data, "APT_TRDE_IDEX",0))
aggregate(APT_TRDE_IDEX ~ APT_COUNT, data = fa_APT_COUNT_data, 
          function(x) c(n = length(x), mean = mean(x), median = median(x), sd = sd(x), mad = mad(x)))
fa_APT_COUNT.aov <- aov(APT_TRDE_IDEX ~ APT_COUNT, data = fa_APT_COUNT_data)
anova(fa_APT_COUNT.aov)
summary(fa_APT_COUNT.aov)
comment("
0.06으로 95%신뢰구간에서 유의함
")

## 주택매매거래현황과 아파트매매지수 상관계수 비교
cor(x_n_var(data, "HOUSE_TRDE_COUNT", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: -0.1791072
x_y_plot(data, x_n_var(data, "HOUSE_TRDE_COUNT", 0), y_n_var(data, "APT_TRDE_IDEX",0))
comment("
거래현황 데이터들은 모두 변동폭 주기가 짧아
주택거래 현황과 같이 범주형 기준을 확실하게 잡아서
분석을 진행해봐야 될 것으로 예상
")

quantile(data$HOUSE_TRDE_COUNT)
comment("
최소값: 2451
Q1: 9220
중앙값: 11721
Q3: 16190
최대값: 26662
")

fa_HOUSE_TRDE_COUNT_data <- data
fa_HOUSE_TRDE_COUNT_data$HOUSE_TRDE_COUNT <- ifelse(fa_HOUSE_TRDE_COUNT_data$HOUSE_TRDE_COUNT < 7100, 0, 
                                      ifelse(fa_HOUSE_TRDE_COUNT_data$HOUSE_TRDE_COUNT <= 17000, 1, 2)) # 상관계수를 구해보아야 해서 as.factor은 안함!!

cor(x_n_var(fa_HOUSE_TRDE_COUNT_data, "HOUSE_TRDE_COUNT", 0), y_n_var(fa_HOUSE_TRDE_COUNT_data, "APT_TRDE_IDEX",0)) # 상관계수: -0.2318826

fa_HOUSE_TRDE_COUNT_data$HOUSE_TRDE_COUNT <- as.factor(fa_HOUSE_TRDE_COUNT_data$HOUSE_TRDE_COUNT)
xfa_y_plot(fa_HOUSE_TRDE_COUNT_data, x_n_var(fa_HOUSE_TRDE_COUNT_data, "HOUSE_TRDE_COUNT", 0), y_n_var(fa_HOUSE_TRDE_COUNT_data, "APT_TRDE_IDEX",0))

aggregate(APT_TRDE_IDEX ~ HOUSE_TRDE_COUNT, data = fa_HOUSE_TRDE_COUNT_data, 
          function(x) c(n = length(x), mean = mean(x), median = median(x), sd = sd(x), mad = mad(x)))

fa_HOUSE_TRDE_COUNT.aov <- aov(APT_TRDE_IDEX ~ HOUSE_TRDE_COUNT, data = fa_HOUSE_TRDE_COUNT_data)
anova(fa_HOUSE_TRDE_COUNT.aov)
summary(fa_HOUSE_TRDE_COUNT.aov)
comment("
0.01로 95%신뢰구간에서 유의함
")

## 아파트매매거래현황과 아파트매매지수 상관계수 비교
cor(x_n_var(data, "APT_TRDE_COUNT", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: -0.3149426
x_y_plot(data, x_n_var(data, "APT_TRDE_COUNT", 0), y_n_var(data, "APT_TRDE_IDEX",0))
comment("
주택거래 현황과 같이 범주형 기준을 확실하게 잡아서
분석을 진행해봐야 될 것으로 예상
")

quantile(data$APT_TRDE_COUNT)
comment("
최소값: 761
Q1: 3942
중앙값: 6079
Q3: 9357
최대값: 16002
")

fa_APT_TRDE_COUNT_data <- data
fa_APT_TRDE_COUNT_data$APT_TRDE_COUNT <- ifelse(fa_APT_TRDE_COUNT_data$APT_TRDE_COUNT < 3942, 0, 
                                                    ifelse(fa_APT_TRDE_COUNT_data$APT_TRDE_COUNT <= 9357, 1, 2)) # 상관계수를 구해보아야 해서 as.factor은 안함!!

cor(x_n_var(fa_APT_TRDE_COUNT_data, "APT_TRDE_COUNT", 0), y_n_var(fa_APT_TRDE_COUNT_data, "APT_TRDE_IDEX",0)) # 상관계수: -0.29215

fa_APT_TRDE_COUNT_data$APT_TRDE_COUNT <- as.factor(fa_APT_TRDE_COUNT_data$APT_TRDE_COUNT)
xfa_y_plot(fa_APT_TRDE_COUNT_data, x_n_var(fa_APT_TRDE_COUNT_data, "APT_TRDE_COUNT", 0), y_n_var(fa_APT_TRDE_COUNT_data, "APT_TRDE_IDEX",0))

aggregate(APT_TRDE_IDEX ~ APT_TRDE_COUNT, data = fa_APT_TRDE_COUNT_data, 
          function(x) c(n = length(x), mean = mean(x), median = median(x), sd = sd(x), mad = mad(x)))

fa_APT_TRDE_COUNT.aov <- aov(APT_TRDE_IDEX ~ APT_TRDE_COUNT, data = fa_APT_TRDE_COUNT_data)
anova(fa_APT_TRDE_COUNT.aov)
summary(fa_APT_TRDE_COUNT.aov)
comment("
0.0001로 99.9% 신뢰구간에서 유의함
")

## 미분양거래현황과 아파트매매지수 상관계수 비교
cor(x_n_var(data, "UN_SOLD_COUNT", 0), y_n_var(data, "APT_TRDE_IDEX",0)) # 상관계수: -0.6967192
x_y_plot(data, x_n_var(data, "UN_SOLD_COUNT", 0), y_n_var(data, "APT_TRDE_IDEX",0))
comment("
-0.6967192로 높은 반비례관계가 나옴
")

for(i in 0:30){ # n개월 변동 상관계수
  cat(i, "개월의 상관계수는", cor(x_n_var(data, "UN_SOLD_COUNT", i), y_n_var(data, "APT_TRDE_IDEX", i)),"입니다.", sep = "", end="\n")
}
x_y_plot(data, x_n_var(data, "UN_SOLD_COUNT", 21), y_n_var(data, "APT_TRDE_IDEX", 21))
comment("
시각화를 21개월 변동해서 보았지만 머...왜 상관계수가 0.8159813으로 높게 나오는지 이해가 안 됨
그래고 개월수도 너무 길고 미분양아파트가 나오면 1~3개월 사이로 반영 될 거 처럼 보임
")

## 미분양거래현황과 아파트실거래가지수 상관계수 비교
cor(x_n_var(data, "UN_SOLD_COUNT", 0), y_n_var(data, "APT_MONY_IDEX",0)) # 상관계수: -0.6049905
x_y_plot(data, x_n_var(data, "UN_SOLD_COUNT", 0), y_n_var(data, "APT_MONY_IDEX",0))
comment("
예측을 진행시 실거래가를 종속변수로 두고 분석을 할 때
어떤관계가 보일지 궁금해서 코드를 인용함

하지만, 아파트실거래가지수와 아파트매매지수의 관계는 거의 비슷해서 종속변수를 변경해도 좋을지는 분석 진행 후 알아보자

상관계수도 아파트매매지수와 비교 할 때 보다 -0.6049905으로 더 작아짐
")

# 회귀분석
comment("
기준금리 : 2개월부터 16개월 까지
주택담보대출연리 : 반영되는 기간이 너무 길어 아예 빼고 예측하는 것도 하나의 방법
 * 전체로 했을 때 변수선택법으로 선택되는지 지켜보기
소비심리지수들 : 범주형으로 바꾸고 월변동은 없음으로 하고 예측진행 => 경우에 따라 3개월 까지는 해보자
소비자물가지수 : 전체 데이터 중에 경향을 파악하기는 쉬우나 이것이 아파트매매지수와의 관련성 찾기는 어려움
실거래가지수들 : 0~1개월 변동
경제심리지수 : 아파트매매지수와는 별 상관이 없어 보이고 경제적 사건들이 경제심리지수에 많은 영향을 미침
예금액/대출액 : 소비자물가지수처럼 오르는 경향만 보이고 하락 구간을 찾기 어려움...
고용률/실업률 : 범주형으로 교체
거래현황들 : 범주형으로 교체
미분양 : 0~9개월 까지는 변동해서 예측해보자
")

## 데이터 복사
fdata <- data

## 구조확인
str(fdata)

## 소비심리지수들 범주형 변경
comment("
95미만: 하강, 95이상 115미만: 보합, 115이상: 상승
")
fdata$REAL_CNSMP_TRL_IDEX <- as.factor(ifelse(fdata$REAL_CNSMP_TRL_IDEX < 95, 0, ifelse(fdata$REAL_CNSMP_TRL_IDEX < 115, 1, 2))) # 부동산
fdata$HOUSE_CNSMP_TRL_IDEX <- as.factor(ifelse(fdata$HOUSE_CNSMP_TRL_IDEX < 95, 0, ifelse(fdata$HOUSE_CNSMP_TRL_IDEX < 115, 1, 2))) # 주택
fdata$TRDE_CNSMP_TRL_IDEX <- as.factor(ifelse(fdata$TRDE_CNSMP_TRL_IDEX < 95, 0, ifelse(fdata$TRDE_CNSMP_TRL_IDEX < 115, 1, 2))) # 주택매매
fdata$SECU_CNSMP_TRL_IDEX <- as.factor(ifelse(fdata$SECU_CNSMP_TRL_IDEX < 95, 0, ifelse(fdata$SECU_CNSMP_TRL_IDEX < 115, 1, 2))) # 주택전세

## 거래현황들 범주형 변경
comment("
각 거래현황들 마다 기준을 다르게 둠
")
fdata$HOUSE_COUNT <- as.factor(ifelse(fdata$HOUSE_COUNT < 14000, 0, # 주택
                                      ifelse(fdata$HOUSE_COUNT < 17000, 1, 2)))
fdata$APT_COUNT <- as.factor(ifelse(fdata$APT_COUNT < 5000, 0,  # 아파트
                                    ifelse(fdata$APT_COUNT < 12000, 1, 2)))
fdata$HOUSE_TRDE_COUNT <- as.factor(ifelse(fdata$HOUSE_TRDE_COUNT < 7100, 0, # 주택매매
                                           ifelse(fdata$HOUSE_TRDE_COUNT <= 17000, 1, 2)))
fdata$APT_TRDE_COUNT <- as.factor(ifelse(fdata$APT_TRDE_COUNT < 3942, 0, # 아파트매매
                                         ifelse(fdata$APT_TRDE_COUNT <= 9357, 1, 2)))

## 유의성 확인
fdata.aov <- aov(APT_TRDE_IDEX ~ APT_TRDE_COUNT, data = fdata)
summary(fdata.aov)

## 변경 잘 되었는지 구조확인
str(fdata)

## 전체 변수로 회귀분석
x_formula <- formula_mk(fdata)[[1]] # 상수 formula 생성
y_formula <- formula_mk(fdata)[[2]] # 전체 formula 생성

fdata_train <- tra_tes_split(fdata)[[1]] # train데이터
fdata_test <- tra_tes_split(fdata)[[2]] # test데이터

fdata.lm <- lm(formula = y_formula, data = fdata_train)
summary(fdata.lm)
fdata_pred <- predict(fdata.lm, newdata = fdata_test)
mse(fdata_test, fdata_pred)
pred_tru(fdata_test, fdata_pred, "전체변수 사용 예측")

## 
summary(model_return(fdata))


View(n_change_data(fdata, c(2,0,3,3,3,3,0,1,1,0,0,0,0,0,0,0,0,0,0,0)))
View(fdata)
length(c(2,0,3,3,3,3,0,1,1,0,0,0,0,0,0,0,0,0,0,0))




























