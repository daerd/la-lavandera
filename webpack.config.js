var path              = require('path')
var webpack           = require('webpack')
var ExtractTextPlugin = require('extract-text-webpack-plugin')

module.exports = {
  entry: {
    site: [
      './source/assets/javascripts/site.js.erb',
      './source/assets/stylesheets/site.css.scss'
    ]
  },
  output: {
    filename: 'assets/javascripts/[name].js',
    path:     path.resolve(__dirname, '.tmp/webpack_output')
  },
  module: {
    rules: [
      {
        test:    /\.js$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader:  'babel-loader',
          options: { presets: [ 'es2015' ] }
        }
      },
      {
        test:  /\.s?[ac]ss$/,
        use:   ExtractTextPlugin.extract({
          use: [
            'css-loader',
            {
              loader: 'postcss-loader',
              options: {
                plugins: function() {
                  return [
                    require('autoprefixer'),
                    require('postcss-flexbugs-fixes')
                  ]
                }
              }
            },
            'sass-loader'
          ]
        })
      },
      {
        test: /\.(png|jp(e*)g|svg|gif|cur)$/,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 8000, // Converts images <8kb to Base64 strings.
              name:  'source/assets/images/[name]-[hash].[ext]'
            }
          }
        ]
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg)$/,
        use: [
          {
            loader:  'url-loader',
            options: {
              name: 'source/assets/fonts/[name]-[hash].[ext]'
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin({
      filename: 'source/assets/stylesheets/[name]-[hash].css'
    })
  ]
}
