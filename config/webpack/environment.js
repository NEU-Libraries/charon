const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

environment.splitChunks()

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    jQuery: 'jquery/dist/jquery',
    Popper: ['popper.js', 'default']
  })
)

const aliasConfig = {
  'jquery-ui': 'jquery-ui-dist/jquery-ui.js'
};

environment.config.set('resolve.alias', aliasConfig);

module.exports = environment
