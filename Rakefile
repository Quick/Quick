def run(command)
  system(command) or raise "RAKE TASK FAILED: #{command}"
end

def has_xcodebuild
  system "which xcodebuild >/dev/null"
end

namespace "podspec" do
  desc "Run lint for podspec"
  task :lint do
    run "bundle exec pod lib lint"
  end
end

namespace "test" do
  desc "Run unit tests for all iOS targets"
  task :ios do |t|
    run "xcodebuild -workspace Quick.xcworkspace -scheme Quick-iOS -destination 'platform=iOS Simulator,name=iPhone 6' clean test"
  end

  desc "Run unit tests for all tvOS targets"
  task :tvos do |t|
    run "xcodebuild -workspace Quick.xcworkspace -scheme Quick-tvOS -destination 'platform=tvOS Simulator,name=Apple TV 1080p' clean test"
  end

  desc "Run unit tests for all OS X targets"
  task :osx do |t|
    run "xcodebuild -workspace Quick.xcworkspace -scheme Quick-OSX clean test"
  end

  desc "Run unit tests for all iOS, tvOS and OS X targets using xctool"
  task xctool: %w[test:xctool:version test:xctool:ios test:xctool:tvos test:xctool:osx]
  namespace :xctool do
    desc "Run unit tests for all iOS targets using xctool"
    task :ios do |t|
      Rake::Task["test:xctool:version"].invoke
      run "xctool -workspace Quick.xcworkspace -scheme Quick-iOS -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6' clean test"
    end

    desc "Run unit tests for all tvOS targets using xctool"
    task :tvos do |t|
      Rake::Task["test:xctool:version"].invoke
      run "xctool -workspace Quick.xcworkspace -scheme Quick-tvOS -sdk appletvsimulator -destination 'platform=tvOS Simulator,name=Apple TV 1080p' clean test"
    end

    desc "Run unit tests for all OS X targets using xctool"
    task :osx do |t|
      Rake::Task["test:xctool:version"].invoke
      run "xctool -workspace Quick.xcworkspace -scheme Quick-OSX clean test"
    end

    desc "Print the version of xctool being used"
    task :version do
      run "echo Using xctool v`xctool -v`..."
    end
  end

  desc "Run unit tests for the current platform built by the Swift Package Manager"
  task :swiftpm do |t|
    run "swift build --clean && swift build"
    run ".build/debug/QuickTests"
    run ".build/debug/QuickFocusedTests"
  end
end

namespace "templates" do
  install_dir = File.expand_path("~/Library/Developer/Xcode/Templates/File Templates/Quick")
  src_dir = File.expand_path("../Quick Templates", __FILE__)

  desc "Install Quick templates"
  task :install do
    if File.exists? install_dir
      raise "RAKE TASK FAILED: Quick templates are already installed at #{install_dir}"
    else
      mkdir_p install_dir
      cp_r src_dir, install_dir
    end
  end

  desc "Uninstall Quick templates"
  task :uninstall do
    rm_rf install_dir
  end
end

if has_xcodebuild then
  task default: ["test:ios", "test:tvos", "test:osx"]
else
  task default: ["test:swiftpm"]
end
