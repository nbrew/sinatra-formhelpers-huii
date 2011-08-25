Sinatra::FormHelpers - Lightweight form helpers for Sinatra
===========================================================

This plugin adds lightweight (3-5 lines each) form helpers to Sinatra that aid with
common form and HTML tags.

    link "google", "http://www.google.com"  # <a href="http://www.google.com">google</a>
    label :person, :first_name              # <label for="person_first_name">First Name</label>
    input :person, :first_name              # <input name="person[first_name]" id="person_first_name" type="text" />

There are also helpers for: form, textarea, submit, image, radio, checkbox, and select

Usage
-----
With Bundler/Isolate:

    gem 'sinatra-formhelpers', '~>0.6.0'

Then, include it in a Sinatra application:

    require 'sinatra/form_helpers'
      
If you're subclassing <code>Sinatra::Base</code>, you also need to call <code>helpers</code> manually:

    class MyApp < Sinatra::Base
      helpers Sinatra::FormHelpers
      # ...
    end

Views
-----
In your views, use these helpers to dynamically create form and HTML elements.  Here's an example in ERB:

    <p>
      Fill out the below form to sign up.
      For more information, visit our <%= link 'FAQ', '/faq' %>
    </p>

    <%= form('/users', :create) %>
    
    <%= input(:user, :first_name) %>
    <%= input(:user, :last_name) %>

    <%= input(:user, :email, :size => 40) %>

    <%= password(:user, :password) %>
    <%= password(:user, :confirm_password) %>

    <%= radio(:user, :gender, ['M', 'F']) %>

    <%= submit %>

Note that unlike the super-magic Rails <code>form_for</code> method, this <code>form()</code> helper takes a URL.

To reduce repetition, you can also use fieldset() to prefix fields with a namespace:

    <%= form('/users', :create) %>

    <% fieldset(:user) do |f| %>
      <%= f.input(:first_name) %>
      <%= f.input(:last_name) %>

      <%= f.input(:email, :size => 40) %>

      <%= f.password(:password) %>
      <%= f.password(:confirm_password) %>

      <%= f.radio(:gender, ['M', 'F']) %>
    <% end %>

    <%= submit %>

This will create fields named "user[first\_name]", "user[last\_name]", and so forth.

Author
------
Copyright (c) 2011 [Nate Wiger](http://nateware.com).  Based on initial efforts (c) 2009 twilson63.
