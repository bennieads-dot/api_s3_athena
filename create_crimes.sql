CREATE EXTERNAL TABLE IF NOT EXISTS `baltimore_crime`.`crime` (
  `ccnumber` string,
  `crimedatetime` string,
  `crimecode` varchar(2),
  `description` string COMMENT 'crime description',
  `inside_outside` varchar(1),
  `weapon` string,
  `post` tinyint,
  `gender` char(1),
  `age` tinyint,
  `race` string,
  `ethnicity` string,
  `location` string,
  `old_district` string,
  `new_district` string,
  `neighborhood` string,
  `premisetype` string,
  `total_incidents` tinyint
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES ('field.delim' = ',')
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION "<S3 PATH TO FOLDER>"
TBLPROPERTIES ('classification' = 'csv','skip.header.line.count'='1');