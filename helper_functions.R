
getCleanFilingInfo <- function(){
    # browser()
    path=file.path(getwd(), 'data')
    # Get all of the 10-K and 10-Q filenames
    f10Q_filings <- list.files(path, pattern = '*10-Q')
    f10K_filings <- list.files(path, pattern = '*10-K')
    fileNames <- c(f10Q_filings,f10K_filings)
    
    # Extract the report dates
    report_date <- as.Date(ifelse(nchar(fileNames)==25+4,
                                  substr(fileNames,12,21), 
                                  ifelse(nchar(fileNames)==26+4,
                                         substr(fileNames,13,22)
                                         ,NA_integer_)), origin='1970-01-01')
    
    # Extract the report types
    report_type <- ifelse(nchar(fileNames)==25+4,
                          substr(fileNames,7,10),
                          ifelse(nchar(fileNames)==26+4,
                                 substr(fileNames,8,11),
                                 NA))
    # Extract the cik numbers
    cik_no <- ifelse(nchar(fileNames)==25+4,
                     substr(fileNames,1,5),
                     ifelse(nchar(fileNames)==26+4,
                            substr(fileNames,1,6),
                            NA))
    
    # Add column for ticker
    ticker <- ifelse(cik_no=='72971',
                     'WFC',
                     ifelse(cik_no=='19617',
                            'JPM',
                            ifelse(cik_no=='70858',
                                   'BOA',
                                   ifelse(cik_no=='831001',
                                          'CBNA',
                                          ifelse(cik_no=='927628',
                                                 'COF',
                                                 NA)))))
    
    # Get the report file paths
    files <- file.path(path, fileNames)
    
    # Get each file size (in megabytes)
    size_MB <- vapply(X=1:length(files), 
                      FUN=function(i) file.info(files[i])$size, 
                      FUN.VALUE = numeric(1))/1000000
    
    idx_order <- order(as.numeric(report_date))
    
    # Store filing information in a dataframe
    files_df <- data.frame(
        cik_no = cik_no,
        ticker=ticker,
        report_type = report_type,
        report_date = report_date,
        report_file_path = files,
        size_MB = size_MB,
        stringsAsFactors = F)
    
    files_df <- files_df[idx_order,]
    row.names(files_df) <- 1:nrow(files_df)
 
    # Return dataframe
    return(files_df)
}

