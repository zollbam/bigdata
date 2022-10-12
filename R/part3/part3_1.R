rm(list=ls())
colors()

# 클러드 섀넌 공식
comment('I(x)=-log2p(x)')

## 기본 개념
log(100) # 기본값은 e
exp(4.60517) # 약 100이 나옴

## 주사위 확률 1/6
-log(1/6,2)
-log(0.5,2)
-log(1/8,2)
comment('확률이 낮을수록 값이 높게 나옴
        확률이 낮은 정보를 찾으면 가치가  높아져서 값이 높게 나오는 것인지 확인 필요함!! 즉, 검색해보자')

# 데이터사우루스
library(ggplot2)
library(datasauRus)
data(package='datasauRus')
dd<-datasaurus_dozen
unique(dd$dataset)
str(dd)

plot(y~x,data=subset(dd,dataset=='dino'),pch=19,col='tomato')

ggplot(dd,aes(x=x,y=y))+
  geom_point(col='#a5f0a1')+
  facet_wrap(~dataset,nrow=3)
comment('datasaurus_dozen안에 들어 있는 dataset별로 여러 개의 정보를 바탕으로 그림을 그려줌')

ggplot(dd,aes(x=x,y=y,colour=dataset))+
  geom_point()+
  facet_wrap(~dataset,nrow=5)
comment('나오는 그래프의 색을 다 다르게 함')
  
## 출처: https://cran.r-project.org/web/packages/datasauRus/vignettes/Datasaurus.html
### 그림을 위에서 부터
ggplot(dd, aes(x,y, colour = dataset))+
  geom_point()+
  theme_void()+
  theme(legend.position='top')+
  facet_wrap(~dataset, ncol = 3)+
  guides(col=guide_legend(nrow=2))

### 그림을 밑에서 부터
ggplot(dd, aes(x,y, colour = dataset))+
  geom_point()+
  theme_void()+
  theme(legend.position='top')+
  facet_wrap(~dataset, ncol = 3,as.table=F)+
  guides(col=guide_legend(nrow=2))

# gapminder셋
ggplot(gapminder::gapminder)+
  aes(gdpPercap,lifeExp,colour=continent,size=pop)+
  geom_point(shape="diamond filled")+
  scale_color_hue(direction=1)+
  labs(x="소득", y="기대수명", title="gapminder따라하기", subtitle = "good", caption = "hans copycats")+
  theme_gray()+
  facet_wrap(~year)

library(dplyr)

gapminder::gapminder%>%
  filter(year >= 1997L & year <= 2007L)%>%
  ggplot()+
  aes(gdpPercap,lifeExp,colour=continent, size=pop, group=gdpPercap)+
  geom_point(shape = "circle",size=3)+
  scale_color_hue(direction=1)+
  theme_minimal()+
  facet_wrap(vars(year))
