# Para Ain't Rails Admin ![https://travis-ci.org/glyph-fr/para](https://travis-ci.org/glyph-fr/para.svg?branch=master)

Admin / CMS Framework for rails. WIP

## Installation

First, add the following line to the Gemfile

```ruby
gem 'para', github: 'glyph-fr/para'
```

And run

```bash
bundle install
```

## Setup

Setting up Para is easy. Run this command to generate all needed files

```bash
rails g para:install
```

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

```ruby
mount Para::Engine, at: '/', as: 'para'
```

### Ensuring root_path is defined

Please note that you should add a `root` path to your routes.rb, in the form
of :

```ruby
root to: 'home#index'
```

If you don't, you'll get errors when trying to access the admin panel.

## Components

Para works with components. To generate one, use the following command

```bash
rails g para:component ComponentName
```

## Resources

Once you created a component, run this generator should you need to associate
that component with a resource

```bash
rails g para:resource ResourceName ComponentName title:string description:text
```

In the generated resource controller, the resource name is already assigned.
It automatically uses CanCan under the hood to load and authorize the resource.
You can pass the same parameters to the macro as the
`load_and_authorize_resource` CanCan macro.

Here is the default behavior, the options hash being the default one and not
written directly in the generated controller.

```ruby
class YourResourcesController < Para::Admin::ResourcesController
  resource :your_resource, through: :component, class: 'YourResource',
                           parent: false
end
```

Components and resources work out of the box with CRUD. If you need to overide
the show page, here is how

```bash
rails g para:table ResourceName
```

And in case you want to change the way the form works, this generator can be helpful

```bash
rails g para:form ResourceName
```

### Orderable resources

Add `acts_as_orderable` to your model and a `position:integer{ default: 0 }` field in the table

`position` fields are not shown by default when a model is orderable

### Nested form fields

When you have a nested model, using `accept_nested_attributes_for`, Para will automatically
allow you to add / edit and delete thos nested resources withing the parent form

If you want to override the nested form behavior, you can generate the fields
with (where `ResourceName` is the name of the child model) :

```bash
rails g para:nested_fields ResourceName
```

## Licence

Para is released under the MIT-Licence.
