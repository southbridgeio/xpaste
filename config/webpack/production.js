const webpack = require('webpack');
const path = require('path');
const merge = require('webpack-merge');
const common = require('./common.js');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const ManifestPlugin = require('webpack-manifest-plugin');

module.exports = merge(common, {
  output: {
    filename: '[name]-[chunkhash].js',
    chunkFilename: '[name]-[chunkhash].chunk.js',
    path: path.resolve(__dirname, '../../public/dist'),
    publicPath: '/dist/'
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin({
      compress: { warnings: false }
    }),
    new ExtractTextPlugin('[name]-[contenthash].css'),
    new ManifestPlugin({ publicPath: '/', writeToFileEmit: true })
  ]
});
