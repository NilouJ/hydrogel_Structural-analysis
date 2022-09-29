library(ggtext)
library(patchwork)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(ggpubr)

### TIME SWEEP
Path <- ("C:/Users/nilou/OneDrive - UNSW/1- CV2022/CRYO RESALTS/CaCl2 - stability-finalised/")
# setwd("G:/CRYO RESALTS")

# LOAD DATASETS ###############################################################

fileName <- paste(Path, 'BIGDATA.csv', sep = '')
data <- read.csv(fileName)


# data$Channel <- as.factor(data$Channel)
data$file <- as.factor(data$file)
data <- data %>% filter(0 < eccentricity & eccentricity < 1)
# head(data)

# levels(data$file)
sd(data$tand)
###############################################################################

plot_lst <- vector("list", length = length(levels(data$file)))
N0 <- c()
mean0 <- c()
sd0 <- c()
se0 <- c()
N1 <- c()
mean1 <- c()
sd1 <- c()
se1 <- c()
N2 <- c()
mean2 <- c()
sd2 <- c()
se2 <- c()
print(levels(data$file))
#
# data <- data %>% filter(20 < Area & Area < 5000)

####### Distribution AREA Perimeter ECCENTRICITY ##########################################################

for (fname in levels(data$file)) {

  if(fname == "BaCl2 - 12 h"){data_fname <- data %>% filter(file == fname)%>% filter(10 < Area & Area < 2500)}
  else{data_fname <- data %>% filter(file == fname)%>% filter(50 < Area & Area < 5000)}

  N0[[fname]] <- length(data_fname$Area)
  mean0[[fname]] <- mean(data_fname$Area)
  sd0[[fname]] <- sd(data_fname$Area)
  se0[[fname]] <- sd0[[fname]]/ sqrt(N0[[fname]])
  sd0 <- as.numeric(sd0)
  se0 <- as.numeric(se0)
  mean0 <- as.numeric(mean0)

  N1[[fname]]<- length(data_fname$Perimeter)
  mean1[[fname]]<- mean(data_fname$Perimeter)
  sd1[[fname]]<- sd(data_fname$Perimeter)
  se1[[fname]]<- sd1[[fname]] / sqrt(N1[[fname]])
  sd1 <- as.numeric(sd1)
  se1 <- as.numeric(se1)
  mean1 <- as.numeric(mean1)

  N2[[fname]]<- length(data_fname$eccentricity)
  mean2[[fname]]<- mean(data_fname$eccentricity)
  sd2[[fname]]<- sd(data_fname$eccentricity)
  se2[[fname]]<- sd2[[fname]] / sqrt(N2[[fname]])
  sd2 <- as.numeric(sd2)
  se2 <- as.numeric(se2)
  mean2 <- as.numeric(mean2)
  # Time[fname] <- mean(data_fname$time)

  Area <- ggplot(data_fname, aes(x=Area)) +
    geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                   binwidth=100,
                   colour="black", fill="white") +
    geom_density(alpha=.2, fill="#696969") +
    xlab(expression("Pore Area ("*mu*"m)"^"2")) +
    ylab("Density") +
    ggtitle(fname)+
    theme_classic()

  Peri <- ggplot(data_fname, aes(x=Perimeter)) +
    geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                   binwidth=20,
                   colour="black", fill="white") +
    geom_density(alpha=.2, fill="#696969") +   # Overlay with transparent
    xlab(expression("Pore Perimeter ("*mu*"m)")) +
    ylab("Density") +
    ggtitle(fname)+
    theme_classic()

  Ecce <- ggplot(data_fname, aes(x=eccentricity)) +
    geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                   binwidth=0.05,
                   colour="black", fill="white") +
    geom_density(alpha=.2, fill="#696969") +   # Overlay with transparent
    xlab(expression("Eccentricity [-]")) +
    ylab("Density") +
    ggtitle(fname)+
    theme_classic()


  dfa <- data.frame(file = fname, Area = tail(mean0, n=1))
  dfp <- data.frame(file = fname, Perimeter = tail(mean1, n=1))
  dfe <- data.frame(file = fname, eccentricity = tail(mean2, n=1))


  A <- ggplot(data_fname, aes(x=file, y=Area)) +
    geom_violin(trim=FALSE) +
    geom_boxplot(width=0.1, color="grey", alpha=0.2) +
    geom_point(data = dfa, size=2, color="red", fill="red") +
    geom_text(data = dfa, size=4, aes(x=file, y = Area * 2 , label = round(Area, digits = 2)), color="black") +
    xlab(NULL) +
    ylab(expression("Pore Area ("*mu*"m)"^"2")) +
    theme_classic()

  P <- ggplot(data_fname, aes(x=file, y=Perimeter)) +
    geom_violin(trim=FALSE) +
    geom_point(data = dfp, size=2, color="red", fill="red") +
    geom_text(data = dfp, size=4, aes(x=file, y = Perimeter + 150 , label = round(Perimeter, digits = 2)), color="black") +
    geom_boxplot(width=0.1, color="grey", alpha=0.2) +
    xlab(NULL) +
    ylab(expression("Pore Perimeter ("*mu*"m)")) +
    theme_classic()

  E <- ggplot(data_fname, aes(x=file, y=eccentricity)) +
    geom_violin(trim=FALSE) +
    geom_boxplot(width=0.1, color="grey", alpha=0.2) +
    geom_point(data = dfe, size=2, color="red", fill="red") +
    geom_text(data = dfe, size=4, aes(x=file, y = eccentricity + 0.15 , label = round(eccentricity, digits = 2)), color="black") +
    xlab(NULL) +
    ylab(expression("Eccentricity [-]")) +
    theme_classic()


  distributions <- (Area | Peri | Ecce) / (A | P | E)
  print(distributions)

  plot_lst[[fname]] <- distributions

  ggsave(plot = plot_lst[[fname]],
         path = Path,
         filename = fname, width = 8, height = 6, device = "png")

}


###################################################################################
dfa <- data.frame(file = levels(data$file), Area = mean0)
dfp <- data.frame(file = levels(data$file), Perimeter = mean1)
dfe <- data.frame(file = levels(data$file), eccentricity = mean2)
# my_comparisons <- list( c("Ca-Alg", "Ba-Alg"),c("Ca-Alg", "Sr-Alg"),
#                         c("Ba-Alg", "Sr-Alg") )

my_comparisons <- list( c("CaCl2 - 0 d" , "CaCl2 - 0.5 d"), c("CaCl2 - 0 d" , "CaCl2 - 1 d"),
                        c("CaCl2 - 0 d" , "CaCl2 - 4 d"), c("CaCl2 - 0 d" , "CaCl2 - 8 d"),
                        c("CaCl2 - 0.5 d" , "CaCl2 - 4 d"), c("CaCl2 - 0.5 d" , "CaCl2 - 8 d"),
)

symnum.args <- list(cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1), symbols = c("****", "***", "**", "*", "ns"))

# if(fname == "Ba-Alg"){data_fname <- data %>% filter(file == fname)%>% filter(10 < Area & Area < 5000)}else{
#   data_fname <- data %>% filter(file == fname)%>% filter(50 < Area & Area < 10000)}

data <- data %>% filter(10 < Area & Area < 10000)


print(head(data))
compare_means(Area ~ file,  data = data)

A <- ggplot(data, aes(x=file, y=Area)) +
  geom_violin(trim=TRUE  ) +
  geom_boxplot(width=0.1, color="grey", alpha=0.2) +
  geom_point(data = dfa, size=2, color="red", fill="red") +
  geom_text(data = dfa, size=4, aes(x=file, y = Area * 2 , label = round(Area, digits = 2)), color="black") +
  stat_compare_means(comparisons = my_comparisons, mapping = aes(x=file, y=Area), symnum.args = symnum.args) +
  xlab(NULL) +
  ylab(expression("Pore Area ("*mu*"m)"^"2")) +
  scale_y_continuous(breaks=seq(0,5000,500))+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.y = element_text(size = 14),
        plot.title = element_text(size = 12))

compare_means(Perimeter ~ file,  data = data)

P <- ggplot(data, aes(x=file, y=Perimeter)) +
  geom_violin(trim=TRUE) +
  geom_boxplot(width=0.1, color="grey", alpha=0.2) +
  geom_point(data = dfp, size=2, color="red", fill="red") +
  geom_text(data = dfp, size=4, aes(x=file, y = Perimeter + 150 , label = round(Perimeter, digits = 2)), color="black") +
  stat_compare_means(comparisons = my_comparisons, mapping = aes(x=file, y=Perimeter), symnum.args = symnum.args) +
  xlab(NULL) +
  ylab(expression("Pore Perimeter ("*mu*"m)")) +
  scale_y_continuous(breaks=seq(0,500,50))+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.y = element_text(size = 14),
        plot.title = element_text(size = 12))

compare_means(eccentricity ~ file,  data = data)
E <- ggplot(data, aes(x=file, y=eccentricity)) +
  geom_violin(trim=TRUE) +
  geom_boxplot(width=0.1, color="grey", alpha=0.2) +
  geom_point(data = dfe, size=2, color="red", fill="red") +
  geom_text(data = dfe, size=4, aes(x=file, y = eccentricity + 0.15 , label = round(eccentricity, digits = 2)), color="black") +
  stat_compare_means(comparisons = my_comparisons, mapping = aes(x=file, y=eccentricity), symnum.args = symnum.args) +
  xlab(NULL) +
  ylab(expression("Eccentricity [-]")) +
  scale_y_continuous(breaks=seq(0,1,0.25))+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.y = element_text(size = 14),
        plot.title = element_text(size = 12))

all <- (A | P | E)
print(A | P | E)

ggsave(plot = all,
       path = Path,
       filename = "all", width = 12, height = 6, device = "png")


###################################################################################
# CLEAN UP #################################################

# Clear packages
detach("package:datasets", unload = TRUE)
dev.off()
cat("\014")




