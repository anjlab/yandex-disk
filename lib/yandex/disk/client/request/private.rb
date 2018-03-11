# frozen_string_literal: true

class Yandex::Disk::Client::Request::Private
  BODY =
  '<propertyupdate xmlns="DAV:">
    <set>
      <prop>
        <public_url xmlns="urn:yandex:disk:meta" />
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
    @http.run_request :proppatch, @path, BODY, HEADERS
    true
  end
end
