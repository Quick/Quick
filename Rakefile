def run(command)
  system(command) or raise "RAKE TASK FAILED: #{command}"
end

desc "Run all unit tests"
task :test do |t|
  run "xcodebuild -workspace Quick.xcworkspace -scheme Quick clean test"
  run "xcodebuild -workspace Quick.xcworkspace -scheme Nimble clean test"
end

task default: [:test]

