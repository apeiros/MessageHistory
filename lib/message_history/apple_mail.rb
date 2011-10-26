require 'plist'
require 'mail'

module MessageHistory

  # Technical Notes:
  # * Parsing of the flags bitset is done according to http://www.apfelwiki.de/Main/EMLX
  class AppleMail < Mail::Message
    def self.read(path)
      size,content,meta=nil
      File.open(path, :encoding => Encoding::UTF_8) do |fh|
        size    = fh.read(11).to_i
        content = fh.read(size)
        meta    = fh.read
      end

      new(content, meta)
    end
    
    def self.watch   
      require 'fssm'                
      FSSM.monitor('~/Library/Mail', '**/*.emlx') do
           create {|base, relative| MessageHistory << MessageHistory::AppleMail.read(File.join(base,relative)) }
      end                              
    end

    def to_message
      MessageHistory::Message.new(Array(from), Array(to), to_message_body, to_message_meta_data)
    end

    def to_message_body
      if parts.empty? then
        part = self
      else
        part = parts.find { |part| part.content_type =~ %r{text/plain} } ||
               parts.find { |part| part.content_type =~ %r{text/html} }
      end
      charset = part.charset
      case part.content_type
        when %r{text/plain}
          body = part.body.to_s.force_encoding(charset).encode(Encoding::UTF_8)
        when %r{text/html}
          html = part.body.to_s.force_encoding(charset).encode(Encoding::UTF_8)
          body = Nokogiri.HTML(html).text
      end

      "#{subject}\n#{body}"
    end

    def to_message_meta_data
      {}
    end

    def self.from_string(string)
      size    = string[0,11].to_i
      content = string[11,size]
      meta    = string[(11+size)..-1]
      new(content, meta)
    end

    attr_reader :plist_data

    # @param [String] content
    #   The E-Mail
    # @param [String] meta
    #   The meta-data plist xml
    def initialize(content, meta)
      @plist_data = meta
      super(content)
    end

    # @return [Hash]
    #   The parsed meta-data plist of the email
    def plist
      @plist ||= Plist.parse_xml(@plist_data)
    end

    def read?
      @read ||= (plist["flags"][0] == 1)
    end
    def deleted?
      @deleted ||= (plist["flags"][1] == 1)
    end
    def answered?
      @answered ||= (plist["flags"][2] == 1)
    end
    def encrypted?
      @encrypted ||= (plist["flags"][3] == 1)
    end
    def flagged?
      @flagged ||= (plist["flags"][4] == 1)
    end
    def recent?
      @recent ||= (plist["flags"][5] == 1)
    end
    def draft?
      @draft ||= (plist["flags"][6] == 1)
    end
    def initial?
      @initial ||= (plist["flags"][7] == 1)
    end
    def forwarded?
      @forwarded ||= (plist["flags"][8] == 1)
    end
    def redirected?
      @redirected ||= (plist["flags"][9] == 1)
    end
    def attachment_count
      @attachment_count ||= ((plist["flags"] >> 10) & 0b111111)
    end
    def priority_level
      @priority_level ||= ((plist["flags"] >> 16) & 0b1111111)
    end
    def signed?
      @signed ||= (plist["flags"][23] == 1)
    end
    def junk?
      @is_junk ||= (plist["flags"][24] == 1)
    end
    def not_junk?
      @is_not_junk ||= (plist["flags"][25] == 1)
    end
    def font_size_delta
      @font_size_delta ||= ((plist["flags"] >> 26) & 0b111)
    end
    def junk_mail_level_recorded
      @junk_mail_level_recorded ||= (plist["flags"][29] == 1)
    end
    def highlight_text_in_toc
      @highlight_text_in_toc ||= (plist["flags"][30] == 1)
    end
  end
end
