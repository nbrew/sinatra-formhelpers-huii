Sinatra::FormHelpers - Lightweight form helpers for Sinatra
===========================================================

This plugin adds lightweight (3-5 lines each) form helpers to Sinatra that aid with
common form and HTML tags.

    link "google", "http://www.google.com"  # <a href="http://www.google.com">google</a>
    label :person, :first_name              # <label for="person_first_name">First Name</label>
    text :person, :first_name               # <input name="person[first_name]" id="person_first_name" type="text" />

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

    <p>Fill out the below form to sign up.</p>

    <%= form('/users', :create) %>
    
    <%= text(:user, :first_name) %>
    <%= text(:user, :last_name) %>
    <%= text(:user, :gender, ['M', 'F']) %>

    <%= textarea(:user, :signature) %>

    <%= submit >
              
Author
------
Copyright (c) 2011 [Nate Wiger](http://nateware.com).  Based on initial efforts (c) 2009 twilson63.
