# Dependencies

1. Ruby 2.7.3
2. Bundler 2.2.9
3. Rails 6.1.3
4. Postgres

# Installation

1. `bundle install`
2. `rake db:setup`

# Running the Specs
`rails spec` or `rspec spec`

# Start the Server
`rails s`

# Live Application

[https://he-better-reads.herokuapp.com](https://he-better-reads.herokuapp.com)

# Feature API Documentation

#### GET /api/books/:book_id/reviews

Returns a list of reviews for the given book ID.

Live URL: [https://he-better-reads.herokuapp.com/api/books/1/reviews](https://he-better-reads.herokuapp.com/api/books/1/reviews)

###### Example Response

```json
[
  {
    "id": 1,
    "rating": 4,
    "description": null,
    "user_id": 1,
    "book_id": 1,
    "created_at": "2021-09-22T01:11:57.566Z",
    "updated_at": "2021-09-22T01:11:57.566Z"
  },
  {
    "id": 2,
    "rating": 3,
    "description": "A fine read for any age.",
    "user_id": 2,
    "book_id": 1,
    "created_at": "2021-09-22T01:11:57.579Z",
    "updated_at": "2021-09-22T01:11:57.579Z"
  }
]

```

#### POST /api/books/:book_id/reviews

##### Required Fields

`rating` - must be a whole number between 1 and 5 inclusive

`user_id` - must be a valid, existing user

##### Optional Fields

`description` - cannot contain profanity

##### Example Request

`POST /api/books/2/reviews`

```json
{
  "user_id": 2,
  "rating": 4,
  "description": "A fine book."
}
```

##### Example Response

```json
{
  "id": 3,
  "rating": 4,
  "description": "A fine book.",
  "user_id": 2,
  "book_id": 2,
  "created_at": "2021-09-22T01:17:55.015Z",
  "updated_at": "2021-09-22T01:17:55.015Z"
}

```

# Notes

This was a great exercise! Just a few notes on implementation:

During a real discussion about development of this feature, I'd discuss with
the team on making the `Review` model polymorphic. I can see a scenario where
users might want to review `Author` as well as `Book`. In either case, migrating
to this sort of relationship would be relatively straightforward with a schema
migration to update `Review` and a data migration to fill out the polymorphic
details. I did not feel it was necessary to make `Review` polymorphic in this
exercise due to time constraints, and it would have been a bit of scope creep
anyway.

The profanity filter was a great stretch goal. The one I have implemented is
just a simple filter, that only matches to a direct spelling of a profane word.
Due to the way it matches a regular expression pattern against a submitted
description it is not very scalable once the list of disallowed terms grows. In
a real feature like this it may have also been useful to establish a model and
table to store banned/profane terms so that new ones can be easily added. To
really create a great profanity filter, I think ultimately it would take a
combination of a performant, scalable filter implementation and a combination of
a reporting system for users, or maybe a moderation queue for new reviews. It would
be interesting to explore using natural language processing to filter profanity-included
descriptions as well, in a more mature and robust implementation.
