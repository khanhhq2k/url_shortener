# Technical notes for URL shortener @ Oivan

## 1. Setup
  - Rails 7.1.2 API mode, Ruby 3.1.2, Postgresql@15

  + Run project in local environment:
    - Run `bundle install` - install gems
    - Run `rails db:prepare` - prepare database + migration
    - Run `rails s` - start server in port 3000

  + Deployment tool:
    - https://kamal-deploy.org/ by Basecamp

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
## 2.  **==To Be Continued==**
- Implement authorization system for users so they can manage their shortened links, it would be nice if we have also link tracking(clicks,...)
-  Nice to have:
  + link tracking(clicks,...)
  + Payment service(?)
  + Improve cache system using Redis
- Explain furthermore about solution applied(algorithm / hash collision resolve/...)
- Scaling the system for a large set of users