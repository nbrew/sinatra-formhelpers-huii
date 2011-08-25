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
      url = action
      method_input = ''
      if action.is_a? Symbol
        case method.to_s.downcase
        when 'delete', 'update'
          method_input = %Q(<input type="hidden" name="_method" value="#{method}" />)
          method = :post
        when 'create'
          method = :post
        end
        url = "/#{action}"
      end
        
      out = tag(:form, nil, {:action => url, :method => method.to_s.upcase}.merge(options)) + method_input
      if block_given?
        @form_object = action
        out << yield
        @form_object = nil
      end
      out
    end
    
    def link(content, href=content, options={})
      tag :a, content, options.merge(:href => href)  
    end

    def label(obj, field, display = "", options={})
      tag :label, (display.nil? || display == '') ? titleize(field.to_s) : display, options.merge(:for => "#{obj}_#{field}")
    end
    
    def text(obj, field="", options={})
      content = params[obj] ? params[obj][field.to_s] : ""       
      id = 
      single_tag :input, options.merge(
        :type => "text", :id => field == "" ? obj : "#{obj}_#{field}",
        :name => field == "" ? obj : "#{obj}[#{field}]",
        :value => content
      )
    end
    
    def textarea(obj, field, options={})
      content = params[obj] ? params[obj][field.to_s] : ""        
      tag :textarea, content, options.merge(:id => "#{obj}_#{field}", :name => "#{obj}[#{field}]")
    end
    
    def image(src, options={})
      single_tag :img, options.merge(:src => src)
    end
    
    def submit(obj, value="", options={})
      single_tag :input, options.merge(:type => "submit", :value => value == "" ? obj : value)
    end

    def checkbox(obj, field, values, options={})
      join = options.delete(:join) || ' '
      Array(values).collect do |val|
        single_tag :input, options.merge(:type => "checkbox", :id => "#{obj}_#{field}_#{val.to_s.downcase}",
                                         :name => "#{obj}[#{field}]", :value => val)
      end.join(join)
    end
    
    def radio(obj, field, values, options={})
      #content = @params[obj] && @params[obj][field.to_s] == value ? "true" : ""    
      # , :checked => content
      join = options.delete(:join) || ' '
      Array(values).collect do |val|
        single_tag :input, options.merge(:type => "radio", :id => "#{obj}_#{field}_#{val.to_s.downcase}",
                                         :name => "#{obj}[#{field}]", :value => val)
      end.join(join)
    end
    
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
    
    def hidden(obj, field="", options={})
      content = params[obj] && params[obj][field.to_s] == value ? "true" : ""       
      single_tag :input, options.merge(:type => "hidden", :id => "#{obj}_#{field}", :name => "#{obj}[#{field}]")      
    end
    
    # standard open and close tags
    # EX : tag :h1, "shizam", :title => "shizam"
    # => <h1 title="shizam">shizam</h1>
    def tag(name, content, options={})
      "<#{name.to_s}" +
        (options.length > 0 ? " #{hash_to_html_attrs(options)}" : '') + 
        (content.nil? ? '>' : ">#{content}</#{name}>")
    end
    
    # standard single closing tags
    # single_tag :img, :src => "images/google.jpg"
    # => <img src="images/google.jpg" />
    def single_tag(name, options={})
      "<#{name.to_s} #{hash_to_html_attrs(options)} />"
    end
    
    def minimal_escape_html(text)
      text.to_s.gsub(/\&/,'&amp;').gsub(/\"/,'&quot;').gsub(/>/,'&gt;').gsub(/</,'&lt;')
    end
    
    def titleize(text)
      text.to_s.gsub(/_+/, ' ').gsub(/\b('?[a-z])/) { $1.capitalize }
    end

    def hash_to_html_attrs(options={})
      html_attrs = ""
      options.keys.sort.each do |key|
        html_attrs << %Q(#{key}="#{minimal_escape_html(options[key])}" )
      end
      html_attrs.chop
    end
    
  end

  helpers FormHelpers
end
