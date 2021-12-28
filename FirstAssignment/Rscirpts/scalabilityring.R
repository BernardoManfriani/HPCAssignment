library(tidyverse)
library(ggplot2)
setwd("C:/Users/berna/Desktop/Sberneun/Università/Magistrale/ANNO 1/Foundation of HPC/Assigment I/File csv/fileSection1/")

results <- read.csv("results.csv",sep=";")

plot(results)
results
plot <- ggplot() +
  geom_point(data = results, aes(x = NumProc, y = Time, color = "Real data", group = 1)) +
  geom_line(data = results, aes(x = NumProc, y = Time, color = "Real data", group = 1))+
  geom_smooth(method='lm',data = results, aes(x = NumProc, y = Time, color = "Fiited", group = 1))+
  geom_line(aes(x = results$NumProc, y = mod, colour = "Model", group = 1))+
  geom_smooth(method='lm', aes(x = results$NumProc, y = mod, color = "Fiited", group = 1))+
  geom_vline(aes(xintercept = 12),linetype = "dotted")+
  geom_vline(aes(xintercept = 24),linetype = "dotted")+
  labs(color = "Lines")
          

plot

results
model <- function(band, lat, n){
  f <- n*((4*10^(-6))/band) + n*lat   #nproc serve per avere il numero di messaggi totali
  return(f)
}

model <- function(band, lat, n){
  f <- n*lat
  return(f)
}

results

latency <- c("null", 0.2329, 0.2329, 0.2329, 0.6113, 0.6113, 0.6113, 1.1157,1.1157,1.1157, 1.1157)
bandwidth <- c("null", 23540.0407,23540.0407,23540.0407,20257.6877,20257.6877,20257.6877,11869.0648, 11869.0648, 11869.0648, 11869.0648)

lat <- c(rep(0.2329*10^(-6), 11), rep(0.6113*10^(-6), 12), rep(1.1157*10^(-6),24))

band <- c(rep(23540.0407, 11), rep(20257.6877, 12), rep(11869.0648,24))

band

mod <- model(band, lat, results$NumProc)
mod
plot(mod)
lat


matrixModel <- 3*(24*8/7199.4289 + 0.5056*10^(-6))
matrixModel

