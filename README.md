# Sinatra::FormHelpers - Lightweight form helpers for Sinatra

This plugin adds lightweight (3-5 lines each) form helpers to Sinatra that aid with
common form and HTML tags.

    link "google", "http://www.google.com"  # <a href="http://www.google.com">google</a>
    label :person, :first_name              # <label for="person_first_name">First Name</label>
    input :person, :first_name              # <input name="person[first_name]" id="person_first_name" type="text" />

There are also helpers for: form, textarea, submit, image, radio, checkbox, and select


## Why Bother?

After all, you can just write Haml or write your own helpers or hand-code raw HTML or whatever.  Well, here's some considerations:

1. Helpers maintain correct state across form submissions (eg, on errors, form stays filled in)
2. Generate automatic labels, valid CSS ID's, and `nested[names]` to make ORMs happy
3. No Rails ultra-magic(tm) here. Just fast, simple code.


## Usage

With Bundler/Isolate:

    gem 'sinatra-formhelpers-huii'

Then, include it in a Sinatra application:

    require 'sinatra/form_helpers'

If you're subclassing `Sinatra::Base`, you also need to call `helpers` manually:

    class MyApp < Sinatra::Base
      helpers Sinatra::FormHelpers
      # ...
    end


## Views

In your views, use these helpers to dynamically create form HTML elements.  Here's an example in ERB:

    <p>
      Fill out the below form to sign up.
      For more information, visit our <%= link 'FAQ', '/faq' %>
    </p>

    <%= form('/users', :post) %>

    <%= input(:user, :first_name) %>
    <%= input(:user, :last_name) %>

    <%= input(:user, :email, :size => 40) %>

    <%= password(:user, :password) %>
    <%= password(:user, :confirm_password) %>

    <%= radio(:user, :gender, ['M', 'F']) %>

    <%= submit %>

Unlike the super-magic Rails `form_for` method, the `form()` helper just takes a URL and method. (Note that `form()` will accept `:create`, `:update`, and `:delete` and include the special `_method` hidden param for you.)

To reduce repetition, use `fieldset()` to prefix fields with a namespace:

    <%= form('/users', :create) %>

    <% fieldset(:user) do |f| %>
      <%= f.input(:first_name) %>
      <%= f.input(:last_name) %>

      <%= f.input(:email, :size => 40) %>

      <%= f.password(:password) %>
      <%= f.password(:confirm_password) %>

      <%= f.radio(:gender, ['M', 'F']) %>
    <% end %>

    <%= submit 'Create account' %>
    <%= submit 'Cancel', :onclick => 'window.location=http://mydomain.com;return false' %>

This will create fields named `user[first_name]`, `user[last_name]`, and so forth.


## Known Bugs

* `fieldset` must be optional in `form`
* `form` must take an URL string *AND* a namespace symbol.


## Fixed Bugs

* Currently `fieldset` does not return a <fieldset> tag properly.
* The state of select tags was not persisted across form submissions.


## Authors

* [Initial efforts](https://github.com/twilson63/sinatra-formhelpers) (c) 2009 [Tom Wilson](https://github.com/twilson63).
* [Additional efforts](https://github.com/nateware/sinatra-formhelpers) (c) 2011 [Nate Wiger](http://nateware.com).
* [Further efforts](https://github.com/cymen/sinatra-formhelpers-ng) (c) 2013 [Cymen Vig](http://blog.cymen.org/).
* [Other efforts](https://github.com/ollie/sinatra-formhelpers-huii) (c) 2014 [Oldrich Vetesnik](https://github.com/ollie).
