# Copyright 2016 Alberto Termanini


#----------------------- GLOBALS:
rm(list=ls());
options(stringsAsFactors = F); 

#----------------------- LIBRARIES:
library("getopt");

#----------------------- CONSTANTS:

#----------------------- FUNCTIONS:
verbose = function(txt) {
  # Invia a stderr la stringa txt preceduta dalla data ed ora di sistema
  dt = format(Sys.time(), "%Y-%m-%d %H:%M:%S");
  write(paste0("[", dt, "] ", txt), stderr());
}

#----------------------- PARAMETERS:
#0: no argument
#1: required argument
#2: optional argument
#args types: logical, integer, double, character
m = matrix(c(
  "verbose", "v", "0", "logical", "verbose mode on",
  "help"   , "h", "0", "logical", "this help",
  "infile",  "i", "1", "character", "input file (tab-delimited with one line of header)",
  "outfile", "o", "1", "character", "output file (PDF)",
  "title", "t", "2", "character", "plot title (default = Boxplots)",
  "xlab", "x", "2", "character", "x-axys label (default = Groups)",
  "ylab", "y", "2", "character", "y-axys label (default = Value)",
  "rotate-labs", "r", "0", "logical", "rotate labels in vertical position",
  "log2", "l", "0", "logical", "log2 transformation"  
 ), byrow=TRUE, ncol=5);
opt = getopt(spec = m, opt = commandArgs(TRUE));

# help:
if ( !is.null(opt$help) ) {
  cat(getopt(m, usage=TRUE));
  quit(status=1);
}

# defaults:
if ( is.null(opt$"verbose" ) )		{ opt$"verbose" = FALSE; }
if ( is.null(opt$"title") )     	{ opt$"title" = "Boxplots"; }
if ( is.null(opt$"xlab") )      	{ opt$"xlab" = "Groups"; }
if ( is.null(opt$"ylab") )      	{ opt$"ylab" = "Value"; }
if ( is.null(opt$"rotate-labs" ) )	{ opt$"rotate-labs" = FALSE; }
if ( is.null(opt$"log2" ) )			{ opt$"log2" = FALSE; }

# print values:
if (opt$"verbose"==TRUE) 			{ print(opt); }

# requirements:
if ( is.null(opt$"infile") )		{ quit(status=1); }
if ( is.null(opt$"outfile") )		{ quit(status=1); }


#----------------------- READING DATA:
if (opt$"verbose"==TRUE) { verbose("Reading data"); };

if(file.exists(opt$"infile")) {
  
  data = read.table(opt$"infile", sep="\t", header=T);
} else {
  
  verbose(paste0("ERROR: file does not exist, exit. File: ", opt$infile));
  quit(status = 1);
}

#----------------------- DATA PROCESSING:
if (opt$"verbose"==TRUE) { verbose("Processing data"); }
if(opt$"log2"==TRUE) {
	
	data[data<=0] = min(data[data>0]);	# avoid log2 of zero or negative values
	data = log2(data);
}

#----------------------- MAKING PLOT:
if (opt$"verbose"==TRUE) { verbose("Making plot") };
pdf(file=opt$"outfile");

my_las=1;
if(opt$"rotate-labs"==TRUE) {
	par(xpd=T, mar=par()$mar+c(5,0,0,0));
	my_las=2;
} else {
	my_las=1;
}
boxplot(data, 
		cex.names=0.7,
		xlab=opt$"xlab", 
		ylab=opt$"ylab", 
		main=opt$"title", 
		las=my_las,
		outline = FALSE);
dev.off();

#----------------------- SESSION INFO:
if(opt$"verbose") {

  sink(file = stderr());
  print(paste0("Date: ", Sys.Date()));
  print("#---------------------[SESSION INFO]---------------------");
  print(sessionInfo());    
}

#----------------------- EXIT:
quit(status=0);
