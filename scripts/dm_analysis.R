# Import the required libraries
library(dplyr)
library(reshape)
library(janitor)
library(tidyverse)
library(ggplot2)
library(ggpubr)


# Read in the data
motif <- read.csv("../db-tables/dm-motif.tsv", sep = "\t", header = F)
#head(motif)
# Add column names
colnames(motif) <- c("ID", "Motif_name", "TF_name", "Collection", "TF")

# Add a new column with family names
#levels(motif$TF)[levels(motif$TF)==""] <- "Uncategorized"
motif$TF_family <- "Uncategorized"

motif[motif$TF %in% c("2","3","4","5","6","7","8","9","10","11","12","13","14","15",
                      "16","17","18","19","20","21","22","23","24","25","26","27","28",
                      "29","30","31","32","33","34","35","36","37","38","39","40","41",
                      "42","43","44","45","46","47","48","49","50","51","52","53","54",
                      "55","56","57","58","59","60","61","62","63","64","65","66","67",
                      "68","69","70","71","72","73","74","75","76","77","78","79","80",
                      "81","65::73"),]$TF_family <- "BDTF"

motif[motif$TF %in% c("354","355","356"),]$TF_family <- "CBFTF"

motif[motif$TF %in% c("364","365","366"),]$TF_family <- "E2FTF"

motif[motif$TF %in% c("367","368","369","370","371","372","373","374"),]$TF_family <- "ETSTF"

motif[motif$TF %in% c("399","400"),]$TF_family <- "GCM"

motif[motif$TF %in% c("1","357","358","359","375","376","377","378","379","380","381","382",
                      "383","384","385","386","387","388","389","390","391","392","393","425",
                      "426","427","428","429","430","431","432","433","434","435","436","437",
                      "438","439","440","441","442","443","444","445","446","447","448","449",
                      "450","451","458","459","460","461","462","463","464","465","466","467",
                      "468","469","470","471","472","473","474","475","476","477","478","479",
                      "480","481","482","483","484","485","486","487","550","551","552","553",
                      "554","555","556","557","558","559","560","561","562","563","564","565",
                      "566","567","568","569","570","571","572","573","574","575","576","577",
                      "578","579","580","581","582","583","584","585","586","587","588","589",
                      "590","591","592","593","594","595","596","597","602","603","604","605",
                      "606","607","608","609","610","611","612","613","614","615","616",
                      "625"),]$TF_family <- "HTH"

motif[motif$TF %in% c("401","402","403","404","405","406","407","408","409","410","411","412",
                      "413","414","415","416","417","418","419","420","421","422","423",
                      "424"),]$TF_family <- "HMGBTF"

motif[motif$TF %in% c("488","489","490","491","598","599","600","601","617","618","619","620",
                      "621","622","623","624","488/490"),]$TF_family <- "IGTF"

motif[motif$TF %in% c("452","453","454","455"),]$TF_family <- "MHTF"

motif[motif$TF %in% c("456","457"),]$TF_family <- "MADSTF"

motif[motif$TF %in% c("513","514","515","516","517","518","519","520","521","522","523","524",
                      "525","526","527","528","529","530","531","532","533","534","535","536",
                      "537","538","539","540","541","542","543","544","545","546","547","548",
                      "549"),]$TF_family <- "ODBDTF"

motif[motif$TF %in% c("626","627","628","629"),]$TF_family <- "THAPTF"

motif[motif$TF %in% c("82","83","84","85","86","87","88","89","90","91","92","93","94","95",
                      "96","97","98","99","100","101","102","103","104","105","106","107",
                      "108","109","110","111","112","113","114","115","116","117","118","119",
                      "120","121","122","123","124","125","126","127","128","129","130","131",
                      "132","133","134","135","136","137","138","139","140","141","142","143",
                      "144","145","146","147","148","149","150","151","152","153","154","155",
                      "156","157","158","159","160","161","162","163","164","165","166","167",
                      "168","169","170","171","172","173","174","175","176","177","178","179",
                      "180","181","182","183","184","185","186","187","188","189","190","191",
                      "192","193","194","195","196","197","198","199","200","201","202","203",
                      "204","205","206","207","208","209","210","211","212","213","214","215",
                      "216","217","218","219","220","221","222","223","224","225","226","227",
                      "228","229","230","231","232","233","234","235","236","237","238","239",
                      "240","241","242","243","244","245","246","247","248","249","250","251",
                      "252","253","254","255","256","257","258","259","260","261","262","263",
                      "264","265","266","267","268","269","270","271","272","273","274","275",
                      "276","277","278","279","280","281","282","283","284","285","286","287",
                      "288","289","290","291","292","293","294","295","296","297","298","299",
                      "300","301","302","303","304","305","306","307","308","309","310","311",
                      "312","313","314","315","316","317","318","319","320","321","322","323",
                      "324","325","326","327","328","329","330","331","332","333","334","335",
                      "336","337","338","339","340","341","342","343","344","345","346","347",
                      "348","349","350","351","352","353","360","361","362","363","394","395",
                      "396","397","398","492","493","494","495","496","497","498","499","500",
                      "501","502","503","504","505","506","507","508","509","510","511",
                      "512","493::509"),]$TF_family <- "ZNTF"

# Convert the new column as a factor and order them
motif$TF_family <- factor(motif$TF_family, levels = c("BDTF", "CBFTF", "E2FTF", "ETSTF", "GCM",
                  "HMGBTF", "HTH", "IGTF", "MADSTF", "MHTF", "ODBDTF", "THAPTF", "ZNTF", "Uncategorized"))

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
pie <- pie + labs(x = NULL,y = NULL, fill = NULL, title = "Drosophila Collection")

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

ggsave(filename="../drosophila-motif-collection.pdf", 
       plot = figure, 
       device = cairo_pdf, 
       width = 300, 
       height = 150,
       units = "mm")

