# coding: utf-8

require 'faraday'
require 'faraday_middleware'

module Yandex
  module Disk
    class Client

    def initialize options={}
      @http = Faraday.new(:url => 'https://webdav.yandex.ru') do |builder|
        builder.request :authorization, "OAuth", options[:access_token]

        builder.response :follow_redirects

        if faraday_configurator = options[:faraday_configurator]
          faraday_configurator.call(builder)
        else
          builder.adapter :excon
        end
      end
    end

    def put src, dest
      res = @http.put do |req|
        req.url dest
        req.headers['Content-Type'] = 'application/binary'
        req.body = File.open(src)
      end
      res.success?
    end

    def mkcol path
      request = @http.build_request('MKCOL') do |req|
        req.url(path)
      end

      env = request.to_env(@http)
      res = @http.app.call(env)
      res.success?
    end

    alias_method :mkdir, :mkcol

    def mkdir_p path
      path_parts = []
      path.split('/').each do |part|
        path_parts << part
        mkdir(path_parts.join('/'))
      end
    end

    def get path
      @http.get(path)
    end

    def copy src, dest
      file_operation 'COPY', src, dest
    end

    def move src, dest
      file_operation 'MOVE', src, dest
    end

    def delete path
      @http.delete(path).success?
    end

    private

    def file_operation op, src, dest
      request = @http.build_request(op) do |req|
        req.url(path)
        req.headers['Destination'] = dest
      end

      env = request.to_env(@http)
      res = @http.app.call(env)
      res.success?
    end
  end
  end
end