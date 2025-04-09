module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        'afida-green': '#e6f2ef',
      },
      fontFamily: {
        sans: ['Inter var', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('daisyui')
  ],
  safelist: [
    {
      pattern: /^(.*?):?btn-.*/,
    },
    {
      pattern: /^(.*?):?modal-.*/,
    },
    {
      pattern: /^(.*?):?alert-.*/,
    },
    {
      pattern: /^(.*?):?badge-.*/,
    },
    {
      pattern: /^(.*?):?card-.*/,
    },
    {
      pattern: /^(.*?):?drawer-.*/,
    },
    {
      pattern: /^(.*?):?dropdown-.*/,
    },
    {
      pattern: /^(.*?):?menu-.*/,
    },
    {
      pattern: /^(.*?):?input-.*/,
    },
    {
      pattern: /^(.*?):?textarea-.*/,
    },
    {
      pattern: /^(.*?):?select-.*/,
    },
    {
      pattern: /^(.*?):?checkbox-.*/,
    },
    {
      pattern: /^(.*?):?radio-.*/,
    },
    {
      pattern: /^(.*?):?toggle-.*/,
    },
  ],
} 