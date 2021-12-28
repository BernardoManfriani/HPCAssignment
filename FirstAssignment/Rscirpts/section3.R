library(gridExtra)
library(grid)
library(ggplot2)

setwd("C:/Users/berna/Desktop/Sberneun/Università/Magistrale/ANNO 1/Foundation of HPC/Assigment I/File csv/fileSection3")
TC <- function(B, lat, N){
  L <- 1200/N^(1/3)
  D <- L^3*N
  Ts <- tableJacobiVF$TimeProc[1]/N
  c <- (L^2 *k *16)/1000000
  Tc <- (c/(B*8)) + k*lat*10^(-6)
  P <- D / (Ts + Tc)
  return(Tc)
}

C <- function(B, lat, N){
  L <- 1200/N^(1/3)
  D <- L^3*N
  Ts <- tableJacobiVF$TimeProc[1]/N
  c <- (L^2 *k *16)/1000000
  Tc <- (c / (B * 8)) + k*lat*10^(-6)
  P <- D / (Ts + Tc)
  return(c)
}

P <- function(B, lat, N){
  L <- 1200/N^(1/3)
  D <- L^3*N
  Ts <- tableJacobiVF$TimeProc[1]/N
  c <- (L^2 *k *16)/1000000
  Tc <- (c / (B * 8)) + k*lat*10^(-6)
  P <- D / (Ts + Tc) /1000000
  return(P)
}

TCgpu <- function(B, lat, N){
  L <- 1200/N^(1/3)
  D <- L^3*N
  Ts <- tableJacobiGPUVF$TimeProc[1]/N
  c <- (L^2 *k *16)/1000000
  Tc <- (c / (B * 8)) + k*lat*10^(-6)
  P <- D / (Ts + Tc)
  return(Tc)
}

Cgpu <- function(B, lat, N){
  L <- 1200/N^(1/3)
  D <- L^3*N
  Ts <- tableJacobiGPUVF$TimeProc[1]/N
  c <- (L^2 *k *16)/1000000
  Tc <- (c / (B * 8)) + k*lat*10^(-6)
  P <- D / (Ts + Tc)
  return(c)
}

Pgpu <- function(B, lat, N){
  L <- 1200/N^(1/3)
  D <- L^3*N
  Ts <- tableJacobiGPUVF$TimeProc[1]/N
  c <- (L^2 *k *16)/1000000
  Tc <- (c / (B * 8)) + k*lat*10^(-6)
  P <- D / (Ts + Tc)/1000000
  return(P)
}
#CPU

tableJacobi <- data.frame(read.csv("Results_Jacobi.csv", sep = ";"))

tableJacobiVF <- tableJacobi

maxComTime <- tableJacobi$MaxTime - tableJacobi$JacobiMAX
maxComTime
minComTime <- tableJacobi$MinTime - tableJacobi$JacobiMIN
minComTime



tableJacobiVF$MAP <- tableJacobi$MAP
tableJacobiVF

k <- c(0, 4, 6, 6, 4, 6, 6, 6, 6, 6, 6)

lup <- tableJacobi$MLUPs
tableJacobiVF$MLUPs = NULL
tableJacobiVF$MaxTime = NULL
tableJacobiVF$MinTime = NULL
tableJacobiVF$JacobiMAX = NULL
tableJacobiVF$JacobiMIN = NULL
tableJacobiVF$minComTime = NULL
tableJacobiVF$maxComTime = NULL

tableJacobiVF$K <- k

TimeProc <- (tableJacobi$MaxTime + tableJacobi$MinTime) / 2

tableJacobiVF$TimeProc = TimeProc

JacobiTime <- (tableJacobi$JacobiMAX + tableJacobi$JacobiMIN) /2

tableJacobiVF$JacobiTime = JacobiTime

CommTime <- (maxComTime + minComTime) / 2

tableJacobiVF$CommTime = CommTime

latency <- c(0, 0.2329, 0.2329, 0.2329, 0.6113, 0.6113, 0.6113, 1.1157,1.1157,1.1157, 1.1157)
bandwidth <- c(0, 23540.0407,23540.0407,23540.0407,20257.6877,20257.6877,20257.6877,11869.0648, 11869.0648, 11869.0648, 11869.0648)

tableJacobiVF$Latency = latency
tableJacobiVF$Bandwidth = bandwidth

tableJacobiVF$MLUPs = lup

c <- C(bandwidth, latency, tableJacobiVF$NProc)

Tc <- TC(bandwidth, latency, tableJacobiVF$NProc)

P <- P(bandwidth, latency, tableJacobiVF$NProc)

Tc[1] <- 0
P[1] <- 112.5653

tableJacobiVF$"C(L,N)" <- c
tableJacobiVF$"Tc(L,N)" <- Tc
tableJacobiVF$"P(L,N)" <- P


tt3 <- ttheme_default( core = list(bg_params = list(fill = blues9[1:2])))

grid.arrange(tableGrob(tableJacobiVF, theme = tt3))



#GPU
tableJacobiGPU <- data.frame(read.csv("Results_JacobiGPU.csv", sep = ";"))
tableJacobiGPU
tableJacobiGPU <- tableJacobiGPU[-c(12:22),]
tableJacobiGPU <- tableJacobiGPU[-c(12:22),]
tableJacobiGPU

lupGPU <- tableJacobiGPU$MLUPs

tableJacobiGPUVF <- tableJacobiVF

TimeProcGPU <- (tableJacobiGPU$MaxTime + tableJacobiGPU$MinTime) / 2
TimeProcGPU

tableJacobiGPUVF$TimeProc = TimeProcGPU

JacobiTimeGPU <- (tableJacobiGPU$JacobiMAX + tableJacobiGPU$JacobiMIN) /2

tableJacobiGPUVF$JacobiTime = JacobiTimeGPU

maxComTimeGPU <- (tableJacobiGPU$MaxTime - tableJacobiGPU$JacobiMAX)
minComTimeGPU <- (tableJacobiGPU$MinTime - tableJacobiGPU$JacobiMIN)
CommTimeGPU <- (maxComTimeGPU + minComTimeGPU) / 2

tableJacobiGPUVF$CommTime = CommTimeGPU

kgpu <- c(0, 4, 6, 6, 4, 6, 6, 6, 6, 6, 6)
latencygpu <- c(0,0.2743,0.2743,0.2743,0.6867,0.6867,0.6867,0.6867,0.6867,0.6867,0.6867)
bandwidthgpu <- c(0,20506.1773,20506.1773,20506.1773,19947.1191,19947.1191,19947.1191,19947.1191,19947.1191,19947.1191,19947.1191 )

tableJacobiGPUVF$K <- kgpu
tableJacobiGPUVF$Latency <- latencygpu
tableJacobiGPUVF$Bandwidth <- bandwidthgpu
tableJacobiGPUVF$MLUPs <- lup

cgpu <- Cgpu(bandwidthgpu, latencygpu, tableJacobiGPU$NProc)
Tcgpu <- TCgpu(bandwidthgpu, latencygpu, tableJacobiGPU$NProc)
Pgpu <- Pgpu(bandwidthgpu, latencygpu, tableJacobiGPU$NProc)
Pgpu
Tcgpu[1] <- 0
Pgpu[1] <- 75.83925

tableJacobiGPUVF$"C(L,N)" <- cgpu
tableJacobiGPUVF$"Tc(L,N)" <- Tcgpu
tableJacobiGPUVF$"P(L,N)" <- Pgpu
tableJacobiGPUVF$MLUPs <- lupGPU

tableJacobiGPUVF[1,7:8] <- "null"
mapgpu <- c("core","core","core","core","socket","socket","socket","socket","socket","socket","socket")
tableJacobiGPUVF$MAP <- mapgpu
tt3 <- ttheme_default( core = list(bg_params = list(fill = blues9[1:2])))
grid.arrange(tableGrob(tableJacobiGPUVF, theme = tt3))


  

#MAP NPROC Time Jacobi CommTime K mlup latency bandwidth cln tcln pln
tableJacobiGPUVF
plotPerfJac <- ggplot()  + 
  geom_point(aes(x = tableJacobi$NProc,y=tableJacobi$MLUPs, group = 1, color = "realCPU")) +
  geom_line(aes(x = tableJacobi$NProc,y=tableJacobi$MLUPs, group = 1, color = "realCPU")) +
  geom_point(aes(x = tableJacobiGPUVF$NProc,y=P, group = 1, color = "modelCPU")) +
  geom_line(aes(x = tableJacobiGPUVF$NProc,y=P, group = 1, color = "modelCPU")) +
  geom_point(aes(x = tableJacobiGPU$NProc,y=tableJacobiGPU$MLUPs, group = 1, color = "realGPU")) +
  geom_line(aes(x = tableJacobiGPU$NProc,y=tableJacobiGPU$MLUPs, group = 1, color = "realGPU")) +
  geom_point(aes(x = tableJacobiVF$NProc,y=Pgpu, group = 1, color = "modelGPU")) +
  geom_line(aes(x = tableJacobiVF$NProc,y=Pgpu, group = 1, color = "modelGPU")) +
  
  labs(x = "N", y = "MLUPs", colour="Nodes", title = "Performance between GPU and THIN" )+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1), plot.title = element_text(hjust =  0.5))
plotPerfJac

tableJacobiGPU


