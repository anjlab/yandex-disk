# coding: utf-8

# frozen_string_literal: true

require 'yandex/disk/client'

module Backup
  module Storage
    module Yandex
      class Disk < Base
        include Storage::Cycler

        attr_accessor :access_token

        def initialize(model, storage_id = nil, &block)
          super
          instance_eval(&block) if block_given?
          @path ||= '/backups'
        end

        def connection
          ::Yandex::Disk::Client.new(:access_token => access_token, :timeout => 500)
        end

        def transfer!
          disk = connection
          disk.mkdir_p(remote_path)
          package.filenames.each do |filename|
            src = File.join(Config.tmp_path, filename)
            dest = File.join(remote_path, filename)
            Logger.info "Storing '#{ dest }'..."
            disk.put!(src, dest)
          end
        end

        def remove!(package)
          Logger.info "Removing backup package dated #{ package.time }..."
          remote_path = remote_path_for(package)
          connection.delete(remote_path)
        end

        def storage_name
          'Yandex::Disk'.freeze
        end

      end
    end
  end
end
