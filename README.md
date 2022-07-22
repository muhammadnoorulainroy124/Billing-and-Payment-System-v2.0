# Billing and Recurring Payment System v2.0
### Ruby version

2.7

### Rails Version

5.2

### System dependencies

Following gems must be installed before running the project:

* gem 'bootstrap', '~> 4.4.1'
* gem 'cloudinary'
* gem 'devise'
* gem 'devise_invitable', '~> 2.0.0'
* gem 'jquery-rails'
* gem 'pagy'
* gem 'pundit'
* gem 'stripe'
* gem 'stripe_event'

### How to Run the Project?

1. Add the above mentioned gems in the ***Gemfile*** if not added and run `bundle install`
2. Create account on Stripe and get your `secret_key` and `public_key`
3. Place your Stripe keys in `credentials.yml` file in encrypted form.
4. For **ActiveStorage**, create acount on `cloudinary` and get your credentials.
5. Place those credentials in `cloudinary.yml` file in `config` folder.
6. You are good to go now. Run `rails server`

### Assumptions

Below are the aussumptions taken before and during implemention of the project.
* Features and Plans cannot be edited as Stripe does not allow to modify the price of a plan.
* If any feature is added in plan, that feature cannot be deleted. Because if the feature is deleted, price
  of the plan will be changed but stripe does not allow this to happen.
* If any Plan is subscribed by any Buyer, it cannot be deleted until it is subscribed.

### Deployment instructions

The project is deployed on the heroku. The link is given below.
[Billing and Recurring Payment System](https://billing-and-payment-system.herokuapp.com/).

