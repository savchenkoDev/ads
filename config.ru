require_relative 'config/environment'

use Rack::Runtime
use Rack::Deflater
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter
use Rack::RequestId
use Rack::Ougai::LogRequests, Application.logger

map '/ads' do
  run AdRoutes
end
