Pod::Spec.new do |s|
  s.name         = "Quick"
  s.version      = "0.9.2"
  s.summary      = "The Swift (and Objective-C) testing framework."

  s.description  = <<-DESC
                   Quick is a behavior-driven development framework for Swift and Objective-C. Inspired by RSpec, Specta, and Ginkgo.
                   DESC

  s.homepage     = "https://github.com/Quick/Quick"
  s.license      = { :type => "Apache 2.0", :file => "LICENSE" }

  s.author       = "Quick Contributors"
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.tvos.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/Quick/Quick.git", :tag => "v#{s.version}" }
  s.source_files = "Sources/Quick/**/*.{swift,h,m}"

  s.public_header_files = [
    'Sources/Quick/Configuration/QuickConfiguration.h',
    'Sources/Quick/DSL/QCKDSL.h',
    'Sources/Quick/Quick.h',
    'Sources/Quick/QuickSpec.h',
  ]

  s.exclude_files = [
    'Sources/Quick/Configuration/QuickConfiguration.swift',
    'Sources/Quick/QuickSpec.swift',
    'Sources/Quick/QuickMain.swift',
  ]

  s.framework = "XCTest"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
end
