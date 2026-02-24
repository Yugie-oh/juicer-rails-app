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
        zumex: {
          orange: '#e85d04',
          'orange-dark': '#dc2f02',
          juice: '#ff9f1c'
        }
      }
    },
  },
  plugins: [],
}
