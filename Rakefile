# Note this is used in the apply stage and is outputted by the plan stage
BUILD_ARTIFACT_NAME = 'aws_demo.plan'
LOCAL_WORKSPACE = 'local'
SOURCE = 'src'
S3_BUCKET = 'vpc-demo-lambda-bucket'
LAMBDA_ZIP = 'lambda.zip'
AWS_REGION = 'ap-southeast-1'
ENVIRONMENT = "aws_demo"
ENV_VARIABLES = %[-var "environment=\"#{ENVIRONMENT}\"" -var "aws_region=\"#{AWS_REGION}\"" -var "lambda_zip_filename=\"#{LAMBDA_ZIP}\"" -var "lambda_zip_bucket=\"#{S3_BUCKET}\""]

desc 'Destroy VPC (note this will force destroy everything)'
task :destroy do
    run "terraform destroy #{ENV_VARIABLES} -force"
end

desc 'Build and Deploy (Should have AWS Credentials on your machine)'
task :create do
    test_source()
    create_bucket()
    
    zip_source(LAMBDA_ZIP)
    push_to_s3(LAMBDA_ZIP)

    run "terraform init -input=false"
    run "terraform plan -out=#{BUILD_ARTIFACT_NAME} -input=false #{ENV_VARIABLES}"
    run "terraform apply -input=false #{BUILD_ARTIFACT_NAME}"
end

task :test do
    zip_source(LAMBDA_ZIP)
end

# Helper methods
def zip_source(filename)
    run "7z a #{filename} #{SOURCE}"
end

def push_to_s3(filename)
    puts "S3: Uploading file #{filename} to s3://#{S3_BUCKET}/#{filename}"
    run "aws s3 cp #{filename} s3://#{S3_BUCKET}/#{filename}"
end

def test_source 
    run "node src" # Just testing that it compiles for the moment

    #TODO Run test suit
end

def create_bucket()
    # TODO Query to see if bucket already exists
    system "aws s3 mb s3://#{S3_BUCKET} --region #{AWS_REGION}"
end

def run(command)
    puts "=> #{command}"
    fail "Oh snap!" if !system command
end
