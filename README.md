# Yandex::Disk gem

Dead simple ruby wrapper for [Yandex.Disk API](http://api.yandex.ru/disk/doc/dg/concepts/about.xml)

To get your `access_token`:

1. Register your app at [Yandex](https://oauth.yandex.ru/client/new)
    1. Be sure to check 'Yandex.Disk permits'
    2. Be sure to check 'Client for development' (it will set https://oauth.yandex.ru/verification_code?dev=True as `Callback URI`)
2. Get access token https://oauth.yandex.ru/authorize?response_type=token&client_id=YOUR_APP_ID
3. Get your access token from redirect url (right from the browser, it will be one of parameters)

## Installation

Add this line to your application's Gemfile:

    gem 'yandex-disk'

## Usage

```ruby
# authorize via oauth access token...
disk = Yandex::Disk::Client.new(:access_token => 'YOUR_ACCESS_TOKEN')

# ...or use login password for authorization
disk = Yandex::Disk::Client.new(:login => 'me', :password => 'secret')

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
disk.copy('/path/to/remote/file/or/dir', '/path/to/new/remote/file/or/dir')
# move file/dir
disk.move('/path/to/remote/file/or/dir', '/path/to/new/remote/file/or/dir')
# delete file/dir
disk.delete('/path/to/remote/file/or/dir') # returns `true` if everything is ok

# property update operations:

# to make folder or file public
disk.make_public('/path/to/remote/dir/or/file') # returns hash with public url `=> { :public_url => "https://yadi.sk/i/B98Qjxxx3S5QJc" }` if everything is ok

# to get quotas
disk.space # returns hash like { :quota_available_bytes => 2488943615, :quota_used_bytes => 2488943615 }

# to get dir contents
disk.list('/') # returns array with hashes like [{:href=>"/",:resourcetype=>:collection,:getlastmodified=><DateTime>,:getcontentlength=>0,:displayname=>"disk",:creationdate=><DateTime>},{:href=>"/readme.pdf",:getlastmodified=><DateTime>,:getcontentlength=>455833,:displayname=>"readme.pdf",:creationdate=><DateTime>}]
```

## Using it with [backup gem](https://github.com/meskyanichi/backup)

```ruby
require 'yandex/disk/backup/storage'

Backup::Model.new(:my_backup, 'Description for my_backup') do
  split_into_chunks_of 50

  database PostgreSQL do |db|
    db.name     = 'pg_db_name'
    db.username = 'username'
    db.password = 'password'
  end

  compress_with Gzip

  store_with Yandex::Disk do |disk|
    disk.access_token = 'YOUR_ACCESS_TOKEN'
    disk.path         = '/backups/'
    disk.keep         = 5
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

## Thanks for support and contribution

- [@aishek (Alexandr Borisov)](https://github.com/aishek)
- [@ilyario (Пономарев Илья)](https://github.com/ilyario)
- [@vivanov77](https://github.com/vivanov77)
