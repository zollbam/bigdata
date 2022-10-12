rm(list=ls())
colors()

# 시각화를 위한 패키지 설치
library(tidyverse)

# anscombe셋
## 데이터 확인
anscombe
str(anscombe)
class(anscombe)

## x평균
mean(anscombe$x1)
mean(anscombe$x2)
mean(anscombe$x3)
mean(anscombe$x4)

## y평균
mean(anscombe$y1)
mean(anscombe$y2)
mean(anscombe$y3)
mean(anscombe$y4)

## 상관계수
cor(anscombe$x1,anscombe$y1)
cor(anscombe$x2,anscombe$y2)
cor(anscombe$x3,anscombe$y3)
cor(anscombe$x4,anscombe$y4)

## 선형회귀
lm(y1~x1,data=anscombe)
lm(y2~x2,data=anscombe)
lm(y3~x3,data=anscombe)
lm(y4~x4,data=anscombe)

## 선형그래프
par(mfrow=c(2,2))
plot(anscombe$x1,anscombe$y1,col='orange',pch=19)
abline(lm(y1~x1,data=anscombe),col='tomato')
plot(anscombe$x2,anscombe$y2,col='orange',pch=19)
abline(lm(y2~x2,data=anscombe),col='tomato')
plot(anscombe$x3,anscombe$y3,col='orange',pch=19)
abline(lm(y3~x3,data=anscombe),col='tomato')
plot(anscombe$x4,anscombe$y4,col='orange',pch=19)
abline(lm(y4~x4,data=anscombe),col='tomato')
par(mfrow=c(1,1))

# mpg셋
## 데이터 확인
str(mpg) # 구조
class(mpg) # 타입
summary(mpg) # 요약 통계략
colSums(is.na(mpg)) # NA값 수
head(mpg)

## geom_point()
ggplot(data=mpg,mapping=aes(x=displ,y=hwy))+geom_point()
comment('aes로 축을 설정 가능')

comment('이렇게 ggplot을 변수에 저장시키는것도 가능')
p<-ggplot(data=mpg,mapping=aes(x=displ,y=hwy))
p+geom_point()

p<-ggplot(data=mpg,mapping=aes(x=displ,y=hwy,col=year))
gp<-geom_point(lwd=3)
p+gp

ggplot(mpg,aes(displ,hwy,color=class,size=class,shape=class,alpha=0.3))+
  geom_point()
comment('class별로 색도 크기도 모양도 다르게 해줌
        alpha=옵션으로 투명도를 나타냄')

ggplot(mpg,aes(x=displ,y=hwy))+
  geom_point(aes(color=class,shape=class,alpha=0.3))

ggplot(mpg,aes(x=displ,y=hwy))+
  geom_point(aes(color=class,shape=class,alpha=0.3),position='jitter')
comment('geom_point()에서도 position을 사용가능
        jitter로 조금 흔들음')

ggplot(mpg,aes(x=displ,y=hwy))+
  geom_point(aes(color=class,shape=class,alpha=0.3,size=3),position='fill')
comment('100을 기준으로 기준의 모양을 그려줌')

## facet_wrap()
?facet_wrap
### 방법1
ggplot(data=mpg,aes(x=displ,y=hwy))+
  geom_point(col='orange') + 
  facet_wrap(~class,nrow=2)

### 방법2
ggplot(data=mpg,aes(x=displ,y=hwy))+
  geom_point(col='orange') + 
  facet_wrap(~class,nrow=2,scales='free')

### 방법3
ggplot(data=mpg,aes(x=displ,y=hwy))+
  geom_point(col='orange') + 
  facet_wrap(~class,nrow=3,scales='free_x',as.table=F)
comment('행렬처럼 위에서부터 채우는 것이 아닌 밑에서 부터 채움')

## facet_grid()
ggplot(mpg,aes(displ,hwy))+
  geom_point(col='orange') + 
  facet_grid(drv~cyl,scales='free')
?facet_grid

## 다양한 geom_----()
p<-ggplot(mpg,aes(displ,hwy,label=year))

### geom_jitter()
p+geom_point()
p+geom_jitter()
comment('점이 조금은 흔들림')

### geom_text()
?geom_text
p+geom_text(hjust=0)+geom_point(col='red')

### geom_segment()
?geom_segment
max.hwy<-aggregate(mpg,list(mpg$displ),max)[c('displ','hwy')]
max.hwy
comment('displ별 hwy의 최대값을 구해줌')

mpg$max_hwy<-max.hwy[match(mpg$displ,max.hwy$displ),'hwy']
mpg
comment('새로운 열을 만들어 각 displ별 hwy최대값을 구함')

p+geom_point()+geom_segment(aes(y=hwy,xend=displ,yend=max_hwy),arrow=arrow(type='closed',length=unit(0.5,'cm')))
comment('화살표 타입은 type=옵션, 길이는 length=옵션 사용')

### geom_smooth()
p+geom_point(col='blue')+
  geom_smooth(col='peru')
comment('점 자체에 색이 blue임
        geom_smooth로 점의 방향을 보여줌')

ggplot(data=mpg,aes(x=displ,y=hwy))+
  geom_point(aes(col=class))+
  geom_smooth(col='cyan')
comment('class별 점 색이 달라짐')

ggplot(data=mpg,aes(x=displ,y=hwy))+
  geom_point(aes(col=class))+
  geom_smooth(col='blue',se=F)+
  labs(title='Fuel efficiency .vs. engine size',
      subtitle='Two seaters are exceptional',
      caption='Data from fueleconomy.gov',
      x='Engine displacement(L)',
      y='Highway fuel economy(mpg)',
      color='Car Type')
comment('se=옵션으로 표준편차 구간을 안 보이게 해줌')

### geom_linerange()
?geom_linerange
p+geom_linerange(stat='summary')

### geom_pointrange()
?geom_pointrange
p+geom_pointrange(stat='summary')

## geom_boxplot()
?geom_boxplot
ggplot(mpg,aes(class,hwy))+geom_boxplot(fill='cyan',outlier.color = 'blue')

### coord_flip()
comment('x축 y축 뒤집기')
p+geom_boxplot(fill='brown')+coord_flip()

ggplot(mpg,aes(class,hwy))+geom_boxplot(fill='cyan',outlier.colour = 'cyan')+coord_flip()

ggplot(mpg,aes(class,hwy))+geom_boxplot(aes(fill=class),outlier.colour = 'cyan')+coord_flip()

## geom_bar()
### table()와 비교
table(diamonds$cut)
barplot(table(diamonds$cut))
comment('이 모양의 그래프를 ggplot를 이용하여 그리고 싶음')

ggplot(data=diamonds,aes(x=cut))+
  geom_bar(col='peru',fill='skyblue')

### 예제
ggplot(mpg)+geom_bar(aes(displ))

ggplot(diamonds)+
  geom_bar(aes(x=cut),col='black',fill='pink')
comment('mapping=aes()옵션은 ggplot에서도 geom_bar()에서도 사용 가능함
        fill=clarity는 clarity별로 나누지 않고 전체에 색을 칠함')

ggplot(data=diamonds)+
  geom_bar(aes(x=cut,fill=clarity),col='black')
comment('aes안에 fill옵션이 있으면 범례가 생기고 aes밖에 있으면 범례가 사라짐')

ggplot(data=diamonds)+
  geom_bar(aes(x=cut,fill=clarity,col=clarity))
comment('막대 주변의 선색을 바꾸고 싶었지만 아무것도 바뀌지 않음')

ggplot(data=diamonds)+
  geom_bar(aes(x=cut,fill=clarity),col='skyblue',position='fill')
comment('비율 100%을 기준으로 구간을 나눔')

ggplot(data=diamonds)+
  geom_bar(aes(x=cut,fill=clarity),col='skyblue',position='dodge')
comment('cut별 각 clarity별로 막대그래프를 나눔')

ggplot(data=diamonds)+
  geom_bar(aes(x=cut,fill=clarity),col='skyblue',position='jitter')

ggplot(data=diamonds)+
  geom_bar(aes(x=cut,fill=cut),show.legend=F,width=1)
comment('width는 작을 수록 막대의 너비가 작아짐')

ggplot(data=diamonds)+
  geom_bar(aes(x=cut,fill=cut),width=0.5)
comment('show.legend=T는 기본값으로 범례를 보여줌')

ggplot(data=diamonds,aes(x=cut,fill=cut))+
  geom_bar(show.legend=F,width=0.5)+
  labs(x='CUT',y='FRQUENCY')+
  theme(aspect.ratio=1)+
  coord_polar()
comment('aspect.ratio=옵션에서 값이 낮아질수록 y축의 길이가 줄어듬
        coord_polar()는 막대 그래프를 파이그래프(극그래프)형태로 보여줌
        width=옵션은 작을수록 각 막대 그래프별 간격이 커짐')

ggplot(data=diamonds,aes(x=cut,fill=cut))+
  geom_bar(show.legend=F,width=0.1)+
  labs(x='CUT',y='FRQUENCY',title='원 그래프')+
  theme(aspect.ratio=1,axis.ticks.y=element_line())
comment('labs에는 main을 쓰는 것이 아니라 title을 씀')

ggplot(data=diamonds,aes(x=cut,fill=cut))+
  geom_bar(show.legend=F,width=0.1)+
  labs(x='CUT',y='FRQUENCY',main='원 그래프')+
  theme(aspect.ratio=2)

ggplot(data=diamonds,aes(x=cut,fill=cut))+
  geom_bar(width=1.5)+
  theme(aspect.ratio=1)+
  coord_polar()

## geom_count()
?stat_count
ggplot(diamonds)+stat_count(aes(cut),fill='steelblue')
ggplot(diamonds)+geom_bar(aes(cut),fill='steelblue')
comment('stat_count와 geom_bar는 별 차이가 없음')

# 지도 시각화
world_df<-map_data('world')
str(world_df)
comment('world라는 데이터셋을 불러와 world_df에 저장')

ggplot(world_df,aes(long,lat,group=group))+
  geom_polygon(fill='lightyellow',color='blue')
comment('group=group있어야 지도 모양으로 나옴
        geom_polygon()로 각 열별로 선으로 구분지어줌')

ggplot(world_df,aes(long,lat,group=group,col=group,fill=region))+
  geom_polygon(show.legend = F)
comment('col=group으로 구분되는 선의 색의 색이 진하거나 연함
        show.legend = F를 안하면 그래프는 안보이고 범례만 크게 보임')

# %>%연산자(파이프라인 연산자)
comment('|>로 많이 추세가 바뀌고 있음')
## 평균보다 큰 hwy파일에서 필요한 4열만 가지고와 표준편차를 구하기
### 기존 방식
sd(mpg[mpg$hwy>mean(mpg$hwy),c(1,2,9,11)]$hwy)

### 연산자 사용(%>%)
mpg%>%
  select(c(1,2,9,11))%>%
  filter(hwy>mean(hwy))%>%
  summarize(sd_mpg_hwy=sd(hwy))

### 연산자 사용(|>)
mpg|>
  select(c(1,2,9,11))|>
  filter(hwy>mean(hwy))|>
  summarize(sd_mpg_hwy=sd(hwy))

## 각 클래스별 최고값만 텍스트로 보여줌
### 각 클래스별 hwy값의 최고값 추출
mpg_df<-mpg
mpg_df%>%
  group_by(class)|>
  filter(row_number(desc(hwy))==1)
best.in.class
comment('class별로 그룹을 나누고 내림차순으로 정렬하여
        행번호가 1인 것은 최대값이므로 각 클래스별 hwy열의 최고값을 구해줌
        class는 7개 이므로 각 1개씩 뽑으면 7행이 추출됨')

### ggplot기본틀 설정
p<-ggplot(mpg,aes(x=displ,y=hwy))

### 그래프 그리기
p+geom_point(aes(color=class))+
  geom_text(aes(label=model),data=best.in.class)
comment('class별로 색을 다르게찍고 text는 최고값 데이터로 model명을 뽑아 보여줌')

### 더 이쁘게 그래프 그리기
p+geom_point(aes(color=class),show.legend = F)+
  geom_label(aes(label=model), data=best.in.class,nudge_x=0.3,alpha=0.5)+
  theme(legend.position='top')+
  geom_smooth(se=F)
comment('nudge_x=, nudge_y로 텍스트의 위치 변경
        범례의 위치도 변경, top,bottom 등 다양함')

### 텍스트가 겹치는 부분이 있어서...
library(ggrepel)
ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class),show.legend=F)+
  geom_label_repel(aes(label=model),data=best.in.class)+
  geom_smooth(se=F)

### 라벨을 저장하여 사용하고 싶을 때 사용
label<-tibble(displ=Inf,hwy=Inf,
              label='Increasing engine size is \n related to decreasing fuel enconomy')

ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class))+
  geom_label_repel(aes(label=model),data=best.in.class)+
  geom_smooth(se=F)+
  geom_text(aes(label=label),data=label,vjust=1,hjust=1)

### 범례를 행 1열로 바꾸기
ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class))+
  geom_smooth(se=F)+
  theme(legend.position='bottom')+
  guides(col=guide_legend(nrow=1,override.aes=list(size=2)))

### 그래프 판을 흰색으로 만듬
ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class))+
  geom_smooth(se=F)+
  theme_classic()

### 그래프 판을 검은색/흰색으로 만듬 => 그래프 판의 테두리가 점더 진해짐
ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class))+
  geom_smooth(se=F)+
  theme_bw()

### 그래프 판의 테두리가 점더 연해짐
ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class))+
  geom_smooth(se=F)+
  theme_light()

### 그래프 판의 격자가 진해짐
ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class))+
  geom_smooth(se=F)+
  theme_linedraw()

### 그래프 판이 검정색이 됨
ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class))+
  geom_smooth(se=F)+
  theme_dark()

### 그래프 판의 테두리가 없어짐
ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class))+
  geom_smooth(se=F)+
  theme_minimal()

### x/y, 격자 등 아무것도 없음=>오로지 점하고 선만 있음
ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class))+
  geom_smooth(se=F)+
  theme_void()

### 그래프 판의 기본값
ggplot(mpg,aes(displ,hwy))+
  geom_point(aes(col=class))+
  geom_smooth(se=F)+
  theme_gray()

# 그래프 png나 pdf로 변환하기
comment('마지막으로 그린 그림이 저장이 됨')
getwd()
ggsave('./figures/myplot.png')
ggsave('./figures/myplot.pdf',width=1920,height=1080,units='px')

# 출처: https://r-graph-gallery.com/histogram_several_group.html
library(ggplot2)
library(dplyr)
library(hrbrthemes)

data <- data.frame(
  type = c( rep("variable 1", 1000), rep("variable 2", 1000) ),
  value = c( rnorm(1000), rnorm(1000, mean=4) )
)
comment('value는 정규성으로 1000개와 평균이 4인 정규분포 1000개 추출')

data

data%>%
  ggplot(aes(x=value, fill=type))+
  geom_histogram(alpha=0.6, position ='identity')+
  scale_fill_manual(values=c("blue", "red")) + 
  theme_ipsum()+ 
  labs(fill='LEGEND')
comment('type별로 채우는 색깔이 다름
        labs(fill=\'LEGEND\')로 범례의 이름 지정')

data%>%
  ggplot(aes(x=value))+
  geom_histogram(alpha=0.6, position ='identity')+
  scale_fill_manual(values=c("#69b3a2", "#404080")) + 
  theme_ipsum()+ 
  labs(fill="조건영")
comment('막대 그래프의 색이 입혀지지 않음')

data%>%
  ggplot(aes(x=value,fill=type))+
  geom_histogram(alpha=0.6, position ='identity')+
  scale_fill_manual(values=c("#69b3a2", "#000000")) + 
  theme_ipsum()+ 
  labs(fill="Type")
comment('막대 그래프의 색이 입혀지지 않음')

# 펭귄데이터셋
## 성별에 따른 히스토그램을 겹쳐서 그리기
library(palmerpenguins)
pg<-penguins
pg<-pg[complete.cases(pg),]
str(pg)
table(pg$sex)

pg%>%
  ggplot(aes(bill_length_mm,fill=sex))+
  geom_histogram(alpha=0.3,position='identity',bins=30)+
  scale_fill_manual(values=c('green','blue'))+
  theme_bw()+
  labs(fill='sex',title='부리 길이 개수',x='부리길이',y='개수')
comment('겹치는 부분의 색은 정한 2개의 색을 합친 것')

# esquisse한 코드 만들기
## 코드 1
library(esquisse)
library(dplyr)
library(ggplot2)
comment('Tools->Addins->Browse Addins')

gapminder::gapminder%>%
  filter(year==2007L)%>%
  ggplot()+
  aes(gdpPercap,lifeExp,colour=continent,size=pop,group=gdpPercap)+
  geom_point(shape="square open")+comment('shape로 점모양을 지정 가능')+
  scale_color_hue('대륙',direction=-1)+comment('범례의 순서가 바뀜')+
  labs(x = "소득", y = "기대수명", title = "Esquisse plot", subtitle = "good", caption = "gyc") +
  theme_linedraw() +
  facet_wrap(vars(year))

## 코드2
gapminder::gapminder|>
  filter(year >= 1997L & year <= 2007L)|>
  ggplot()+
  aes(gdpPercap,lifeExp,colour=continent,size=pop,group=gdpPercap)+
  geom_point(shape="bullet",size=4)+
  scale_color_hue(direction=-0.5)+comment('0,-1,1이 3개로 값을 넣는데 점의 색이 바뀌는거 같음')+
  labs(x="소득",y="기대수명",title="1997~2007",subtitle="plot",caption="cgy")+
  theme_classic()+
  facet_wrap(~year,nrow=1,scales='free')+
  theme(legend.key=element_rect(),
        plot.title=element_text(size=20),
        plot.subtitle=element_text(size=15))

## 코드3
ggplot(gapminder)+
  aes(gdpPercap,lifeExp,color=continent)+
  geom_point(alpha=0.4)+
  scale_x_log10(labels=scales::dollar)+
  labs(title='Gapinder: GDP .vs. Lofe Expectancy',x='DFP per capita',y='Life Expectancy')+
  theme(plot.title=element_text(size=18,face='bold',color='blue'),
        axis.title=element_text(size=15,color='cyan'),
        legend.title=element_text(size=14),
        legend.text=element_text(size=13,color='peru'),
        axis.text.x=element_text(size=13),
        axis.text.y=element_text(size=13))

# 지도 시각화 실습
comment('공공데이터를 pdf에서 받아서 사용하자!!!
        R 파트3 2장 56쪽
        출처: https://www.mohw.go.kr/react/popup_200128_3.html')

## 데이터 불러오기
library(xlsxjars)
library(xlsx)

corona.df<-read.xlsx('coronacenter.xlsx',1)

## 데이터 확인
str(corona.df)
class(corona.df)
summary(corona.df)
colSums(is.na(corona.df))
head(corona.df)

## 필요열만 추출
corona.df_w<-corona.df[,c(2,3,4,7)]
head(corona.df_w)

## 열이름 변경
colnames(corona.df_w)<-c('city','sector','name','addr')
str(corona.df_w)

## city열이 대구인 데이터만 추출
daegu<-corona.df_w[corona.df_w$city=='대구',]
str(daegu)
head(daegu,10)

table(daegu$sector) # 대구의 구마다 진료소가 몇개 있는지 확인
barplot(table(daegu$sector),col='steelblue')

## 지도 시각화
library(ggmap)
ggmap_key<-'AIzaSyDCmW29qL9PNiMskMxpNwFZ_G-V1zIowec'
register_google(ggmap_key)
daegu.loc<-mutate_geocode(data=daegu,location=addr,source='google')
View(daegu.loc)
daegu.loc_w<-daegu.loc[,c('lon','lat','name')]
daegu.loc_nax<-na.omit(daegu.loc_w)
daegu.loc_nax

comment('위도경도가 안나옴...일단 나중에')

# plotly
## 내가 만든 데이터프레임
library(ggplot2)
library(plotly)

df<-data.frame(
  x=c(1,2,3,4),
  y=c(1,2,3,4),
  f=c(1,2,3,4)
)

p<-ggplot(df,aes(x,y))+
  geom_point(aes(frame=f))
comment('frame=옵션으로 그래프를 만들었을 때 play를 누르면 점이 움직임')

ggplotly(p)

# sleep셋
data(sleep)

sleep%>%
  plot_ly()%>%
  add_trace(x=~ID,y=~extra,type='bar')%>%
  layout(title='Bar Plot',xaxis=list(title='Species'),yaxis=list(title='Frequency'))
comment('add_trace()함수로 x와 y축을 bar형태로 그래프를 그리고
        layout으로 타이틀, x축, y축의 명을 지정')

# penguins셋
library(palmerpenguins)
penguins%>%
  plot_ly(x=~bill_length_mm, y=~bill_depth_mm, name=~species,
          hovertext=~island, hoverinfo='x+y+name+text')
comment('x축은 부리 길이, y축은 부리 깊이, 종별로 점 색깔을 다르게하고
        마우스를 점위에 올려두면 좌표와 섬/종 이름이 보임')

# gapminder셋
## x축은 gdpPercap, y축은 lifeExp, hover은 국가/인구 수가 나타나도록
library(gapminder)

gapminder%>%
  filter(year==2007)%>%
  plot_ly(x=~gdpPercap,y=~lifeExp,name=~country,
          hovertext=~pop, hoverinfo='x+y+name+text')

## 움직이는 그래프 만들기
p<-ggplot(gapminder,aes(gdpPercap,lifeExp))+
  geom_point(aes(color=continent,size=pop,alpha=0.5,frame=year))+
  geom_smooth(se=F)+
  scale_x_log10(label=scales::dollar)+
  theme_bw()

ggplotly(p)
