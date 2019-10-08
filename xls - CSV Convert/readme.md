# Excel to CSV Convert
The best way to accomplish this task would be to convert the xlsx to CSV format. This is a very easily accomplishable task with common amd available tools. Excel offers the ability to save to CSV. Other options include cloud conversion.

### Convert & Load with Snowpipe
Another option is to utilize cloud tools to convert the excel file and then utilize Snowpipe to auto ingest the files into Snowflake. This Git Repo utilizes NodeJS to convert Excel to CSV. Dropping files into S3 or Azure Blob you can trigger a FaaS job to convert Excel into CSV through either Lambda/Azure Functions. After the function has completed converting you could save the file into respective buckets/folders to be uploaded into Snowflake through Snowpipe auto ingest. 

Through Snowpipe you can automate ingestion into Snowflake after the files have been converted as outlined in the infrastructure below.

### Cloud Convert Infrastructure
![Excel to CSV Convert](https://github.com/mariusndini/SQLQueryReports/blob/master/img/xlx-csv.png)



