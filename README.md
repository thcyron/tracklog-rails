Bikelog
=======

**Bikelog** is a Ruby on Rails application for managing GPS track logs. It’s
based on Rails Edge and thus requires Ruby 1.9.

Features
--------

* Visualizing tracks on a Google Map
* Track statistics like distance, duration, speeds, ascent etc.
* Elevation profiles
* Dashboard showing overall statistics
* Graphs for last 12-month activity by distance and duration
* GPX import and export
* Basic user management

Screenshots
-----------

[![Logs](http://thcyron.de/bikelog/screenshots/logs-thumb.png)](http://thcyron.de/bikelog/screenshots/logs.png)
[![Log](http://thcyron.de/bikelog/screenshots/log-thumb.png)](http://thcyron.de/bikelog/screenshots/log.png)

(Note: As Bikelog is under development, the screenshots may not always
represent to current state.)

Installation
------------

Because Bikelog is a standard Rails application, you can use your favourite
deployment tools to install Bikelog on your server. To run it locally you’ll
need to go through the following steps:

    % bundle
    % rake db:setup
    % rails server
    % open http://localhost:3000/

The default user is *admin* with the same password.

Todo
----

* Filtering of inaccurate trackpoints (maybe using the Kalman filter)
* GPS import using Garmin’s JavaScript API
* KML import
* Split GPX parsing and analyzing into a separate file/library

License
-------

Bikelog is released under the MIT license.

Authors
-------

* [Thomas Cyron](http://thcyron.de/)

Contributors
------------

* [Lloyd Pick](https://github.com/lloydpick)
