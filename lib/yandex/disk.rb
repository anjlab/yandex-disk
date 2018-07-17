# coding: utf-8

# frozen_string_literal: true

require 'yandex/disk/version'

module Yandex
  module Disk
    autoload :Client, 'yandex/disk/client'

    module Backup
      autoload :Storage, 'yandex/disk/backup/storage'
    end
  end
end
