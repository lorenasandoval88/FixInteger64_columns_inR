library(tidyverse)
library(boxr)

# GET BIGQUERY TABLE AND UPLOAD TO BOX-----------------------------

# bigquery authorization - please select your NIH email in the console below
bq_auth()

# box authorization 
box_auth(client_id = "627lww8un9twnoa8f9rjvldf7kb56q1m",client_secret =  "gSKdYKLd65aQpZGrq9x4QVUNnn5C8qqm")    

# project
project <- "nih-nci-dceg-connect-dev"

#query
sql = "Select *, CAST (Connect_ID as STRING) AS Connect_ID2 from `nih-nci-dceg-connect-dev.Connect.Sanford_recruitment_AM`"

# download bq table
tb <- bq_project_query(project, sql)
Sanford_AM = bq_table_download(tb)

# added fix 0525, to populate missing connectIDs
# replace ConnectID (int) with Connect_ID2 (char), then remove Connect_ID2
# Sanford_AM$Connect_ID = Sanford_AM$Connect_ID2
# Sanford_AM = subset(Sanford_AM, select=-c(Connect_ID2))

# check column types for the entire datafram and for the connectID column
type(Sanford_AM)

Sanford_AM$Connect_ID # here connectId is int32 and we have 10 missing values
# CONNECTID TYPE INT64 WAS FORCED TO TYPE 32 ******
# values above 4.2 billion can't be processed as int32

Sanford_AM$Connect_ID2 # here connectId is string and we have 0 missing values

# READ BOX FILE--------------------------------------------------------------
data = box_read(815035904998)
type(data) #check is columns are type int64 as opposed to int32 orstring

# function to check for integer64
is.integer64 <- function(x){
  class(x)=="integer64"
}

# convert function64 column to integer32
df_mut <- data %>%
  mutate_if(is.integer64, as.integer)

# FIXED! --------------------------------------------

# option to edit int type in download
Sanford_AM2 = bq_table_download(tb, bigint = c("integer64"))

#length is 21 for a 10 digit value
sapply(Sanford_AM2$Connect_ID[31], nchar)

#length is 10 for a 10 digit value if coverted to string
sapply(toString(Sanford_AM2$Connect_ID[31]), nchar)
