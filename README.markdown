Spaced Repetition Project
===

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
