# To get an API key
# registered here: https://cloud.google.com/maps-platform/#get-started
# you will need to provide credit card information, but google will give you $300 credit to try for 12 months 

# you can have 2500 query at most evey day (ie. geocode 2500 address)


# Geo coding in R ---------------------------------------------------------
library(tidyverse) # data wrangling
library(ggmap) # geo-code

# sample data file 
dt <- tibble(
  school = c("MIT Sloan Business School", 
             "Unveristy of Michigan, School of Public Health", 
             "Harvard Medical School"),
  street_address = c("100 Main St", "1415 Washington Heights", "25 Shattuck St"),
  city = c("Cambridge", "Ann Arbor", "Boston"),
  state = c("MA", "MI", "MA"),
  zipcode = c("02142", "48109", "02115")
)

# create a complete address
dt <- dt %>% 
  distinct(street_address, city, state, zipcode) %>% 
  mutate(
    address_complete = paste(street_address, city, state, sep = ", "),
    lon = NA_real_, # place holder
    lat = NA_real_ # place holder
  )


# register the API key (only need to do once)
API_key <- "########"
register_google(key = API_key, write = TRUE)


# geo-code the address
for (i in 1:nrow(dt)) {
  result <- geocode(dt$address_complete[i], output = "latlona", source = "google")
  dt$lon[i] <- as.numeric(result[1])
  dt$lat[i] <- as.numeric(result[2])
}

# write out
write.csv(dt, "~/All_addressed_geocoded.csv", row.names = FALSE)

