# Text Sharing Challenge

Quip! Uh, I mean "quick"! Our text sharing application is slow so we want to prototype a version in Elixir. Building on what we learned from the Short URL application, we need to build an application that can let different users collaborate on a text snippet. Don't worry we just want a proof of concept for now.

## Requirements
Write a web application that allows users to collaborate on a snippet of text. 

The program should:

 1. [ ] Allow a user to enter the text into a text area and save the text.
 
 2. [ ] Stored the text in a data store (Not Postgres).

 3. [ ] Generate a URL that can be used to retrieve the saved text.

 4. [ ] Allow a user that follows the URL to see the text displayed along with an invitation to edit the text.

 5. [ ] Allow a user to click the Edit button and edit a version of the snippet.
 
 6. [ ] Allow a user to see the revision history

## Constraints

* [ ] Data must use an in memory data store

* [ ] Don't use the Phoenix framework. Plug, Raxx, Cowboy, or any other library are all acceptable

## Challenges

* [ ] Use either: GenServer, Agent, or ETS as the data store

* [ ] Record the timestamps for creating and updating the snippets 

* [ ] Record which user updated the snippet

##

This challenge is based on Exercise 54 in Brian P. Hogan's “[Exercises for Programmers][1]"
book by PragProg.

[1]: https://pragprog.com/book/bhwb/exercises-for-programmers
