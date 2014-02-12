require 'spec_helper'

describe "Sinatra::FormHelpers in app" do
  it 'renders an anchor tag' do
    app.get '/link' do
      erb "<%= link 'google', 'http://www.google.com', :title => 'Google' %>"
    end

    get '/link'
    expect( last_response.body ).to eq( %q(<a href="http://www.google.com" title="Google">google</a>) )
  end

  it 'renders a label tag' do
    app.get '/label' do
      erb "<%= label :person, :first_name %>"
    end

    get '/label'
    expect( last_response.body ).to eq( %q(<label for="person_first_name">First Name</label>) )
  end

  it 'renders a label tag with display input' do
    app.get '/hello' do
      erb "<%= label :person, :first_name, 'Hello World'%>"
    end

    get '/hello'
    expect( last_response.body ).to eq( %q(<label for="person_first_name">Hello World</label>) )
  end

  it 'renders an input tag type text without @params' do
    app.get '/text' do
      erb "<%= input :person, :first_name %>"
    end

    get '/text'
    expect( last_response.body ).to match( /name="person\[first_name\]"/ )
    expect( last_response.body ).to eq( %q(<input id="person_first_name" name="person[first_name]" type="text" />) )
  end

  it 'accepts an input tag with custom type option' do
    app.get '/input-with-custom-type' do
      erb "<%= input :person, :password, type: 'password' %>"
    end

    get '/input-with-custom-type'
    expect( last_response.body ).to eq( '<input id="person_password" name="person[password]" type="password" />' )
  end

  it 'renders an input tag type text with single arg' do
    app.get '/q' do
      erb "<%= input :q %>"
    end

    get '/q'
    expect( last_response.body ).to eq( %q(<input id="q" name="q" type="text" />) )
  end

  it 'renders an input tag type text with @params' do
    app.get '/tom' do
      @params = { :person => {"first_name" => "Tom"}}
      erb "<%= input :person, :first_name %>"
    end

    get '/tom'
    expect( last_response.body ).to eq( %q(<input id="person_first_name" name="person[first_name]" type="text" value="Tom" />) )
  end

  it 'renders a password tag type password' do
    app.get '/password' do
      erb "<%= password :person, :password %>"
    end

    get '/password'
    expect( last_response.body ).to eq( '<input id="person_password" name="person[password]" type="password" />' )
  end

  it 'renders a button tag type button' do
    app.get '/button' do
      erb "<%= button :new %>"
    end

    get '/button'
    expect( last_response.body ).to eq( '<input id="button_new" name="button" type="button" value="new" />' )
  end

  it 'renders an textarea tag type text without @params' do
    app.get '/notes' do
      erb "<%= textarea :person, :notes %>"
    end

    get '/notes?person[notes]=Yeppers'
    expect( last_response.body ).to eq( %q(<textarea id="person_notes" name="person[notes]">Yeppers</textarea>) )
  end

  it 'renders a textarea tag with @params' do
    app.get '/notes2' do
      @params = { :person => {"notes" => "This is a note"}}
      erb "<%= textarea :person, :notes %>"
    end

    get '/notes2'
    expect( last_response.body ).to eq( %q(<textarea id="person_notes" name="person[notes]">This is a note</textarea>) )
  end

  it 'renders a textarea tag with @params' do
    app.get '/img' do
      erb "<%= image '/images/hello.png', :alt => 'Lolcatz' %>"
    end

    get '/img'
    expect( last_response.body ).to eq( '<img alt="Lolcatz" src="/images/hello.png" />' )
  end

  it 'renders an input tag with a submit type' do
    app.get '/sub' do
      erb "<%= submit 'Create' %>"
    end

    get '/sub'
    expect( last_response.body ).to eq( '<input id="button_create" name="submit" type="submit" value="Create" />' )
  end

  it 'renders an input tag with a submit type with zero args' do
    app.get '/create' do
      erb "<%= submit %>"
    end

    get '/create'
    expect( last_response.body ).to eq( '<input id="button_submit" name="submit" type="submit" value="Submit" />' )
  end

  it 'renders an input tag with a checkbox type' do
    app.get '/check' do
      erb "<%= checkbox :person, :active, 'Yes' %>"
    end

    get '/check'
    expect( last_response.body ).to eq(
      '<input id="person_active_yes" name="person[active]" type="checkbox" value="Yes" /><label for="person_active_yes">Yes</label>'
    )
  end

  it 'renders an input tag with a multiple checkbox type' do
    app.get '/check2' do
      erb "<%= checkbox :person, :eyes, [1,2,3] %>"
    end

    get '/check2'
    expect( last_response.body ).to eq(
      '<input id="person_eyes_1" name="person[eyes][]" type="checkbox" value="1" /><label for="person_eyes_1">1</label> ' +
      '<input id="person_eyes_2" name="person[eyes][]" type="checkbox" value="2" /><label for="person_eyes_2">2</label> ' +
      '<input id="person_eyes_3" name="person[eyes][]" type="checkbox" value="3" /><label for="person_eyes_3">3</label>'
    )
  end

  it 'renders an input tag with a radio type' do
    app.get '/radio' do
      erb "<%= radio :person, :gender, [['M','Male'],['F','Female'],'Other'] %>"
    end

    get '/radio'
    expect( last_response.body ).to eq(
      %(<input id="person_gender_m" name="person[gender]" type="radio" value="M" /><label for="person_gender_m">Male</label> ) +
      %(<input id="person_gender_f" name="person[gender]" type="radio" value="F" /><label for="person_gender_f">Female</label> ) +
      %(<input id="person_gender_other" name="person[gender]" type="radio" value="Other" /><label for="person_gender_other">Other</label>)
    )
  end

  it 'renders a select tag' do
    app.get '/select' do
      erb "<%= select :person, :relationship, ['Friend','CoWorker','Lead'] %>"
    end

    get '/select'
    expect( last_response.body ).to eq( '<select id="person_relationship" name="person[relationship]">' +
      '<option value="Friend">Friend</option><option value="CoWorker">CoWorker</option>' +
      '<option value="Lead">Lead</option></select>' )
  end

  it 'renders a select tag with selected option' do
    app.get '/select2' do
      @params = { :person => {"relationship" => "CoWorker"}}
      erb "<%= select :person, :relationship, ['Friend','CoWorker','Lead'] %>"
    end

    get '/select2'
    expect( last_response.body ).to eq( '<select id="person_relationship" name="person[relationship]">' +
      '<option value="Friend">Friend</option><option selected="selected" value="CoWorker">CoWorker</option>' +
      '<option value="Lead">Lead</option></select>' )
  end

  it 'renders a hidden tag with single arg' do
    app.get '/hidden' do
      erb "<%= hidden :q %>"
    end

    get '/hidden'
    expect( last_response.body ).to eq( %q(<input id="q" name="q" type="hidden" />) )
  end

  it 'renders a hidden tag with value' do
    app.get '/hidden2' do
      erb '<%= hidden :person, :id, :value => 1 %>'
    end

    get '/hidden2'
    expect( last_response.body ).to eq( '<input id="person_id" name="person[id]" type="hidden" value="1" />' )
  end

  it 'renders a form tag' do
    app.get '/form' do
      erb "<%= form :person, :create %>"
    end

    get '/form'
    expect( last_response.body ).to eq( %q(<form action="/person" method="POST"><input type="hidden" name="_method" value="create" />) )
  end

  it 'renders a fieldset group' do
    app.get '/fieldset' do
      erb <<-EndTemplate
<% fieldset(:user) do |f| %>
  <%= f.input(:first_name) %>
  <%= f.input(:last_name) %>

  <%= f.input(:email, :size => 40) %>

  <%= f.password(:password) %>
  <%= f.password(:confirm_password) %>

  <%= f.radio(:gender, ['M', 'F']) %>
<% end %>
<%= submit %>
EndTemplate
end

    get '/fieldset'
    expect( last_response.body ).to eq(
      %(  <input id="user_first_name" name="user[first_name]" type="text" />\n) +
      %(  <input id="user_last_name" name="user[last_name]" type="text" />\n\n) +
      %(  <input id="user_email" name="user[email]" size="40" type="text" />\n\n) +
      %(  <input id="user_password" name="user[password]" type="password" />\n) +
      %(  <input id="user_confirm_password" name="user[confirm_password]" type="password" />\n\n) +
      %(  <input id="user_gender_m" name="user[gender]" type="radio" value="M" /><label for="user_gender_m">M</label>) +
      %( <input id="user_gender_f" name="user[gender]" type="radio" value="F" /><label for="user_gender_f">F</label>\n) +
      %(<input id="button_submit" name="submit" type="submit" value="Submit" />)
    )
  end
end
