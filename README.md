# README

This is a ruby 1.9 app that monitors a sguil db for new events, when a new event is encountered, it fires the event via a POST request to the sguil-api server configured.

The sguil database has a column named `class` which is a reserved word in RoR and caused all of my tests to fail.
I was unable to get `alias_attribute` to work correctly on the api-server side, and renamed the field during transmission to `event_class`.

* Ruby version

Built with Ruby version 1.9.3p484

* Other requirements

This app uses the mysql2 gem, which requires you to install `libmysql-ruby` and `libmysqlclient-dev` from apt-get.
Dotenv is being used to manage the `SERVER_URI` env variable that maps to the sguil-api server.

* Configuration

This application is currently in development mode, not suitable for production as-is. This application needs the URL for the paired api-server. You can set the URL in the `SERVER_URI` environment variable in the `.env` file in the `lib` directory.

* Deployment instructions

