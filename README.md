# Phone Your Rep API
[![Code Climate](https://codeclimate.com/github/phoneyourrep/phone-your-rep-api/badges/gpa.svg)](https://codeclimate.com/github/phoneyourrep/phone-your-rep-api)
[![Build Status](https://travis-ci.org/msimonborg/phone-your-rep-api.svg?branch=master)](https://travis-ci.org/msimonborg/phone-your-rep-api)
[![Coverage Status](https://coveralls.io/repos/github/msimonborg/phone-your-rep-api/badge.svg?branch=master)](https://coveralls.io/github/msimonborg/phone-your-rep-api?branch=master)

The companion to [the Phone Your Rep frontend](https://github.com/kylebutts/phone_your_rep).

http://www.phoneyourrep.com

Data sources:

Congress - https://github.com/TheWalkers/congress-legislators and https://github.com/unitedstates

State and district shapefiles - https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html

ZCTA to congressional district relationship file - http://www2.census.gov/geo/docs/maps-data/data/rel/zcta_cd111_rel_10.txt

# Vagrant
If you are too busy to do the manual installation, you can download a Vagrant BOX which has the requirements below already installed, download it here.

https://s3.amazonaws.com/debugpyr/pyr.box

# Installation
```
rbenv install 2.4.1 or rvm install 2.4.1
```
Make sure you have PostgreSQL installed, and then install the PostGIS extension. If you're using MacOS you can try installing with Homebrew. Otherwise it's recommended that you use the Vagrant box.
```
brew install postgres
brew install postgis
```

Mac users can also download the [Heroku PostgreSQL app](https://postgresapp.com/) instead of running `brew install`. The app comes with the PostGIS extension enabled and everything working out of the box. This is by far the easiest route to get PostGIS on a Mac.

Then

```
gem install bundler
bundle install
```
You can setup and then fully seed the database with one command
```
bundle exec rake db:pyr:setup
```
If you've already configured and seeded the database before and just need to update, skip ahead to #Updating. If you need to set up for the first time, or reset and seed from scratch, then use `rake db:pyr:setup`. It'll take a few, so grab a cold one. If you're on MacOS, you can get an alert when it's finished by running this instead
 ```
bundle exec rake db:pyr:setup_alert
 ```
 If you're configuring for the first time and you're getting errors, or you don't want to do a complete reset, or you're some kind of control freak, here are the manual steps broken down

#### Step 1: Creating the spatial database and migrating
```
bundle exec rake db:drop # skip this unless you're resetting
bundle exec rake db:create
bundle exec rake db:gis:setup # enables the PostGIS extension
bundle exec rake db:migrate
```
Migrating is your first test that you have a properly configured database. If you get errors while migrating, you may have PostGIS configuration issues and your database is not recognizing the geospatial datatypes. Read up on the documentation for RGeo and ActiveRecord PostGIS Adapter to troubleshoot.

#### Step 2: Seeding the data
Many of the offices have coordinates preloaded in the seed data. Any that don't will automatically be geocoded during seeding.

The `geocoder` gem allows you to do some geocoding without an API key. It will probably be enough for seeding and development. However, if you want to use your own API key for geocoding, you can configure it in `config/initializers/geocoder.rb`. You will also need to check this file for deployment, as it's configured to access an environment variable for the API key in production.

If you don't want to geocode any of the offices at all, comment out this line in office_location.rb
```ruby
after_validation :geocode, if: :needs_geocoding?
```
Then seed the db
```
bundle exec rake db:seed
```
The `seeds.rb` file invokes a handful of discreet seeding tasks. If you want to isolate any of these, or seed manually, here they are broken down:
```
bundle exec rake db:pyr:seed_states
bundle exec rake db:pyr:seed_districts
```
The two tasks above load the basic state and district data such as names and codes.
```
bundle exec rake db:pyr:shapefiles
```
The `shapefiles` task loads the geographic boundary data for the states and districts, and is the last test that your database is configured properly for GIS.
```
bundle exec rake db:pyr:seed_reps
```
The `seed_reps` task loads all of the rep and office location data and generates VCards for each office.

If you want to be able to look up congressional districts by ZCTA, pass `zctas=true` as a variable to the rake task, e.g.
```
bundle exec rake db:seed zctas=true
```
or
```
bundle exec rake db:pyr:setup zctas=true
```

Finally
```
bundle exec rails s
```
#### Congrats! You've set up a geospatial database! Have a few cold ones, you deserve it.
The app is configured to get QR code images from the `phone-your-rep-images` S3 bucket by default. These QR codes are kept up to date with the current data. If you are adapting this app for a different data set and wish to generate your own, you can do so easily by following these steps:

##### Create your own dedicated S3 bucket
##### Set a `PYR_S3_BUCKET` evironment variable to the bucket name
##### Download and configure the AWS command line tool to interact with your bucket.

Then just
```
rake pyr:qr_codes:create
```
This will generate the images, empty the bucket, upload the images, and then delete the local copies. If you set the environment variable properly, your app should automatically point to the right URLs.

# Updating
If you just need to update your existing database with the most current data then run
```
rake db:pyr:update:all
```
The discreet steps are broken down as follows:
```
rake db:pyr:update:retired_reps
```
This deactivates any reps (and their office locations) that are no longer serving in congress.
```
rake db:pyr:update:current_reps
```
This updates basic info for the active reps, including name, role, state, district, and DC office. New reps will be added to the database.
```
rake db:pyr:update:socials
```
This updates the social media accounts for active reps.
```
rake db:pyr:update:office_locations
```
This updates all of the active district offices for all reps, adds new ones, and deactivates those no longer in service. Updated VCards are also generated for each office.

If you need to generate updated QR codes you can run the update command as `rake db:pyr:update:all qr_codes=true`

All of the raw data is stored in the code base as YAML files which track files from [unitedstates](https://www.github.com/unitedstates/congress-legislators) and [TheWalkers](https://www.github.com/thewalkers/congress-legislators). Each database update task automatically updates the YAML file first by `curl`-ing its online source and committing any changes. These files may be updated often, so it's recommended that you check for updates tasks once a week or so.

The full database update is a little time consuming. Fetching the raw data first can let you check for changes and save you from running the entire database update task if there are no changes made.

You can update all of the local YAML data files and commit the changes *without* updating the database by running
```
rake db:pyr:update:raw_data
```
This can be broken down into separate tasks for the individual files:
```
rake db:pyr:update:fetch_retired_reps
rake db:pyr:update:fetch_current_reps
rake db:pyr:update:fetch_socials
rake db:pyr:update:fetch_office_locations
```

For any of the individual update tasks (exlcuding `db:pyr:update:all`) you can specify a file destination other than the default by setting it in the `file` variable e.g. `rake db:pyr:update:socials file=socials.yaml`. This will download the data to `socials.yaml` in the root directory, commit the change, and update the database from that file, leaving the default file (`lib/seeds/legislators-social-media.yaml`) unchanged.

You can also specify an alternative data source (as long as it's in YAML format) by setting it as the `source` variable e.g. `rake db:pyr:update:socials source=https://www.yoursource.com/data.yaml`

# Deployment

This is deployed on Heroku. Deploying a geo-spatially enabled database to Heroku can be a bit of a challenge. Docs for that will come soon.

# Usage

### Ruby developers can try the [pyr gem](https://www.github.com/phoneyourrep/pyr)

This API is in beta. An example request to the API looks like this:
```
https://phone-your-rep.herokuapp.com/api/beta/reps?lat=42.3134848&long=-71.2072321
```

And here is the response:
```json
{
  "total_records": 3,
  "_links": {
    "self": {
      "href": "https://phone-your-rep.herokuapp.com/api/beta/reps?lat=42.3134848&long=-71.2072321"
    }
  },
  "reps": [
    {
      "self": "https://phone-your-rep.herokuapp.com/api/beta/reps/M000133",
      "state": {
        "self": "https://phone-your-rep.herokuapp.com/states/25",
        "state_code": "25",
        "name": "Massachusetts",
        "abbr": "MA"
      },
      "bioguide_id": "M000133",
      "official_full": "Edward J. Markey",
      "role": "United States Senator",
      "party": "Democrat",
      "senate_class": "02",
      "last": "Markey",
      "first": "Edward",
      "middle": "J.",
      "nickname": "Ed",
      "suffix": null,
      "contact_form": "http://www.markey.senate.gov/contact",
      "url": "http://www.markey.senate.gov",
      "photo": "https://theunitedstates.io/images/congress/450x550/M000133.jpg",
      "twitter": "SenMarkey",
      "facebook": "EdJMarkey",
      "youtube": "RepMarkey",
      "instagram": null,
      "googleplus": null,
      "twitter_id": "3047090620",
      "facebook_id": "6846731378",
      "youtube_id": "UCT1ujew5yQy2uMhGrjiKHoA",
      "instagram_id": null,
      "office_locations": [
        {
          "self": "https://phone-your-rep.herokuapp.com/api/beta/office_locations/1314",
          "id": 1314,
          "bioguide_id": "M000133",
          "office_type": "district",
          "distance": 8.2,
          "building": "975 JFK Federal Building",
          "address": "15 Sudbury St.",
          "suite": "",
          "city": "Boston",
          "state": "MA",
          "zip": "02203",
          "phone": "617-565-8519",
          "fax": "",
          "hours": "",
          "latitude": 42.3613091,
          "longitude": -71.0593927,
          "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/1314",
          "qr_code_link": "https://s3.amazonaws.com/phone-your-rep-images/9o6tqptj1_Markey_district_1314.png"
        },
        {
          "self": "https://phone-your-rep.herokuapp.com/api/beta/office_locations/1315",
          "id": 1315,
          "bioguide_id": "M000133",
          "office_type": "district",
          "distance": 42.5,
          "building": "",
          "address": "222 Milliken Blvd.",
          "suite": "Suite 312",
          "city": "Fall River",
          "state": "MA",
          "zip": "02721",
          "phone": "508-677-0523",
          "fax": "",
          "hours": "",
          "latitude": 41.6999176,
          "longitude": -71.1587266,
          "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/1315",
          "qr_code_link": "https://s3.amazonaws.com/phone-your-rep-images/3c4hp2pyzd_Markey_district_1315.png"
        },
        {
          "self": "https://phone-your-rep.herokuapp.com/api/beta/office_locations/1316",
          "id": 1316,
          "bioguide_id": "M000133",
          "office_type": "district",
          "distance": 72.4,
          "building": "",
          "address": "1550 Main St.",
          "suite": "4th Floor",
          "city": "Springfield",
          "state": "MA",
          "zip": "01101",
          "phone": "413-785-4610",
          "fax": "",
          "hours": "",
          "latitude": 42.1032165,
          "longitude": -72.5929441,
          "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/1316",
          "qr_code_link": "https://s3.amazonaws.com/phone-your-rep-images/77buuaccxv_Markey_district_1316.png"
        },
        {
          "self": "https://phone-your-rep.herokuapp.com/api/beta/office_locations/200",
          "id": 200,
          "bioguide_id": "M000133",
          "office_type": "capitol",
          "distance": 385.0,
          "building": null,
          "address": "255 Dirksen Senate Office Building",
          "suite": null,
          "city": "Washington",
          "state": "DC",
          "zip": "20510",
          "phone": "202-224-2742",
          "fax": null,
          "hours": null,
          "latitude": 38.8928318,
          "longitude": -77.0043625,
          "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/200",
          "qr_code_link": "https://s3.amazonaws.com/phone-your-rep-images/5puc375jgq_Markey_capitol_200.png"
        }
      ]
    },
    {
      "self": "https://phone-your-rep.herokuapp.com/api/beta/reps/W000817",
      "state": {
        "self": "https://phone-your-rep.herokuapp.com/states/25",
        "state_code": "25",
        "name": "Massachusetts",
        "abbr": "MA"
      },
      "bioguide_id": "W000817",
      "official_full": "Elizabeth Warren",
      "role": "United States Senator",
      "party": "Democrat",
      "senate_class": "01",
      "last": "Warren",
      "first": "Elizabeth",
      "middle": null,
      "nickname": null,
      "suffix": null,
      "contact_form": "http://www.warren.senate.gov/?p=email_senator#thisForm",
      "url": "http://www.warren.senate.gov",
      "photo": "https://theunitedstates.io/images/congress/450x550/W000817.jpg",
      "twitter": "SenWarren",
      "facebook": "senatorelizabethwarren",
      "youtube": "senelizabethwarren",
      "instagram": null,
      "googleplus": null,
      "twitter_id": "970207298",
      "facebook_id": "131559043673264",
      "youtube_id": "UCTH9zV8Imw09J5bOoTR18_A",
      "instagram_id": null,
      "office_locations": [
        {
          "self": "https://phone-your-rep.herokuapp.com/api/beta/office_locations/1897",
          "id": 1897,
          "bioguide_id": "W000817",
          "office_type": "district",
          "distance": 8.2,
          "building": "2400 JFK Federal Building",
          "address": "15 Sudbury St.",
          "suite": "",
          "city": "Boston",
          "state": "MA",
          "zip": "02203",
          "phone": "617-565-3170",
          "fax": "",
          "hours": "",
          "latitude": 42.3613091,
          "longitude": -71.0593927,
          "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/1897",
          "qr_code_link": "https://s3.amazonaws.com/phone-your-rep-images/9g9zrqnpbu_Warren_district_1897.png"
        },
        {
          "self": "https://phone-your-rep.herokuapp.com/api/beta/office_locations/1898",
          "id": 1898,
          "bioguide_id": "W000817",
          "office_type": "district",
          "distance": 72.4,
          "building": "",
          "address": "1550 Main St.",
          "suite": "Suite 406",
          "city": "Springfield",
          "state": "MA",
          "zip": "01103",
          "phone": "413-788-2690",
          "fax": "",
          "hours": "",
          "latitude": 42.1032165,
          "longitude": -72.5929441,
          "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/1898",
          "qr_code_link": "https://s3.amazonaws.com/phone-your-rep-images/61252tqznk_Warren_district_1898.png"
        },
        {
          "self": "https://phone-your-rep.herokuapp.com/api/beta/office_locations/367",
          "id": 367,
          "bioguide_id": "W000817",
          "office_type": "capitol",
          "distance": 385.0,
          "building": null,
          "address": "317 Hart Senate Office Building",
          "suite": null,
          "city": "Washington",
          "state": "DC",
          "zip": "20510",
          "phone": "202-224-4543",
          "fax": null,
          "hours": null,
          "latitude": 38.8928318,
          "longitude": -77.0043625,
          "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/367",
          "qr_code_link": "https://s3.amazonaws.com/phone-your-rep-images/4cb6hk2egn_Warren_capitol_367.png"
        }
      ]
    },
    {
      "self": "https://phone-your-rep.herokuapp.com/api/beta/reps/K000379",
      "state": {
        "self": "https://phone-your-rep.herokuapp.com/states/25",
        "state_code": "25",
        "name": "Massachusetts",
        "abbr": "MA"
      },
      "district": {
        "self": "https://phone-your-rep.herokuapp.com/districts/2504",
        "full_code": "2504",
        "code": "04",
        "state_code": "25"
      },
      "bioguide_id": "K000379",
      "official_full": "Joseph P. Kennedy III",
      "role": "United States Representative",
      "party": "Democrat",
      "senate_class": null,
      "last": "Kennedy",
      "first": "Joseph",
      "middle": "P.",
      "nickname": null,
      "suffix": "III",
      "contact_form": null,
      "url": "https://kennedy.house.gov",
      "photo": "https://theunitedstates.io/images/congress/450x550/K000379.jpg",
      "twitter": "RepJoeKennedy",
      "facebook": "301936109927957",
      "youtube": null,
      "instagram": "repkennedy",
      "googleplus": null,
      "twitter_id": "1055907624",
      "facebook_id": "301936109927957",
      "youtube_id": "UCgfHlaGqxD8p-2V_YlNIqrA",
      "instagram_id": "1328567154",
      "office_locations": [
        {
          "self": "https://phone-your-rep.herokuapp.com/api/beta/office_locations/1200",
          "id": 1200,
          "bioguide_id": "K000379",
          "office_type": "district",
          "distance": 2.9,
          "building": "",
          "address": "29 Crafts St.",
          "suite": "Suite 375",
          "city": "Newton",
          "state": "MA",
          "zip": "02458",
          "phone": "617-332-3333",
          "fax": "617-332-3308",
          "hours": "M-F 9-5:30PM",
          "latitude": 42.3548224,
          "longitude": -71.1999166,
          "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/1200",
          "qr_code_link": "https://s3.amazonaws.com/phone-your-rep-images/7gubdgo2kr_Kennedy_district_1200.png"
        },
        {
          "self": "https://phone-your-rep.herokuapp.com/api/beta/office_locations/1199",
          "id": 1199,
          "bioguide_id": "K000379",
          "office_type": "district",
          "distance": 25.8,
          "building": "",
          "address": "8 N. Main St.",
          "suite": "Suite 200",
          "city": "Attleboro",
          "state": "MA",
          "zip": "02703",
          "phone": "508-431-1110",
          "fax": "508-431-1101",
          "hours": "M-F 9-5:30PM",
          "latitude": 41.9449626,
          "longitude": -71.2846799,
          "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/1199",
          "qr_code_link": "https://s3.amazonaws.com/phone-your-rep-images/3yratflx0b_Kennedy_district_1199.png"
        },
        {
          "self": "https://phone-your-rep.herokuapp.com/api/beta/office_locations/368",
          "id": 368,
          "bioguide_id": "K000379",
          "office_type": "capitol",
          "distance": 385.4,
          "building": null,
          "address": "434 Cannon HOB",
          "suite": null,
          "city": "Washington",
          "state": "DC",
          "zip": "20515-2104",
          "phone": "202-225-5931",
          "fax": null,
          "hours": null,
          "latitude": 38.8870943,
          "longitude": -77.0082254,
          "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/368",
          "qr_code_link": "https://s3.amazonaws.com/phone-your-rep-images/62qf7ihqu3_Kennedy_capitol_368.png"
        }
      ]
    }
  ]
}
```
