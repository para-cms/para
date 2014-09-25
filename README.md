# Para Ain't Rails Admin

This project rocks and uses MIT-LICENSE.

## Installation

First, add the following line to the Gemfile

    gem 'para', github: 'glyph-fr/para'

And run

    bundle install

## Setup

Setting up Para is easy. Run this command to generate all needed files

    rails g para:install
    
This will do the following
   
  * Create `config/initializers/para.rb`
  * Copy the needed migrations
    * Components
    * Pages
  * Add the following gems if they're not already in the Gemfile
    * devise
    * simple_form
    * simple_form_extension
    * paperclip
    * cancancan
    * friendly_id
  * Run the generators of the gems above
      * `devise:install` generator
      * `simple_form:install` generator
      * `simple_form_extension:install` generator
      * `cancan:ability` generator
      * `friendly_id` generator

At the end, you will end up with a model `AdminUser` already configured to work with devise and also migrated.

Also, `para` adds the following line to `routes.rb` to mount the engine:
    
    mount Para::Engine, at: '/', as: 'para'
