# Note this is used in the apply stage and is outputted by the plan stage
BUILD_ARTIFACT_NAME = 'aws_demo.plan'
LOCAL_WORKSPACE = 'local'
SOURCE = 'src'
S3_BUCKET = 'demolambdas'
LAMBDA_ZIP = 'lambda.zip'
REGION = 'ap-southeast-1'

desc 'Build'
task :build do
    zip_source(LAMBDA_ZIP)

    # run "aws s3 mb s3://#{S3_BUCKET}"
    push_to_s3(LAMBDA_ZIP)
end

desc 'Terraform plan'
task :plan do
    run "terraform init -input=false"
    run "terraform plan -out=#{BUILD_ARTIFACT_NAME} -input=false"
end

desc 'Terraform apply'
task :apply do
    run "terraform apply -input=false #{BUILD_ARTIFACT_NAME}"
end

desc 'Terraform destroy'
task :destroy do
    run "terraform destroy"
end

desc 'Run the pipeline'
task :default do
    Rake::Task['build'].invoke;
    Rake::Task['plan'].invoke;
    Rake::Task['apply'].invoke;
end

# Helper methods
def run(command)
    puts "=> #{command}"

    fail "Oh snap!" if !system command
end

def zip_source(filename)
    run "7z a #{filename} #{SOURCE}"
end

def push_to_s3(filename)
    puts "S3: Uploading file #{filename} to s3://#{S3_BUCKET}/#{filename}"
    run "aws s3 cp #{filename} s3://#{S3_BUCKET}/#{filename}"

end