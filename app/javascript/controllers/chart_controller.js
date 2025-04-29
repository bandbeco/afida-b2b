import { Controller } from "@hotwired/stimulus"
// Chart.js and adapter are now loaded globally via script tags, remove imports
// import Chart from 'chart.js/auto';
// import 'chartjs-adapter-date-fns';

// No need to register components manually with chart.js/auto

// Connects to data-controller="chart"
export default class extends Controller {
  static values = {
    xyData: Array, // For line/bar charts: [{x, y}, ...]
    pieData: Object, // For pie/doughnut: {labels: [], datasets: [{data: []}]}
    type: String,    // e.g., 'line', 'bar', 'pie'
    label: String,   // e.g., 'Revenue (£)', 'Orders'
    yAxisLabel: String // e.g., 'Revenue (£)', 'Number of Orders'
  }

  connect() {
    // Provide default type if not specified
    if (!this.hasTypeValue) {
      this.typeValue = 'line'; // Default to line chart
    }
    this.renderChart()
  }

  renderChart() {
    // Check if *any* data value is present
    if (!this.hasXyDataValue && !this.hasPieDataValue) {
      console.error("Chart data is missing for element:", this.element);
      this.element.innerHTML = "<p>No data available to display chart.</p>";
      return;
    }

    const chartType = this.typeValue;
    let finalDataConfig;
    let chartData; // Hold the relevant data value

    // Prepare data config based on chart type
    if (['pie', 'doughnut'].includes(chartType)) {
      chartData = this.pieDataValue;
      if (!chartData || !chartData.datasets || !chartData.labels) {
        console.error("Pie/Doughnut data format incorrect or missing:", chartData);
        this.element.innerHTML = "<p>Invalid data for pie chart.</p>";
        return;
      }
      // Ensure data exists and is not empty
      if (!chartData.datasets[0] || !chartData.datasets[0].data || chartData.datasets[0].data.length === 0) {
        console.warn("Pie chart data array is empty for element:", this.element);
        this.element.innerHTML = "<p>No data available for pie chart.</p>";
        return;
      }
      finalDataConfig = chartData;
    } else {
      chartData = this.xyDataValue;
      if (!chartData || chartData.length === 0) {
        console.error("Line/Bar data is missing or empty:", chartData);
        this.element.innerHTML = "<p>No data available for chart.</p>";
        return;
      }
      finalDataConfig = {
        datasets: [{
          label: this.labelValue || 'Dataset',
          data: chartData,
          fill: false,
          borderColor: 'rgb(75, 192, 192)',
          backgroundColor: chartType === 'bar' ? 'rgba(75, 192, 192, 0.5)' : undefined,
          tension: 0.1
        }]
      };
    }

    // Determine if axes should be displayed
    const displayAxes = !['pie', 'doughnut'].includes(chartType);

    // Use the globally available Chart object
    new Chart(this.element, {
      type: chartType,
      data: finalDataConfig,
      options: {
        scales: displayAxes ? {
          x: {
            type: 'time',
            time: {
              unit: 'day',
              tooltipFormat: 'PP'
            },
            title: {
              display: true,
              text: 'Date'
            }
          },
          y: {
            beginAtZero: true,
            title: {
              display: this.hasYAxisLabelValue,
              text: this.yAxisLabelValue || ''
            }
          }
        } : undefined, // Disable scales for pie/doughnut
        plugins: {
          tooltip: {
            enabled: true
          },
          legend: {
            display: true
          }
        }
      }
    });
  }
}
