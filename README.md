# Technical notes for URL shortener @ Oivan

## 1. Setup
  - Rails 7.1.2 API mode, Ruby 3.1.2, Postgresql@15

  + Run project in local environment:
    - Run `bundle install` - install gems
    - Run `rails db:prepare` - prepare database + migration
    - Run `rails s` - start server in port 3000

  - a Dockerfile is generated(from Rails 7.1), it can be used for deployment or dockerized Rails app
  - Demo Url: http://149.28.144.40

  + Testing
    - `rspec` to run all existing specs.
    - Create new shortened url:
      ```
        curl -X POST http://149.28.144.40/urls/encode \
        -H 'content-type: application/json' \
        -d '{
        "url": "https://tuoitre.vn/de-nghi-tang-luong-khoi-diem-cua-bac-si-20231202192344949.htm"
        }'
      ```
    - Decode url to get original link:
      ```
        curl -X POST http://149.28.144.40/urls/decode \
        -H 'content-type: application/json' \
        -d '{
        "url": "http://149.28.144.40/D73g0"
        }'
      ```

## 2. Requirements and drafting solution
 - Each unique URL will be shortened and save into database
 - The hashValue consists of characters from [0-9, a-z, A-Z], containing 10 + 26 + 26 = 62
possible characters
 - "Unique" means if users request to shorten an URL which is process already, we will return the existing shortened URL instead of create a new one(to prevent duplication)
 - "Unique" might help to save some data but should be turned off if have a relation like Users -(One to many)-> Urls
 - From the requirement Hash value have maximum of 5 chars(N), so I decided to use Base62 encoding, which suits url regular characters(Ref Table 1 for calculation)
 - Main solution: MD5(URL + Random(10_000_000_000)) => Base62 encoding => Hash value
 - When users request to get original url(Decode), server performs a search in two places:
	 - Cache
	 - Perform SQL search for the hash_value in shortened url


| N | Maximum URL numbers |
|-----------------------------|-----------------------------|
|1|62^1 = 62|
|2|62^2 = 3,884|
|3|62^3 = 238,328|
|4|62^4 = 14,776,336|
|5|62^5 = 916,132,832|
|6|62^6 = 56,800,235,584|

## 3. Operation cost
- Assume there are 10 millions new URLs created everyday
- Write operation per second: 10_000_000/24/3600 = 116
- Assume write:read ratio is 1:10, so 116*10 = 1160
- For N = 5, we have 916,132,832 unique shortened urls, so the application can run for just 91,6 days ~ 3 months!!!
- We might have to extend N to 6, 7 or even 8 like tinyurl, for N=6 we would have 56.8 biillions urls, which would be enough for 15 years  
- Storage
	- Assume average URL length is 100 chars =  100 bytes, a db record is 200 bytes in size, so to run for 15 years, we would need to have 56,8 billions * 200 bytes memory, which equals to 11.36 Terabytes
## 3. Performance and real life problems
- Least recently used(LRU) cache is implemented to store 50 last visited urls, to cut down sql hit
- Proper index in URL table
- 


## 5.  **==To Be Continued==**
- Implement authorization system for users so they can manage their shortened links, it would be nice if we have also link tracking(clicks,...)
-  Nice to have:
  + link tracking(clicks,...)
  + Payment service(?)
  + Improve cache system using Redis
- Explain furthermore about solution applied(algorithm / hash collision resolve/...)
- Scaling the system for a large set of users
