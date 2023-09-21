# api_s3_athena
This is a sample project I came up with to practice a simple data engineering pipeline and learn more about the following AWS services.

The lambda function has has no error handling, this was put together quickly and without the need to have in a prod environment.

- IAM (Identity and Access Management) 🔑
- Lambda (Serverless computing) 🤖
- S3 (Object storage) 🪣
- Athena (Interactive query service) 🦉

# Prerequisites
- An AWS Account
- Access (should be public) to the [Open Baltimore Crimes Dataset/API](https://data.baltimorecity.gov/datasets/baltimore::part-1-crime-data/api)

# Steps
- Create a user via AWS IAM with permissions to read and write in S3, create and run Lambda functions, and able to read and write in athena.
- Create an S3 bucket with the following folders:
  - crime/
  - crime_codes/
- Download the [crime_Codes.csv](https://data.baltimorecity.gov/documents/crime-codes/about) file locally
- Upload this file to the crime_codes/ S3 sub folder. Theres no API endpoint for this data so we cant query for it
- As the above user, create and write a lambda function (lambda_function.py in this repo), the lambda should:
  - Call the crimes api and get the max 2000 records (all fields but lat and long)
  - Traverse the response and create a csv containg all records and a header
  - Save the csv to Lambda ephemeral storage (/tmp)
  - Upload the CSV to the S3 crimes/ folder
- Create a lambda layer for this function which contains the python requests package (must be <2.3). A requests import error will happen if not done.
  - ```pip install requests==2.29.0 -t python```
  - ```zip -r requests.zip python```
  - upload 'requests.zip' to the layer
- Create the following env variables by selecting 'Configuration' in the lambda
  - AWS_BUCKET_NAME
  - S3_ACCESS_KEY_ID
  - S3_SECRET_ACCESS_KEY
- Increste timeout of lambda to 5 seconds
- Create a test case for the lambda:
  ```
  {
  "url": "https://services1.arcgis.com/UWYHeuuJISiGmgXx/arcgis/rest/services/Part1_Crime_Beta/FeatureServer/0/query?where=1%3D1&outFields=CCNumber,CrimeDateTime,CrimeCode,Description,Inside_Outside,Weapon,Post,Gender,Age,Race,Ethnicity,Location,Old_District,New_District,Neighborhood,PremiseType,Total_Incidents&outSR=4326&f=json",
  "csv_name": "crime.csv"
  }
  ```
- Run the test
- Check S3 /crimes for the csv
- Open AWS Athena service
- Create a new database, then complete the following on the crimes/ and crime_codes/ S3 locations
  - Create a table from S3 bucket location
  - Create the database if not exists yet, call it: `baltimore_crime`
  - Choose parent of the csv we are importing
  - Table type: Apache Hive
  - Data Type: CSV
  - Bulk add columns (copy/paste header of csv)
  - Choose all data types
  - Tables Properties:
    - Key: skip.header.line.count, value: 1
  - Once both tables are created, you should be able to query against both tables, try running the sample query in this repo
