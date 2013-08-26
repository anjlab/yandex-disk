# Yandex::Disk gem

Dead simple ruby wrapper for [Yandex.Disk API](http://api.yandex.ru/disk/doc/dg/concepts/about.xml)

1. Register you app
2. Get access token https://oauth.yandex.ru/authorize?response_type=token&client_id=<YOUR_APP_ID>
3. get access token from redirect url (right from the browser)

## Installation

Add this line to your application's Gemfile:

    gem 'yandex-disk'

## Usage

```ruby
disk = Yandex::Disk::Client.new(:access_token => 'YOUR_ACCESS_TOKEN')

# to upload file to Yandex.Disk
disk.put('path/to/local/file', '/path/to/remote/file') # returns `true` if everything is ok

# to download file to Yandex.Disk
res = disk.get('/path/to/remote/file') # => res.body will contain file

# to make dir (only creates last part of path)
disk.mkdir('/path/to/remote/dir') # returns `true` if everything is ok

# to make full path
disk.mkdir_p('/path/to/remote/dir')

# remote file operations:

# copy file/dir
disk.copy('/path/to/remote/file/or/dir', ''/path/to/new/remote/file/or/dir')
# move file/dir
disk.move('/path/to/remote/file/or/dir', ''/path/to/new/remote/file/or/dir')
# delete file/dir
disk.delete('/path/to/remote/file/or/dir') # returns `true` if everything is ok
```

## Using it with [backup gem](https://github.com/meskyanichi/backup)

```ruby
require 'yandex/disk/backup/storage'

Backup::Model.new(:my_backup, 'Description for my_backup') do
  split_into_chunks_of 250

  database PostgreSQL do |db|
    db.name               = 'pg_db_name'
    db.username           = 'username'
    db.password           = 'password'
  end

  compress_with Gzip

  store_with ::Yandex::Disk::Backup::Storage do |server|
    server.access_token = 'YOUR_ACCESS_TOKEN'
    server.path         = '/backups/'
    server.keep         = 5
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

To run tests setup env var with your access_token and run `rake`

export YANDEX_DISK_TOKEN=e5d4aaa4ec2246558b510f7fef25b7b1
