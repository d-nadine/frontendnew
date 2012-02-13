# Radium Pure JS Frontend

This repo contains all the individual source files (JS/CSS/Templates)
for compiling all assets for production. It also contains a simple Rack
application based on Rake-Pipeline for deployment.

The server is setup for development and production. Assets are
recomplied with every request in development. Assets are compiled and
deploy time in production. Assets are also cached.

The code can be deployed using standard rack deployment practices.

The production code runs on Heroku. A custom buildpack is used to
compile the assets using `bundle exec rakep build`. If the code is not
depoyed to heroku, the assets will have to be compiled and added to SCM
manually.

## Stucture

Main Components:

1. [Rake-Pipeline](https://github.com/livingsocial/rake-pipeline): Asset
   compilation.
2. [Web Filters](https://github.com/wycats/rake-pipeline-web-filters):
   Asset Hax
3. [Rack Reverse Proxy](https://github.com/jaswope/rack-reverse-proxy):
   Proxying all API requests to the API server
4. [Buildpack](https://github.com/Adman65/heroku-buildpack-ruby): Awesomesauce with a Heroku build pack

Rake-Pipeline compiles all things into a static directory. A rack
middleware is used to server the directory. `/` is rewritten to
`index.html`. All requests to `/api/foo` are proxied to
`http://api.server/foo`. 

The Developer API key is automatically added in a header. This way it is
never exposed to end users. 

## Configuration

There are 3 different things that may be configured.

```yml
server: "http://api.radiumcrm.com" # server to proxy all requests
too
developer_api_key: test # developer key to use
user_api_key: test # optionally, authenticate as a user in
development
```

## Running Locally

```
# bundle if required
$ bundle exec rackup
```

## Deploying

The JS frontend can be deployed and managed completely separately from
the API server. Just push to heroku and off it goes.

```
# commit your stuff
$ git push heroku master
```

## Maintainers

* Assets (JS/CSS/HTML): Josh
* All Server Stuff: Adam
