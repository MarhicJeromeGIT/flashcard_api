Spaced Repetition Project
===

# Notes Jerome

- The API documentation is generated as a Swagger Json definition. It is viewable with the Swagger UI tool, at this adress:
[SuperMemo2 API Doc](http://petstore.swagger.io/?url=http://iknow.bandanatech.org/) 
- You can try it with the "Try it out" buttons, as I currently run the application on my server
- I tried to focus on API speed first, by making heavy use of Redis data types (list and sorted set)
- There are a number of tests who should all succeed, by running "rails test"

  # Installation
  - Need to have a redis server running on the default (6379) port
  - need to setup the current server url in the .env file (and possibly the secrets for production)
  - typical Rails 5 application deployment : rake db:migrate, rake db:seed
  - deployment with 'cap production deploy' command
  
  # Usage
  - After speed, my second focus was ease of use, so the API is simple:
    - Step 1: get the cards data (id => question/answer) with the /cards call
    - Step 2: get the list of cards to study next with the /todays_session call
    - Step 3: Assess (= rate, review) a card with the /assessments call
    - (Back to step 2, the list of cards to review should have been updated correctly)
    - Step 4: There are a number of /statistics api call available.
  
  # Warning
  - There is no user management api currently (sign up, sign in...) as I estimated it was not the focus of the exercise
  - So the Seed file create and initialize 2 users whose Access Token are "abcd" and "1234" respectively
  - Similarly there is no card creation API
  - Currently there is only one deck of cards, no custom deck per user

  # Future expansion
  - make the API JSON API complient?
  - It should be easy to swap the SM2 algorithm for another
  - Didn't do any performance measurement
  - Backup of the redis content to S3
  - Use several instances of redis (one per core), split between users
  - todays_session originally contains all card in the deck, may be split up in X cards per day
  - It should be easy to add access to "tomorrow's session" in advance when today's session is finished
  - $redis variable is global.

# Description

We would like you to create a [spaced repetition](https://en.wikipedia.org/wiki/Spaced_repetition) system based on the [SuperMemo 2.0 algorithm](https://www.supermemo.com/english/ol/sm2.htm).
The system should provide a JSON API.

The API should be able to support the basic features of a service like iKnow.

# Requirements

The system should have vocabulary items that users can study. Users
perform self-assessment on each item, ranking their knowledge of the
items from 0 to 5 (as the
SuperMemo 2.0 algorithm describes).

Users can request vocabulary items to study, which should be presented to them in
the order in which they need to study them based on the results of the
algorithm.

Additionally, APIs should be provided which enable the app to show study
statistics similar to these:

![srs_stats_example_1](https://s3.amazonaws.com/test-le-stats/image1.png)

![srs_stats_example_2](https://s3.amazonaws.com/test-le-stats/image2.png)

In particular, we want to offer the following statistics:

* How many vocabulary words a user needs to review in the future (similar to "Forecast" above).

* How much time they've spent studying each vocabulary item.

* How many times they've used each answer choice.


# Notes

You may use whichever language or framework you like, but please provide instructions for running your code.

Please write your application as though it was production code: keep it well-factored for future expansion. Leave room in your code design for new features, even though you won't implement them. When you're finished, we'll chat about the code and how it could be expanded in a real product.
