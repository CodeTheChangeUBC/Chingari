const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const vue = require('./loaders/vue')
environment.loaders.append('vue', vue)

module.exports = environment

// Add an ProvidePlugin 
environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  jquery: 'jquery',
  'window.Tether': "tether",
  Popper: ['popper.js', 'default'],
  ActionCable: 'actioncable',
  Vue: 'vue',
  VueResource: 'vue-resource',
})
)

// const config = environment.toWebpackConfig()

// config.resolve.alias = {
//   jquery: "jquery/src/jquery",
//   vue: "vue/dist/vue.js",
//   vue_resource: "vue-resource/dist/vue-resource",
// }

// export the updated config
// module.exports = config