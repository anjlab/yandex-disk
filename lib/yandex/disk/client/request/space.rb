require 'nokogiri'

class Yandex::Disk::Client::Request::Space
  BODY = '<D:propfind xmlns:D="DAV:">
  <D:prop>
    <D:quota-available-bytes/>
    <D:quota-used-bytes/>
  </D:prop>
</D:propfind>'
  HEADERS = {
    :Depth => 0
  }

  def initialize(http)
    @http = http
  end

  def perform
    response = @http.run_request :propfind, '/', BODY, HEADERS
    parse_result = parse(response.body)
    {
      :quota_available_bytes => parse_result.quota_available_bytes,
      :quota_used_bytes => parse_result.quota_used_bytes
    }
  end


  private

  class AttriutesParser < Nokogiri::XML::SAX::Document
    attr_reader :quota_available_bytes, :quota_used_bytes

    def start_element(name, attributes = [])
      case name
        when 'd:quota-used-bytes'
          @is_quota_used_bytes = true
        when 'd:quota-available-bytes'
          @is_quota_available_bytes = true
      end
    end

    def characters(string)
      @quota_used_bytes = string.to_i if @is_quota_used_bytes
      @quota_available_bytes = string.to_i if @is_quota_available_bytes
    end
  end

  def parse(body)
    attributes_parser = AttriutesParser.new

    parser = Nokogiri::XML::SAX::Parser.new(attributes_parser)
    parser.parse(body)

    attributes_parser
  end
end