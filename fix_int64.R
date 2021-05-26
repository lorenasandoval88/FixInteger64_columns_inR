library(tidyverse)
library(boxr)
data = box_read(814606954122)
type(data) #check is columns are type int64 as opposed to int32 orstring
is.integer64 <- function(x){
  class(x)=="integer64"
}

df_mut <- c %>%
  mutate_if(is.integer64, as.integer)
