# Clerk OCR

## Installation
1. Clone the repo
2. Run `gem install bundle && bundle install`
3. Run `rails db:setup && rails db:migrate` to create db and included Users table
4. To use Figaro / application.yml, run `bundle exec figaro install`

## Additional Options
1. Put your UA-XXX property code for Google Analytics in shared/footer
2. Install Sendgrid add-on (Heroku), visit [settings](https://app.sendgrid.com/settings/tracking) to disable click, open tracking and enable subscription tracking
