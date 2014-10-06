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
    * `20140925085452_create_para_components.para.rb`
    * `20140925085453_create_para_pages.para.rb`
    * `20140925085454_add_slug_to_para_components.para.rb`
    * `20140925085455_create_para_component_sections.para.rb`
    * `20140925085456_add_identifier_to_para_component_sections.para.rb`
  * Add the following gems if they're not already in the Gemfile
    * `devise`
    * `simple_form`
    * `simple_form_extension`
    * `paperclip`
    * `cancancan`
    * `friendly_id`
  * Run the generators of the gems above
      * `devise:install`
      * `simple_form:install`
      * `simple_form_extension:install`
      * `cancan:ability`
      * `friendly_id`

At the end, you will end up with a model `AdminUser` already configured to work with devise and also migrated.

Also, `para` adds the following line to `routes.rb` to mount the engine:

    mount Para::Engine, at: '/', as: 'para'

## Components

Para works with components. To generate one, use the following command

    rails g para:component ComponentName

## Resources
Once you created a component, run this generator should you need to associate that component with a resource

    rails g para:resource ResourceName ComponentName title:string description:text

Components and resources work out of the box with CRUD. If you need to overide the show page, here is how

    rails g para:table ResourceName

And in case you want to change the way the form works, this generator can be helpful

    rails g para:form ResourceName

### Orderable resources

Add `acts_as_orderable` to your model and a `position:integer{ default: 0 }` field in the table

`position` fields are not shown by default when a model is orderable

### Nested form fields

When you have a nested model, using `accept_nested_attributes_for`, Para will automatically
allow you to add / edit and delete thos nested resources withing the parent form

If you want to override the nested form behavior, you can generate the fields
with (where `ResourceName` is the name of the child model) :

    rails g para:nested_fields ResourceName

