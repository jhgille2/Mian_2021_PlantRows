
dataFiles <- list.files(paste0(here(), "/Data/"), full.names = TRUE)
dataFiles <- dataFiles[which(file_ext(dataFiles) == "xlsx")]

checkFile <- paste0(here(), "/Data/Checks/CheckData.xlsx")

the_plan <-
  drake_plan(

   ## Plan targets in here.
    Cleaned_Data = clean_Data(data = file_in(!!dataFiles)),
    
    Export_Prepared = prepare_Export(Cleaned_Data$All),
    Holl_Prepared   = prepare_Export(Cleaned_Data$HOLL),
    
    PrintFile = prepare_PrintingLabels(PlantRows = Cleaned_Data$All, Checks = file_in(!!checkFile)),
    
    PrintWorkbook = prepare_PrintWorkbook(PrintFile),
    
    Data_Export = saveWorkbook(Export_Prepared, 
                               file = file_out(!!paste0(here(), "/PRows_2021_Mian_New.xlsx")),
                               overwrite = TRUE),
    
    Holl_Export = saveWorkbook(Holl_Prepared, 
                               file = file_out(!!paste0(here(), "/Holl_Lines.xlsx")),
                               overwrite = TRUE),
    
    PrintFile_Export = saveWorkbook(PrintWorkbook, 
                                    file = file_out(!!paste0(here(), "/PlantRows_2021_PrintFile.xlsx")), 
                                    overwrite = TRUE)
    
    
)
