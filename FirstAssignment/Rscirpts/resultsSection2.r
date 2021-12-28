# read csv assignment 1 
library(ggplot2)
library(RColorBrewer)
library(patchwork)

setwd("C:/Users/berna/Desktop/Sberneun/Università/Magistrale/ANNO 1/Foundation of HPC/Assigment I/File csv")

##############
plot_times <- function(file) {
  df <- data.frame(read.csv(file))
  dfSave <- df
  df<-df[1:24,]
  
  dfSave$X <- NULL
  dfSave$X.1 <- NULL
  
  model <-lm(t.usec.[1:24] ~ X.bytes[1:24], df)
  lambda <-  model$coef[1]
  B <- model$coef[2]
  
  print(file)
  print(coef(model))
  print(paste0("bandwith: ", 1/coef(model)[2], "\n"))
  
  #if(!"t.usec.comp." %in% colnames(df)){
    dfSave$t.usec.comp.[1:24] <- round(loess(t.usec. ~ X.bytes, dfSave[1:24,])$fitted, 4)
    write.csv(dfSave[], file)
  #}
  
  times <- ggplot() +
    # core ucx
    geom_line(data = df, aes(x = as.factor(X.bytes), y = t.usec., color="empirical", group = 1)) +
    geom_point(data = df, aes(x = as.factor(X.bytes), y = t.usec., color="empirical", group = 1))  + 

    # theoretical 
    geom_line(data = df, aes(x = as.factor(X.bytes), y = min(t.usec.) + X.bytes/max(Mbytes.sec), color="comm. model", group=1)) +
    geom_point(data = df, aes(x = as.factor(X.bytes), y = min(t.usec.) + X.bytes/max(Mbytes.sec), color="comm. model", group=1)) +

    # fit 
    #geom_line(data = df, aes(x = as.factor(X.bytes), y = lambda+ X.bytes*B, color="fit model", group=1)) +
    #geom_point(data = df, aes(x = as.factor(X.bytes), y = lambda + X.bytes*B, color="fit model", group=1)) +
    geom_point(aes(as.factor(df$X.bytes), loess(t.usec. ~ X.bytes, df)$fitted, color="fit model", group=1))+
    geom_line(aes(as.factor(df$X.bytes), loess(t.usec. ~ X.bytes, df)$fitted, color="fit model", group=1))+
    
    
    labs(x = "Message size (bytes)", y = "Time") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
    theme(legend.title = element_blank()) +
    scale_colour_manual(values = c("empirical" = "#2bacbd", "comm. model" = "#cf5e25", "fit model" = "#297504")) +
    labs(title = gsub('fileSection2/', '', gsub('.{4}$', '', file)), colour="Lines")+
    #theme_light() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1), plot.title = element_text(hjust =  0.5))
    #labs(title = gsub('_', ' ', gsub('.{4}$', '', file)))
  
  return(times)
}


plot_bandwidth <- function(file) {
  df <- data.frame(read.csv(file))
  dfSave <- df
  dfSave$X <- NULL
  dfSave$X.1 <- NULL

  df<-df[1:24,]
  model <-lm(t.usec. ~ X.bytes, df)
  lambda <-  model$coef[1]
  B <- model$coef[2]
  
  print(file)
  print(coef(model))
  print(paste0("bandwith: ", 1/coef(model)[2], "\n"))
  
  #if(!"Mbytes.sec.comp" %in% colnames(df)){
    dfSave$Mbytes.sec.comp[1:24] <- round(dfSave$X.bytes[1:24]/loess(t.usec. ~ X.bytes, dfSave[1:24,])$fitted, 4)
    write.csv(dfSave, file)
  #}
  
  
  #bandwidth
  bandwidth <- ggplot() +
    # core ucx
    geom_line(data = df, aes(x = as.factor(X.bytes), group = 2, y = Mbytes.sec, color="empirical")) +
    geom_point(data = df, aes(x = as.factor(X.bytes), group = 2, y = Mbytes.sec, color="empirical"))  +

    # theoretical
    geom_line(data = df, aes(x = as.factor(X.bytes), y = X.bytes/(min(t.usec.) + X.bytes/max(Mbytes.sec)), color="comm. model", group=1)) +
    geom_point(data = df, aes(x = as.factor(X.bytes), y = X.bytes/(min(t.usec.) + X.bytes/max(Mbytes.sec)), color="comm. model", group=1)) +

    # fit
    geom_point(aes(as.factor(df$X.bytes),df$X.bytes/loess(t.usec. ~ X.bytes, df)$fitted, color="fit model", group=1))+
    geom_line(aes(as.factor(df$X.bytes), df$X.bytes/loess(t.usec. ~ X.bytes, df)$fitted, color="fit model", group=1))+
    
    labs(x = "Message size (bytes)", y = "Speed MB/s") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
    theme(legend.title = element_blank()) +
    scale_colour_manual(values = c("empirical" = "#2bacbd", "comm. model" = "#cf5e25", "fit model" = "#297504")) +
    labs(title = gsub('fileSection2/', '', gsub('.{4}$', '', file)), colour="Lines")
    

  return(bandwidth)
}

plot_nshm <- function(core, socket, node, type) {
  core_times <- plot_times(core)
  socket_times <- plot_times(socket)
  node_times <- plot_times(node)
  core_times + socket_times + node_times
  
  ggsave(paste0("img/time", type, ".png"), width = 17, height = 8, dpi = 120)
  #mettere type da passare come argomento delle funzioni
  
  core_bandwidth <- plot_bandwidth(core)
  socket_bandwidth <- plot_bandwidth(socket)
  node_badnwidth <- plot_bandwidth(node)
  core_bandwidth + socket_bandwidth + node_badnwidth
  ggsave(paste0("img/bandiwdth", type, ".png"), width = 17, height = 8, dpi = 120)
}


plot_shm <- function(core, socket, type) {
  core_times <- plot_times(core)
  socket_times <- plot_times(socket)
  core_times + socket_times
  ggsave(paste0("img/time", type, ".png"), width = 17, height = 8, dpi = 120)
  
  core_bandwidth <- plot_bandwidth(core)
  socket_bandwidth <- plot_bandwidth(socket)
  core_bandwidth + socket_bandwidth
  ggsave(paste0("img/bandwidth", type, ".png"), width = 17, height = 8, dpi = 120)
}


plot_report <- function(core, socket, type) {
  core_bandwidth <- plot_bandwidth(core)
  socket_bandwidth <- plot_bandwidth(socket)
  core_bandwidth + socket_bandwidth
  ggsave(paste0("img/bandiwdth", type, ".png"), width = 17, height = 8, dpi = 120)
}

#openmpi - cpu
##############  
#ucx
plot_nshm("fileSection2/bycoreUcx.csv", "fileSection2/bysocketUcx.csv", "fileSection2/bynodeUcx.csv", "openCpuUcx")
#tcp
plot_nshm("fileSection2/bycoreOb1tcp.csv", "fileSection2/bysocketOb1tcp.csv", "fileSection2/bynodeOb1tcp.csv", "openCpuTcp")
#vader
plot_shm("fileSection2/bycoreOb1Vader.csv", "fileSection2/bysocketOb1Vader.csv", "openCpuVader")

#openmpi - gpu
##############
#ucx
plot_nshm("fileSection2/bycoreUcxGPU.csv", "fileSection2/bysocketUcxGPU.csv", "fileSection2/bynodeUcxGPU.csv", "openGpuUcx" )
#tcp
plot_nshm("fileSection2/bycoreOb1tcpGPU.csv", "fileSection2/bysocketOb1tcp.csv", "fileSection2/bynodeOb1tcpGPU.csv", "openGpuTcp")
#vader
plot_shm("fileSection2/bycoreOb1VaderGPU.csv", "fileSection2/bysocketOb1VaderGPU.csv", "openGpuVader")


#intel - cpu
#############
#ucx
plot_nshm("fileSection2/bycoreIntelInfinibandTHIN.csv", "fileSection2/bysocketIntelInfinibandTHIN.csv", "fileSection2/bynodeIntelIfinibandTHIN.csv", "intelCpuUcx")
#tcp
plot_nshm("fileSection2/bycoreIntelTcpTHIN.csv", "fileSection2/bysocketIntelTcpTHIN.csv", "fileSection2/bynodeIntelTcpTHIN.csv", "intelCpuTcp")
#vader
plot_shm("fileSection2/bycoreIntelShmTHIN.csv", "fileSection2/bysocketIntelShmTHIN.csv", "intelCpuVader")

#intel - gpu
##############
#ucx
plot_nshm("fileSection2/bycoreIntelInfinibandGPU.csv", "fileSection2/bysocketIntelInfinibandGPU.csv", "fileSection2/bynodeIntelIfinibandGPU.csv", "intelGpuUcx" )
#tcp
plot_nshm("fileSection2/bycoreIntelTcpGPU.csv", "fileSection2/bysocketIntelTcpGPU.csv", "fileSection2/bynodeIntelTcpGPU.csv", "intelGpuTcp")
#vader
plot_shm("fileSection2/bycoreIntelShmGPU.csv", "fileSection2/bysocketIntelShmGPU.csv", "intelGpuVader")



plot_report("fileSection2/bysocketUcx.csv", "fileSection2/bysocketIntelInfinibandTHIN.csv", "bysocketInfiniband")
