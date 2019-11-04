# @summary Custom mbeans metrics
class puppet_metrics_dashboard::mbeans_metrics(
  String[2] $timeout = lookup('puppet_metrics_dashboard::http_response_timeout'),
  Puppet_metrics_dashboard::Puppetdb_metric $metrics = [],
){
  $_master_list = $puppet_metrics_dashboard::master_list.map |$entry| {
    $entry ? {
      Tuple[String, Integer] => { 'host' => $entry[0], 'port' => $entry[1] },
      String                 => { 'host' => $entry, 'port' => 8140 },
    }
  }

  $_master_list.each | $master | {
    $host = $master['host']
    $port = $master['port']
    $metrics.each | $metric | {
      telegraf::input { "mbeans_${metric['name']}_${host}":
        plugin_type => 'httpjson',
        options     => [{
          'name'                 => "mbeans_${metric['name']}",
          'method'               => 'GET',
          'servers'              => [ "https://${host}:${port}/metrics/v1/mbeans/${metric['url']}" ],
          'insecure_skip_verify' => true,
          'response_timeout'     => $timeout,
        }],
        notify      => Service['telegraf'],
        require     => Package['telegraf'],
      }
    }
  }
}
