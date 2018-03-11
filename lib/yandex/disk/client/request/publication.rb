# frozen_string_literal: true

require 'nokogiri'

class Yandex::Disk::Client::Request::Publication
  BODY =
  '<propertyupdate xmlns="DAV:">
    <set>
      <prop>
        <public_url xmlns="urn:yandex:disk:meta">true</public_url>
      </prop>
    </set>
  </propertyupdate>'.freeze
  HEADERS = {
  }.freeze

  def initialize http, path
    @http = http
    @path = path
    freeze
  end

  def perform
    response = @http.run_request :proppatch, @path, BODY, HEADERS
    parse_result = parse(response.body)
    { :public_url => parse_result.public_url }
  end

  private

  class AttributesParser < Nokogiri::XML::SAX::Document
    attr_reader :public_url

    def start_element name, attributes = []
      case name
        when 'public_url'
          @public_url = true
      end
    end

    def characters string
      @public_url = string if (@public_url == true)
    end
  end

  def parse body
    attributes_parser = AttributesParser.new

    parser = Nokogiri::XML::SAX::Parser.new(attributes_parser)
    parser.parse(body)

    attributes_parser
  end
end
