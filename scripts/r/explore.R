#find convex hulls of each team ignoring goalkeepers
pos <- subset(df,matchID==5) %>%
  group_by(team, player) %>%
  dplyr::summarise(x.mean = mean(x), y.mean = mean(y)) %>%
  ungroup() %>%
  mutate(team = as.factor(team), player = as.factor(player)) %>%
  as.data.frame()

cent <- pos %>%
  subset(!(player %in% c(2,13)))%>%
  group_by(team) %>%
  dplyr::summarise(centX = mean(x.mean), centY = mean(y.mean)) %>%
  ungroup() %>%
  mutate(team = as.factor(team)) %>%
  as.data.frame()

data_hull <- pos %>%
  filter(!(player %in% c(2,13))) %>%
  group_by(team)%>%
  nest() %>%
  mutate(
    hull = map(data, ~ with(.x, chull(x.mean, y.mean))),
    out = map2(data, hull, ~ .x[.y,,drop=FALSE])
  )%>%
  select()%>%
  unnest()

p <- pitch_plot(68, 105) +
  geom_polygon(data = filter(data_hull, team == 'team A'), aes(x, y, frame = .frame), fill = 'red', alpha = 0.4) +
  geom_polygon(data = filter(data_hull, team == 'team B'), aes(x, y, frame = .frame), fill = 'blue', alpha = 0.4) +
  geom_point(data = filter(data, str_detect(team, 'team')), aes(x, y, group = player, fill = team, frame = .frame), shape = 21, size = 6, stroke = 2) +
  geom_point(data = filter(data, team == 'ball'), aes(x, y, frame = .frame), shape = 21, fill = 'dark orange', size = 4) +
  scale_fill_manual(values = c('team A' = 'red', 'team B' = 'blue')) +
  geom_text(data = filter(data, str_detect(team, 'team')), aes(x, y, label = player, frame = .frame), color = 'white') +
  guides(fill = FALSE)

plot_pos <- function(df, lengthPitch = 105, widthPitch = 68, fill1 = "red",
                     col1 = NULL, fill2 = "blue", col2 = NULL, labelCol = "black",
                     homeTeam = NULL, flipAwayTeam = TRUE, label = c("name", "number", "none"),
                     labelBox = TRUE, shortNames = TRUE, nodeSize = 5, labelSize = 4,
                     arrow = c("none", "r", "l"), theme = c("light", "dark", "grey", "grass"),
                     title = NULL, subtitle = NULL, source = c("manual", "statsbomb"),
                     x = "x", y = "y", id = "id", name = NULL, team = NULL) {

  # define colours by theme
  if(theme[1] == "grass") {
    colText <- "white"
  } else if(theme[1] == "light") {
    colText <- "black"
  } else if(theme[1] %in% c("grey", "gray")) {
    colText <- "black"
  } else {
    colText <- "white"
  }
  if(is.null(col1)) col1 <- fill1
  if(is.null(col2)) col2 <- fill2

  # plot
  p <- ##soccerPitch(theme = theme[1], title = title, subtitle = subtitle) +
    ggplot(data, aes( col = factor(team), fill = factor(team))) +
    #geom_polygon(data = df[1:23,], aes(x,y,group=team), fill=team, color=team) +
    #geom_path(data = df[1:23,],stat="voronoi", size=0.1, aes(x,y,color=team)) +
    #coord_quickmap() +
    # perimeter line
    #geom_rect(aes(x=NULL,y=NULL,xmin = 0, xmax = lengthPitch, ymin = 0, ymax = widthPitch), fill = NA, col = colPitch, lwd = lwd) +
    # centre circle
    #geom_circle(aes(x0 = lengthPitch/2, y0 = widthPitch/2, r = 9.15), col = colPitch, lwd = lwd) +
    # kick off spot
    #geom_circle(aes(x0 = lengthPitch/2, y0 = widthPitch/2, r = 0.25), fill = colPitch, col = colPitch, lwd = lwd) +
    # halfway line
    #geom_segment(aes(x = lengthPitch/2, y = 0, xend = lengthPitch/2, yend = widthPitch), col = colPitch, lwd = lwd) +
    # penalty arcs
    #geom_arc(aes(x0= 11, y0 = widthPitch/2, r = 9.15, start = pi/2 + 0.9259284, end = pi/2 - 0.9259284), col = colPitch, lwd = lwd) +
    #geom_arc(aes(x0 = lengthPitch - 11, y0 = widthPitch/2, r = 9.15, start = pi/2*3 - 0.9259284, end = pi/2*3 + 0.9259284), col = colPitch, lwd = lwd) +
    # penalty areas
    #geom_rect(aes(x=NULL,y=NULL,xmin = 0, xmax = 16.5, ymin = widthPitch/2 - 20.15, ymax = widthPitch/2 + 20.15), fill = NA, col = colPitch, lwd = lwd) +
    #geom_rect(aes(x=NULL,y=NULL,xmin = lengthPitch - 16.5, xmax = lengthPitch, ymin = widthPitch/2 - 20.15, ymax = widthPitch/2 + 20.15), fill = NA, col = colPitch, lwd = lwd) +
    # penalty spots
    #geom_circle(aes(x0 = 11, y0 = widthPitch/2, r = 0.25), fill = colPitch, col = colPitch, lwd = lwd) +
    #geom_circle(aes(x0 = lengthPitch - 11, y0 = widthPitch/2, r = 0.25), fill = colPitch, col = colPitch, lwd = lwd) +
    # six yard boxes
    #geom_rect(aes(x=NULL,y=NULL,xmin = 0, xmax = 5.5, ymin = (widthPitch/2) - 9.16, ymax = (widthPitch/2) + 9.16), fill = NA, col = colPitch, lwd = lwd) +
    #geom_rect(aes(x=NULL,y=NULL,xmin = lengthPitch - 5.5, xmax = lengthPitch, ymin = (widthPitch/2) - 9.16, ymax = (widthPitch/2) + 9.16), fill = NA, col = colPitch, lwd = lwd) +
    # goals
    #geom_rect(aes(x=NULL,y=NULL,xmin = -2, xmax = 0, ymin = (widthPitch/2) - 3.66, ymax = (widthPitch/2) + 3.66), fill = NA, col = colPitch, lwd = lwd) +
    #geom_rect(aes(x=NULL,y=NULL,xmin = lengthPitch, xmax = lengthPitch + 2, ymin = (widthPitch/2) - 3.66, ymax = (widthPitch/2) + 3.66), fill = NA, col = colPitch, lwd = lwd)+


    geom_point(data=df,aes(x,y),shape = 21, size = 6, stroke = 1.3) +
    transition_states(
      states = frame,
      transition_length = 0.01,
      state_length = 0,
      wrap = FALSE
    ) +
    scale_colour_manual(values = c("#355C7D", "#7d8a35","#F67280","#FFFFFF")) +
    scale_fill_manual(values = c("#355C7D", "#7d8a35","#F67280")) +
    guides(colour = FALSE, fill = FALSE)+
    coord_fixed()
    #theme_void(base_family="Roboto Condensed")

  return(p)

}


p<-plot_pos(df,
            title = "test",
            subtitle = "pos frame 1",
            team = "true",
            theme = c('grass'),
            homeTeam = 'h')
p
animate(p, fps = 13,nframes=frames)

ggplot(data = df,aes(x,y))+
geom_point(aes(fill = team, colour = team), shape = 21, size = 6, stroke = 1.3) +
  transition_states(
    states = frame,
    transition_length = 0.01,
    state_length = 0,
    wrap = FALSE
  )
#anim_save("single_frame", animation = last_animation())

#CTM
avPos <- function(param,df=ctm){
  minute = as.numeric(param[1])#
  range = as.numeric(param[2])
  #check if valid range minute combination
  if(minute-(range)<0 ||minute+(range)<0){
    return(NULL)
  }
  #initialize the count variables
  noH = 0
  noA = 0

  #for loop to check who has possession in all frames in the range
  for (i in 0:(range-1)){
    #first if statement checks in the period before the centre point
    if (df[minute+i]=="h"){#if home team has possesion i frames before minute
      noH = noH+1 #then increment home counter
    }
    else{#else increment away counter
      noA = noA+1
    }
    #second if statement checks in the period before the centre point
    if(i!=0){#dont double count midpoint
      if (df[minute-i]=="h"){#if home team has possesion i frames after minute
        noH = noH+1
      }
      else{
        noA = noA+1
      }
    }

  }
  if(noH>noA){
    return("h")
  }
  else{
    return("a")
  }
}


ctm_Plot<-function(team){
  ctm <- data.frame(cbind(team,seq(1,6329)))
  colnames(ctm) <- c("team","frame")
  sub <- cbind(seq(32,6331,by=62),rep(31,102))


  sum<-apply(FUN=avPos,MARGIN=1,X=as.matrix(sub),df=ctm$team)

  perm<-c()
  for (i in 1:50){
    perm <- c(perm,rep(i,times=i))
  }
  perm<-c(perm,rep(51,times=51),rep(52,times=51),103-rev(perm))

  len <- c()
  for (i in 1:50){
    len<- c(len,seq(1,i))
  }
  len<-c(len,seq(1,51),seq(1,51),rev(len))

  temp <- data.frame(cbind(perm,len))
  ctmRes<-apply(FUN=avPos,MARGIN=1,X=temp,df=sum)
  temp <- data.frame(cbind(perm,len,ctmRes))
  colnames(temp)<-c("time","range","team")
  temp$team <- as.factor(temp$team)
  temp$time <- as.numeric(temp$time)
  temp$range <- as.numeric(temp$range)

  return(ggplot(data = temp,aes(x=time,y=range,color=team))+
    geom_point())
}

#for loop to determine possession at given frame
team <- c()
for(i in 1:frames){
  temp <- subset(df, frame==i)
  distances<-as.matrix(dist(as.matrix(temp[,4:5]),method="euclidean"))[,1]
  index <- which.min(distances[2:23])+1
  team <- c(team,temp[index,3])
}

p1 <- ctm_Plot(team)

#determine centroid based territorial advanage at given frame
team1 <- c()
for(i in 1:frames){

  #remove ball and goalkeepers
    temp <- subset(df, frame==i)[-c(1,2,13),]

  #find centroid of home team and distance from centroid to right hand side of pitch
    aveHomeX <- mean(as.numeric(as.matrix(subset(temp,team=="h")[,4])))
    distHome<-53.5-aveHomeX
    #aveHome <- c(aveHomeX,mean(as.numeric(as.matrix(subset(temp,team=="h")[,5]))))

  #find centroid of away team and distance from centroid to left hand side of pitch
    aveAwayX <- mean(as.numeric(as.matrix(subset(temp,team=="a")[,4])))
    distAway<-53.5-aveAwayX
    #aveAway <- c(aveAwayX,mean(as.numeric(as.matrix(subset(temp,team=="a")[,5]))))

  #if home dist > away dist, then away advantage
    if (distHome > distAway){
      team1 <- c(team1,"a")
    }
    else{
      team1 <- c(team1,"h")
    }
}

p2 <- ctm_Plot(team1)
p2

#average pass positions
hun<-df[1:100,]
hun$x <- as.numeric(hun$x)
hun$y <- as.numeric(hun$y)





ggplot()+
  geom_point(data = pos,
             aes(x=x.mean+53.5,y=y.mean+35,colour=team),
             size=3,alpha=1)+
  geom_point(data = cent,
             aes(x=centX+53.5,y=centY+35,colour=team,fill=team),
             size=5)+
  geom_polygon(data = filter(data_hull, team == 'h'), aes(x.mean+53.5, y.mean+35),fill=pal[5], alpha = 0.35) +
  geom_polygon(data = filter(data_hull, team == 'a'), aes(x.mean+53.5, y.mean+35),fill=pal[1], alpha = 0.35) +
  #perimeter
  geom_rect(aes(xmax=107,xmin=0,ymax=70,ymin=0),fill=NA,color="grey")+
  # centre circle
  geom_circle(aes(x0 = lengthPitch/2, y0 = widthPitch/2, r = 9.15), col = colPitch, lwd = lwd) +
  # kick off spot
  geom_circle(aes(x0 = lengthPitch/2, y0 = widthPitch/2, r = 0.25), fill = colPitch, col = colPitch, lwd = lwd) +
  # halfway line
  geom_segment(aes(x = lengthPitch/2, y = 0, xend = lengthPitch/2, yend = widthPitch), col = colPitch, lwd = lwd) +
  # penalty arcs
  geom_arc(aes(x0= 11, y0 = widthPitch/2, r = 9.15, start = pi/2 + 0.9259284, end = pi/2 - 0.9259284), col = colPitch, lwd = lwd) +
  geom_arc(aes(x0 = lengthPitch - 11, y0 = widthPitch/2, r = 9.15, start = pi/2*3 - 0.9259284, end = pi/2*3 + 0.9259284), col = colPitch, lwd = lwd) +
  # penalty areas
  geom_rect(aes(x=NULL,y=NULL,xmin = 0, xmax = 16.5, ymin = widthPitch/2 - 20.15, ymax = widthPitch/2 + 20.15), fill = NA, col = colPitch, lwd = lwd) +
  geom_rect(aes(x=NULL,y=NULL,xmin = lengthPitch - 16.5, xmax = lengthPitch, ymin = widthPitch/2 - 20.15, ymax = widthPitch/2 + 20.15), fill = NA, col = colPitch, lwd = lwd) +
  # penalty spots
  geom_circle(aes(x0 = 11, y0 = widthPitch/2, r = 0.25), fill = colPitch, col = colPitch, lwd = lwd) +
  geom_circle(aes(x0 = lengthPitch - 11, y0 = widthPitch/2, r = 0.25), fill = colPitch, col = colPitch, lwd = lwd) +
  # six yard boxes
  geom_rect(aes(x=NULL,y=NULL,xmin = 0, xmax = 5.5, ymin = (widthPitch/2) - 9.16, ymax = (widthPitch/2) + 9.16), fill = NA, col = colPitch, lwd = lwd) +
  geom_rect(aes(x=NULL,y=NULL,xmin = lengthPitch - 5.5, xmax = lengthPitch, ymin = (widthPitch/2) - 9.16, ymax = (widthPitch/2) + 9.16), fill = NA, col = colPitch, lwd = lwd) +
  # goals
  geom_rect(aes(x=NULL,y=NULL,xmin = -2, xmax = 0, ymin = (widthPitch/2) - 3.66, ymax = (widthPitch/2) + 3.66), fill = NA, col = colPitch, lwd = lwd) +
  geom_rect(aes(x=NULL,y=NULL,xmin = lengthPitch, xmax = lengthPitch + 2, ymin = (widthPitch/2) - 3.66, ymax = (widthPitch/2) + 3.66), fill = NA, col = colPitch, lwd = lwd)+
  #geom_hline(yintercept=cent$centY[1])+
  coord_fixed()+
  scale_color_manual(values=pal[c(2,11,6)])+
  scale_fill_manual(values=pal[c(2,11,6)])+
  scale_x_continuous(breaks = seq(-200,-180,by=10)) +
  scale_y_continuous(breaks = seq(-200,-180,by=10)) +
  fte_theme(font = c("Segoe UI Light","Segoe UI"))+
  theme(panel.background=element_rect(fill=green, color=green)) +
  theme(plot.background=element_rect(fill=green, color=green)) +
  theme(panel.border=element_rect(color=green)) +
  labs(title="Average Positions and Convex Hull",x="",y="")

wDF <- df[,c(2,2,1,4,5)]
wDF$id<-as.numeric(wDF$id)
wDF$id.1<-as.numeric(wDF$id.1)
wDF$frame<-as.numeric(wDF$frame)
write.table(wDF,"small.txt",sep=";",row.names = F,col.names=F)

#plot individual paths
soccerPitch()+
  geom_path(data=subset(df,frame %in% 1:2000 & team == "h"),
            aes(x=x+53.5,y=y+35,colour=id),
            lwd = 1) +
  scale_color_manual(values=pal)+
  fte_theme() +
  coord_fixed()

soccerPitch()+
  geom_path(data=subset(df,as.numeric(frame)/8 == floor(as.numeric(frame)/8)& id %in% c(4,5,14,15)),
            aes(x=x+53.5,y=y+35,colour=id,linetype=team),
            lwd = 1) +
  scale_color_manual(values=pal)+
  fte_theme() +
  coord_fixed()
