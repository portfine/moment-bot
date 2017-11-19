# pr-title-check
ruby CI server for Github PR titles

Heavily based off the great Github tutorial on [building CI servers](https://developer.github.com/v3/guides/building-a-ci-server/), and [its code](https://github.com/github/platform-samples/tree/master/api/ruby/building-a-ci-server).

## Setup
[Get Ruby!](https://www.ruby-lang.org/en/documentation/installation/)
```
gem install bundler
bundle install
```
## Usage
[Make a token](https://github.com/settings/tokens), and add it to your environment.
```
KUNAL_PERSONAL_ACCESS_TOKEN=<my_new_token>
```
Run the server.
```
rackup config.ru
```
Put it online, or [use ngrok](https://ngrok.com/) to get online.

In your Github repo, [add a webhook](https://developer.github.com/webhooks/creating/#setting-up-a-webhook) to send events about [Pull Requests](https://developer.github.com/v3/activity/events/types/#pullrequestevent).
## Deployment
To run things with local gems, use
```
bundle install --path localgems
bundle exec rackup config.ru
```
## Help
Make an issue, open a PR, or ping me directly at marwahaha@berkeley.edu
