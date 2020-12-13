const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function(app){
  app.use(
      createProxyMiddleware('/api', {
          target: 'http://54.180.165.95:3001/',
          changeOrigin: true
      })
  )
};
