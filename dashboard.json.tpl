{
  "widgets": [
    {
      "height": 6,
      "width": 6,
      "y": 0,
      "x": 0,
      "type": "text",
      "properties": {
        "markdown": "### EC2 Metrics\nResource Links\n%{ for i in instances ~}- ${i.id} = ${i.arn}\n%{ endfor ~}"
      }
    },
    {
    "type": "metric",
    "x": 6,
    "y": 0,
    "width": 6,
    "height": 6,
    "properties": {
        "view": "timeSeries",
        "stacked": false,
        "metrics": [
            %{ for key, i in instances ~}
            [ "AWS/EC2", "CPUUtilization", "InstanceId", "${i.id}" ]%{ if key != length(instances) - 1 ~},%{ endif ~}
            %{ endfor ~}
        ],
        "region": "ap-northeast-1"
    }
}
    %{ if length(albs) > 0 ~}
    {
      "height": 6,
      "width": 6,
      "y": 0,
      "x": 0,
      "type": "text",
      "properties": {
        "markdown": "### EC2 Metrics\nResource Links\n%{ for i in albs ~}- ${i.id} = ${i.arn}\n%{ endfor ~}"
      }
    }
    %{ endif ~}
  ]
}