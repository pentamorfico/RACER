args = commandArgs(trailingOnly=TRUE)

ndg.file <- args[1]
overlap.file <- args[2]
output.file <- args[3]
#organism <- args[4] #poner un parametro en param_file con el nombre de la base de datos del organismo en bioconductor


get.first <- function(elto)
{
  return(strsplit(elto,"\\.")[[1]][1])
}

peaks.overlap <- read.table(file=overlap.file,header=TRUE,comment.char="%",fill=TRUE)
overlapping.genes <- as.vector(peaks.overlap[["OverlapGene"]])

overlapping.genes <- sapply(overlapping.genes,get.first)
names(overlapping.genes) <- NULL
overlapping.genes <- unique(overlapping.genes)
length(overlapping.genes)

peaks.ndg <- read.table(file=ndg.file,header=TRUE,comment.char="%",fill=TRUE)
head(peaks.ndg)
fw.genes <- as.vector(peaks.ndg[["Downstream_FW_Gene"]])
rv.genes <- as.vector(peaks.ndg[["Downstream_REV_Gene"]])

ndg.fw.genes <- as.vector(fw.genes[peaks.ndg[["X.Overlaped_Genes"]] == 0 &
                          (peaks.ndg[["Distance"]] < peaks.ndg[["Distance.1"]]) &
                          (peaks.ndg[["Distance"]] < 2000)])
ndg.rv.genes <- as.vector(rv.genes[peaks.ndg[["X.Overlaped_Genes"]] == 0 &
                         (peaks.ndg[["Distance_fw"]] > peaks.ndg[["Distance.1"]]) &
                         (peaks.ndg[["Distance.1"]] < 2000)])

ndg.genes <- c(ndg.fw.genes,ndg.rv.genes)
ndg.genes <- sapply(ndg.genes,get.first)
names(ndg.genes) <- NULL
length(ndg.genes)

target.genes <- unique(c(ndg.genes,overlapping.genes))
length(target.genes)
write(as.vector(unlist(target.genes)),file=output.file)
