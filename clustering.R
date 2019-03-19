#This code takes in raw demographic data for all 435 congressional districts from Census Bureau in all 50 states and outputs 10 similar districts in the US for each of the 8 districts in Minnesota

#Loading required libraries
library(readxl)
library(rmarkdown)
library('dplyr')
library('tidyr')
library(analogue)
library(plyr)
library(cluster)
library(stringr)
library(data.table)

#The 2017_demo.csv has 2017 deomgraphic data for all US states obtained from the United States Census Bureau.
demo <-  read.csv('2017_demo.csv')

#Dropping columns not of interest to us
demo_fil<-demo[, -grep("Margin.of.Error", colnames(demo))]
write.csv(demo_fil, '2017_demo_filtered.csv')
demo_fil <-  read.csv('2017_demo_filtered.csv', row.names = 1, header = TRUE)
demo_fil <- demo_fil[, -grep("districtGeography", colnames(demo_fil))]
demo_fil <- demo_fil[, -grep("districtGeography", colnames(demo_fil))]


# Normalize data
normalize <- function(x){
  return ((x - min(x))/(max(x) - min(x)))}
data_norm <- as.data.frame(lapply(demo_fil, normalize))
row.names(data_norm) <- row.names(demo_fil)

# Apply K-means and display SSE elbow plot
SSE_curve <- c()
for (k in 1:100) {
  kcluster <- kmeans(data_norm, k)
  sse <- sum(kcluster$withinss)
  SSE_curve[k] <- sse
}
plot(1:100, SSE_curve, type="b", xlab="Number of Clusters", ylab="SSE")

distance_matrix <- daisy(data_norm,metric ="euclidean")
sil_curve <- c()
for (k in 2:50) {
  kcluster <- kmeans(data_norm, k)
  clusts <- kcluster$cluster
  dist <- distance_matrix
  sil_result <- silhouette(clusts, dist)
  sil <- mean(sil_result[,3])
  sil_curve[k] <- sil
}
sil_curve = sil_curve[2:50]

# Silhoutte plot
plot(2:50, sil_curve, type="b", xlab="Number of Clusters", ylab="Silhouette")
new_num_clusters = which.max(sil_curve)+1

#Picking 29 clusters and writint cluster Ids to csv
num_clusters = 29
kcluster <- kmeans(data_norm, num_clusters)
kcluster$size
kcluster$centers
kcluster$cluster
demo_fil$cluster <- kcluster$cluster
write.csv(demo_fil, '2017_demo_raw_clustered.csv')

#Filtering out districts with Minnesota clusters
district_cluster <- demo_fil %>% select(c(349))
district_cluster$district <- row.names(district_cluster)
x <- district_cluster %>% filter(str_detect(district,'Minnesota')) %>% inner_join(district_cluster, by='cluster')
colnames(x) <- c('cluster', 'minnesota_district', 'closest_district')
write.csv(x, 'similar_districts_to_minnesota.csv')

#Filtering out 10 most similar districts based on distance measure
distance_v <- Vectorize(distance)
x %>% rowwise() %>%mutate(distance = distance(minnesota_district, closest_district, method = "euclidean"))
testFunc <- function(a, b) a + b
apply(x[,c('minnesota_district', 'closest_district')], 1, function(y) testFunc(y['z'],y['x']))
x$dist <- apply(x[,c('minnesota_district', 'closest_district')], 1, function(y) 
  distance(data_norm[y['minnesota_district'],], data_norm[y['closest_district'],], method = "euclidean")[1]
  )
x %>% group_by(minnesota_district) %>% arrange(dist, .by_group=TRUE) %>% top_n(10)
cleaned_closest_district <- x  %>% arrange(minnesota_district, dist) %>% group_by(minnesota_district) %>% top_n(-10)
write.csv(cleaned_closest_district, 'similar_districts_to_minnesota_top10.csv')
