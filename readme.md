# Radium Pure JS Frontend

See [Iridium](https://github.com/radiumsoftware/iridium)
for underlying code that powers this project.

## Configuration

You must create a `config/settings.yml` after cloning this repo. There
you can configure the `user_api_key`. This allows you to use the app as
if you were logged in as them.

```yml
# config/settings.yml

development:
  user_api_key: test # optionally, authenticate as a user indevelopment
```

## Running Locally

```
# bundle if required
$ bundle exec foreman start dev
$ open localhost:9292
```

## Deploying

The JS frontend can be deployed and managed completely separately from
the API server. Just execute the deploy script and it will do the rest.

```
# commit your stuff
$ ./script/deploy
```

## Maintainers

* JS Application: Paul
* All Server Stuff: Adam
* Iridium: Adam
