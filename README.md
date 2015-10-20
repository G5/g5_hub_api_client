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

## Running Unit Tests

    rspec spec

## Running End-To-End Tests

Make sure that you have a client hub up and running. Open notifications_e2e_spec.rb and set the

`CLIENT_URN` e.g. g5-c-6jxap99-blark,
`HUB_HOST` e.g. 'http://localhost:3000'
`AUTH_TOKEN` e.g. 0419547595d6e36c7d9b7424ba4865ddba4bb662fbdd70e0815daaae311788b2

Getting an `AUTH_TOKEN` is a little difficult. You can do it manually by adding

```ruby
logger.debug(current_user.g5_access_token)
```

to any G5 Auth enabled webapp and then watching the logs.

Next run

    rspec spec_end2end

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

### NotificationService.all_for_user(user_id, params={page: 0, page_size: 25, auth_token: nil})

**Example**
```ruby
results = client.notification_service.all_for_user(user_id, page: 0, page_size: 12, auth_token: '1234sdf...')
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
result = client.notification_service.create(g5_client_urn, notification, auth_token: 'someauthtoken')
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
                :actions,       # Array of Actions
                :client_id,     # id of client in hub DB... not client_urn
                :created_at,    # Date
                :modified_at    # Date
                :read_at        # Date
  ...
end
```

### `Action` Model

The `Action model is structured thus

```ruby
class Action
    attr_accessor :label,   # String
                  :url      # URL
...
end
```
