####*********************************************####
#   Abhishek Dixit (PG ID: 11915034)
#   Seshadri Deb Roy (PG ID:11915032)
#   Hanumesh Vittal setty Nagur (PG ID :11915088)
#-------------------
#Citation/Refrence: The Code is referred/used from Prof. Sidhir Voleti's TA Class's, on Shiny & UDpipe Explorationexample (session 4 &5)
#-----------------
####*********************************************####

if (!require(shiny)) {install.packages("shiny")}
if (!require(dplyr)) {install.packages("dplyr")}
if (!require(tidytext)) {install.packages("tidytext")}
if (!require(textrank)) {install.packages("textrank")}
if (!require(ggplot2)) {install.packages("ggplot2")}
if (!require(udpipe)){install.packages("udpipe")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(wordcloud)){install.packages("shinycssloaders")}
if (!require(shinythemes)){install.packages("shinythemes")}

library(shiny)
library(dplyr)
library(tidytext)
library(textrank)
library(ggplot2)
library(udpipe)
library(lattice)
library(igraph)
library(ggraph)
library(wordcloud)
library(stringr)
library(shinycssloaders)
library(shinythemes)
