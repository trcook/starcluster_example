options(repos=structure(c(CRAN="http://cran.case.edu/")))
packages=c("caret","gbm",'data.table','caretEnsemble','frbs','foreign',"devtools","Matching")
install.packages(packages,dependencies=T)

require('devtools')
install_github("trcook/tmisc",subdir="tmisc")


#To run in parallel:
# require(doSNOW)
# n = 2 # number of cores on each node
# clist<-c(rep('localhost',n),rep("node001",n)) # i.e. repeat node name for the # of cores on each node
# cl<-makeSOCKcluster(clist)
# registerDoSNOW(cl)
# parallel code here
# stopCluster(cl)