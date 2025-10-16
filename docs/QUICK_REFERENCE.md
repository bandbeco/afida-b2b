# AFIDA Quick Reference Guide

A quick reference for common development tasks and patterns in the AFIDA codebase.

## Table of Contents

- [Common Commands](#common-commands)
- [Key File Locations](#key-file-locations)
- [Database Quick Reference](#database-quick-reference)
- [Model Associations](#model-associations)
- [Common Queries](#common-queries)
- [URL Helpers](#url-helpers)
- [Authorization Quick Reference](#authorization-quick-reference)
- [Frontend Controllers](#frontend-controllers)
- [Helper Methods](#helper-methods)

---

## Common Commands

### Development

```bash
# Start development server
bin/dev

# Rails console
rails console

# Database
rails db:migrate
rails db:rollback
rails db:reset
rails db:seed

# Tests
rails test
rails test:system
rails test test/models/user_test.rb

# Code quality
bundle exec rubocop
bundle exec rubocop -a  # Auto-fix
bundle exec brakeman    # Security scan
```

### Production

```bash
# Deploy
kamal deploy

# Run migrations
kamal app exec 'rails db:migrate'

# Rails console (production)
kamal app exec -i 'rails console'
```

---

## Key File Locations

| Purpose | Location |
|---------|----------|
| Routes | `config/routes.rb` |
| Schema | `db/schema.rb` |
| Models | `app/models/` |
| Controllers | `app/controllers/` |
| Views | `app/views/` |
| Stimulus Controllers | `app/javascript/controllers/` |
| Mailers | `app/mailers/` |
| Authorization Rules | `app/models/ability.rb` |
| Test Fixtures | `test/fixtures/` |
| Tailwind Config | `app/assets/tailwind/tailwind.config.js` |
| Credentials | `config/credentials.yml.enc` |

---

## Database Quick Reference

### Core Tables

```ruby
users                  # Customer and admin accounts
products              # Product catalog
categories            # Product categories
price_list_items      # Custom pricing per user
addresses             # Saved addresses
shopping_carts        # User carts
shopping_cart_items   # Items in carts
orders                # Customer orders
order_items           # Line items in orders
```

### Key Columns

```ruby
# Users
users.role            # 0=customer, 1=admin
users.default_shipping_address_id
users.default_billing_address_id

# Products
products.deleted_at   # Soft delete
products.sku          # Case-insensitive (citext)

# Orders
orders.status         # 0=pending, 1=processing, 2=shipped, 3=delivered, 4=canceled
orders.payment_method # 0=invoice, 1=bank_transfer, 2=credit_card
orders.invoice_number # Format: ONL-000{id}

# Price List Items
price_list_items.hidden  # Hide from customer view
```

---

## Model Associations

### User

```ruby
user.shopping_cart
user.shopping_cart_items
user.orders
user.price_list_items
user.addresses
user.default_shipping_address
user.default_billing_address
```

### Product

```ruby
product.category
product.order_items
product.orders
product.price_list_items
product.shopping_cart_items
product.picture        # Active Storage attachment
```

### Order

```ruby
order.user
order.order_items
order.products
```

---

## Common Queries

### Users

```ruby
# Find admin
User.find_by(role: :admin)

# Find customer by email
User.find_by(email: 'customer@example.com')

# All customers
User.where(role: :customer)

# Users who accepted invitation
User.where.not(invitation_accepted_at: nil)
```

### Products

```ruby
# All active products
Product.all  # Default scope excludes soft-deleted

# Including deleted
Product.with_deleted

# By category
Product.where(category: category)

# With images
Product.with_attached_picture

# Soft delete
product.soft_delete!
```

### Orders

```ruby
# User's orders
user.orders.order(created_at: :desc)

# By status
Order.where(status: :pending)

# Revenue in date range
Order.revenue_in_range(1.month.ago..Time.current)

# Count in date range
Order.count_in_range(1.week.ago..Time.current)

# With order items
Order.includes(:order_items)
```

### Shopping Cart

```ruby
# Get or create cart
cart = user.shopping_cart || user.create_shopping_cart

# Cart items grouped by category
cart.shopping_cart_items
    .includes(product: [:category, { picture_attachment: :blob }])
    .group_by { |item| item.product.category }
```

### Price Lists

```ruby
# User's price list (visible items)
user.price_list_items.without_hidden

# Create custom pricing
PriceListItem.create!(
  user: user,
  product: product,
  price: 10.99
)

# Hide item
price_list_item.update!(hidden: true)
```

---

## URL Helpers

### Common Routes

```ruby
# Root
root_path                      # /

# Users
user_path(user)               # /users/:id
edit_user_path(user)          # /users/:id/edit

# Products
products_path                 # /products
product_path(product)         # /products/:id
new_product_path              # /products/new

# Categories
categories_path               # /categories
category_path(category)       # /categories/:id

# Shopping Cart
add_to_cart_shopping_cart_item_path(item)  # PATCH /shopping_cart_items/:id/add_to_cart

# Orders
orders_path                   # /orders
new_order_path               # /orders/new
order_path(order)            # /orders/:id
summary_order_path(order)    # /orders/:id/summary

# Addresses
addresses_path                # /addresses
set_default_shipping_address_path(address)  # PATCH /addresses/:id/set_default_shipping

# Admin
admin_dashboard_path          # /admin/dashboard
admin_users_path              # /admin/users
admin_user_price_list_items_path(user)  # /admin/users/:user_id/price-list
```

---

## Authorization Quick Reference

### Customer Permissions

```ruby
# Can read own resources
can :read, Order, user: user
can :read, PriceListItem, user: user

# Can manage cart
can [:read, :add_to_cart, :remove_from_cart], ShoppingCartItem

# Can create orders
can :create, Order

# Can manage own profile
can [:show, :update], User, id: user.id

# Can manage own addresses
can :manage, Address, user_id: user.id
```

### Admin Permissions

```ruby
# Can manage everything
can :manage, :all
```

### Usage in Controllers

```ruby
# Load and authorize automatically
load_and_authorize_resource

# Manual authorization
authorize! :read, @order

# Check permissions
current_user.can?(:create, Order)
current_user.cannot?(:destroy, @product)
```

---

## Frontend Controllers

### Stimulus Controllers

```javascript
// Address selection
data-controller="address-selection"
data-action="change->address-selection#selectAddress"

// Address lookup (postcode)
data-controller="address-lookup"
data-action="click->address-lookup#lookup"

// Postcode validation
data-controller="postcode-validator"
data-action="input->postcode-validator#validate"

// Chart (admin dashboard)
data-controller="chart"

// Visibility toggle (admin)
data-controller="visibility"
data-action="click->visibility#toggle"

// Search form
data-controller="search-form"
data-action="submit->search-form#search"
```

---

## Helper Methods

### User Helpers

```ruby
user.formatted_name                # "John Doe"
user.admin?                       # Check if admin
user.customer?                    # Check if customer
user.invited?                     # Invitation sent?
user.accepted_invitation?         # Invitation accepted?
user.most_ordered_products(5)     # Top 5 products
```

### Order Helpers

```ruby
# In OrdersHelper (app/helpers/orders_helper.rb)
order_summary_pdf(order)          # Generate PDF invoice
```

### Address Helpers

```ruby
address.formatted_address(include_attn: true)  # Multi-line formatted address
```

### Product Helpers

```ruby
# Check if product has image
product.picture.attached?

# Image variant
product.picture.variant(resize_to_limit: [300, 300])
```

### View Helpers

```ruby
# Current user
current_user

# Authorization
can?(:create, Order)
cannot?(:manage, User)

# Flash messages
flash[:notice]
flash[:alert]
```

---

## Environment-Specific Configuration

### Check Environment

```ruby
Rails.env.development?
Rails.env.test?
Rails.env.production?
```

### Credentials

```bash
# Edit credentials
EDITOR=vim rails credentials:edit

# Access in code
Rails.application.credentials.aws[:access_key_id]
```

---

## Testing Patterns

### Model Tests

```ruby
# test/models/user_test.rb
test "should create user" do
  user = User.new(email: 'test@example.com', ...)
  assert user.save
end

test "should require email" do
  user = User.new(email: nil)
  assert_not user.valid?
end
```

### Controller Tests

```ruby
# test/controllers/orders_controller_test.rb
test "should get index" do
  get orders_url
  assert_response :success
end

test "should create order" do
  assert_difference('Order.count') do
    post orders_url, params: { order: { ... } }
  end
end
```

### System Tests

```ruby
# test/system/orders_test.rb
test "placing an order" do
  visit new_order_url
  fill_in "Postcode", with: "SW1A 1AA"
  click_on "Place Order"
  assert_text "Order was successfully created"
end
```

---

## Useful Console Commands

### User Management

```ruby
# Create admin
User.create!(
  email: 'admin@afida.com',
  first_name: 'Admin',
  last_name: 'User',
  role: :admin,
  password: 'password',
  password_confirmation: 'password'
)

# Invite user
admin = User.find_by(role: :admin)
User.invite!({ email: 'new@example.com' }, admin)

# Reset password
user = User.find_by(email: 'user@example.com')
user.update(password: 'newpassword', password_confirmation: 'newpassword')
```

### Product Management

```ruby
# Create product
product = Product.create!(
  name: 'Eco Box',
  sku: 'ECO-001',
  price: 5.99,
  category: Category.first
)

# Attach image
product.picture.attach(
  io: File.open('path/to/image.jpg'),
  filename: 'eco-box.jpg'
)
```

### Order Management

```ruby
# Find order
order = Order.find(123)

# Update status
order.update(status: :shipped)

# Order details
order.order_items.each do |item|
  puts "#{item.product.name}: #{item.quantity} @ £#{item.unit_price}"
end

# Total revenue
Order.sum(:total_amount)
```

---

## Common Patterns

### Soft Delete

```ruby
# Model
default_scope { where(deleted_at: nil) }

def soft_delete!
  update!(deleted_at: Time.zone.now)
end

# Query including deleted
Product.with_deleted
```

### Enums

```ruby
# Definition
enum :status, { pending: 0, processing: 1 }

# Usage
order.status = :processing
order.processing?
order.pending!
Order.where(status: :shipped)
```

### Nested Attributes

```ruby
# Model
accepts_nested_attributes_for :order_items, allow_destroy: true

# Form
form.fields_for :order_items do |item_form|
  item_form.text_field :quantity
end
```

### Scopes

```ruby
# Definition
scope :visible, -> { where(hidden: false) }
scope :in_range, ->(range) { where(created_at: range) }

# Usage
Product.visible
Order.in_range(1.week.ago..Time.current)
```

---

## Debugging Tips

```ruby
# In code
Rails.logger.debug "Order: #{@order.inspect}"
puts @order.attributes.to_yaml

# In views
<%= debug @order %>

# Byebug
debugger  # Pauses execution

# SQL queries
ActiveRecord::Base.logger = Logger.new(STDOUT)  # In console
```

---

## Performance Tips

```ruby
# Eager loading (avoid N+1)
Product.includes(:category, :picture_attachment)
Order.includes(order_items: :product)

# Batch processing
Product.find_each do |product|
  # Process each product
end

# Pluck (get specific columns)
User.pluck(:id, :email)

# Count vs. Size vs. Length
Product.count        # SQL COUNT query
products.size        # COUNT if not loaded, length if loaded
products.length      # Loads all records
```

---

*For more detailed information, see [CODEBASE.md](CODEBASE.md)*
