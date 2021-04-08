##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param PlantRows
##' @param Checks
prepare_PrintingLabels <- function(PlantRows = Cleaned_Data$All, Checks =
                                   file_in(!!checkFile)) {
  
  # Read in the check data
  CheckData <- read_excel(Checks)
  
  # Only keep a selection of the columns for the other plant rows
  ReducedData <- PlantRows %>%
    dplyr::select(testName, gen, cross, mg, plant_number, protein, oil, p_o, nir_number) %>%
    rename(nir_number_2019 = nir_number) %>%
    mutate(plant_number = as.character(plant_number))
  
  # Split each data set according to test name
  SplitChecks  <- split(CheckData, CheckData$testName)
  SplitReduced <- split(ReducedData, ReducedData$testName)
  
  FinalData <- vector("list", length = length(SplitReduced))
  for(i in seq_along(SplitReduced)){
    
    CurrentData     <- SplitReduced[[i]]
    CurrentTestName <- names(SplitReduced)[[i]]
    
    CurrentChecks   <- SplitChecks[[CurrentTestName]]
    
   FinalData[[i]] <- reduce(list(CurrentChecks, CurrentData, CurrentChecks), bind_rows)
  }
  
  AllData <- reduce(FinalData, bind_rows)
  
  AllData$`2021 Row#` <- as.character(1:nrow(AllData)) %>% str_pad(4, pad = "0") %>% paste0("RM21-", .)
  
  AllData %>%
    dplyr::select(`2021 Row#`, 
                  testName, 
                  gen, 
                  cross, 
                  mg, 
                  plant_number, 
                  protein, 
                  oil, 
                  p_o, 
                  nir_number_2019)
}
