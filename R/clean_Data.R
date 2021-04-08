##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param data
clean_Data <- function(data = dataFiles) {

  # Read in all the selections
  allFiles <- lapply(data, read_excel)
  
  # Get the test names from the file names
  fileNames <- file_path_sans_ext(basename(data))
  
  # Notes that I want to exclude from selections
  BadQualitites <- c("POOR QUALITY", 
                     "PQ", 
                     "WRINKLED SEED", 
                     "HILUM BLEEDING", 
                     "SOME HILUM BLEEDING",
                     "MIXED HILUM", 
                     "GREEN SEED", 
                     "BLEEDING HILUM")

  # A function to clean the data in one file. The filter function
  # excludes rows with fewer than 80 seeds or those that have notes that indicate bad seed. 
  cleanFn <- function(oneFile){
    oneFile %>%
      clean_names() %>%
      remove_empty(which = "rows") %>%
      mutate(seed_number = as.numeric(str_match(as.character(seed_number),"[0-9]+"))) %>%
      mutate(notes = toupper(notes)) %>%
      dplyr::filter(seed_number >= 100 | is.na(seed_number), !(notes %in% BadQualitites) | is.na(notes))
  }
  
  # Clean all the files using this function
  allData <- lapply(allFiles, cleanFn)
  
  # Add the test names to the files
  for(i in 1:length(allData)){
    allData[[i]]$testName <- fileNames[[i]]
  }
    
  # Bind everything into a single dataframe
  allData <- do.call(bind_rows, allData)
  
  # Sort by NIR number, remove crosses 41-44 and return
  
  allData %>% 
    separate(nir_number, into = c("nir", "nirNumber"), sep = "-") %>% 
    arrange(nirNumber) %>% unite("nir_number", nir:nirNumber, remove = TRUE) %>% 
    separate(cross, into = c("Mx", "CrossNum", "SampleNum")) %>%
    dplyr::filter(CrossNum %in% c("41", "42", "43", "44")) %>%
    unite(cross, c("Mx", "CrossNum", 'SampleNum'), sep = "-")%>%
    mutate(cross = str_replace(cross, "-NA", "")) -> HollData
  
  allData %<>% 
    separate(nir_number, into = c("nir", "nirNumber"), sep = "-") %>% 
    arrange(nirNumber) %>% unite("nir_number", nir:nirNumber, remove = TRUE) %>% 
    separate(cross, into = c("Mx", "CrossNum", "SampleNum")) %>%
    dplyr::filter(!(CrossNum %in% c("41", "42", "43", "44"))) %>%
    unite(cross, c("Mx", "CrossNum", 'SampleNum'), sep = "-")%>%
    mutate(cross = str_replace(cross, "-NA", ""))
  
  return(list("All" = allData, "HOLL" = HollData))
}
