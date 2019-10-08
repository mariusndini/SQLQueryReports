# Excel to CSV Convert
One format to ingest data in Snowflake is CSV. Excel to CSV conversion is sometimes needed. This is aan accomplishable task with available tools. Excel offers the ability to save to CSV. Other options include converting through FaaS functions.

### Convert & Load w/ Snowpipe
This Git Repo utilizes NodeJS to convert Excel to CSV. Dropping files into S3/Azure Blob bucket you can trigger a FaaS job to convert Excel into CSV through either Lambda/Azure Functions. After the function has completed  save the file into respective staging buckets to be uploaded into Snowflake through Snowpipe auto ingest.

Through Snowpipe you can automate ingestion into Snowflake after the files have been converted as outlined in the infrastructure below.

### Cloud Convert Infrastructure w/ Snowpipe
![Excel to CSV Convert](https://github.com/mariusndini/SQLQueryReports/blob/master/img/xlx-csv.png)



