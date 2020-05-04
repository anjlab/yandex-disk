require 'nokogiri'
require 'date'

class Yandex::Disk::Client::Request::List
  HEADERS = {
    :Depth => 1
  }

  def initialize http, path
    @http = http
    @path = path
  end

  def perform
    response = @http.run_request :propfind, @path, nil, HEADERS
    parse_result = parse(response.body)
    parse_result.list
  end


  private

  class ListParser < Nokogiri::XML::SAX::Document
    attr_reader :list

    def initialize
      @list = []
    end

    def start_element name, attributes = []
      case name
        when 'd:href'
          @current = {}
          @is_href = true

        when 'd:displayname'
          @is_displayname = true

        when 'd:getcontentlength'
          @is_getcontentlength = true

        when 'd:creationdate'
          @is_creationdate = true

        when 'd:getlastmodified'
          @is_getlastmodified = true

        when 'd:collection'
          @current[:resourcetype] = :collection
      end
    end

    def end_element name, attributes = []
      case name
        when 'd:href'
          @list << @current if @current
          @is_href = false

        when 'd:displayname'
          @is_displayname = false

        when 'd:getcontentlength'
          @is_getcontentlength = false

        when 'd:creationdate'
          @is_creationdate = false

        when 'd:getlastmodified'
          @is_getlastmodified = false
      end
    end

    def characters string
      @current[:href] = string if @is_href
      @current[:displayname] = string if @is_displayname
      @current[:getcontentlength] = string.to_i if @is_getcontentlength
      @current[:creationdate] = DateTime.parse(string) if @is_creationdate
      @current[:getlastmodified] = DateTime.parse(string) if @is_getlastmodified
    end
  end

  def parse body
    list_parser = ListParser.new

    parser = Nokogiri::XML::SAX::Parser.new(list_parser)
    parser.parse(body)

    list_parser
  end
end