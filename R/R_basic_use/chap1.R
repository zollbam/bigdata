rm(list = ls())

# readline
comment("
readline은 콘솔에서 사용자로부터 입력을 받기 위한 함수        
")
myclass <- readline("What is your favorite class?? ")
paste("My favorite class is", myclass)

# 회귀식 모델로 회귀선 그리기
urban.pop <- c(50,47,69,47,47,57,72,42,51,40) # 도시인구비율
life.exp <- c(67,72,77,65,74,75,76,59,72,60) # 기대수명
life.lm <- lm(life.exp ~ urban.pop) # 회귀모델
plot(urban.pop, life.exp, col = "blue", pch = 19, # 산점도 그래프, 점 색: 파란색, 점모양: 19
     main = "Urban Population Percent vs. Life Expectancy", # title 제목
     xlab = "Urban Population Percent (%)", # x축 라벨
     ylab = "Life Expectancy (age)") # y축 라벨
abline(life.lm, col = "red")

# getwd, setwd
comment("
getwd: 현재의 작업 디렉토리 위치를 알기 위해서 사용하는 함수
setwd: 현재의 작업 디렉토리 위치를 변경시켜주는 함수
")
getwd()
setwd("D:/zoolbam_code/java")
getwd()
setwd("C:/Users/HOME/Documents")
getwd()

# save, save.image, load
comment("
save: 개별 변수를 파일로 저장할 수 있음
save.image: 현재까지 작업한 내용이 .RData 파일에 저장
 - .RData파일은 C:/Users/HOME/Documents에 저장되어 있음
 - 이 폴더에는 .Rhistory파일도 저장되어 있음
load: rda나 RData의 파일을 불러와 작업공간으로 불러들임
")
animal <- c("rabbit", "tiger", "lion")
save(animal, file="animal.rda") # animal변수만 저장
save.image() # 작업공간을 .RData파일에 저장
load("C:/Users/HOME/Documents/animal.rda") # 저장된 animal 변수만 불러옴
load("C:/Users/HOME/Documents/.RData") # 저장된 모든 변수나 함수를 불러옴

# ls, ls.str
comment("
ls: 작업공간에 생성된 변수와 함수의 리스트를 볼 때 쓰는 함수
ls.str: 각 변수 또는 함수의 이름뿐만 아니라 각 객체의 구조을 알 수 있음
")
ls() # 현재까지의 변수나 함수를 보여줌
x <- 100
y <- c(2,3,5,7)
hero <- c("Superman", "Batman", "Spiderman")
f <- function(y) (y - 32)/1.8 # 한줄함수
ls.str()

# history
comment("
history: 실행했던 명령어 라인을 보여줌
 - 기본적으로는 25개를 보여줌
 - 인수를 숫자로 지정하면 해당 숫자만큼 명령어 라인을 보여줌
 - Inf를 인수로 정하면 모든 명령어 라인을 볼 수 있음
실행되었던 명령어들은 .Rhistory파일에 저장됨
")
history()
history(10)
history(Inf)

# .Last.value
comment("
.Last.value: 바로직전의 실행결과를 저장 시킬 수 있는 함수
 - if, 오래걸려서 나온 결과가 변수에 저장되어 있지 않는다면?? 이 함수를 사용하면 됨
")
f(100) # 까먹고 변수에 저장하는 것을 하지 못 함
z <- .Last.value # .Last.value을 이용해 변수에 저장 시킴
z # f(100)의 결과가 z변수에 저장됨

# installed.packages
comment("
installed.packages: 설치된 패키지에 대한 좀 더 자세한 정보를 볼 수 있음
")
installed.packages() # df형태
installed.packages()[,c("Package", "Version")] # 해당 열의 정보만 볼 수 있음

# search
comment("
search: 메모리에 적재된 패키지 리스트를 보여줌
")
search()

# xyplot
comment("
xyplot: 산점도 그려줌
 - lattice패키지 내에 있는 함수
")
library(lattice)
xyplot(data = cars, dist ~ speed) # x: speed, y: dist

# .libPaths
comment("
.libPaths: 패키지가 설치된 경로를 확인
 - 새로운 경로 지정도 가능
")
.libPaths()

# data
comment("
data: 패키지안의 데이터 셋을 불러옴
")
data(package = "MASS") # MASS패키지의 모든 데이터셋을 불러옴
data(Animals, package = "MASS") # MASS패키지의 Animals셋만 불러옴

# args
comment("
args: 함수의 인수에 대해 간단히 보고 싶을 때
")
args(plot)
args(f)
args(mean)
args(median)
args(sd)

# example
comment("
example: 해당 함수의 예제 코드 보고 싶을 때
")
example(median)
example(sd)
example(sqrt)
example("Titanic") # Titanic데이터셋에 대한 간단한 분석 예제를 볼 수 있음
example("cars") # cars데이터셋에 대한 간단한 분석 예제를 볼 수 있음

# apropos
comment("
apropos: 생성했던 변수의 이름이나 사용하려는 함수 이름의 일부만을 이용하여 검색
 - 변수나 함수를 사용하는 정확한 이름이 기억나지 않을 때 유용!!!
")
apropos("vector")
apropos("q$") # q로 끝나는
apropos("[7-9]") # 7과 9사이를 포함하는 
apropos("xy+") # xy를 포함하는

# demo
comment("
demo: 여러 예를 볼 수 있음
")
demo(graphics)

# fortunes
comment("
fortunes: R과 관련된 재미있고 때로는 유익한 문구나 코멘트가 담겨져 있음
 - 해당 번호에 맞는 문구나 코멘트를 보여줌
")
install.packages("fortunes")
library(fortunes)
fortune(1)
fortune(5)
fortune() # 랜덤
