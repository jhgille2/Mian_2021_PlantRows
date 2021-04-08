##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param Cleaned_Data
prepare_Export <- function(Cleaned_Data) {

  SplitData <- split(Cleaned_Data, Cleaned_Data$testName)
  
  wb <- createWorkbook()
  
  for(i in 1:length(SplitData)){
    TestName <- unique(SplitData[[i]]$testName)
    addWorksheet(wb, sheetName = TestName)
    writeData(wb, TestName, SplitData[[i]])
  }
  
  return(wb)
}
