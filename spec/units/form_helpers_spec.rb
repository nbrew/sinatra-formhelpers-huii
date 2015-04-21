RSpec.describe "Sinatra::FormHelpers methods" do
  it 'renders an anchor tag' do
    expect( fh.form(:person, :create) ).to eq( '<form action="/person" method="post"><input type="hidden" name="_method" value="create" />' )
  end

  it 'renders a form tag' do
    expect( fh.form(:person, :update, action: "/people/14") ).to eq(
      '<form action="/people/14" method="post"><input type="hidden" name="_method" value="update" />'
    )
  end

  it 'renders a form tag (2)' do
    expect( fh.form("/people/7", :delete) ).to eq(
      '<form action="/people/7" method="post"><input type="hidden" name="_method" value="delete" />'
    )
  end

  it 'renders a form tag (3)' do
    expect( fh.form("/people", :create) ).to eq(
      '<form action="/people" method="post"><input type="hidden" name="_method" value="create" />'
    )
  end

  it 'renders a nested form tag' do
    expect( fh.form(:person, :create) do |f|
      # f.input(:first_name)
      f.input(:last_name)
    end ).to eq( '<form action="/person" method="post"><input type="hidden" name="_method" value="create" /><fieldset>' +
      # '<input id="person_first_name" name="person[first_name]" type="text" />' +
      '<input id="person_last_name" name="person[last_name]" type="text" />' +
      '</fieldset></form>'
    )
  end

  it 'renders a nested form tag with different action and namespace' do
    expect( fh.form(:person, :create, action: "/people") do |f|
      f.input(:name)
    end ).to eq( '<form action="/people" method="post"><input type="hidden" name="_method" value="create" /><fieldset>' +
      '<input id="person_name" name="person[name]" type="text" />' +
      '</fieldset></form>'
    )
  end

  it 'nests form elements arbitrarily' do
    expect( fh.fieldset(:person) do |n|
      # n.radio(:partners, 1..6)
      n.textarea(:comments, "yo yo yo!")
    end ).to eq( '<fieldset>' +
      # '<input id="person_partners_1" name="person[partners]" type="radio" value="1" /> ' +
      # '<input id="person_partners_2" name="person[partners]" type="radio" value="2" /> ' +
      # '<input id="person_partners_3" name="person[partners]" type="radio" value="3" /> ' +
      # '<input id="person_partners_4" name="person[partners]" type="radio" value="4" /> ' +
      # '<input id="person_partners_5" name="person[partners]" type="radio" value="5" /> ' +
      # '<input id="person_partners_6" name="person[partners]" type="radio" value="6" />' +
      '<textarea id="person_comments" name="person[comments]">yo yo yo!</textarea></fieldset>'
    )
  end

  it 'nests form elements arbitrarily with nil value' do
    expect( fh.fieldset(:person) do |n|
      # n.radio(:partners, 1..6)
      n.textarea(:comments, nil)
    end ).to eq( '<fieldset>' +
      # '<input id="person_partners_1" name="person[partners]" type="radio" value="1" /> ' +
      # '<input id="person_partners_2" name="person[partners]" type="radio" value="2" /> ' +
      # '<input id="person_partners_3" name="person[partners]" type="radio" value="3" /> ' +
      # '<input id="person_partners_4" name="person[partners]" type="radio" value="4" /> ' +
      # '<input id="person_partners_5" name="person[partners]" type="radio" value="5" /> ' +
      # '<input id="person_partners_6" name="person[partners]" type="radio" value="6" />' +
      '<textarea id="person_comments" name="person[comments]"></textarea></fieldset>'
    )
  end

  it 'renders a fieldset tag with an input' do
    expect( fh.fieldset(:user) do |f|
      f.input(:last_name)
    end ).to eq( '<fieldset><input id="user_last_name" name="user[last_name]" type="text" /></fieldset>' )
  end

  it 'renders an empty fieldset tag' do
    expect( fh.fieldset(:user) do |f|
    end ).to eq( '<fieldset></fieldset>' )
  end

  it 'renders a fieldset tag with legend' do
    expect( fh.fieldset(:user, 'Oh boy!') do |f|
    end ).to eq( '<fieldset><legend>Oh boy!</legend></fieldset>' )
  end

  it 'renders a link tag' do
    expect( fh.link('http://google.com') ).to eq( '<a href="http://google.com">http://google.com</a>' )
  end

  it 'renders a form label tag' do
    expect( fh.label(:person, :first_name) ).to eq( '<label for="person_first_name">First Name</label>' )
  end

  it 'renders a form checkbox tag' do
    expect( fh.checkbox(:person, :gender, %w[M F], join: '<br />') ).to eq(
      '<input id="person_gender_m" name="person[gender][]" type="checkbox" value="M" /><label for="person_gender_m">M</label><br />' +
      '<input id="person_gender_f" name="person[gender][]" type="checkbox" value="F" /><label for="person_gender_f">F</label>'
    )
  end

  it 'renders a minimal text tag' do
    expect( fh.input(:q) ).to eq( %q(<input id="q" name="q" type="text" />) )
  end

  it 'renders a minimal email tag' do
    expect( fh.email(:q) ).to eq( %q(<input id="q" name="q" type="email" />) )
  end

  it 'renders a minimal textarea tag' do
    expect( fh.textarea(:r) ).to eq( %q(<textarea id="r" name="r"></textarea>) )
  end

  it 'renders a submit tag' do
    expect( fh.submit ).to eq( %q(<input id="button_submit" name="submit" type="submit" value="Submit" />) )
    expect( fh.submit("Send!") ).to eq( %q(<input id="button_send_" name="submit" type="submit" value="Send!" />) )
  end

  it 'renders a reset tag' do
    expect( fh.reset ).to eq( %q(<input id="button_reset" name="reset" type="reset" value="Reset" />) )
    expect( fh.reset("Blark") ).to eq( %q(<input id="button_blark" name="reset" type="reset" value="Blark" />) )
  end

  it 'supports multiple values for checkboxes' do
    fh.params = {user: {'devices' => ['iPhone', 'iPad'] }}
    expect( fh.checkbox(:user, :devices, ['iPhone', 'iPad', 'iPod', 'iPoop']) ).to eq(
      "<input checked=\"checked\" id=\"user_devices_iphone\" name=\"user[devices][]\" type=\"checkbox\" value=\"iPhone\" /><label for=\"user_devices_iphone\">iPhone</label> <input checked=\"checked\" id=\"user_devices_ipad\" name=\"user[devices][]\" type=\"checkbox\" value=\"iPad\" /><label for=\"user_devices_ipad\">iPad</label> <input id=\"user_devices_ipod\" name=\"user[devices][]\" type=\"checkbox\" value=\"iPod\" /><label for=\"user_devices_ipod\">iPod</label> <input id=\"user_devices_ipoop\" name=\"user[devices][]\" type=\"checkbox\" value=\"iPoop\" /><label for=\"user_devices_ipoop\">iPoop</label>"
    )
  end

  describe "#select" do
    it "renders a select tag" do
      fh.params = {}
      expect( fh.select(:video, :src_format, ['59.94i','59.94p','30p']) ).to eql(
        '<select id="video_src_format" name="video[src_format]"><option value="59.94i">59.94i</option><option value="59.94p">59.94p</option><option value="30p">30p</option></select>'
      )
    end

    it "selects value from passed value option" do
      expect( fh.select(:video, :src_format, ['59.94i','59.94p','30p'], {value: '59.94i'}) ).to eq(
        '<select id="video_src_format" name="video[src_format]"><option selected="selected" value="59.94i">59.94i</option><option value="59.94p">59.94p</option><option value="30p">30p</option></select>'
      )
    end

    it "selects value from params" do
      fh.params = {video: {:src_format => '59.94i'}}
      expect( fh.select(:video, :src_format, ['59.94i','59.94p','30p']) ).to eq(
        '<select id="video_src_format" name="video[src_format]"><option selected="selected" value="59.94i">59.94i</option><option value="59.94p">59.94p</option><option value="30p">30p</option></select>'
      )
    end

  end

end
