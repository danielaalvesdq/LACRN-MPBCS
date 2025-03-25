#library(ggplot2)
#library(GGally) 
#library(gridExtra)
#library(grid) ##textGrob


pca <- read.table("results/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_LACRN_PCA.eigenvec", header = F)
MAF <- 1
#pca <- read.table(pc, header = F)
n_pca <- length(pca)-2
colnamesPCA <- 1:n_pca
colnamesPCA <- paste("PC",colnamesPCA ,sep = "")
colnamesPCA <- append(c("Sample_ID", "Fam_ID"),colnamesPCA)
colnames(pca) <- colnamesPCA
samplesheet <- read.delim("data_processing/12_1000G_REF_LACRN_SET/SampleSheet_qc.csv")
#samplesheet$Country_Source <- ifelse(as.vector(samplesheet$Country) == as.vector(samplesheet$Source), as.vector(samplesheet$Country), paste(as.vector(samplesheet$Country), as.vector(samplesheet$Source),sep ="_") )
#samplesheet <- subset(samplesheet, select = c("Name","Sample_ID","SentrixBarcode_A" ,"Date", "Country","Source", "Country_Source", "Discard", "Plate", "Well"))
#colnames(samplesheet) <- c("Name","Sample_ID","CHIP" ,"Date", "Country","Source", "Country_Source", "Discard","Plate","Well")
#samplesheet2 <- subset(samplesheet, select = c("Sample_ID","CHIP","Country_Source", "Discard"))

popinfo <- read.delim("data_processing/12_1000G_REF_LACRN_SET/popinfo_1000G_AYMARA_MAPUCHE_LACRN.csv")

pca2 <- pca[,c(1:6)]
samples2 <- popinfo
pca3 <- merge(pca2, samples2, by.x = "Sample_ID", by.y = "IndID", all.x = T)
#pca3 <- pca3[!is.na(pca3$PC1),]
#pca3$CHIP[is.na(pca3$CHIP)] <- "Unknown"
#pca3$Date <- as.vector(pca3$Date)
#pca3$Date[is.na( pca3$Date )] <- "Unknown"
#pca3$Country <- as.vector(pca3$Country)
#pca3$Country[is.na( pca3$Country )] <- "Unknown"
#pca3$Source <- as.vector(pca3$Source)
#pca3$Source[is.na( pca3$Source )] <- "Unknown"
#pca3$Country_Source[is.na( pca3$Country_Source )] <- "Unknown"
#pca3$Country_Source <- as.factor(pca3$Country_Source)

#pca3 <- pca3[pca3$Sample_ID != "203299780240_R01C01",]
pca3$Ancestry <- as.vector(pca3$Ancestry)
pca3$Ancestry[pca3$Ancestry == "Huilliche"] <- "Mapuche"
pca3$Ancestry[pca3$Ancestry == "Pehuenche"] <- "Mapuche"

pca3$Ancestry <- as.factor(pca3$Ancestry)

pca3$COLOR <- NA 
pca3$PCH <- 20 

pca3$COLOR[pca3$Ancestry == "AFR"] <- "forestgreen"
pca3$PCH[pca3$Ancestry == "AFR"] <- 21
pca3$COLOR[pca3$Ancestry == "Argentina"] <- "#A9F5F5"
pca3$COLOR[pca3$Ancestry == "Aymara"] <- "violetred4"
pca3$PCH[pca3$Ancestry == "Aymara"] <- 8
pca3$COLOR[pca3$Ancestry == "Brazil"] <- "blue"
pca3$COLOR[pca3$Ancestry == "Chile "] <- "#A5A2A4"
pca3$COLOR[pca3$Ancestry == "EAS"] <- "#EFEF8E"
pca3$PCH[pca3$Ancestry == "EAS"] <- 23
pca3$COLOR[pca3$Ancestry == "EUR"] <- "orange"
pca3$PCH[pca3$Ancestry == "EUR"] <- 4
pca3$COLOR[pca3$Ancestry == "Mapuche"] <- "green"
pca3$PCH[pca3$Ancestry == "Mapuche"] <- 25
pca3$COLOR[pca3$Ancestry == "Mexico"] <- "red"
pca3$COLOR[pca3$Ancestry == "Uruguay"] <- "black"

#pairs(pca3[,3:6], col = pca3$Country_Source, oma=c(3,3,3,15))
#colors_pairs <- c(, "", "", "", "", "", "", "","red","blue")
colors_pairs <- c("forestgreen", "orange", "#EFEF8E","violetred4","green","#A9F5F5","blue","#A5A2A4","red","black")
#20 original
#21, 22, 23
#Cambiar AYMARA por otro distinto al rojo, mapuche dejarlo tal cual, pero AFR poner otro tono de verde. EUR poner mas ocruro el naranjo

###ACA ordenar aleatoriamente


set.seed(88)
pca3 <- pca3[ sample(nrow(pca3)),]


png(filename = paste("results/12_1000G_REF_LACRN_SET/Country_PCA_", MAF,"_REF.png" ,sep = ""),width = 800, height = 800)
pairs(pca3[,3:6], col = pca3$COLOR, oma=c(3,3,5,15),cex.labels=3, cex = 2, pch=pca3$PCH, cex.axis = 2, main = "PCA grouped by Country")
par(xpd = T)
legend("bottomright", legend = c("AFR","EUR","EAS","Aymara","Mapuche","Argentina","Brazil","Chile","Mexico","Uruguay"), col =colors_pairs , pch = c(21,4,23,8,25,20,20,20,20,20) ,pt.cex = 2)
#legend("bottomright", legend = c( levels(pca3$Ancestry)), col =colors_pairs , pch = c(21, 20 ,8,20,20,23,4,25,20,20) ,pt.cex = 2)
dev.off()


pdf(paste("results/12_1000G_REF_LACRN_SET/Country_PCA_", MAF,"_REF_123.pdf" ,sep = ""), width = 8 , height = 6 )
par(mfrow=c(1,2), oma = c(8,1,4,1), mar= c(4, 4, 1, 2))
plot(pca3$PC1, pca3$PC2, xlab="PC1", ylab = "PC2",  col=pca3$COLOR, pch=pca3$PCH, cex = 2)
plot(pca3$PC1, pca3$PC3, xlab="PC1", ylab = "PC3",  col=pca3$COLOR, pch=pca3$PCH, cex = 2)
#par(xpd = T)
mtext(text="PC1 vs PC2 and PC3", line = 2, outer = T)
legend(-0.45,-0.3, legend = c("AFR","EUR","EAS","Aymara","Mapuche","Argentina","Brazil","Chile","Mexico","Uruguay"), col =colors_pairs , pch = c(21,4,23,8,25,20,20,20,20,20) ,pt.cex = 2,  horiz = TRUE, xpd = NA, cex=0.75)
#legend(-0.35,-0.5, legend = c("Argentina","Brazil","Chile","Mexico","Uruguay"), col =colors_pairs , pch = c(20,20,20,20,20) ,pt.cex = 2 ,  horiz = TRUE, xpd = NA )
dev.off()




#pca3$Country <- as.factor(pca3$Country)
#png(filename = paste("results/11_PCA_MAF_0_1/Country_PCA_", MAF,".png" ,sep = "") ,width = 800, height = 800)
#pairs(pca3[,3:6], col = pca3$Country, oma=c(3,3,5,22),cex.labels=3, cex = 2, pch=20, cex.axis = 2, main = "PCA grouped by Country")
#par(xpd = T)
#legend("bottomright", fill = unique(pca3$Country), legend = c( levels(pca3$Country)))
#dev.off()

#pca3$CHIP <- as.factor(pca3$CHIP)
#png(filename = paste("results/11_PCA_MAF_0_1/CHIP_PCA_", MAF,".png" ,sep = "") ,width = 800, height = 800)
#pairs(pca3[,3:6], col = pca3$CHIP, oma=c(3,3,5,22),cex.labels=3, cex = 2, pch=20, cex.axis = 2, main = "PCA grouped by CHIP")
#par(xpd = T)
#legend("bottomright", fill = unique(pca3$CHIP), legend = c( levels(pca3$CHIP)))
#dev.off()

#pca3$Date <- as.factor(pca3$Date)
#colors_pairs <- c("#94CE94", "#A9F5F5", "#E90C7A", "#0C18C4", "#A5A2A4", "#EFEF8E", "#DBDB90", "#7CB7B7","red","blue","yellow", "black","green","gray","darkblue","brown","pink")
#png(filename = paste("results/11_PCA_MAF_0_1/Date_PCA_", MAF,".png" ,sep = "") ,width = 800, height = 800)
#pairs(pca3[,3:6], col = colors_pairs, oma=c(3,3,5,22),cex.labels=3, cex = 2, pch=20, cex.axis = 2, main = "PCA grouped by Date")
#par(xpd = T)
#legend("bottomright", fill = unique(pca3$Date), legend = c( levels(pca3$Date)))
#dev.off()

#pca3$Well <- as.factor(pca3$Well)
#png(filename = paste("results/11_PCA_MAF_0_1/WELL_PCA_", MAF,".png" ,sep = ""),width = 800, height = 800)
#pairs(pca3[,3:6], col = pca3$Well, oma=c(3,3,5,22),cex.labels=3, cex = 2, pch=20, cex.axis = 2, main = "PCA grouped by Well")
#par(xpd = T)
#legend("bottomright", fill = unique(pca3$Well), legend = c( levels(pca3$Well)))
#dev.off()



###ggpairs(pca3[,3:6]) 






###resumen <- merge(pca,samples2,by = "Sample_ID", all = T)
###resumen2 <- resumen[!is.na(resumen$PC1),]
###resumen2$Country[is.na(resumen2$Country)] <- "Unknown"

#Meuestra out 203299780240_R01C01 en PC3
###resumen2 <- resumen2[resumen2$Sample_ID != "203299780240_R01C01",]

###g_legend<-function(a.gplot){
###   tmp <- ggplot_gtable(ggplot_build(a.gplot))
###   leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
###   legend <- tmp$grobs[[leg]]
###   return(legend)}

###for (pc in 1:4) {
###   l <- list()
###   for (pc2 in 1:4) {
###      if(pc != pc2){
###         title <- paste("PC", pc," VS PC", pc2,sep = "")
###         name <- paste("PC", pc,"_PC", pc2,sep = "")
###        print(title)
###         PC1 <- paste("PC", pc, sep = "")
###         PC2 <- paste("PC", pc2,sep = "")
###         #PC1_data <- resumen2[,PC1]
###         #PC2_data <- resumen2[,PC2]
###         p <- ggplot(resumen2,  aes_string(x= PC1,y=PC2,col="Country")) +
###            geom_point(aes(shape = Country, color = Country), size = 0.4, alpha = 0.4) +  #Size and alpha just for fun
###            scale_color_manual(values = c("#94CE94", "#A9F5F5", "#E90C7A", "#0C18C4", "#A5A2A4", "#EFEF8E", "#DBDB90", "#7CB7B7","red","blue","yellow")) +#your colors here
###            scale_shape_manual(values = c(2,3,20,21,7,8,4,5,1,10,12)) +
###            xlab(PC1) + 
###            ylab(PC2) +
###            theme_classic() +
###            ggtitle(title) +
###            #theme(plot.title = element_text(hjust = 0.5), axis.title = element_text(size = 7))
###            theme(plot.title = element_text(hjust = 0.5), axis.title = element_text(size = 7), legend.text=element_text(size=3), legend.position = "bottom")
###         #print(p)
###         tmp <- list(p)
###         l[[name]] <- tmp
###         #dev.off()
###      }
###   }
###   mylegend <- g_legend(l$PC4_PC1[[1]])
###   png( paste("results/8_PCA/",PC1,".png" ,sep="")    , width=6, height=4, res=200, unit="in")
###   ##Cambiar manualmente nomr de elementos a agregar acorde a la lista generada en cada iteracion
###   GRID <- grid.arrange(arrangeGrob(l$PC4_PC1[[1]] + theme(legend.position="none"),
###                                    l$PC4_PC2[[1]] + theme(legend.position="none"),
###                                    l$PC4_PC3[[1]] + theme(legend.position="none"),
###                                    nrow=1),
###                        mylegend, nrow=2,heights=c(8, 2))
###   dev.off()
###}

#grid.arrange(arrangeGrob(PC1_PC2 + theme(legend.position = "none"), PC1_PC3 + theme(legend.position = "none"), PC1_PC4 + theme(legend.position = "none"), PC2_PC3 + theme(legend.position = "none"), PC2_PC4 + theme(legend.position = "none"), PC3_PC4 + theme(legend.position = "none"), ncol = 3, nrow = 2, top = textGrob("Análisis de Componentes Principales GSA2019", gp = gpar(fontface = 8, fontsize = 8), hjust = 0.5, y = 0.5)),mylegend, nrow = 2, heights = c(22,1))


