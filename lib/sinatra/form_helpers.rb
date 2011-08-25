module Sinatra
  module FormHelpers
    # FormHelpers are a suite of helper methods
    # built to make building forms in Sinatra
    # a breeze.
    # 
    # link "jackhq", "http://www.jackhq.com"
    # 
    # label :person, :first_name
    # text :person, :first_name
    # 
    # area :person, :notes
    # 
    # etc.
    def form(action, method=:get, options={}, &block)
      method_input = ''
      if method.is_a? Symbol
        case method.to_s.downcase
        when 'delete', 'update'
          method_input = %Q(<input type="hidden" name="_method" value="#{method}" />)
          method = :post
        when 'create'
          method = :post
        end
      end
      action = "/#{action}" if action.is_a? Symbol

      out = tag(:form, nil, {:action => action, :method => method.to_s.upcase}.merge(options)) + method_input
      out << fieldset(action, &block) + '</form>' if block_given?
      out
    end

    def fieldset(obj, legend=nil, &block)
      raise ArgumentError, "Missing block to fieldset()" unless block_given?
      out = yield Fieldset.new(self, obj)
      '<fieldset>' + (legend.nil? ? '' : "<legend>#{fast_escape_html(legend)}</legend>") + out + '</fieldset>'
    end
    
    # Link to a URL
    def link(content, href=content, options={})
      tag :a, content, options.merge(:href => href)  
    end

    # Link to an image
    def image(src, options={})
      single_tag :img, options.merge(:src => src)
    end

    # Form field label
    def label(obj, field, display = "", options={})
      tag :label, (display.nil? || display == '') ? titleize(field.to_s) : display, options.merge(:for => "#{obj}_#{field}")
    end

    # Form text input.  Specify the value as :value => 'foo'
    def text(obj, field=nil, options={})
      value = param_or_default(obj, field, options[:value])
      single_tag :input, options.merge(
        :type => "text", :id => field.nil? ? obj : "#{obj}_#{field}",
        :name => field.nil? ? obj : "#{obj}[#{field}]",
        :value => value
      )
    end

    # Form password input.  Specify the value as :value => 'foo'
    def password(obj, field=nil, options={})
      value = param_or_default(obj, field, options[:value])
      single_tag :input, options.merge(
        :type => "password", :id => field.nil? ? obj : "#{obj}_#{field}",
        :name => field.nil? ? obj : "#{obj}[#{field}]",
        :value => value
      )
    end

    # Form textarea box.
    def textarea(obj, field=nil, content='', options={})
      content = param_or_default(obj, field, content)
      tag :textarea, content, options.merge(
        :id   => field.nil? ? obj : "#{obj}_#{field}",
        :name => field.nil? ? obj : "#{obj}[#{field}]"
      )
    end

    # Form submit tag.
    def submit(value='Submit', options={})
      single_tag :input, {:name => "submit", :type => "submit", :value => value}.merge(options)
    end

    # Form reset tag.  Does anyone use these anymore?
    def reset(value='Reset', options={})
      single_tag :input, {:name => "reset", :type => "reset", :value => value}.merge(options)
    end

    # Form checkbox.  Specify an array of values to get a checkbox group.
    def checkbox(obj, field, values, options={})
      join = options.delete(:join) || ' '
      Array(values).collect do |val|
        single_tag :input, options.merge(:type => "checkbox", :id => "#{obj}_#{field}_#{val.to_s.downcase}",
                                         :name => "#{obj}[#{field}]", :value => val)
      end.join(join)
    end
    
    # Form radio input.  Specify an array of values to get a radio group.
    def radio(obj, field, values, options={})
      #content = @params[obj] && @params[obj][field.to_s] == value ? "true" : ""    
      # , :checked => content
      join = options.delete(:join) || ' '
      Array(values).collect do |val|
        single_tag :input, options.merge(:type => "radio", :id => "#{obj}_#{field}_#{val.to_s.downcase}",
                                         :name => "#{obj}[#{field}]", :value => val)
      end.join(join)
    end

    # Form select dropdown.  Currently only single-select (not multi-select) is supported.
    def select(obj, field, values, options={})
      content = ""
      Array(values).each do |val|
        if val.is_a? Array
          content << tag(:option, val.last, :value => val.first)
        else
          content << tag(:option, val, :value => val)
        end
      end
      tag :select, content, options.merge(:id => "#{obj}_#{field}", :name => "#{obj}[#{field}]")
    end
    
    # Form hidden input.  Specify value as :value => 'foo'
    def hidden(obj, field="", options={})
      content = param_or_default(obj, field, options[:value])
      single_tag :input, options.merge(:type => "hidden", :id => "#{obj}_#{field}", :name => "#{obj}[#{field}]")      
    end
    
    # Standard open and close tags
    # EX : tag :h1, "shizam", :title => "shizam"
    # => <h1 title="shizam">shizam</h1>
    def tag(name, content, options={})
      "<#{name.to_s}" +
        (options.length > 0 ? " #{hash_to_html_attrs(options)}" : '') + 
        (content.nil? ? '>' : ">#{content}</#{name}>")
    end
    
    # Standard single closing tags
    # single_tag :img, :src => "images/google.jpg"
    # => <img src="images/google.jpg" />
    def single_tag(name, options={})
      "<#{name.to_s} #{hash_to_html_attrs(options)} />"
    end
    
    def fast_escape_html(text)
      text.to_s.gsub(/\&/,'&amp;').gsub(/\"/,'&quot;').gsub(/>/,'&gt;').gsub(/</,'&lt;')
    end
    
    def titleize(text)
      text.to_s.gsub(/_+/, ' ').gsub(/\b('?[a-z])/) { $1.capitalize }
    end

    def param_or_default(obj, field, default)
      if field
        params[obj] ? params[obj][field.to_s] || default : default
      else
        params[obj] || default
      end
    end

    def hash_to_html_attrs(options={})
      html_attrs = ""
      options.keys.sort.each do |key|
        html_attrs << %Q(#{key}="#{fast_escape_html(options[key])}" )
      end
      html_attrs.chop
    end

    class Fieldset
      def initialize(parent, name)
        @parent = parent
        @name   = name.to_s.gsub(/\W+/,'')
        @outbuf = ''
      end

      def method_missing(meth, *args)
        @outbuf << @parent.send(meth, @name, *args)
      end
    end
  end

  helpers FormHelpers
end
