# AFIDA E-commerce Platform - Codebase Documentation

## Table of Contents

1. [Project Overview](#project-overview)
2. [Technology Stack](#technology-stack)
3. [Architecture](#architecture)
4. [Database Schema](#database-schema)
5. [Core Domain Models](#core-domain-models)
6. [Controllers & Routes](#controllers--routes)
7. [Frontend Architecture](#frontend-architecture)
8. [Authentication & Authorization](#authentication--authorization)
9. [Business Logic](#business-logic)
10. [Testing](#testing)
11. [Deployment](#deployment)
12. [Key Patterns & Conventions](#key-patterns--conventions)

---

## Project Overview

AFIDA is a B2B e-commerce platform built with Ruby on Rails for wholesale clients ordering eco-friendly packaging products. The application serves UK-based clients with customized pricing per customer.

**Key Features:**
- User management with role-based access (Admin/Customer)
- Product catalog with categories and custom pricing
- Shopping cart functionality
- Order processing with multi-step checkout
- Address management with UK postcode validation
- Invoice generation (PDF)
- Email notifications
- Analytics tracking (PostHog)

---

## Technology Stack

### Backend
- **Ruby**: 3.3.4
- **Rails**: 8.0.2
- **Database**: PostgreSQL with extensions (citext, plpgsql)
- **Web Server**: Puma 7.0.1
- **Session Store**: ActiveRecord Session Store

### Frontend
- **CSS Framework**: Tailwind CSS 4.x
- **JavaScript**:
  - Hotwire (Turbo Rails + Stimulus)
  - Importmap for module management
- **Asset Pipeline**: Propshaft
- **Templating**: ERB

### Authentication & Authorization
- **Devise**: 4.9 (authentication)
- **Devise Invitable**: 2.0 (user invitations)
- **CanCanCan**: 3.6 (authorization)

### File Storage
- **Active Storage**: Image attachments for products
- **AWS S3**: Cloud storage for production

### Additional Services
- **Email**: Mailgun
- **Analytics**: PostHog
- **PDF Generation**: Prawn
- **HTTP Client**: HTTParty
- **Time Formatting**: LocalTime

### Development & Testing
- **Testing**: Minitest with Capybara for system tests
- **Linting**: Rubocop Rails Omakase
- **Security**: Brakeman
- **Debugging**: Debug gem

### Deployment
- **Containerization**: Docker
- **Orchestration**: Kamal
- **Performance**: Thruster (HTTP caching/compression)

---

## Architecture

### MVC Structure

```
app/
├── assets/              # Static assets (images, stylesheets)
├── channels/            # Action Cable channels
├── controllers/         # Request handlers
│   ├── admin/          # Admin namespace
│   │   ├── dashboard_controller.rb
│   │   ├── users_controller.rb
│   │   ├── products_controller.rb
│   │   ├── price_list_items_controller.rb
│   │   └── addresses_controller.rb
│   ├── users/          # User-specific controllers
│   │   └── invitations_controller.rb
│   ├── addresses_controller.rb
│   ├── categories_controller.rb
│   ├── order_items_controller.rb
│   ├── orders_controller.rb
│   ├── postcode_lookups_controller.rb
│   ├── price_list_items_controller.rb
│   ├── products_controller.rb
│   ├── shopping_cart_items_controller.rb
│   └── users_controller.rb
├── helpers/             # View helpers
├── javascript/          # Frontend JavaScript
│   ├── components/     # Reusable JS components
│   └── controllers/    # Stimulus controllers
├── jobs/               # Background jobs
├── mailers/            # Email mailers
│   ├── application_mailer.rb
│   └── order_mailer.rb
├── models/             # Domain models
│   ├── ability.rb
│   ├── address.rb
│   ├── category.rb
│   ├── checkout.rb
│   ├── order.rb
│   ├── order_item.rb
│   ├── price_list_item.rb
│   ├── product.rb
│   ├── shopping_cart.rb
│   ├── shopping_cart_item.rb
│   └── user.rb
└── views/              # Templates (ERB)
    ├── admin/
    ├── addresses/
    ├── categories/
    ├── devise/
    ├── layouts/
    ├── order_items/
    ├── orders/
    ├── price_list_items/
    ├── products/
    ├── shared/
    ├── shopping_cart_items/
    └── users/
```

---

## Database Schema

### Core Tables

#### users
**Purpose**: Customer and admin accounts

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| email | string | Unique, used for login |
| encrypted_password | string | Devise password hash |
| first_name | string | User's first name |
| last_name | string | User's last name |
| company | string | Company name |
| role | integer | Enum: 0=customer, 1=admin |
| default_shipping_address_id | bigint | FK to addresses |
| default_billing_address_id | bigint | FK to addresses |
| invitation_token | string | For invite system |
| invitation_sent_at | datetime | Invitation timestamp |
| invitation_accepted_at | datetime | Acceptance timestamp |

**Indexes**: email (unique), invitation_token (unique)

#### products
**Purpose**: Product catalog

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| sku | citext | Case-insensitive SKU |
| name | string | Product name |
| description | text | Product details |
| colour | string | Product color |
| pac_size | integer | Package size |
| price | decimal(10,2) | Base price |
| width_in_mm | integer | Dimensions |
| depth_in_mm | integer | Dimensions |
| height_in_mm | integer | Dimensions |
| diameter_in_mm | integer | Dimensions |
| volume_in_ml | integer | Volume |
| category_id | bigint | FK to categories |
| deleted_at | datetime | Soft delete |

**Indexes**: sku, category_id

#### categories
**Purpose**: Product categorization

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| name | string | Category name |

#### price_list_items
**Purpose**: Custom pricing per user

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| user_id | bigint | FK to users |
| product_id | bigint | FK to products |
| price | decimal(10,2) | Custom price |
| hidden | boolean | Visibility flag (default: false) |
| deleted_at | datetime | Soft delete |

**Indexes**: user_id, product_id

#### addresses
**Purpose**: Shipping and billing addresses

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| user_id | bigint | FK to users |
| company | string | Company name |
| attn | string | Attention to |
| building_name | string | Building name |
| street_number_and_name | string | Street address (required) |
| post_town | string | City (required) |
| postcode | string | UK postcode (required) |
| additional_notes | text | Delivery notes |

**Indexes**: user_id

#### shopping_carts
**Purpose**: User shopping cart

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| user_id | bigint | FK to users (unique) |

**Indexes**: user_id

#### shopping_cart_items
**Purpose**: Items in shopping cart

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| shopping_cart_id | bigint | FK to shopping_carts |
| product_id | bigint | FK to products |
| quantity | integer | Item quantity (default: 0) |
| unit_price | decimal(10,2) | Price at time of add |

**Indexes**: shopping_cart_id, product_id

#### orders
**Purpose**: Customer orders

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| user_id | bigint | FK to users |
| status | integer | Enum: 0=pending, 1=processing, 2=shipped, 3=delivered, 4=canceled |
| payment_method | integer | Enum: 0=invoice, 1=bank_transfer, 2=credit_card |
| subtotal_amount | decimal(10,2) | Before tax/shipping |
| shipping_amount | decimal(10,2) | Shipping cost |
| vat_rate | decimal(10,2) | VAT percentage |
| vat_amount | decimal(10,2) | VAT total |
| total_amount | decimal(10,2) | Final total |
| shipping_address | text | Formatted address string |
| billing_address | text | Formatted address string |
| invoice_number | string | Generated: ONL-000{id} |

**Indexes**: user_id

#### order_items
**Purpose**: Line items in orders

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| order_id | bigint | FK to orders |
| product_id | bigint | FK to products |
| quantity | integer | Item quantity |
| unit_price | decimal(10,2) | Price at time of order |

**Indexes**: order_id, product_id

### Relationships

```
User
├── has_one :shopping_cart
├── has_many :shopping_cart_items (through: :shopping_cart)
├── has_many :orders
├── has_many :price_list_items
├── has_many :addresses
├── belongs_to :default_shipping_address (class: Address)
└── belongs_to :default_billing_address (class: Address)

Product
├── belongs_to :category
├── has_many :order_items
├── has_many :orders (through: :order_items)
├── has_many :price_list_items
├── has_many :shopping_cart_items
└── has_one_attached :picture

Category
└── has_many :products

Order
├── belongs_to :user
├── has_many :order_items
└── has_many :products (through: :order_items)

ShoppingCart
├── belongs_to :user
└── has_many :shopping_cart_items

Address
└── belongs_to :user
```

---

## Core Domain Models

### User (`app/models/user.rb`)

**Responsibilities:**
- Authentication (Devise)
- User invitations (Devise Invitable)
- Role management (customer/admin)
- Address management
- Shopping cart association
- Order history

**Key Methods:**
- `formatted_name`: Returns "FirstName LastName"
- `admin?`: Checks if user has admin role
- `customer?`: Checks if user has customer role
- `invited?`: Checks if invitation was sent
- `accepted_invitation?`: Checks if invitation was accepted
- `most_ordered_products(limit)`: Returns top ordered products with frequency

**Scopes**: Inherits from Devise

**Validations:**
- Email presence and uniqueness (Devise)
- Password confirmation

### Product (`app/models/product.rb`)

**Responsibilities:**
- Product information management
- Soft deletion
- Image attachments
- Category association

**Key Methods:**
- `soft_delete!`: Marks product as deleted (sets deleted_at)

**Scopes:**
- `default_scope`: Only active products (deleted_at: nil)
- `with_deleted`: Includes soft-deleted products

**Validations:**
- Name presence
- Price presence and >= 0

### Order (`app/models/order.rb`)

**Responsibilities:**
- Order lifecycle management
- Address handling (shipping/billing)
- Invoice number generation
- Revenue tracking

**Key Methods:**
- `build_address_strings`: Converts form fields to formatted addresses
- `generate_invoice_number`: Creates "ONL-000{id}" after creation

**Scopes:**
- `revenue_in_range(range)`: Sum of orders in date range
- `count_in_range(range)`: Count of orders in date range

**Enums:**
- `status`: pending, processing, shipped, delivered, canceled
- `payment_method`: invoice, bank_transfer, credit_card

**Validations:**
- Order items presence
- Shipping and billing addresses presence
- Subtotal > 0
- Payment method and status presence

**Virtual Attributes (for forms):**
- `selected_shipping_address_id`
- `selected_billing_address_id`
- `use_shipping_for_billing`
- `shipping_*` and `billing_*` address fields
- `save_shipping_address`, `save_billing_address`

### PriceListItem (`app/models/price_list_item.rb`)

**Responsibilities:**
- Custom pricing per user
- Product visibility control

**Scopes:**
- Likely has `without_hidden` scope (based on usage in code)

**Validations:**
- User and product associations
- Price presence

### Address (`app/models/address.rb`)

**Responsibilities:**
- UK address storage
- Address formatting

**Key Methods:**
- `formatted_address(include_attn:)`: Returns multi-line formatted address

**Validations:**
- User association
- Street, post_town, postcode presence

### Checkout (`app/models/checkout.rb`)

**Responsibilities:**
- Calculate order totals
- VAT calculations
- Shipping calculations

**Purpose**: Service object for order creation calculations

### Ability (`app/models/ability.rb`)

**Responsibilities:**
- Authorization rules (CanCanCan)

**Rules:**
- Customers can:
  - Read their own orders
  - Read their own price list items
  - Manage their shopping cart items
  - Create orders
  - Show/update their user profile
  - Manage their addresses

- Admins can:
  - Manage all resources

---

## Controllers & Routes

### Route Structure

```ruby
# Root
root 'orders#new'

# Authentication
devise_for :users, controllers: { invitations: 'users/invitations' }

# Public Resources
resources :addresses do
  member do
    patch :set_default_shipping
    patch :set_default_billing
  end
end
resources :categories, except: [:destroy]
resources :products
resources :price_list_items, only: [:show], path: 'price-list'
resources :users, only: [:show, :edit, :update]

# Shopping & Orders
resources :orders do
  get 'summary', on: :member
end
resources :shopping_cart_items do
  member do
    patch :add_to_cart
    patch :remove_from_cart
  end
end

# Utilities
get 'postcode_lookup', to: 'postcode_lookups#new'

# Admin Namespace
namespace :admin do
  get 'dashboard', to: 'dashboard#index'
  resources :users do
    resources :price_list_items, only: [:index], path: 'price-list'
    resources :addresses
  end
  resources :price_list_items, only: [:edit, :update], path: 'price-list'
  resources :products, only: [:show] do
    member { patch :update_visibility }
  end
end

# Health Check
get 'up' => 'rails/health#show', as: :rails_health_check
```

### Key Controllers

#### OrdersController (`app/controllers/orders_controller.rb`)

**Responsibilities:**
- Order creation from shopping cart
- PDF invoice generation
- Order management
- Address selection and saving
- PostHog analytics tracking

**Key Actions:**
- `new`: Set up order form with cart items and addresses
- `create`: Process order, send email, clear cart, track analytics
- `show`: Display order (HTML/PDF formats)
- `update`: Admin order updates
- `index`: List orders (filtered by role)

**Important Methods:**
- `build_shopping_cart_items`: Initialize cart from price list
- `categorized_shopping_cart_items`: Group cart items by category
- `save_addresses_from_order`: Persist new addresses if requested
- `capture_order_created`: Send analytics event to PostHog

#### Admin::DashboardController (`app/controllers/admin/dashboard_controller.rb`)

**Responsibilities:**
- Admin analytics and reporting
- Revenue metrics
- Order statistics

#### ProductsController (`app/controllers/products_controller.rb`)

**Responsibilities:**
- Product CRUD operations
- Category filtering
- Product images

#### ShoppingCartItemsController (`app/controllers/shopping_cart_items_controller.rb`)

**Responsibilities:**
- Add/remove items from cart
- Update quantities
- Cart management

**Key Actions:**
- `add_to_cart`: Increment quantity
- `remove_from_cart`: Decrement quantity or remove item

---

## Frontend Architecture

### JavaScript (Stimulus Controllers)

Located in `app/javascript/controllers/`:

1. **address_autocomplete_controller.js**
   - UK address autocomplete

2. **address_lookup_controller.js**
   - Postcode lookup integration
   - Fetches address details from UK postcode API

3. **address_selection_controller.js**
   - Manages address dropdown selection
   - Pre-fills form fields from saved addresses
   - Handles "Use shipping for billing" toggle

4. **chart_controller.js**
   - Admin dashboard charts
   - Data visualization

5. **order_item_controller.js**
   - Order item manipulation in forms

6. **postcode_validator_controller.js**
   - UK postcode format validation

7. **search_form_controller.js**
   - Product search functionality

8. **visibility_controller.js**
   - Product visibility toggles (admin)

### Styling

**Tailwind CSS 4.x**
- Configuration: `app/assets/tailwind/tailwind.config.js`
- Custom styles: `app/assets/stylesheets/application.tailwind.css`

**Asset Pipeline**
- Propshaft for asset serving
- Importmap for JavaScript modules

---

## Authentication & Authorization

### Authentication (Devise)

**Configuration**: `config/initializers/devise.rb`

**Features Enabled:**
- Database authenticatable
- Recoverable (password reset)
- Rememberable (persistent login)
- Validatable (email/password validation)
- Invitable (user invitations)

**User Roles:**
```ruby
enum :role, { customer: 0, admin: 1 }
```

### Authorization (CanCanCan)

**Ability Definition** (`app/models/ability.rb`):

```ruby
# Customers
can :read, Order, user: user
can :read, PriceListItem, user: user
can [:read, :add_to_cart, :remove_from_cart], ShoppingCartItem, shopping_cart: { user: user }
can :create, Order
can [:show, :update], User, id: user.id
can :manage, Address, user_id: user.id

# Admins
can :manage, :all
```

**Usage in Controllers:**
```ruby
load_and_authorize_resource  # Automatically applies CanCan
```

---

## Business Logic

### Order Creation Flow

1. **Shopping Cart Assembly**
   - Customer adds products to cart
   - Prices locked at user's custom price (from PriceListItem)
   - Cart persisted in database

2. **Checkout Process** (`OrdersController#new`)
   - Load cart items grouped by category
   - Load user's saved addresses
   - Pre-select default shipping/billing addresses
   - Display order form

3. **Order Submission** (`OrdersController#create`)
   - `Checkout` service calculates totals (subtotal, VAT, shipping, total)
   - Build Order with calculated values
   - Convert cart items to order_items
   - Validate and save order
   - Generate invoice number (after_create callback)
   - Send order confirmation email
   - Track analytics event (PostHog)
   - Optionally save new addresses
   - Clear shopping cart
   - Redirect to order summary

4. **Order Management**
   - Admins can update order status
   - Generate PDF invoices (Prawn)
   - Email notifications (Mailgun)

### Pricing System

**Multi-tier Pricing:**
1. **Base Price**: Product has default price
2. **Custom Price**: PriceListItem overrides per user
3. **Cart Price**: Locked when added to cart (unit_price in shopping_cart_items)
4. **Order Price**: Locked when order placed (unit_price in order_items)

**Price List Management:**
- Admins create/update PriceListItem records for each user
- Customers see only products in their price list
- Price list items can be hidden (hidden: true) without deletion

### Address Management

**Address Types:**
1. **Saved Addresses**: Reusable addresses stored in addresses table
2. **Default Addresses**: User can set default shipping and billing
3. **Order Addresses**: Stored as formatted text in orders (not FK)

**Address Flow:**
- User can select from saved addresses
- User can enter new address inline
- Option to save new address for future use
- Option to use shipping address for billing

---

## Testing

### Test Structure

```
test/
├── application_system_test_case.rb
├── channels/
├── controllers/           # Controller tests
├── fixtures/             # Test data (YAML)
├── helpers/              # Helper tests
├── integration/          # Integration tests
├── mailers/             # Mailer tests
├── models/              # Model tests
└── system/              # System tests (Capybara)
```

### Testing Stack

- **Framework**: Minitest
- **System Tests**: Capybara + Selenium WebDriver
- **Fixtures**: YAML-based test data

### Running Tests

```bash
# All tests
rails test

# Specific test file
rails test test/models/user_test.rb

# System tests
rails test:system
```

---

## Deployment

### Docker

**Dockerfile**: Multi-stage build
- Base image with Ruby 3.3.4
- Bundle install with deployment flags
- Asset precompilation
- Thruster for HTTP optimization

**Kamal Configuration** (`config/deploy.yml`):
- Container orchestration
- Zero-downtime deployments
- Environment configuration

### Environment Variables

**Required:**
- `DATABASE_URL`: PostgreSQL connection
- `RAILS_MASTER_KEY`: Credentials encryption key
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`: S3 storage
- `MAILGUN_API_KEY`, `MAILGUN_DOMAIN`: Email service
- `POSTHOG_API_KEY`, `POSTHOG_HOST`: Analytics

**Optional:**
- `RAILS_MAX_THREADS`: Puma threads (default: 5)
- `RAILS_LOG_LEVEL`: Log verbosity

### Production Setup

```bash
# Build Docker image
docker build -t afida .

# Database setup
rails db:create db:migrate

# Credentials
EDITOR=vim rails credentials:edit

# Deploy with Kamal
kamal deploy
```

---

## Key Patterns & Conventions

### Soft Deletion

Products use soft deletion pattern:
```ruby
default_scope { where(deleted_at: nil) }
scope :with_deleted, -> { unscope(where: :deleted_at) }

def soft_delete!
  update!(deleted_at: Time.zone.now)
end
```

### Service Objects

**Checkout** (`app/models/checkout.rb`):
- Encapsulates order calculation logic
- Single responsibility: compute totals
- Returns attributes hash for Order

### Scopes for Analytics

```ruby
scope :revenue_in_range, ->(range) { where(created_at: range).sum(:total_amount) }
scope :count_in_range, ->(range) { where(created_at: range).count }
```

### N+1 Query Prevention

```ruby
# Example from OrdersController
.includes(product: [:category, { picture_attachment: :blob }])
```

### Virtual Attributes for Forms

Order model uses `attr_accessor` for form-only fields that don't persist:
```ruby
attr_accessor :selected_shipping_address_id, :use_shipping_for_billing
```

### Nested Attributes

```ruby
accepts_nested_attributes_for :order_items,
  allow_destroy: true,
  reject_if: ->(attrs) { attrs['quantity'].to_i.zero? }
```

### Strong Parameters (Rails 8 Style)

```ruby
params.expect(order: [:status, :payment_method, ...])
```

### Callbacks

```ruby
before_validation :build_address_strings, on: :create
after_create :generate_invoice_number
```

### Enum Pattern

```ruby
enum :status, { pending: 0, processing: 1, shipped: 2, delivered: 3, canceled: 4 }
enum :payment_method, { invoice: 0, bank_transfer: 1, credit_card: 2 }
```

### Authorization Pattern

```ruby
class ApplicationController < ActionController::Base
  # CanCanCan automatically applied
  load_and_authorize_resource
end
```

### Multi-format Responses

```ruby
respond_to do |format|
  format.html
  format.pdf do
    send_data pdf_generator.render, type: 'application/pdf', disposition: 'inline'
  end
end
```

---

## Common Development Tasks

### Adding a New Product

```bash
rails console
> product = Product.create!(
    name: "Eco Box",
    sku: "ECO-001",
    price: 5.99,
    category: Category.first
  )
> product.picture.attach(io: File.open('path/to/image.jpg'), filename: 'eco-box.jpg')
```

### Creating a User with Price List

```ruby
user = User.create!(
  email: 'customer@example.com',
  first_name: 'John',
  last_name: 'Doe',
  company: 'Eco Company Ltd',
  role: :customer
)

# Invite user
user.invite!(User.find_by(role: :admin))

# Create custom pricing
Product.find_each do |product|
  PriceListItem.create!(
    user: user,
    product: product,
    price: product.price * 0.9  # 10% discount
  )
end
```

### Generating an Invoice

```ruby
order = Order.find(123)
pdf = OrderSummaryPdf.new(order).render
File.write("invoice_#{order.invoice_number}.pdf", pdf)
```

---

## API Integration Points

### Postcode Lookup

**Service**: UK Postcode API (via HTTParty)
**Controller**: `PostcodeLookupsController`
**Stimulus**: `address_lookup_controller.js`

**Flow**:
1. User enters postcode
2. JavaScript calls controller endpoint
3. Controller queries external API
4. Returns address suggestions
5. JavaScript populates form fields

### Analytics (PostHog)

**Events Tracked:**
- `order_created`: Full order details including items

**Configuration**: `config/initializers/posthog.rb`

**Usage**:
```ruby
$posthog.capture({
  distinct_id: current_user.email,
  event: 'order_created',
  properties: { ... }
})
```

---

## File Upload (Active Storage)

**Configuration**: `config/storage.yml`

**Services:**
- `local`: Development (storage/)
- `amazon`: Production (S3)

**Usage:**
```ruby
# In Product model
has_one_attached :picture

# In forms
form.file_field :picture

# In views
image_tag product.picture.variant(resize_to_limit: [300, 300])
```

---

## Email System

**Mailers**: `app/mailers/`
- `ApplicationMailer`: Base mailer
- `OrderMailer`: Order confirmation emails

**Configuration**: Mailgun via `mailgun-ruby` gem

**Templates**: `app/views/order_mailer/`

**Usage**:
```ruby
OrderMailer
  .with(order: @order, user: current_user)
  .new_order_email
  .deliver_now
```

---

## Security Considerations

### Implemented Protections

1. **CSRF Protection**: Rails default (Devise)
2. **SQL Injection**: ActiveRecord parameterized queries
3. **XSS Protection**: ERB auto-escaping
4. **Strong Parameters**: Controller parameter whitelisting
5. **Password Security**: Devise bcrypt hashing
6. **Authorization**: CanCanCan resource-level permissions
7. **Content Security Policy**: Configured in initializers
8. **Permissions Policy**: Configured in initializers

### Session Management

- **Store**: Database-backed sessions (activerecord-session_store)
- **Security**: HttpOnly cookies, signed session data

---

## Performance Optimizations

### Database

1. **Indexes**: On foreign keys, unique fields (email, SKU)
2. **Eager Loading**: `.includes()` to prevent N+1 queries
3. **Connection Pooling**: Configured per environment

### Caching

- Asset caching (Propshaft)
- Fragment caching opportunities (not yet implemented)

### Image Processing

- **ImageProcessing gem**: Resize variants on-the-fly
- **Variants**: Cached to reduce regeneration

---

## Development Workflow

### Local Development

```bash
# Start development server with all services
bin/dev

# This runs (from Procfile.dev):
# - rails server
# - tailwindcss watch
```

### Database Management

```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Reset database (caution!)
rails db:reset

# Seed data
rails db:seed
```

### Code Quality

```bash
# Run Rubocop
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a

# Security audit
bundle exec brakeman
```

---

## Troubleshooting

### Common Issues

1. **Missing Images in Development**
   - Check `storage/` directory exists
   - Verify Active Storage migrations ran
   - Check image processing gem installed

2. **Cart Not Persisting**
   - Check session store configured
   - Verify sessions table exists (migration)
   - Check cookies enabled in browser

3. **Email Not Sending**
   - Verify Mailgun credentials in environment
   - Check mailer configuration in `config/environments/`
   - Review logs for SMTP errors

4. **Authorization Errors**
   - Verify user role (customer/admin)
   - Check ability.rb rules
   - Ensure `load_and_authorize_resource` in controller

---

## Future Enhancements

Based on codebase patterns, potential improvements:

1. **Background Jobs**: Add Sidekiq for async email/analytics
2. **Fragment Caching**: Cache product listings
3. **API**: Add JSON API for mobile app
4. **Inventory Management**: Track stock levels
5. **Reporting**: Enhanced admin analytics
6. **Payment Integration**: Stripe for credit card processing
7. **Search**: Elasticsearch for advanced product search
8. **Internationalization**: I18n for multi-language support (currently UK-only)

---

## Resources

- **Rails Guides**: https://guides.rubyonrails.org/
- **Devise**: https://github.com/heartcombo/devise
- **CanCanCan**: https://github.com/CanCanCommunity/cancancan
- **Hotwire**: https://hotwired.dev/
- **Tailwind CSS**: https://tailwindcss.com/

---

*Last Updated: 2025*
*Rails Version: 8.0.2*
*Ruby Version: 3.3.4*
