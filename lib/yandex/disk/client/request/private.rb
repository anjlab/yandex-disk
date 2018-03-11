class Yandex::Disk::Client::Request::Private
  BODY =
  '<propertyupdate xmlns="DAV:">
    <set>
      <prop>
        <public_url xmlns="urn:yandex:disk:meta" />
      </prop>
    </set>
  </propertyupdate>'
  HEADERS = {
  }

  def initialize http, path
    @http = http
    @path = path
  end

  def perform
    @http.run_request :proppatch, @path, BODY, HEADERS
    true
  end
end
