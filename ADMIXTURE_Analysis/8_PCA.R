library(ggplot2)
library(gridExtra)
library(grid) ##textGrob

pca <- read.table("results/8_PCA/LACRN_filter3_PCA.eigenvec", header = F)
n_pca <- length(pca)-2
colnamesPCA <- 1:n_pca
colnamesPCA <- paste("PC",colnamesPCA ,sep = "")
colnamesPCA <- append(c("Sample_ID", "Fam_ID"),colnamesPCA)
colnames(pca) <- colnamesPCA
samples <- read.csv("inputs/2_quality_control/SampleSheet.csv")
samples2 <- samples[,c(1,8)]
samples2$Country <- gsub("\\+","_",samples2$Country)
samples2$Country <- gsub("\\(","_",samples2$Country)
samples2$Country <- gsub("\\)","_",samples2$Country)
samples2$Country <- gsub("/","_",samples2$Country)
resumen <- merge(pca,samples2,by = "Sample_ID", all = T)
resumen2 <- resumen[!is.na(resumen$PC1),]
resumen2$Country[is.na(resumen2$Country)] <- "Unknown"

#Meuestra out 203299780240_R01C01 en PC3
resumen2 <- resumen2[resumen2$Sample_ID != "203299780240_R01C01",]

g_legend<-function(a.gplot){
   tmp <- ggplot_gtable(ggplot_build(a.gplot))
   leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
   legend <- tmp$grobs[[leg]]
   return(legend)}

for (pc in 1:4) {
   l <- list()
   for (pc2 in 1:4) {
      if(pc != pc2){
         title <- paste("PC", pc," VS PC", pc2,sep = "")
         name <- paste("PC", pc,"_PC", pc2,sep = "")
         print(title)
         PC1 <- paste("PC", pc, sep = "")
         PC2 <- paste("PC", pc2,sep = "")
         #PC1_data <- resumen2[,PC1]
         #PC2_data <- resumen2[,PC2]
         p <- ggplot(resumen2,  aes_string(x= PC1,y=PC2,col="Country")) +
            geom_point(aes(shape = Country, color = Country), size = 0.4, alpha = 0.4) +  #Size and alpha just for fun
            scale_color_manual(values = c("#94CE94", "#A9F5F5", "#E90C7A", "#0C18C4", "#A5A2A4", "#EFEF8E", "#DBDB90", "#7CB7B7","red","blue","yellow")) +#your colors here
            scale_shape_manual(values = c(2,3,20,21,7,8,4,5,1,10,12)) +
            xlab(PC1) + 
            ylab(PC2) +
            theme_classic() +
            ggtitle(title) +
            #theme(plot.title = element_text(hjust = 0.5), axis.title = element_text(size = 7))
            theme(plot.title = element_text(hjust = 0.5), axis.title = element_text(size = 7), legend.text=element_text(size=3), legend.position = "bottom")
         #print(p)
         tmp <- list(p)
         l[[name]] <- tmp
         #dev.off()
      }
   }
   mylegend <- g_legend(l$PC4_PC1[[1]])
   png( paste("results/8_PCA/",PC1,".png" ,sep="")    , width=6, height=4, res=200, unit="in")
   ##Cambiar manualmente nomr de elementos a agregar acorde a la lista generada en cada iteracion
   GRID <- grid.arrange(arrangeGrob(l$PC4_PC1[[1]] + theme(legend.position="none"),
                                    l$PC4_PC2[[1]] + theme(legend.position="none"),
                                    l$PC4_PC3[[1]] + theme(legend.position="none"),
                                    nrow=1),
                        mylegend, nrow=2,heights=c(8, 2))
   dev.off()
}




















#grid.arrange(arrangeGrob(PC1_PC2 + theme(legend.position = "none"), PC1_PC3 + theme(legend.position = "none"), PC1_PC4 + theme(legend.position = "none"), PC2_PC3 + theme(legend.position = "none"), PC2_PC4 + theme(legend.position = "none"), PC3_PC4 + theme(legend.position = "none"), ncol = 3, nrow = 2, top = textGrob("Análisis de Componentes Principales GSA2019", gp = gpar(fontface = 8, fontsize = 8), hjust = 0.5, y = 0.5)),mylegend, nrow = 2, heights = c(22,1))


