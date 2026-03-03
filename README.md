# AtomosFlags ⚛️🚩

Elegant, lightweight, and atomic feature flags for Rails applications.

Designed for distributed systems and high-performance environments. `AtomosFlags` provides deterministic targeting and request-level immutability.

## Features

- **Atomic Decisions:** Once a flag is evaluated within a request, it stays the same (via `ActiveSupport::CurrentAttributes`).
- **Deterministic Rollout:** Percentage-based rollout is consistent for the same actor across all nodes.
- **Polymorphic Actors:** Target flags based on any object (User, Context, Team) that responds to certain methods.
- **Audit-Ready:** Easily snapshot all active flags for a given actor to store in your metadata/audit logs.
- **Lightweight:** No heavy dependencies, uses your existing ActiveRecord connection.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'atomos_flags'
```

And then execute:
```bash
$ bundle install
$ bin/rails atomos_flags:install:migrations
$ bin/rails db:migrate
```

## Usage

### Basic Toggle
```ruby
if AtomosFlags.on?(:new_engine)
  # Do something
end
```

### Targeting an Actor
```ruby
# Actor can be a User, Context, or any object
if AtomosFlags.on?(:beta_feature, actor: current_user)
  # Only for specific users based on rules
end
```

### Snapshotting for Audits
Perfect for storing in your "Atoms" or database records:
```ruby
record.metadata[:flags] = AtomosFlags.snapshot(current_user)
```

## Targeting Rules (JSONB)

Flags are managed via the `feature_flags` table. Example rules:

```json
{
  "context_ids": [1, 45, 99],
  "user_emails": ["@genghisgain.pl"],
  "percentage": 10,
  "seed": "my_v1_rollout"
}
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
