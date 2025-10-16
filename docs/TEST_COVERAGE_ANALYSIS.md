# Test Coverage Analysis & Recommendations

**Generated**: 2025-10-16
**Baseline Coverage**: 43.23% line coverage, 50% branch coverage
**Target Coverage**: 90%+ line coverage

## Executive Summary

### Current State
- **Total Tests**: 68 tests, 125 assertions
- **Line Coverage**: 43.23% (415/960 lines)
- **Branch Coverage**: 50.0% (31/62 branches)
- **Status**: All tests passing ✅

### Critical Issues Identified

1. **Product Model**: Empty test file (0% coverage)
2. **User Model**: Missing critical business logic tests
3. **Checkout Model**: Only 1 test for 7 methods
4. **Address Model**: No validation or formatting tests
5. **Ability Model**: No authorization tests
6. **Controllers**: Missing error path tests
7. **Mailers**: Minimal coverage

---

## Priority 1: Critical Business Logic (HIGH)

### Product Model (`app/models/product.rb`)
**Current Coverage**: ~20% (estimated)
**Test File**: `test/models/product_test.rb` (EMPTY)

**Missing Tests**:
- [ ] Validations (name, price presence)
- [ ] Price numericality validation (>= 0)
- [ ] Soft deletion (`soft_delete!`)
- [ ] Default scope (excludes deleted)
- [ ] `with_deleted` scope
- [ ] Category association
- [ ] Picture attachment
- [ ] Order items relationship

**Impact**: HIGH - Core domain model, affects pricing and orders

---

### Checkout Model (`app/models/checkout.rb`)
**Current Coverage**: ~14% (1/7 methods)
**Test File**: `test/models/checkout_test.rb`

**Missing Tests**:
- [ ] `subtotal_amount` calculation
- [ ] `shipping_amount` logic (free over £100)
- [ ] `quantities` sum
- [ ] `total_amount` calculation
- [ ] `attributes` hash structure
- [ ] Edge case: empty cart
- [ ] Edge case: exactly £100 threshold

**Impact**: CRITICAL - Financial calculations, affects all orders

---

### User Model (`app/models/user.rb`)
**Current Coverage**: ~15% (3/20+ methods)
**Test File**: `test/models/user_test.rb`

**Missing Tests**:
- [ ] `most_ordered_products(limit)` - complex query
- [ ] `invited?` predicate
- [ ] `accepted_invitation?` predicate
- [ ] Associations (orders, shopping_cart, addresses, price_list_items)
- [ ] Default address relationships
- [ ] Password validation (edge cases)
- [ ] Email validation
- [ ] Role enum behavior

**Impact**: HIGH - User behavior affects pricing, orders, cart

---

## Priority 2: Data Integrity (MEDIUM-HIGH)

### Address Model (`app/models/address.rb`)
**Current Coverage**: Unknown (likely <30%)
**Test File**: `test/models/address_test.rb`

**Missing Tests**:
- [ ] Required field validations (street, post_town, postcode)
- [ ] `formatted_address(include_attn:)` method
- [ ] UK postcode format
- [ ] User association
- [ ] Optional fields (company, attn, building_name, notes)

**Impact**: MEDIUM-HIGH - Shipping errors if broken

---

### ShoppingCartItem Model (`app/models/shopping_cart_item.rb`)
**Current Coverage**: Unknown
**Test File**: `test/models/shopping_cart_item_test.rb`

**Missing Tests**:
- [ ] Quantity validation (>= 0)
- [ ] Unit price validation (presence, >= 0)
- [ ] `total_price` calculation
- [ ] `added_to_cart` scope (quantity > 0)
- [ ] `attributes` method
- [ ] Decimal precision handling

**Impact**: MEDIUM - Cart functionality

---

### PriceListItem Model (`app/models/price_list_item.rb`)
**Current Coverage**: Partial
**Test File**: `test/models/price_list_item_test.rb`

**Missing Tests**:
- [ ] `without_hidden` scope
- [ ] User-product uniqueness
- [ ] Price validation
- [ ] Hidden flag behavior

**Impact**: MEDIUM - Custom pricing integrity

---

## Priority 3: Authorization & Security (MEDIUM)

### Ability Model (`app/models/ability.rb`)
**Current Coverage**: Minimal
**Test File**: `test/integration/ability_test.rb`

**Missing Tests**:
- [ ] Customer can read own orders
- [ ] Customer can read own price list
- [ ] Customer can manage own cart
- [ ] Customer can create orders
- [ ] Customer can manage own addresses
- [ ] Customer CANNOT access other users' data
- [ ] Admin can manage all resources
- [ ] Unauthenticated user permissions

**Impact**: CRITICAL - Security vulnerability if broken

---

## Priority 4: Controllers (MEDIUM)

### OrdersController
**Current Coverage**: Partial (happy path only)
**Test File**: `test/controllers/orders_controller_test.rb`

**Missing Tests**:
- [ ] Order creation with validation errors
- [ ] Address save checkbox behavior
- [ ] "Use shipping for billing" toggle
- [ ] PDF generation
- [ ] PostHog analytics capture
- [ ] Email sending
- [ ] Cart clearing after order
- [ ] Admin vs customer access
- [ ] Invalid order updates

**Impact**: HIGH - Order flow errors

---

### ProductsController
**Current Coverage**: Partial
**Test File**: `test/controllers/products_controller_test.rb`

**Missing Tests**:
- [ ] Admin-only create/update/delete
- [ ] Customer read-only access
- [ ] Product image upload
- [ ] Category filtering
- [ ] Validation error handling
- [ ] Soft delete behavior

**Impact**: MEDIUM - Product management

---

### ShoppingCartItemsController
**Current Coverage**: Minimal
**Test File**: `test/controllers/shopping_cart_items_controller_test.rb`

**Missing Tests**:
- [ ] Add to cart (increment quantity)
- [ ] Remove from cart (decrement, delete at 0)
- [ ] Quantity edge cases (0, negative)
- [ ] Update unit price from price list
- [ ] Authorization (own cart only)

**Impact**: MEDIUM - Cart functionality

---

## Priority 5: Mailers & Jobs (LOW-MEDIUM)

### OrderMailer
**Current Coverage**: Minimal
**Test File**: `test/mailers/order_mailer_test.rb`

**Missing Tests**:
- [ ] Email recipients correct
- [ ] Email subject correct
- [ ] Email body includes order details
- [ ] Attachments (if any)
- [ ] From address correct

**Impact**: LOW-MEDIUM - Customer communication

---

## Recommendations by Priority

### Immediate (Week 1)
1. **Product Model**: Write all tests (~2 hours)
2. **Checkout Model**: Complete test coverage (~1 hour)
3. **Ability Model**: Security tests (~2 hours)
4. **User Model**: Complete business logic tests (~2 hours)

**Expected Coverage Increase**: 43% → 65%

### Short-term (Week 2)
5. **Address Model**: Validation and formatting tests (~1 hour)
6. **ShoppingCartItem**: Complete coverage (~1 hour)
7. **OrdersController**: Error paths and edge cases (~3 hours)
8. **ProductsController**: Authorization and validations (~2 hours)

**Expected Coverage Increase**: 65% → 80%

### Medium-term (Week 3-4)
9. **All System Tests**: End-to-end workflows (~4 hours)
10. **Remaining Controllers**: Complete coverage (~3 hours)
11. **Mailers**: Email content verification (~1 hour)
12. **Integration Tests**: Cross-model workflows (~2 hours)

**Expected Coverage Increase**: 80% → 90%+

---

## Test Quality Issues

### Current Problems

1. **Product Test is Empty**
   - `test/models/product_test.rb` has no tests
   - Core model completely untested

2. **Missing Edge Cases**
   - No boundary testing (e.g., shipping threshold at exactly £100)
   - No negative test cases (invalid data)

3. **No Authorization Tests**
   - Security-critical Ability model has minimal coverage
   - Could allow unauthorized access

4. **Incomplete Controller Tests**
   - Only happy paths tested
   - No error handling verification
   - No authorization checks

5. **No Integration Tests for Key Workflows**
   - Order creation flow end-to-end
   - User invitation flow
   - Cart to order conversion

---

## Testing Best Practices to Adopt

### Follow TDD Discipline

From `skills/testing/test-driven-development`:

```ruby
# RED - Write failing test first
test "validates price presence" do
  product = Product.new(name: "Box", price: nil)
  assert_not product.valid?
  assert_includes product.errors[:price], "can't be blank"
end

# Verify RED - Test must fail
# GREEN - Write minimal code
validates :price, presence: true

# Verify GREEN - Test must pass
# REFACTOR - Clean up
```

### Test Structure

```ruby
# Good test structure
test "calculates shipping fee correctly" do
  # Arrange
  cart = create_cart_with_subtotal(99.99)
  checkout = Checkout.new(cart)

  # Act
  shipping = checkout.shipping_amount

  # Assert
  assert_equal 5.00, shipping, "Should charge shipping under £100"
end
```

### Cover Edge Cases

```ruby
# Test boundaries
test "free shipping at exact threshold" do
  cart = create_cart_with_subtotal(100.00)
  assert_equal 0, Checkout.new(cart).shipping_amount
end

test "shipping charged just under threshold" do
  cart = create_cart_with_subtotal(99.99)
  assert_equal 5.00, Checkout.new(cart).shipping_amount
end
```

### Test Errors and Validations

```ruby
# Negative tests
test "rejects negative price" do
  product = Product.new(price: -10)
  assert_not product.valid?
end

test "rejects non-numeric price" do
  product = Product.new(price: "free")
  assert_not product.valid?
end
```

---

## Automated Testing Strategy

### CI/CD Integration

```yaml
# .github/workflows/test.yml (recommended)
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: bundle exec rails test
      - name: Check coverage
        run: |
          if [ $(grep -o "Line Coverage: [0-9]*" coverage/.last_run.json | grep -o "[0-9]*") -lt 90 ]; then
            echo "Coverage below 90%"
            exit 1
          fi
```

### Coverage Thresholds

Uncomment in `test/test_helper.rb`:

```ruby
SimpleCov.start 'rails' do
  # ...
  minimum_coverage 90        # Fail if total < 90%
  minimum_coverage_by_file 80  # Fail if any file < 80%
end
```

---

## Metrics to Track

- **Line Coverage**: 43% → 90%+ goal
- **Branch Coverage**: 50% → 85%+ goal
- **Tests per Model**: Average 10+ tests
- **Assertions per Test**: Average 2-3
- **Test Execution Time**: Keep under 2 minutes

---

## Commands

```bash
# Run all tests with coverage
rails test

# Run specific test file
rails test test/models/product_test.rb

# Run specific test
rails test test/models/product_test.rb:12

# View coverage report
open coverage/index.html

# Run only model tests
rails test test/models/

# Run only controller tests
rails test test/controllers/
```

---

## Next Steps

1. ✅ SimpleCov installed and configured
2. ✅ Baseline coverage established (43.23%)
3. ⏳ Write Priority 1 tests (Product, Checkout, Ability, User)
4. ⏳ Review and iterate
5. ⏳ Enable coverage thresholds
6. ⏳ Set up CI/CD
7. ⏳ Document test patterns

---

*Last Updated: 2025-10-16*
*Target Date for 90% Coverage: 4 weeks*
