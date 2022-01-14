# ShortUrl Challenge

This challenge is designed to get you out of your "comfort zone" and expose you to other libraries & patterns you may not
be familiar with. This isn't going into production so have fun with it!

## Requirements
Write a web application that allows users to take a long URL & convert it to a shortened URL.

Example:
```
http://really-long-url.com/the/page/I/am/looking/for -> http://localhost:4000/abc1234
```

The program should:

 1. [X] Accept a long URL

 2. [X] Generate a short local URL like `/abc1234`

 3. [X] Store the short URL & the long URL together

 4. [X] Redirect visitors to the long URL when the short URL is visited

 5. Track the number of times the short URL is visited

 6. Provide a statistics page for the short URL, such as `/abc1234/stats`
    - Visiting this URL should show:
      * short URL
      * long URL
      * number of times the short URL was accessed

## Constraints

* [X] Data must use an in memory data store

* [X] Don't use the Phoenix framework. Plug, Raxx, Cowboy, or any other library are all acceptable.

## Challenges

* [X] Don’t allow an invalid URL to be entered into the form.

* [X] Detect duplicate URLs. Don’t create a new short URL if one already exists

* Record the date and time each short URL was accessed

* [X] Use either: GenServer, Agent, or ETS as the data store

##

This challenge is based on Exercise 54 in Brian P. Hogan's “[Exercises for Programmers][1]"
book by PragProg.

[1]: https://pragprog.com/book/bhwb/exercises-for-programmers
