# Import the required libraries
library(dplyr)
library(reshape)
library(janitor)
library(tidyverse)
library(ggplot2)
library(ggpubr)

# Read in the data
motif <- read.csv("../db-tables/hg-motif.tsv", sep = "\t", header = F)
# Add column names
colnames(motif) <- c("ID", "Motif_name", "TF_name", "Collection", "TF")
levels(motif$TF)[levels(motif$TF)==""] <- "Uncategorized"
levels(motif$Collection)[levels(motif$Collection) == "Wei-mouse"] <- "Wei2010"
levels(motif$Collection)[levels(motif$Collection) == "Wei-human"] <- "Wei2010"

# Create a checker function
get_class <- function(x) {
  # Get the substring
  test_string <- substr(x, start = 1, stop = 2)
  # Test the substring for class
  if (test_string == "1.") {return("Basic domains")}
  else if (test_string == "2.") {return("Zinc-coordinating DBD")}
  else if (test_string == "3.") {return("Helix-turn-helix-domains")}
  else if (test_string == "4.") {return("All-alpha-helical DBD")}
  else if (test_string == "5.") {return("Alpha-Helices")}
  else if (test_string == "6.") {return("Immunoglobulin fold")}
  else if (test_string == "7.") {return("beta-Hairpin")}
  else if (test_string == "8.") {return("beta-Sheet")}
  else if (test_string == "9.") {return("beta-Barrel DBD")}
  else if (test_string == "0.") {return("Undefined DBD")}
  else {return("Uncategorized")}
}

# Convert the data into a tibble for mutation
motif <- as_tibble(motif)

# Add the TF families
motif %>% group_by(TF) %>% mutate(TF_family = get_class(TF)) -> motif
motif$TF_family <- as.factor(motif$TF_family)

motif <- as.data.frame(motif)
# Order the factors
motif$TF_family <- factor(motif$TF_family, levels = c("All-alpha-helical DBD","Alpha-Helices","Basic domains",
                                                      "beta-Barrel DBD","beta-Hairpin","beta-Sheet","Helix-turn-helix-domains",
                                                      "Immunoglobulin fold","Zinc-coordinating DBD",
                                                      "Undefined DBD","Uncategorized"))

# Select columns to use for analysis
data1 <- dplyr::select(motif,Collection,TF_family)

# Group data by mptof collection and count each family representation
data1 %>%
  group_by(Collection) %>%
  count(TF_family) -> data1

# Tranform the data for easy percent calculation
data1 = cast(data1,TF_family~Collection,value = "n") 

# Assign all null values 0
data1[is.na(data1)] <- 0

# Calculate percentages
data1 <- adorn_percentages(data1, denominator = "col", na.rm = TRUE)

# Gather the data
data1 <- data1 %>%
  gather(value = "Abudance", key = "Motif_Collection", -TF_family)

# select colours to use
myPalette <- c('#89C5DA', "#DA5724", "#74D944", "#CE50CA", "#3F4921", "#C0717C", "#CBD588", 
               "#5F7FC7", "#673770", "#D3D93E", "#38333E", "#508578", "#D7C1B1", "#689030", 
               "#AD6F3B", "#CD9BCD", "#D14285", "#6DDE88", "#652926", "#7FDCC0", "#C84248", 
               "#8569D5", "#5E738F", "#D1A33D", "#8A7C64", "#599861")

# Plot the abudance graph
plot2 <- ggplot(data1,aes(x = Motif_Collection, y = Abudance))+geom_col(aes(fill = TF_family),
                                                           position = position_stack(reverse = FALSE))+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_fill_manual(values = myPalette)

###################
##### PIE PLOT ####
###################
data2 <- motif %>% group_by(Collection) %>% tally()
names(data2)[names(data2) == "n"] <- "count"

# Create a basic bar
bar1 <- ggplot(data2,aes(x="",y=count,fill=Collection)) + geom_bar(stat = "identity", width = 1)
# Do a pie plot
pie <- bar1 + coord_polar("y", start = 0) + geom_text(aes(label = paste0(round(count /sum(count) * 100), "%")), 
                                                    position = position_stack(vjust = 0.5))
# Remove labels
pie <- pie + labs(x = NULL,y = NULL, fill = NULL, title = "Human Collection")

# Tidy up the theme
plot1 <- pie + theme_classic() + theme(axis.line = element_blank(),
                                     axis.text = element_blank(),
                                     axis.ticks = element_blank(),
                                     plot.title = element_text(hjust = 0.5, color = "#666666",face = "bold.italic"))+
              scale_fill_manual(values = myPalette)+ labs(fill = "Motif database")

figure <- ggarrange(plot1, plot2,
          labels = c("A: Distribution", "B: Abundance of TF families"),
          ncol = 2, nrow = 1)

#ggexport(figure, filename = "figure1.pdf",width = 480, height = 480, res = 300)

ggsave(filename="../human-motif-collection.pdf", 
       plot = figure, 
       device = cairo_pdf, 
       width = 300, 
       height = 150,
       units = "mm")

