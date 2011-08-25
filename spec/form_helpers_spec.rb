require File.expand_path 'spec_helper', File.dirname(__FILE__)

# class Application < Sinatra::Base
#   register Sinatra::FormHelpers
# 
#   set :raise_errors, false
#   set :show_exceptions, false
#   
#   get '/link' do
#     
#   end
# end
# 
# class Bacon::Context
#   include Rack::Test::Methods
#   def app
#     Application  # our application
#   end
# end

describe "Sinatra::FormHelpers methods" do
  it "renders an anchor tag" do
    fh.form(:person, :create).should == '<form action="/person" method="POST">'
  end
  it 'renders a form tag' do
    fh.form(:person, :update, :action => "/people/14").should ==
      '<form action="/people/14" method="POST"><input type="hidden" name="_method" value="update" />'
  end
  it 'renders a form tag (2)' do
    fh.form("/people/7", :delete).should ==
      '<form action="/people/7" method="POST"><input type="hidden" name="_method" value="delete" />'
  end
  it 'renders a form tag (3)' do
    fh.form("/people", :create).should ==
      '<form action="/people" method="POST">'
  end
  it 'renders a nested form tag' do
    fh.form(:person, :create) do |f|
      f.text(:first_name)
      f.text(:last_name)
    end.should == '<form action="/person" method="POST">' + 
      '<input id="person_first_name" name="person[last_name]" type="text" value="" />'
      '<input id="person_last_name" name="person[last_name]" type="text" value="" />' +
      '</form>'
  end
  it 'nests form elements arbitrarily' do
    fh.nest(:person) do |n|
      n.radio(:partners, 1..6)
      n.textarea(:comments, "yo yo yo!")
    end.should == '<textarea id="person_comments" name="person[comments]">yo yo yo!</textarea>'
  end
  it 'renders a link tag' do
    fh.link('http://google.com').should == '<a href="http://google.com">http://google.com</a>'
  end
  it 'renders a form label tag' do
    fh.label(:person, :first_name).should == '<label for="person_first_name">First Name</label>'
  end
  it 'renders a form checkbox tag' do
    fh.checkbox(:person, :gender, %w[M F], :join => '<br />').should ==
      '<input id="person_gender_m" name="person[gender]" type="checkbox" value="M" /><br />' +
      '<input id="person_gender_f" name="person[gender]" type="checkbox" value="F" />'
  end
  it 'renders a minimal text tag' do
    fh.text(:q).should == %q(<input id="q" name="q" type="text" value="" />)
  end
  it 'renders a minimal textarea tag' do
    fh.textarea(:r).should == %q(<textarea id="r" name="r"></textarea>)
  end
  it 'renders a submit tag' do
    fh.submit.should == %q(<input name="submit" type="submit" value="Submit" />)
    fh.submit("Send!").should == %q(<input name="submit" type="submit" value="Send!" />)
  end
  it 'renders a reset tag' do
    fh.reset.should == %q(<input name="reset" type="reset" value="Reset" />)
    fh.reset("Blark").should == %q(<input name="reset" type="reset" value="Blark" />)
  end
end

describe "Sinatra::FormHelpers in app" do
  it 'renders an anchor tag' do
    app.get '/link' do
      erb "<%= link 'google', 'http://www.google.com', :title => 'Google' %>"
    end

    get '/link'
    last_response.body.should == %q(<a href="http://www.google.com" title="Google">google</a>)
  end

  it 'renders a label tag' do
    app.get '/label' do
      erb "<%= label :person, :first_name %>"
    end
    
    get '/label'
    last_response.body.should == %q(<label for="person_first_name">First Name</label>)
  end

  it 'renders a label tag with display text' do
    app.get '/hello' do
      erb "<%= label :person, :first_name, 'Hello World'%>"
    end
      
    get '/hello'
    last_response.body.should == %q(<label for="person_first_name">Hello World</label>)
  end
  
  it 'renders an input tag type text without @params' do
    app.get '/text' do
      erb "<%= text :person, :first_name %>"
    end

    get '/text'
    last_response.body.should =~ /name="person\[first_name\]"/
    last_response.body.should == %q(<input id="person_first_name" name="person[first_name]" type="text" value="" />)
  end

  it 'renders an input tag type text with single arg' do
    app.get '/q' do
      erb "<%= text :q %>"
    end
  
    get '/q'
    last_response.body.should == %q(<input id="q" name="q" type="text" value="" />)
  end
  
  it 'renders an input tag type text with @params' do
    app.get '/tom' do
      @params = { :person => {"first_name" => "Tom"}}
      erb "<%= text :person, :first_name %>"
    end
        
    get '/tom'
    last_response.body.should == %q(<input id="person_first_name" name="person[first_name]" type="text" value="Tom" />)
  end
  
  it 'renders an textarea tag type text without @params' do
    app.get '/notes' do
      erb "<%= textarea :person, :notes %>"
    end
    
    get '/notes?person[notes]=Yeppers'
    last_response.body.should == %q(<textarea id="person_notes" name="person[notes]">Yeppers</textarea>)
  end
  
  it 'renders a textarea tag with @params' do
    app.get '/notes2' do
      @params = { :person => {"notes" => "This is a note"}}
      erb "<%= textarea :person, :notes %>"
    end

    get '/notes2'
    last_response.body.should == %q(<textarea id="person_notes" name="person[notes]">This is a note</textarea>)
  end
  
  it 'renders a textarea tag with @params' do
    app.get '/img' do
      erb "<%= image '/images/hello.png', :alt => 'Lolcatz' %>"
    end
    
    get '/img'
    last_response.body.should == '<img alt="Lolcatz" src="/images/hello.png" />'
  end

  it 'renders an input tag with a submit type' do
    app.get '/sub' do
      erb "<%= submit 'Create' %>"
    end
    
    get '/sub'
    last_response.body.should == '<input name="submit" type="submit" value="Create" />'
  end
  
  it 'renders an input tag with a submit type with single arg' do
    app.get '/create' do
      erb "<%= submit 'Create' %>"
    end
    
    get '/create'
    last_response.body.should == '<input name="submit" type="submit" value="Create" />'
  end
  
  it 'renders an input tag with a checkbox type' do
    app.get '/check' do
      erb "<%= checkbox :person, :active, [1,2,3] %>"
    end
    
    get '/check'
    last_response.body.should ==
      '<input id="person_active_1" name="person[active]" type="checkbox" value="1" /> ' +
      '<input id="person_active_2" name="person[active]" type="checkbox" value="2" /> ' +
      '<input id="person_active_3" name="person[active]" type="checkbox" value="3" />'
  end

  it 'renders an input tag with a radio type' do
    app.get '/radio' do
      erb "<%= radio :person, :gender, ['Male','Female','Other'] %>"
    end
    
    get '/radio'
    last_response.body.should ==
      '<input id="person_gender_male" name="person[gender]" type="radio" value="Male" /> ' +
      '<input id="person_gender_female" name="person[gender]" type="radio" value="Female" /> ' +  
      '<input id="person_gender_other" name="person[gender]" type="radio" value="Other" />'
  end
  
  it 'renders an select tag' do
    app.get '/select' do
      erb "<%= select :person, :relationship, ['Friend','CoWorker','Lead'] %>"
    end
    
    get '/select'
    last_response.body.should == '<select id="person_relationship" name="person[relationship]">' +
      '<option value="Friend">Friend</option><option value="CoWorker">CoWorker</option>' + 
      '<option value="Lead">Lead</option></select>'
  end
  
  it 'renders a hidden tag with value' do
    app.get '/hidden' do 
      erb '<%= hidden :person, :id, :value => 1 %>'
    end
    
    get '/hidden'
    last_response.body.should == '<input id="person_id" name="person[id]" type="hidden" value="1" />'
  end
end

