const webpack = require('webpack');
const merge = require('webpack-merge');
const common = require('./common.js');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = merge(common, {
  devtool: 'inline-source-map',

  plugins: [
    new ExtractTextPlugin('[name].css')
  ]
});
