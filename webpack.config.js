module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|jpe?g|gif|svg|webp)$/,
        loader: 'url-loader',
        query: {
          limit: 1000, // 1kB
          name: 'img/[name].[hash:7].[ext]'
        }
      },
      {
        test: /\.(woff2?|eot|ttf|otf)(\?.*)?$/,
        loader: 'url-loader',
        query: {
          limit: 1000, // 1kB
          name: 'fonts/[name].[hash:7].[ext]'
        }
      }
    ],
  },
};
