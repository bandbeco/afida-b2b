# Project Brief: AFIDA E-commerce Platform

## Overview
AFIDA is an e-commerce platform built with Ruby on Rails, designed to facilitate online ordering of products with customized pricing for different users. The system supports product categorization, user management with different roles, shopping cart functionality, and order processing.

## Core Requirements

### User Management
- Support for customer and admin roles
- User authentication via Devise
- User invitation system
- Profile management with address storage

### Product Management
- Product categorization
- Product details including dimensions, volume, color, etc.
- Product images via Active Storage
- Soft deletion capability

### Pricing System
- Custom price lists per user
- Ability to hide specific price list items
- Default product pricing

### Shopping Experience
- Shopping cart functionality
- Add/remove items from cart
- Cart persistence

### Order Processing
- Order creation from cart items
- Shipping and billing address management
- Multiple payment methods (invoice, bank transfer, credit card)
- Order status tracking
- Invoice number generation
- VAT and shipping calculations

### Address Management
- Save and reuse addresses
- Default shipping and billing addresses
- Address validation

## Technical Requirements
- Ruby on Rails framework
- PostgreSQL database
- Responsive design
- Secure authentication
- Data validation
- Efficient database queries

## Success Criteria
- Users can browse products by category
- Users can add products to cart and place orders
- Admins can manage products, categories, and users
- Custom pricing is applied correctly per user
- Orders are processed accurately with proper invoicing
- Address management works seamlessly
