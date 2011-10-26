module MessageHistory
  class Message
    attr_reader :from         # Array<String>
    attr_reader :to           # Array<String>
    attr_reader :body         # String
    attr_reader :meta_data    # Hash
    attr_reader :html_preview # String (html)

    def initialize(from, to, body, meta_data, html_preview=nil)
      @from         = from
      @to           = to
      @body         = body
      @meta_data    = meta_data
      @html_preview = html_preview || derive_html_preview
    end

    def derive_html_preview
      "<p>" \
        "From: #{from.join(', ')}<br>\n" \
        "To: #{to.join(', ')}<br>\n" \
        "Body: #{body}" \
      "</p>"
    end
  end
end
