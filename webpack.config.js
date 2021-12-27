const path = require('path')
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin');

module.exports = {
  mode: process.env.NODE_ENV || 'development',
  entry: ["regenerator-runtime/runtime.js", path.join(__dirname, "app", "javascript", "index.js")],
  plugins: [
    new CaseSensitivePathsPlugin(),
  ],
  output: {
    filename: 'index.js',
    path: path.resolve(__dirname, "./public/js")
  },
  resolve: {
    extensions: ['.ts', '.js', '*'],
    modules: [path.resolve(__dirname, "./app/javascript"), "node_modules"],
    alias: {
      '~': path.resolve('./node_modules')
    }
  },
  module: {
    rules: [
      {
        test: /\.?js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            presets: [
              '@babel/preset-env',
              '@babel/preset-react',
            ]
          }
        }
      },
      {
        test: /\.css$/i,
        use: ["style-loader", "css-loader"],
      },
      {
        test: /\.(png|jp(e*)g|gif)$/,
        use: ['file-loader'],
      },
      {
        test: /\.svg$/,
        use: ['@svgr/webpack'],
      },
    ]
  },
};