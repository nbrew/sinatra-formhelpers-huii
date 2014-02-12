require 'spec_helper'

describe "Sinatra::FormHelpers methods" do
  it 'renders an anchor tag' do
    fh.form(:person, :create).should == '<form action="/person" method="POST"><input type="hidden" name="_method" value="create" />'
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
      '<form action="/people" method="POST"><input type="hidden" name="_method" value="create" />'
  end

  it 'renders a nested form tag' do
    fh.form(:person, :create) do |f|
      # f.input(:first_name)
      f.input(:last_name)
    end.should == '<form action="/person" method="POST"><input type="hidden" name="_method" value="create" /><fieldset>' +
      # '<input id="person_first_name" name="person[first_name]" type="text" />' +
      '<input id="person_last_name" name="person[last_name]" type="text" />' +
      '</fieldset></form>'
  end

  it 'nests form elements arbitrarily' do
    fh.fieldset(:person) do |n|
      # n.radio(:partners, 1..6)
      n.textarea(:comments, "yo yo yo!")
    end.should == '<fieldset>' +
      # '<input id="person_partners_1" name="person[partners]" type="radio" value="1" /> ' +
      # '<input id="person_partners_2" name="person[partners]" type="radio" value="2" /> ' +
      # '<input id="person_partners_3" name="person[partners]" type="radio" value="3" /> ' +
      # '<input id="person_partners_4" name="person[partners]" type="radio" value="4" /> ' +
      # '<input id="person_partners_5" name="person[partners]" type="radio" value="5" /> ' +
      # '<input id="person_partners_6" name="person[partners]" type="radio" value="6" />' +
      '<textarea id="person_comments" name="person[comments]">yo yo yo!</textarea></fieldset>'
  end

  it 'renders a fieldset tag with an input' do
    fh.fieldset(:user) do |f|
      f.input(:last_name)
    end.should == '<fieldset><input id="user_last_name" name="user[last_name]" type="text" /></fieldset>'
  end

  it 'renders an empty fieldset tag' do
    fh.fieldset(:user) do |f|
    end.should == '<fieldset></fieldset>'
  end

  it 'renders a fieldset tag with legend' do
    fh.fieldset(:user, 'Oh boy!') do |f|
    end.should == '<fieldset><legend>Oh boy!</legend></fieldset>'
  end

  it 'renders a link tag' do
    fh.link('http://google.com').should == '<a href="http://google.com">http://google.com</a>'
  end

  it 'renders a form label tag' do
    fh.label(:person, :first_name).should == '<label for="person_first_name">First Name</label>'
  end

  it 'renders a form checkbox tag' do
    fh.checkbox(:person, :gender, %w[M F], :join => '<br />').should ==
      '<input id="person_gender_m" name="person[gender][]" type="checkbox" value="M" /><label for="person_gender_m">M</label><br />' +
      '<input id="person_gender_f" name="person[gender][]" type="checkbox" value="F" /><label for="person_gender_f">F</label>'
  end

  it 'renders a minimal text tag' do
    fh.input(:q).should == %q(<input id="q" name="q" type="text" />)
  end

  it 'renders a minimal textarea tag' do
    fh.textarea(:r).should == %q(<textarea id="r" name="r"></textarea>)
  end

  it 'renders a submit tag' do
    fh.submit.should == %q(<input id="button_submit" name="submit" type="submit" value="Submit" />)
    fh.submit("Send!").should == %q(<input id="button_send_" name="submit" type="submit" value="Send!" />)
  end

  it 'renders a reset tag' do
    fh.reset.should == %q(<input id="button_reset" name="reset" type="reset" value="Reset" />)
    fh.reset("Blark").should == %q(<input id="button_blark" name="reset" type="reset" value="Blark" />)
  end

  it 'supports multiple values for checkboxes' do
    fh.params = {:user => {'devices' => ['iPhone', 'iPad'] }}
    fh.checkbox(:user, :devices, ['iPhone', 'iPad', 'iPod', 'iPoop']).should ==
      "<input checked=\"checked\" id=\"user_devices_iphone\" name=\"user[devices][]\" type=\"checkbox\" value=\"iPhone\" /><label for=\"user_devices_iphone\">iPhone</label> <input checked=\"checked\" id=\"user_devices_ipad\" name=\"user[devices][]\" type=\"checkbox\" value=\"iPad\" /><label for=\"user_devices_ipad\">iPad</label> <input id=\"user_devices_ipod\" name=\"user[devices][]\" type=\"checkbox\" value=\"iPod\" /><label for=\"user_devices_ipod\">iPod</label> <input id=\"user_devices_ipoop\" name=\"user[devices][]\" type=\"checkbox\" value=\"iPoop\" /><label for=\"user_devices_ipoop\">iPoop</label>"
  end
end
