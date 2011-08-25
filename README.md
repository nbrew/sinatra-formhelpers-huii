Sinatra::FormHelpers - Lightweight form helpers for Sinatra
===========================================================

This plugin adds lightweight (3-5 lines each) form helpers to Sinatra that aid with
common form and HTML tasks.

  link "google", "http://www.google.com"  # <a href="http://www.google.com">google</a>
  label :person, :first_name              # <label for="person_first_name">First Name</label>
  text :person, :first_name               # <input name="person[first_name]" id="person_first_name" type="text" />

There are also helpers for: form, textarea, submit, image, radio, checkbox, and select

To install it, run:

  gem install sinatra-formhelpers

To include it in a Sinatra application:

  require 'sinatra/form_helpers'
      
If you're subclassing <code>Sinatra::Base</code>, then you need to call the <code>helpers</code> manually:

  class MyApp < Sinatra::Base
    helpers Sinatra::FormHelpers
    # ...
  end
        
              
Author
------
Copyright (c) 2011 [Nate Wiger](http://nateware.com).  Based on initial efforts (c) 2009 twilson63.
