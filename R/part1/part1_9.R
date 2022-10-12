rm(list=ls())

comment('ggplot이라는 패키지가 없을 때 ?ggplot을 하면 아무것도 찾을 수 없다고 뜬다. 하지만 ??ggplot을 하면 더 자세한 정보를 찾아볼수 있어서 ??는 패키지가 설치 되어 있지 않아도 사용할 수 있다고 알아두자!!!')

# R 파트1 9.탐색적 데이터 분석.pdf
# MASS패키지
# survey데이터셋
# 설문조사한 데이터
library(MASS)
data('survey') # 데이터셋을 불러옴
df<-survey
View(df)
str(df)

df_no <- na.omit(df) # NA행 모두 삭제(237행에서 168행이 됨)
str(df_no)
dim(df_no)

df_cc <- df[complete.cases(df),] # NA행 모두 삭제(237행에서 168행이 됨)
str(df_cc)
dim(df_cc)
comment('complete.cases나 na.omit는 동일한 결과가 나옴
        방법은 본인이 편한걸로')

# na값이 있는 데이터로 분석
# 키로 히스토그램 그리시
hist(df$Height,breaks=20) # 남여 전체
hist(df[df$Sex=='Male',]$Height,breaks=20) # 남자만
hist(df[df$Sex=='Female',]$Height,breaks=20) # 여자만

# 키 평균
mean(df[df$Sex=='Male',]$Height)
mean(df[df$Sex=='Female',]$Height)
comment('NA값이 있으므로 NA가 나옴')

aggregate(df[,c(10,12)],by=list(gender=df$Sex),FUN=mean)
comment('10열은 Height, 12열은 Age인데 Height에는 NA가 포함되어 있어서 NA값이 나옴')

# t.test(): t테스트
t.test(Height~Sex,data=df)
comment('Height는 종속, Sex는 독립')

# 박스플롯 그리기
table(df$Sex)
comment('df의 총 행은 237행인데 118*2=336임
        찾아보니 NA가 1개 있어서 useNA옵션을 추가해봄')
table(df$Sex,useNA='always')

boxplot(Height~Sex,data=df,col=c('red','blue'))
boxplot.stats(df[df$Sex=='Female','Height'])$out # 이상치

# na값이 없는 데이터로 분석
# 키로 히스토그램 그리시
hist(df_no$Height,breaks=20) # 남여 전체
hist(df_no[df_no$Sex=='Male',]$Height,breaks=20) # 남자만
hist(df_no[df_no$Sex=='Female',]$Height,breaks=20) # 여자만

# 키 평균
mean(df_no[df_no$Sex=='Male',]$Height)
mean(df_no[df_no$Sex=='Female',]$Height)
comment('NA값이 없으므로 이번에는 평균이 제대로 나옴')

aggregate(df_no[,c(10,12)],by=list(gender=df_no$Sex),FUN=mean)
comment('10열은 Height, 12열은 Age')

# t.test(): t테스트
t.test(Height~Sex,data=df_no)
comment('Height는 종속, Sex는 독립')

# 박스플롯 그리기
table(df_no$Sex)
table(df_no$Sex,useNA='ifany')
table(df_no$Sex,useNA='always')

boxplot(Height~Sex,data=df_no,col=c('red','blue'))
comment('NA가 없는 데이터에서는 남성에서 이상치가 발견')
boxplot.stats(df_no[df_no$Sex=='Male','Height'])$out # 이상치

# sample()
sample(1:10,size=5)
comment('1~10중 5개를 추출
        replace=옵션으로 T이면 중복뽑기 가능
        F이면 중복뽑기 불가능')

# 백만번 시도해서 7이 나온 개수 구하는 함수
# 단, 1번에 5개 뽑을 때 비복원으로 뽑음 => 1번 시도할때 같은 값이 나올수 없음
one_ten_sam_dux <- function(){
  s<-0
  for(i in 1:1000000){
    x<-sample(1:10,size=5)
    s<-s+sum(x==7)
    comment('x안에 5개의 수가 있는데 7이면 T, 아니면 F를 반환
            i가 시도하면서 7이 나올 때 마다 계속 s에 대해줌
            7이 2번나오면 s에 2를 더하고
            7이 안나오면 s에 0을 더해주는 기능')
  }
  s
}
one_ten_sam_dux()

# 백만번 시도해서 7이 나온 개수 구하는 함수
# 단, 1번에 5개 뽑을 때 복원으로 뽑음 => 1번 시도할때 같은 값이 나올수 있음
one_ten_sam_duo <- function(){
  s<-0
  for(i in 1:1000000){
    x<-sample(1:10,size=5,replace = T)
    s<-s+sum(x==7)
  }
  s
}
one_ten_sam_duo()

# iris데이터 랜덤추출
idx <- sample(1:nrow(iris),size=50)
iris[idx,]

# set.seed()
set.seed(2022)
sample(1:10,size=78,replace=T)
# sample(1:10,size=78,replace=F) 비복원인데 size가 78이니까 10번 뽑으면 더이상 뽑을 수 없으므로 오류가 나옴
sample(1:10,size=3,replace=F)

# 펭귄데이터셋
library(palmerpenguins)

data(package='palmerpenguins')
commen('palmerpenguins패키지 안의 데이터셋의 설명을 보여줌')

data('penguins')
comment('데이터셋 쓸수 있음')

pg <- data.frame(penguins)
str(pg)
summary(pg)
comment('데이터셋의 구조나 형태 등을 살펴봄')

aggr(pg,numbers=T,prop=F,sortVar=T)
comment('결측치가 어디 열에 있는지 그래프로 확인')

# na행을 다 삭제
pg_nax <- na.omit(pg)
dim(pg_nax)
str(pg_nax)
aggr(pg_nax,numbers=T,prop=F,sortVar=T)
comment('NA값이 삭제되었는지 확인')

# 펭귄 종의 대한 막대 그래프
table(pg_nax$species,useNA='always')
barplot(table(pg_nax$species,useNA='always'))
barplot(table(pg_nax$species),col=c('black','skyblue','orange'))

# 펭귄이 사는 섬에 대한 막대 그래프
table(pg_nax$island)
barplot(table(pg_nax$island),col=c('pink','steelblue','black'))

# 펭귄이 성별에 대한 막대 그래프
table(pg_nax$sex)
barplot(table(pg_nax$sex),col=c('red','blue'))

# 하나의 plot창에 그래프 그려보기
par(mfrow=c(1,3))
barplot(table(pg_nax$species),col=c('black','skyblue','orange'))
barplot(table(pg_nax$island),col=c('pink','steelblue','black'))
barplot(table(pg_nax$sex),col=c('red','blue'))

# 각 범주형 데이터의 비율을 표로 만들어보자(na가 있음)
# 나누기로 하는 방법
table(pg$species)/length(pg$species)
table(pg$island)/length(pg$island)
table(pg$sex)/length(pg$sex)

# prop.table()함수 이용
prop.table(table(pg$species))
prop.table(table(pg$island))
prop.table(table(pg$sex))

# tapply()로 만들기
tapply(pg_nax$sex,
       INDEX=list(pg_nax$island),
       FUN=function(n) {n/nrow(pg_nax)})

# 각 범주형 데이터의 비율을 표로 만들어보자(na가 없음)
table(pg_nax$species)/length(pg_nax$species)
table(pg_nax$island)/length(pg_nax$island)
table(pg_nax$sex)/length(pg_nax$sex)
str(pg)

# 교차표만들기
library(gmodels)
table(pg[,c(1,2)])
table(pg_nax[,c(1,2)])
comment('열이름이 나오지만')

table(pg$species,pg$island)
comment('이때는 열이름이 나오지 않음')
comment('2개 열에 대한 교차표를 만들어봄')

CrossTable(pg$species,pg$island,
           prop.t=F,prop.r=F,prop.c=F,prop.chisq=F)
CrossTable(pg_nax$species,pg_nax$island,
           prop.t=F,prop.r=F,prop.c=F,prop.chisq=F)
comment('table()로 쓰는거 보다 더 이쁘게 만들수 있지만 F로 설정해야할 옵션이 너무 많아서 불편함')

table(pg[,c(1,2,7)])
comment('1열은 종, 2열은 섬, 7열은 성별로
        종과 섬에 대한 교차표를 보여주지만 성별이라는 큰틀에서 나누어서 보여줌
        즉, 수컷 펭귄의 종과 섬의 교차표, 암컷 펭귄의 종과 섬의 교차표로 2개의 교차표를 보여줌')

table(pg[,c(1,7,2)])
comment('각 섬마다 종과 성별의 교차표를 봄')

# 3~6열은 수치형 데이터
str(pg_nax[,3:6])
summary(pg_nax[,3:6])
comment('3열: bill_length_mm(부리길이)
        4열: bill_depth_mm(부리높이)
        5열: flipper_length_mm(날개길이)
        6열: body_mass_g(체중)')

# 수치형 데이터의 히스토그램 만들기
par(mfrow=c(2,2))
hist(pg$bill_length_mm,col='skyblue',breaks=13)
hist(pg$bill_depth_mm,col='steelblue',breaks=16)
hist(pg$flipper_length_mm,col='orange',breaks=12)
hist(pg$body_mass_g,col='tomato',breaks=18)

par(mfrow=c(1,1)) # 1행 1열로 그래프 보여줌 다시 원상복귀

# psych패키지의 decsribe()을 통해서 기술통계량을 산출
library(psych)
describe(pg)
comment('범주형인 종/섬/성별 등도 숫자형태로 보여짐
        가로로 볼수 있어서 보기 편함')

summary(pg)
comment('각 열마다 따로 볼 수 있을 때는 편함
        범주형도 각 값에 대한 개수를 알 수 있어서 범주형 볼때는 이 함수가 더 잘 되어 있음')

describe(pg_nax)
View(describe(pg_nax))
summary(pg_nax)

# 펭귄종류별 3~6열의 평균 구하기
aggregate(pg[,3],by=list(species=pg$species),FUN=mean)
comment('NA값이 포함되어 있어 평균값이 NA가 나옴
        NA를 빼고 계산하기위해 na.rm옵션을 쓰거나 처음부터 NA가 없는 데이터를 불러와서 분석해야 함')

aggregate(pg[,3],by=list(species=pg$species),FUN=mean,na.rm=T)
aggregate(pg[,4],by=list(species=pg$species),FUN=mean,na.rm=T)
aggregate(pg[,5],by=list(species=pg$species),FUN=mean,na.rm=T)

body_data<-subset(pg,select = 6)
aggregate(body_data,by=list(species=pg$species),FUN=mean,na.rm=T)
comment('subset으로 추출되어야지 aggregate에서 열이름이 나옴 subset으로 뽑지 않으면 x라고 값이 보임')

# 종별 부리높이의 대한 평균구하기
aggregate(pg_nax$bill_depth_mm,by=list(species=pg_nax$species),FUN=mean)
comment('종별 이름이 행이름으로 지정되어 세로로 종 이름이 보임')

tapply(pg_nax$bill_depth_mm,INDEX=list(species=pg_nax$species),FUN=mean)
comment('종별 이름이 열이름으로 지정되어 가로로 종 이름이 보임')

comment('위 2개의 평균결과는 동일하지만 가로로 보이는지 세로로 보이는지 그 차이임임')

# 각 열마다 결측치 개수 구하기
for (i in 1:length(pg)){
  cat(colnames(pg)[i],sum(is.na(pg[,i])),'\n')
}
comment('sum(is.na(pg$col))로 할때는 오류가 떠서 [,i]로 바꾸니 원하는 모양의 형태가 나옴')

# 결측치 그래프 그려보기
aggr(pg,numbers=T,prop=F,sortVar=T)
comment('pdf와 그래프 모양이 다름 왜그런지 확인 해보니
        number of missings의 그래프가 결측치가 많을수록 완쪽에 있는 것을 확인하고 sortVar옵션을 지워봄')

aggr(pg,numbers=T,prop=F)
comment('pdf와 동일한 그림이 나오는 것을 확인
        sortVar옵션을 사용하면 number of missings그래프도 내림차순으로 보여지는 것을 알게됨')

# NA를 삭제한 데프 만들기
sum(!complete.cases(pg)) # NA행은 총 11개
pg[!complete.cases(pg),] # NA가 있는 행만 추출
str(pg[!complete.cases(pg),])

pg_nax1<-pg[complete.cases(pg),]
dim(pg_nax1)
comment('11개 행이 삭제 된 것을 확인')

rm(pg_nax1)
comment('위에서 pg_nax를 만들었으므로 필요없어서 삭제')

# pg_nax로 수치형 데이터의 박스플롯 만들기
par(mfrow=c(1,4))
boxplot(pg_nax$bill_length_mm,col='yellow',border='black')
boxplot(pg_nax$bill_depth_mm,col='yellow',border='black')
boxplot(pg_nax$flipper_length_mm,col='yellow',border='black')
boxplot(pg_nax$body_mass_g,col='yellow',border='black')

# 펭귄종별로 박스플롯 그려보자
par(mfrow=c(2,2))
boxplot(pg_nax$bill_length_mm~pg_nax$species,col=c('pink','blue','green'),border='black',xlab='species',ylab='bill_length_mm')
boxplot(pg_nax$bill_depth_mm~pg_nax$species,col=c('pink','blue','green'),border='black',xlab='species',ylab='bill_depth_mm')
boxplot(pg_nax$flipper_length_mm~pg_nax$species,col=c('pink','blue','green'),border='black',xlab='species',ylab='flipper_length_mm')
boxplot(pg_nax$body_mass_g~pg_nax$species,col=c('pink','blue','green'),border='black',xlab='species',ylab='body_mass_g')

# 이상치 값 확인해보기
pg_out.3<-boxplot.stats(pg_nax[pg_nax$species=='Gentoo',3])$out
pg_out.4<-boxplot.stats(pg_nax[pg_nax$species=='Adelie',4])$out
pg_out.5<-boxplot.stats(pg_nax[pg_nax$species=='Adelie',5])$out
pg_out.6<-boxplot.stats(pg_nax[pg_nax$species=='Chinstrap',6])$out

# 이상치로 해당 행 찾아보기
View(pg_nax[pg_nax$bill_length_mm %in% pg_out.3,])
View(pg_nax[pg_nax$bill_depth_mm %in% pg_out.4,])
View(pg_nax[pg_nax$flipper_length_mm %in% pg_out.5,])
View(pg_nax[pg_nax$body_mass_g %in% pg_out.6,])
comment('View를 str/dim/class등 여러 함수를 써가면서 확인해보자!!!')

# order()함수를 이용하여 날개의 길이 기준으로 오름차순으로 정렬
flip_ord<-order(pg_nax$flipper_length_mm)
pg_nax[flip_ord,]

# 날개길이 기준으로 오름차순, 그 다음으로 체중으로 내림차순 정렬 하여보자
fi.or_bo.de<-order(pg_nax$flipper_length_mm,-pg_nax$body_mass_g)
fi.or_bo.de_df_nax<-pg_nax[fi.or_bo.de,]
rownames(fi.or_bo.de_df_nax) <- NULL # 행 번호 리셋
fi.or_bo.de_df_nax

# 행번호 리셋 다른 방법
fi.or_bo.de_df_nax<-pg_nax[fi.or_bo.de,]
View(fi.or_bo.de_df_nax)
rownames(fi.or_bo.de_df_nax)<-1:nrow(fi.or_bo.de_df_nax)
fi.or_bo.de_df_nax

# 부리가 가장 긴 10개의 데이터를 출력
bi.l_top10_or<-order(pg_nax$bill_length_mm,decreasing=T)
View(pg_nax[bi.l_top10_or[1:10],])

# split()을 이용한 pg_nax셋 종류별로 구분
pg_nax_sp<-split(pg_nax,pg_nax$species) # 리스트 형태
class(pg_nax_sp)
summary(pg_nax_sp)

View(pg_nax_sp$Adelie) # Adelie정보만 추출
View(pg_nax_sp$Chinstrap) # Chinstrap정보만 추출
View(pg_nax_sp$Gentoo) # Gentoo정보만 추출

# rbind()를 이용하여 분리된 리스트 합치기
# Adelie와 Gentoo 합치기
AG<-rbind(pg_nax_sp$Adelie,pg_nax_sp$Gentoo)
str(AG)
summary(AG)
class(AG)
levels(AG$species)
comment('levels값이 3개나 나온다. Chinstrap이라는 것은 안나오게 하고 싶음')

AG$species<-factor(AG$species)
str(AG)
summary(AG)
class(AG)
levels(AG$species)
comment('팩터형을 다시 지정해서 열에 저장시킴')

# 펭귄데이터셋에서 sample()함수를 이용하여 20개 데이터를 임의 추출
set.seed(2022)
df.origin<-data.frame(id=1:nrow(pg),species=pg$species, bill_length=pg$bill_length_mm,bill_depth=pg$bill_depth_mm)
idx<-sample(1:nrow(df.origin),size=20)
df.sample<-df.origin[idx,]
df.sample

# df.sample데프를 부리길이와 깊이를 따로 분리한후 10개 샘플링 후 merge()함수로 다시 합치기
pg.x<-df.sample[sample(1:nrow(df.sample),size=10),c(1,2,3)]
pg.x[order(pg.x$id),]
pg.y<-df.sample[sample(1:nrow(df.sample),size=10),c(1,2,4)]
pg.y[order(pg.y$id),]
merge(pg.x,pg.y,all=T)
?merge
# 2개 수치형 데이터의 상관조사
plot(pg$bill_length_mm,pg$bill_depth_mm,pch='*',col='black') #산점도
cor(pg$bill_length_mm,pg$bill_depth_mm) # 피어슨 상관계수

# 특정 조건에 맞는 색을 그래프에 칠해보기
my.color<-ifelse(pg$species=='Gentoo','tomato',ifelse(pg$species=='Adelie','steelblue','orange'))
comment('Gentoo=>tomato, Adelie=>steelblue, Chinstrap=>orange로 종별로 다른 색을 칠하기 위해 변수로 만듬
        길이는 행의 개수만큼 만들어져 있음')

plot(pg$bill_length_mm,pg$bill_depth_mm,pch='+',col=my.color)

# 상관계수(na가 있음)
cor(pg[pg$species=='Adelie',]$bill_length_mm,
    pg[pg$species=='Adelie',]$bill_depth_mm,use='complete.obs')

cor(pg[pg$species=='Gentoo',]$bill_length_mm,
    pg[pg$species=='Gentoo',]$bill_depth_mm,use='complete.obs')

cor(pg[pg$species=='Chinstrap',]$bill_length_mm,
    pg[pg$species=='Chinstrap',]$bill_depth_mm,use='complete.obs')

# 상관계수(na가 없음)
cor(pg_nax[pg_nax$species=='Adelie',]$bill_length_mm,
    pg_nax[pg_nax$species=='Adelie',]$bill_depth_mm)

cor(pg_nax[pg_nax$species=='Gentoo',]$bill_length_mm,
    pg_nax[pg_nax$species=='Gentoo',]$bill_depth_mm)

cor(pg_nax[pg_nax$species=='Chinstrap',]$bill_length_mm,
    pg_nax[pg_nax$species=='Chinstrap',]$bill_depth_mm)

