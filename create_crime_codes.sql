CREATE EXTERNAL TABLE IF NOT EXISTS `baltimore_crime`.`crime_codes` (
  `code` string,
  `type` string,
  `name` string,
  `class` string,
  `name_combine` string,
  `weapon` string,
  `violent_cr` string,
  `vio_prop_cfs` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES ('field.delim' = ',')
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION "<S3 PATH TO FOLDER>"
TBLPROPERTIES (
  'classification' = 'csv',
  'skip.header.line.count' = '1'
);