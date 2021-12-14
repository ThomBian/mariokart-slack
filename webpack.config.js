const path = require('path')
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin');

module.exports = {
  mode: process.env.NODE_ENV || 'development',
  entry: path.join(__dirname, "app", "javascript", "index.js"),
  plugins: [
    new CaseSensitivePathsPlugin()
  ],
  output: {
    filename: 'index.js',
    path: path.resolve(__dirname, "./public/js")
  },
  module: {
    rules: [
      {
        test: /\.?js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ['@babel/preset-env', '@babel/preset-react']
          }
        }
      },
      {
        test: /\.css$/i,
        use: ["style-loader", "css-loader"],
      },
      {
        test: /\.(png|jp(e*)g|svg|gif)$/,
        use: ['file-loader'],
      },
      {
        test: /\.svg$/,
        use: ['@svgr/webpack'],
      },
    ]
  },
};