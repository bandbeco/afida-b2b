# AFIDA E-commerce Platform

A B2B e-commerce platform for wholesale clients ordering eco-friendly packaging products, built with Ruby on Rails.

## Quick Start

### Prerequisites

- Ruby 3.3.4
- PostgreSQL 14+
- Node.js (for asset compilation)

### Setup

```bash
# Install dependencies
bundle install

# Setup database
rails db:create db:migrate db:seed

# Start development server
bin/dev
```

The application will be available at `http://localhost:3000`

## Project Overview

AFIDA is a wholesale ordering platform serving UK-based clients with:

- **Custom Pricing**: Each customer has a personalized price list
- **Product Catalog**: Eco-friendly packaging products organized by category
- **Shopping Cart**: Persistent cart with quantity management
- **Order Management**: Full order lifecycle with PDF invoices
- **Address Management**: UK postcode validation and saved addresses
- **User Invitations**: Admin-controlled customer onboarding
- **Analytics**: PostHog integration for order tracking

## Technology Stack

- **Backend**: Ruby on Rails 8.0.2, PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **Authentication**: Devise + Devise Invitable
- **Authorization**: CanCanCan
- **File Storage**: Active Storage (S3 in production)
- **Deployment**: Docker + Kamal

## Documentation

Comprehensive documentation is available in the `/docs` directory:

- **[Codebase Documentation](docs/CODEBASE.md)**: Complete technical guide including:
  - Architecture overview
  - Database schema
  - Domain models
  - Controllers & routes
  - Frontend architecture
  - Business logic flows
  - Testing guide
  - Deployment instructions

## Project Structure

```
app/
├── controllers/     # Request handlers (including admin namespace)
├── models/         # Domain models (User, Product, Order, etc.)
├── views/          # ERB templates
├── javascript/     # Stimulus controllers
├── mailers/        # Email templates
└── assets/         # Stylesheets and images

config/
├── routes.rb       # Application routes
├── database.yml    # Database configuration
└── initializers/   # App initialization

db/
├── migrate/        # Database migrations
├── schema.rb       # Current schema
└── seeds.rb        # Seed data

test/               # Minitest test suite
```

## Common Tasks

### Create an Admin User

```ruby
rails console

User.create!(
  email: 'admin@afida.com',
  first_name: 'Admin',
  last_name: 'User',
  role: :admin,
  password: 'temporary_password',
  password_confirmation: 'temporary_password'
)
```

### Invite a Customer

```ruby
admin = User.find_by(role: :admin)
customer = User.invite!(
  { email: 'customer@company.com',
    first_name: 'John',
    last_name: 'Doe',
    company: 'Eco Company Ltd' },
  admin
)
```

### Run Tests

```bash
# All tests
rails test

# System tests
rails test:system

# Specific test
rails test test/models/user_test.rb
```

### Code Quality

```bash
# Linting
bundle exec rubocop

# Security audit
bundle exec brakeman
```

## Deployment

The application is containerized with Docker and deployed using Kamal:

```bash
# Deploy to production
kamal deploy

# Check deployment status
kamal app details
```

See [Deployment Documentation](docs/CODEBASE.md#deployment) for detailed instructions.

## Environment Variables

Required environment variables for production:

```env
DATABASE_URL=postgresql://...
RAILS_MASTER_KEY=...
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=...
MAILGUN_API_KEY=...
MAILGUN_DOMAIN=...
POSTHOG_API_KEY=...
POSTHOG_HOST=...
```

## User Roles

- **Customer**: Can browse products, manage cart, place orders, view order history
- **Admin**: Full access including user management, product management, analytics dashboard

## Key Features

### For Customers

- Browse products by category
- View custom pricing (price list)
- Add items to shopping cart
- Place orders with shipping/billing addresses
- Save addresses for future use
- View order history
- Download PDF invoices

### For Admins

- Manage products and categories
- Create/invite users
- Set custom pricing per user
- View order analytics
- Process orders
- Manage product visibility

## Support

For technical issues or questions, refer to:

1. [Codebase Documentation](docs/CODEBASE.md)
2. Project cursor rules in `.cursorrules`
3. Memory bank in `memory-bank/` directory

## License

Proprietary - All rights reserved
