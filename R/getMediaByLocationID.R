# Get Media By Location ID
#
# this function outputs a data frame translated from a json download
# from the instagram link.
#
#INPUTS:
# tag - string that will be searched on instagram
# n - number of images to look at
# maxID - identifier to specify search location
#
#OUTPUTS:
#
# dataframe -  n x 15 dataframe of media information.
# colnames : commenst_disabled, id, tumbnail_src, tumbnail_resources, is_video,
# code, date, display_src, video_views, caption, dimension.height,
# dimensions.wdith, owner.id, comments.count, likes.count


getMediaByLocationID <- function(locationID, n = 12, maxID = ""){

  #indexing variable
  i <- 0

  #boolean for checking on more data available
  moreAvailable <- TRUE

  #Empty data frame for rows to be addded to
  data <- data.frame()


  #will run while more data exists and it has not reached n results
  while(moreAvailable && i < n){

    #create the url from Json Link
    url <- getMediaJsonByLocationIDLink(locationID,maxID)

    #the unflattened response
    response <- jsonlite::fromJSON(url)

    #flattening the data down to the nodes, into a dataframe
    media <- jsonlite::flatten(response$location$media$nodes)

    #iterating over the rows of the media
    for(row in 1:nrow(media)){

      #will exit loop and return data if reaching the limit
      if(i == n){
        return(data)
      }

      #will add a new row of media to data
      data <- rbind(data,media[row,])

      #incrementing the counting index
      i <- i + 1

    }

    #Where to start the next query to the instagram link
    maxID <- response$location$media$page_info$end_cursor
    #makes sure more exists
    moreAvailable <- response$location$media$page_info$has_next_page

  }

  #convert the json data to R dataframe
  return(url)
}