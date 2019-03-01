[![Coverage](https://raw.githubusercontent.com/NEU-Libraries/charon/master/badge.svg?sanitize=true)](https://github.com/NEU-Libraries/charon)

# Charon

Charon is a digital framework designed to provide workflow management for a range of contributory and editorial digital humanities projects. Charon is part of CERES (the Community-Enhanced Repository for Engaged Scholarship), a larger ecology of tools developed by the Northeastern University Library to provide long-term sustainable support for advanced forms of digital scholarship, data curation, and publication.

This code has been designed to be developed and tested with [Docker](https://www.docker.com/) and docker compose.

* Clone the repository
* ```docker-compose up --build```

This will start a rails server which can be accessed at <http://localhost:3000>

To run the test suite if you already have the containers running

```docker exec -ti charon_web_1 bundle exec rspec spec```
