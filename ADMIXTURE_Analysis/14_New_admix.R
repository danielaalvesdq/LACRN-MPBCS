# Plot ADMIXTURE 
#/media/cyanez/4A3056073055FB01/Cyanez/180410_leftraru_imputacion1/7_set_ref_muestra_LD_y_admixture

path_output <- file.path("results", "14_Admixture")
path_data  <- file.path("data_processing", "14_Admixture")
path_input  <- file.path("data_processing", "14_Admixture")


# Set working directory
if(basename(getwd())=="code"){
  if(!file.exists(path_data))
    stop("Input directory doesn't exist: ", path_data)
  if(!file.exists(path_output))
    dir.create(path_output, mode = "0755", recursive=T)
}

sortAncestryComps <- function(x, pops, poporder, rename=T) {
    if(! all(pops %in% poporder)) {
      stop("poporder is incomplete. It must contain the name of all populations in vector pops, in the desired order.")
    }
    poporder <- poporder[poporder %in% pops]
    anc.mean <- apply(x, 2, tapply, pops, mean)
    anc.mean <- anc.mean[match(poporder, row.names(anc.mean)),]
    coli <- 1:ncol(anc.mean)
    usedi <- NULL
    anc.out <- NULL
    outcol  <- NULL
    outpop  <- NULL
    for(j in 1:nrow(anc.mean)) {
        if(length(coli)<1) break
        jmax <- which.max(anc.mean[j,coli])
        anc.out <- cbind(anc.out, x[,coli[jmax]])
        outcol <- c(outcol, colnames(x)[coli[jmax]])
        outpop <- c(outpop, poporder[j])
        usedi <- c(usedi, coli[jmax])
        coli <- setdiff(coli, usedi)
    }
    if(rename) {
      colnames(anc.out) <- outpop
    } else {
      colnames(anc.out) <- outcol
    }
    if(length(coli)>0)
      anc.out <- cbind(anc.out, x[,coli])
    rownames(anc.out) <- rownames(x)
    anc.out
}

adx_files <- dir(path_data, patt=".Q$", full.names=T)

###Arreglar el orden de los K, dado que no se leen en orden
#data1<-adx_files[2:9]
#data2<-adx_files[1]
#
#data1[9]<-data2[1]
#adx_files<-data1

errors  <- read.table(file.path(path_data, "CV_1000G_AYM_MAP_LACRN_LD_SORT.txt"))
popinfo <- read.table(file.path(path_data, "popinfo_1000G_AYMARA_MAPUCHE_LACRN.csv"),header=T,sep="\t")
popinfo$Population <- popinfo$Ancestry
fam     <- read.table(file.path(path_data, "1000G_AYM_MAP_LACRN_LD_SORT.fam"),sep=" ")
samps <- fam[,1]
#samps <- fam[,2]

#popinfo
#print("############")
#fam

#if(!all(samps %in% popinfo[,"IndID"]))
#  stop("Not all individuals in popinfo file")
  
popinfo <- popinfo[popinfo[,"IndID"] %in% samps,]
cverr <- errors[,2]
K     <- errors[,1]
adx_files <- adx_files[order(K)]
cverr <- cverr[order(K)]
K <- K[order(K)]
adx_files <- paste("data_processing/14_Admixture/1000G_AYM_MAP_LACRN_LD_SORT", K, "Q", sep=".")

popinfo$slab <- sprintf("%-10s %8s", popinfo$IndID, popinfo$Ancestry)
x_pop <- tapply((1:nrow(popinfo))*1.2, popinfo$Population, mean)
m_pop <- tapply((1:nrow(popinfo))*1.2, popinfo$Population, max)

x_anc <- tapply((1:nrow(popinfo))*1.2, list(popinfo$Ancestry, popinfo$Population), mean)
x_anc_ls <- list()
for(anc in rownames(x_anc)) {
  x_anc_ls[[anc]] <- x_anc[anc, !is.na(x_anc[anc,])]
}
x_anc_vec <- unlist(x_anc_ls)
names(x_anc_vec) <- sub("\\..*$", "", names(x_anc_vec))

pops  <- unique(as.character(popinfo$Population))
N_pop <- length(pops)

#palette(rainbow(max(N_pop, max(K))))
#comps_palette <- c("brown3", "forestgreen", "darkslategray2", "darkorange1", "mediumorchid4",  "lightpink", "cadetblue3", "burlywood", "darkolivegreen2", "lightpink1", "lightskyblue3", "rosybrown4", "darkorchid", "hotpink2", "navy", "yellow2", "sienna3", "seashell2", "lightgoldenrod4", "magenta")
#comps_palette <- c("darkorchid", "hotpink2", "navy", "yellow2", "sienna3", "seashell2", "lightgoldenrod4", "magenta")
comps_palette <- c("brown3", "forestgreen", "darkslategray2", "darkorange1", "mediumorchid4", "lightpink", "darkblue","yellow1", "darkolivegreen2", "lightpink1", "goldenrod1", "cadetblue3", "burlywood", "lightskyblue3", "rosybrown4")

palette(comps_palette)

pdf(file.path(path_output, "CV_1000G_AYM_MAP_LACRN.pdf"), width=6.5, height=4)
#png(file.path(path_output, "CV.png"), width=2000, height=1200)
plot(cverr~K, ylab="error VC", type="b", col="darkblue", las=1, main="Error de validacion cruzada ADMIXTURE")
dev.off()

#pdf(file.path(path_output, "ADMIXIRE_Kn.pdf"))
pdf(file.path(path_output, "ADMIXIRE_Kn_1000G_AYM_MAP_LACRN.pdf"), paper="letter")
  par(mfrow=c(4, 1), cex.axis=.4, mar=c(6, 4, 3, 1))
  for (i in 1:length(K)) {
    qtbl <- read.table(adx_files[i])
    qtbl <- qtbl[match(popinfo[,"IndID"], samps),]
    qtbl <- sortAncestryComps(qtbl, popinfo$Population, unique(popinfo$Population))
    qtbl <- t(as.matrix(qtbl))#[,rev(1:ncol(qtbl))])
    barplot(qtbl, main=sprintf("K=%i", K[i]), xlab="sample", ylab="Ancestry", col=1:nrow(qtbl), border=NA, names.arg=popinfo$IndID, las=2,xaxt='n')
    text(x_pop, 1.05, names(x_pop), srt=45, font=2, cex=.5, adj=0, xpd=NA)
    text((1:ncol(qtbl))+cumsum(c(0,rep(.2,ncol(qtbl)-1)))-.5, par("usr")[3]-0.05, srt = 90, adj = 1 , labels = popinfo$slab, xpd = TRUE, cex=0.1)
    abline(v=m_pop, col="blue", lwd=.2)
  }
dev.off()

pdf(file.path(path_output, "ADMIXTURE_K_4_6_1000G_AYM_MAP_LACRN.pdf"))
#png(file.path(path_output, "REF_PatagDoc_K4_5_6_REAP.png"), width=2000, height=1200)
  par(mfrow=c(3, 1), cex.axis=.4, mar=c(6, 4, 3, 1))
  for (i in 2:4) {
    qtbl <- read.table(adx_files[i])
    qtbl <- qtbl[match(popinfo[,"IndID"], samps),]
    qtbl <- sortAncestryComps(qtbl, popinfo$Population, unique(popinfo$Population))
    qtbl <- t(as.matrix(qtbl))#[,rev(1:ncol(qtbl))])
    barplot(qtbl, main=sprintf("K=%i", K[i]), xlab="sample", ylab="Ancestry", col=1:nrow(qtbl), border=NA, names.arg=popinfo$IndID, las=2,xaxt='n')
    text(x_pop, 1.05, names(x_pop), srt=45, font=2, cex=.5, adj=0, xpd=NA)
    text((1:ncol(qtbl))+cumsum(c(0,rep(.2,ncol(qtbl)-1)))-.5, par("usr")[3]-0.05, srt = 90, adj = 1 , labels = popinfo$slab, xpd = TRUE, cex=0.1)
    abline(v=m_pop, col="blue", lwd=.2)
  }
dev.off()

pdf(file.path(path_output, "ADMIXTURE_K_5_1000G_AYM_MAP_LACRN.pdf"),width=20,height=5)
#png(file.path(path_output, "ADMIKTURE_K_5.png"), width=1200,height=300,units="px")
#png(file.path(path_output, "REF_PatagDoc_K5_REAP.png"), width=2000, height=1200)
    for (i in 3) {
    qtbl <- read.table(adx_files[i])
    qtbl <- qtbl[match(popinfo[,"IndID"], samps),]
    qtbl <- sortAncestryComps(qtbl, popinfo$Population, unique(popinfo$Population))
    qtbl <- t(as.matrix(qtbl))#[,rev(1:ncol(qtbl))])
    barplot(qtbl, main=sprintf("K=%i", K[i]), xlab="sample", ylab="Ancestry", col=1:nrow(qtbl), border=NA, names.arg=popinfo$IndID, las=2,xaxt='n')
    text(x_pop, 1.05, names(x_pop), srt=45, font=2, cex=.7, adj=0, xpd=NA)
    text((1:ncol(qtbl))+cumsum(c(0,rep(.2,ncol(qtbl)-1)))-.5, par("usr")[3]-0.05, srt = 90, adj = 1 , labels = popinfo$slab, xpd = TRUE, cex=0.2)
    abline(v=m_pop, col="blue", lwd=.2)
  }
dev.off()

#png(file.path(path_output, "ADMIXTURE_barplots.png"), width=6, height=4, res=200, unit="in")
pdf(file.path(path_output, "ADMIXTURE_barplots_1000G_AYM_MAP_LACRN.pdf"),width=10,height=5)
#Definir cuántos K se quieren graficar por página
  par(mfrow=c(4, 1), cex.axis=.4, mar=c(0, 1, 0, 0), oma=c(4, 0, 3,1))
#Definir qué Ks se quieren graficar
  for (i in 1:4) {
    qtbl <- read.table(adx_files[i])
    qtbl <- qtbl[match(popinfo[,"IndID"], samps),]
    qtbl <- sortAncestryComps(qtbl, popinfo$Population, unique(popinfo$Population))
    qtbl <- t(as.matrix(qtbl))#[,rev(1:ncol(qtbl))])
     barplot(qtbl, col=1:nrow(qtbl), border=NA, las=2, space=NULL, xaxt='n',yaxt='n')
    abline(v=m_pop, col="blue", lwd=.5)
    mtext(sprintf("K%i", K[i]), side=2, las=2, line=-1, adj=0.5, font=2, cex=.5)
   if(i==0){ ## para que no grafique arriba
      text(x_anc_vec, 1.05, names(x_anc_vec), srt=0, font=1, cex=.3, xpd=NA, adj=0.5)
    }
    if(i==4){
     text(-27, -.25, "K", cex=.9, xpd=NA, font=2, srt=90)
      text(x_pop, -.05, names(x_pop), srt=40, font=2, cex=.6, adj=1, xpd=NA)
    }
  }

dev.off()

