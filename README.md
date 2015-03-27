# G5HubApi::Client

Gem to enable easy access to G5 Hub APIs

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'g5_hub_api_client', git: 'git@github.com:G5/g5_hub_api_client.git'
```
Using the github method is only a temporary measure until we can get the gem published.

And then execute:

    $ bundle

## G5HubApi::Client

```ruby
require 'g5_hub_api_client'
```

### .new(host)

```ruby
client = G5HubApi::Client.new('http://localhost:3000')
```

## Notifications

To access the functionality to do with notifications you'll use the `NotificationService`

```ruby
service = client.notification_service
```

Will return a service object that has methods to access notification
functionality like retrieving Notifications and creating new ones.

### NotificationService.all(client_urn, params={page: 0, page_size: 25, auth_token: nil})

**Example**
```ruby
results = client.notification_service.all(g5_client_urn, page: 0, page_size: 12, auth_token: '1234sdf...')
```

**Returns** ApiResponse structured thus:
```ruby
class ApiResponse
  attr_accessor :results,     # Array of Notifications
                :total_rows,  # Total number of notifications for client
                :error        # Error if one has occurred, otherwise nil
  ...
end
```

### NotificationService.create(client_urn, `Notification`, params={auth_token: nil})

**Example**
```ruby
result = client.notification_service.create g5_client_urn, notification
```

**Returns** `Notification`

### `Notification` Model

The `Notification` model is structured thus

```ruby
class Notification
  attr_accessor :id,            # int
                :product,       # String
                :locations,     # Array of Strings
                :notif_type,    # String
                :description,   # String
                :actions,       # Hash of actions
                :client_id,     # id of client in hub DB... not client_urn
                :created_at,    # Date
                :modified_at    # Date
  ...
end
```