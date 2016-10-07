# Appifly

[![Code Climate](https://codeclimate.com/github/andela-megwali/appifly/badges/gpa.svg)](https://codeclimate.com/github/andela-megwali/appifly)
[![Coverage Status](https://coveralls.io/repos/github/andela-megwali/appifly/badge.svg?branch=testing)](https://coveralls.io/github/andela-megwali/appifly?branch=testing)
[![Build Status](https://travis-ci.org/andela-megwali/appifly.svg?branch=master)](https://travis-ci.org/andela-megwali/appifly)

##Description

Appifly is a responsive and intuitive flight booking web application that helps travellers find quality flights to exciting destinations. The application can be viewed here [Appifly](http://appifly.herokuapp.com)

## Functions and Features

The app supports three tiers of users:

### Anonymous User

  An anonymous user is not required to register or sign in to perform functions. This user has access to the following functions:

    * Search for and filter flights using several criteria including "Origin", "Destination", "Earliest Departure Date", "No of Passengers" and "Travel Class".
    * Select and book a preferred flights from the matching options presented
    * Receive a booking confirmation email and/or text message after booking a flight successfully
    * Search for booking details by the unique booking reference number

### Registered and Logged In User

  In addition to the functions of the anonymous user, a logged in user can:
    
    * Receive welcome email on sign up
    * View all past bookings on his/her dashboard
    * Manage past bookings including editing/updating or cancelling bookings
    * Manage his/her profile
    * Can view all flights

### Admin User

  In addition to all the above, an admin user has total oversight of the app features and functions:

    * Can view and manage all bookings, flights, users, airports, passengers
    * Can create, update and delete any flight, user, airport, bookings


##Dependencies and Frameworks

The application is designed with Ruby 2.3.1 and runs on Rails 4.2.6 and uses the Puma server.
The front-end design was implemented with Bootstrap.

To run this application. you need to install <a href="https://www.ruby-lang.org" target ="blank">Ruby</a> and <a href="http://rubyonrails.org/" target="blank">Rails</a>. Every other dependency will be installed when you run "bundle install".


## Instructions for Getting Started
  
  To use the app, visit http://appifly.herokuapp.com.

  To test and run the app locally follow the instructions below:


### Run Locally

You will require a basic understanding of "Git" and the "Command Line Interface" to use this application.

You also need access to a steady internet connection for the initial installation.

### Installation

 Clone the repo to a directory on your local machine using git clone command as shown below:

    $  git clone https://github.com/andela-megwali/appifly.git

 Get into the appifly directory:

    $  cd appifly
    
 Install dependencies

    $  bundle install

 Setup / Migrate database

    $ rails db:setup

 Seed database with data

    $ rails db:seed

 Start the puma server

    $ rails server

 Visit http://localhost:3000 to view the application on your browser.


### Using the Application

 Start the puma server

    $ rails server

 Visit http://localhost:3000 on your browser
 
 Follow the intuitive guides to search for and book flights.


## Running the Tests

To test the application, run 'bundle exec rspec' from the appifly directory after you have installed all the dependencies i.e. using 'bundle install' as previously described.

    $  bundle exec rspec


## Limitations

  * It currently doesn't have payment integration and refund

## Contributing

You can contribute to this project by forking the repository on GitHub at https://github.com/andela-megwali/appifly.
We also welcome bug reports and all bugs would be squashed as soon as possible.