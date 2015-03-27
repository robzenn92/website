[![Circle CI](https://circleci.com/gh/cucumber/website/tree/master.svg?style=svg)](https://circleci.com/gh/cucumber/website/tree/master)

# The (new) cukes.info website

## Run it locally

Install Ruby. Then:

    gem install bundler
    bundle install
    bundle exec foreman start

Point a browser to `http://localhost:5000`

### How it works

We use Rack to mount several smaller rack apps that serve different bits of content that make up the site. The individual rack apps are stored under `apps` and are loaded by `config.ru`

See [this blog post](http://mwmanning.com/2011/12/04/Jekyll-on-Heroku-Part-2.html) for more information about this design.

We decided not to use rack-jekyll as it didn't seem to be able to handle mounting a non-root directory, and didn't seem to add much, other than complexity.

## Modify or add content

Please see [The Cucumber Brand] for details about fonts and colours.
