Pod::Spec.new do |s|
  s.name         = "Quick"
  s.version      = "0.3.1"
  s.summary      = "The Swift (and Objective-C) testing framework."

  s.description  = <<-DESC
                   Quick is a behavior-driven development framework for Swift and Objective-C. Inspired by RSpec, Specta, and Ginkgo.
                   DESC

  s.homepage     = "https://github.com/Quick/Quick"
  s.license      = { :type => "Apache 2.0", :file => "LICENSE" }

  s.author       = "Quick Contributors"
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.10"

  s.source       = { :git => "https://github.com/Quick/Quick.git", :tag => "v#{s.version}" }
  s.source_files  = "Quick", "Quick/**/*.{swift,h,m}"

  s.framework = "XCTest"
  s.requires_arc = true
end
