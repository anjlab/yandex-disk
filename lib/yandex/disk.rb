# coding: utf-8

require 'yandex/disk/version'

module Yandex
  module Disk
    autoload :Client, 'yandex/disk/client'

    module Backup
      autoload :Storage, 'yandex/disk/backup/storage'
    end
  end
end