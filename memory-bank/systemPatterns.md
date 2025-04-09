# System Patterns: AFIDA E-commerce Platform

## System Architecture

### Application Architecture
AFIDA follows a standard Ruby on Rails MVC (Model-View-Controller) architecture:

- **Models**: Represent data structures and business logic
- **Views**: Handle presentation and user interface
- **Controllers**: Manage request flow and coordinate between models and views

The application uses Rails 7.2 features including:
- Active Record for ORM
- Active Storage for file attachments
- Devise for authentication
- Tailwind CSS for styling

### Database Architecture
PostgreSQL database with the following key tables:
- Users
- Products
- Categories
- PriceListItems
- ShoppingCarts
- ShoppingCartItems
- Orders
- OrderItems
- Addresses

## Key Design Patterns

### Authentication & Authorization
- **Devise**: Handles user authentication, password recovery, and session management
- **Devise Invitable**: Manages user invitations
- **Role-based Access**: Admin and customer roles with different permissions

### Soft Deletion
Products and price list items implement soft deletion pattern:
- Records are marked with `deleted_at` timestamp rather than being physically removed
- Default scopes exclude soft-deleted records
- `with_deleted` scope allows access to soft-deleted records when needed

### Shopping Cart Pattern
- ShoppingCart belongs to a User
- ShoppingCartItems belong to a ShoppingCart and reference Products
- Cart state persists between sessions
- Items can be added, removed, or have quantities adjusted

### Custom Pricing System
- Each user has their own price list items for products
- PriceListItems link Users to Products with custom pricing
- Hidden flag allows selective visibility of price list items
- Default product pricing as fallback

### Address Management
- Addresses belong to Users
- Users can have default shipping and billing addresses
- Addresses can be reused across multiple orders
- Address formatting handled by model methods

### Order Processing Workflow
- Orders have a status enum (pending, processing, shipped, delivered, canceled)
- Orders track shipping and billing addresses
- Orders have payment method enum (invoice, bank transfer, credit card)
- Invoice numbers are automatically generated

## Component Relationships

### User-related Components
```
User
  ├── ShoppingCart
  │     └── ShoppingCartItems
  ├── Orders
  │     └── OrderItems
  ├── Addresses
  └── PriceListItems
```

### Product-related Components
```
Category
  └── Products
        ├── PriceListItems
        ├── OrderItems
        └── ShoppingCartItems
```

### Order-related Components
```
Order
  ├── OrderItems
  │     └── Products
  └── User
```

## Critical Implementation Paths

### User Registration & Invitation
1. Admin creates user account with email
2. System sends invitation email
3. User sets password and completes registration
4. Admin configures price list items for user

### Shopping Process
1. User browses products by category
2. User views product details with personalized pricing
3. User adds products to shopping cart
4. User adjusts quantities or removes items as needed
5. User proceeds to checkout

### Checkout Process
1. User reviews cart contents
2. User selects or enters shipping address
3. User selects or enters billing address
4. User selects payment method
5. System creates order with order items
6. System generates invoice number
7. System calculates VAT and shipping
8. System sends order confirmation

### Order Management
1. Admin views pending orders
2. Admin processes orders and updates status
3. System notifies users of status changes
4. Admin marks orders as shipped or delivered

## Technical Debt & Considerations

### Performance Optimization
- N+1 query prevention for product listings with price list items
- Pagination for large result sets
- Caching strategies for frequently accessed data

### Security Considerations
- CSRF protection
- SQL injection prevention via parameterized queries
- Authorization checks on all sensitive actions
- Secure password handling via Devise

### Scalability Patterns
- Database indexing on frequently queried columns
- Efficient query patterns
- Potential for background job processing for order handling
