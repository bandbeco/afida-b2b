# frozen_string_literal: true

module Admin
  class DashboardController < ApplicationController
    def index
      date_range = 30.days.ago.beginning_of_day..Time.current.end_of_day
      orders_in_range = Order.where(created_at: date_range)

      @total_revenue_last_30_days = orders_in_range.sum(:total_amount)
      @total_orders_last_30_days = orders_in_range.count

      @average_order_value_last_30_days = if @total_orders_last_30_days.positive?
                                            @total_revenue_last_30_days / @total_orders_last_30_days
      else
                                            0
      end

      # Find users whose first order falls within the date range
      user_ids_in_range = orders_in_range.pluck(:user_id).uniq
      first_order_dates = Order.where(user_id: user_ids_in_range).group(:user_id).minimum(:created_at)
      new_client_ids = first_order_dates.select { |_user_id, first_date| date_range.cover?(first_date) }.keys

      # Count orders placed by these new clients within the range
      @new_client_orders_last_30_days = orders_in_range.where(user_id: new_client_ids).count

      # Chart Data: Revenue Trend
      @revenue_trend_data = orders_in_range
                            .group_by_day(:created_at, range: date_range, format: "%Y-%m-%d")
                            .sum(:total_amount)
                            .map { |date, total| { x: date, y: total } }

      # Chart Data: Orders Trend
      @order_trend_data = orders_in_range
                          .group_by_day(:created_at, range: date_range, format: "%Y-%m-%d")
                          .count
                          .map { |date, count| { x: date, y: count } }

      # Top Clients
      @top_clients_by_revenue = orders_in_range
                                .joins(:user)
                                .group("users.id", "users.company", "users.first_name", "users.last_name") # Group by user details
                                .select("users.id", "users.company", "users.first_name", "users.last_name", "SUM(orders.total_amount) as total_revenue")
                                .order(total_revenue: :desc)
                                .limit(5)

      # Best Selling Products (by Quantity)
      @top_products_by_quantity = OrderItem
                                  .joins(:order, :product)
                                  .where(orders: { created_at: date_range })
                                  .group("products.id", "products.sku", "products.name")
                                  .select("products.id", "products.sku", "products.name", "SUM(order_items.quantity) as total_quantity")
                                  .order(total_quantity: :desc)
                                  .limit(10)

      # Revenue by Category
      revenue_by_category_raw = OrderItem
                                .joins(:order, product: :category)
                                .where(orders: { created_at: date_range })
                                .group("categories.name")
                                .sum("order_items.quantity * order_items.unit_price") # Calculate total revenue per item

      # Format for Chart.js Pie Chart
      @revenue_by_category_data = {
        labels: revenue_by_category_raw.keys,
        datasets: [ {
          label: "Revenue (£)",
          data: revenue_by_category_raw.values
          # Add background colors later if needed
        } ]
      }
    end
  end
end
