desc "Run the Maven tests"

task :maven_test do
  run_or_exit("mvn verify")
end

private

def run_or_exit(command)
  result = system(command)
  unless result
    $stderr.puts "Error executing Maven test, exiting."
    exit($?.exitstatus)
  end
end
