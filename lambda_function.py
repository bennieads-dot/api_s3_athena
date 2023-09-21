import json
import boto3
import csv
import gc
import os
import requests

'''
This script doesnt have any error handling, its only purpose is to test and run manually in
AWS lambda.
'''


def get_data(url):
    data = []
    res = requests.get(url).json()["features"]
    for row in res:
        data.append(row["attributes"])
    del res
    gc.collect()
    return data


def write_csv(data, file):
    with open(file, "w") as f:
        wr = csv.DictWriter(f, delimiter=",", fieldnames=list(
            data[0].keys()))
        wr.writeheader()
        wr.writerows(data)
    f.close()
    print(f'successfully wrote {len(data)} rows to {file}')


def upload_to_s3(file, name):
    access_key = os.getenv("S3_ACCESS_KEY_ID")
    secret_key = os.getenv("S3_SECRET_ACCESS_KEY")
    bucket_name = os.getenv("AWS_BUCKET_NAME")
    key = 'crime/'+name
    s3 = boto3.client('s3',
                      aws_access_key_id=access_key,
                      aws_secret_access_key=secret_key
                      )
    with open(file, 'rb') as data:
        s3.upload_fileobj(data, bucket_name, key)
    data.close()
    print("uploaded to S3")


def lambda_handler(event, context):
    # TODO implement
    url = event["url"]
    name = event["csv_name"]
    file = '/tmp/'+event["csv_name"]

    data = get_data(url)
    write_csv(data, file)
    upload_to_s3(file, name)

    print("complete")
