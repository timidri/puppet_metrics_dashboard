# A metric name corresponding to an endpoint (url)
type Puppet_metrics_dashboard::Mbeans_metric = Tuple[
  Struct[{
    name => String[1],
    url  => String[1]
  }],
  1,
  default
]
