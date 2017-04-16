# Change Log

## [Unreleased](https://github.com/Quick/Quick/tree/HEAD)

[Full Changelog](https://github.com/Quick/Quick/compare/v0.3.0...HEAD)

**Implemented enhancements:**

- Support escaping autoclosure syntax for expect [\#251](https://github.com/Quick/Quick/issues/251)

- Deliver failures on the main thread? [\#248](https://github.com/Quick/Quick/issues/248)

- README: Add instructions on testing view controllers defined using UIStoryboard [\#212](https://github.com/Quick/Quick/issues/212)

- README: Add note that a test target that uses Quick must contain at least one Swift file \(and file Apple radar\) [\#164](https://github.com/Quick/Quick/issues/164)

**Fixed bugs:**

- Support Swift 1.2 [\#243](https://github.com/Quick/Quick/issues/243)

- Quick does not work on physical devices [\#140](https://github.com/Quick/Quick/issues/140)

**Merged pull requests:**

- Updates tests in ArrangeActAssert to be correct [\#255](https://github.com/Quick/Quick/pull/255) ([ScottPetit](https://github.com/ScottPetit))

- Improved documentation [\#254](https://github.com/Quick/Quick/pull/254) ([modocache](https://github.com/modocache))

- Add instructions for running Quick specs on device [\#252](https://github.com/Quick/Quick/pull/252) ([mkauppila](https://github.com/mkauppila))

- Add "How to Install Quick using Carthage" to table of contents [\#250](https://github.com/Quick/Quick/pull/250) ([mkauppila](https://github.com/mkauppila))

- \[\#212\] readme regarding testing view controllers that use storyboards [\#213](https://github.com/Quick/Quick/pull/213) ([pawurb](https://github.com/pawurb))

## [v0.3.0](https://github.com/Quick/Quick/tree/v0.3.0) (2015-02-10)

[Full Changelog](https://github.com/Quick/Quick/compare/v0.2.2...v0.3.0)

**Implemented enhancements:**

- README: Add details on focused examples and example filtering [\#226](https://github.com/Quick/Quick/issues/226)

- README: Add note on how to export Swift classes to test them in test target [\#222](https://github.com/Quick/Quick/issues/222)

- Create +ObjC versions of all functional tests written in Swift [\#200](https://github.com/Quick/Quick/issues/200)

- README: Add instructions for including Quick in a project via Carthage [\#199](https://github.com/Quick/Quick/issues/199)

- Remove FunctionalTests.swift and FunctionalTests+ObjC.m [\#186](https://github.com/Quick/Quick/issues/186)

- Add configuration object; provide hooks around each example [\#163](https://github.com/Quick/Quick/issues/163)

- Support focused tests [\#134](https://github.com/Quick/Quick/issues/134)

- Podspec and distribution via CocoaPods [\#22](https://github.com/Quick/Quick/issues/22)

**Closed issues:**

- Black box testing [\#241](https://github.com/Quick/Quick/issues/241)

- justBeforeEach? [\#209](https://github.com/Quick/Quick/issues/209)

**Merged pull requests:**

- Support Swift 1.2 [\#245](https://github.com/Quick/Quick/pull/245) ([modocache](https://github.com/modocache))

- Swift 1.2 [\#244](https://github.com/Quick/Quick/pull/244) ([mprudhom](https://github.com/mprudhom))

- Removed beta xcode warning in README. [\#242](https://github.com/Quick/Quick/pull/242) ([jeffh](https://github.com/jeffh))

- Fixes build [\#240](https://github.com/Quick/Quick/pull/240) ([ashfurrow](https://github.com/ashfurrow))

- Add to Cocoapods Trunk [\#239](https://github.com/Quick/Quick/pull/239) ([ashfurrow](https://github.com/ashfurrow))

- Simplify framework search paths to avoid finding the wrong xctest.framework [\#237](https://github.com/Quick/Quick/pull/237) ([mattdelves](https://github.com/mattdelves))

- Add SharedExamples+BeforeEachTests+ObjC [\#236](https://github.com/Quick/Quick/pull/236) ([mkauppila](https://github.com/mkauppila))

- Fix typo in Objective-C DSL [\#235](https://github.com/Quick/Quick/pull/235) ([paulyoung](https://github.com/paulyoung))

- Carthage install: Add Nimble to cartfile.private [\#234](https://github.com/Quick/Quick/pull/234) ([jmig](https://github.com/jmig))

- Add AfterSuiteTests+ObjC [\#232](https://github.com/Quick/Quick/pull/232) ([mkauppila](https://github.com/mkauppila))

- Add Configuration Information to README [\#230](https://github.com/Quick/Quick/pull/230) ([codeblooded](https://github.com/codeblooded))

- Fix \#start-writing-specs Link in README [\#229](https://github.com/Quick/Quick/pull/229) ([codeblooded](https://github.com/codeblooded))

- you need the pre version of CP [\#228](https://github.com/Quick/Quick/pull/228) ([orta](https://github.com/orta))

- update CocoaPods instructions [\#227](https://github.com/Quick/Quick/pull/227) ([orta](https://github.com/orta))

- Add Carthage instructions [\#203](https://github.com/Quick/Quick/pull/203) ([raven](https://github.com/raven))

## [v0.2.2](https://github.com/Quick/Quick/tree/v0.2.2) (2014-12-27)

[Full Changelog](https://github.com/Quick/Quick/compare/v0.2.1...v0.2.2)

**Closed issues:**

- No Podfile in v0.2.0 tag [\#215](https://github.com/Quick/Quick/issues/215)

**Merged pull requests:**

- Add BeforeSuiteTests+ObjC [\#225](https://github.com/Quick/Quick/pull/225) ([mkauppila](https://github.com/mkauppila))

- Add PendingTests+ObjC [\#224](https://github.com/Quick/Quick/pull/224) ([mkauppila](https://github.com/mkauppila))

- Add AfterEachTests+ObjC tests  [\#223](https://github.com/Quick/Quick/pull/223) ([mkauppila](https://github.com/mkauppila))

- Add BeforeEachTests+ObjC tests [\#220](https://github.com/Quick/Quick/pull/220) ([mkauppila](https://github.com/mkauppila))

- Tests/it specs objc [\#218](https://github.com/Quick/Quick/pull/218) ([mkauppila](https://github.com/mkauppila))

- Make classes final. [\#217](https://github.com/Quick/Quick/pull/217) ([paulyoung](https://github.com/paulyoung))

- Readme change for podfile version [\#216](https://github.com/Quick/Quick/pull/216) ([ashfurrow](https://github.com/ashfurrow))

- Configuration: Add example filters [\#184](https://github.com/Quick/Quick/pull/184) ([modocache](https://github.com/modocache))

## [v0.2.1](https://github.com/Quick/Quick/tree/v0.2.1) (2014-12-07)

[Full Changelog](https://github.com/Quick/Quick/compare/v0.2.0...v0.2.1)

**Implemented enhancements:**

- Expose currently running spec's ExampleMetadata on sharedWorld [\#178](https://github.com/Quick/Quick/issues/178)

**Fixed bugs:**

- beforeEach might be executed in reverse order [\#196](https://github.com/Quick/Quick/issues/196)

- No such module 'Quick' [\#195](https://github.com/Quick/Quick/issues/195)

**Closed issues:**

- Encoding problem with test description [\#208](https://github.com/Quick/Quick/issues/208)

- beforeSuite executing too early [\#198](https://github.com/Quick/Quick/issues/198)

- Library not loaded: @rpath/Quick.framework/Quick / @rpath/Nimble.framework/Nimble [\#159](https://github.com/Quick/Quick/issues/159)

**Merged pull requests:**

- Fix block syntax in code example [\#214](https://github.com/Quick/Quick/pull/214) ([mkauppila](https://github.com/mkauppila))

- Fix beforeEach execution order [\#211](https://github.com/Quick/Quick/pull/211) ([modocache](https://github.com/modocache))

- .travis.yml: Test OS X as well [\#210](https://github.com/Quick/Quick/pull/210) ([modocache](https://github.com/modocache))

- Update README.md for correct CocoaPods gem [\#207](https://github.com/Quick/Quick/pull/207) ([palewar](https://github.com/palewar))

- Update contributing guidelines. [\#205](https://github.com/Quick/Quick/pull/205) ([paulyoung](https://github.com/paulyoung))

- Update example Podfile. [\#204](https://github.com/Quick/Quick/pull/204) ([paulyoung](https://github.com/paulyoung))

- Changes related to moving Nimble to a workspace [\#202](https://github.com/Quick/Quick/pull/202) ([paulyoung](https://github.com/paulyoung))

- Move Nimble dependency to a workspace [\#201](https://github.com/Quick/Quick/pull/201) ([gfontenot](https://github.com/gfontenot))

- Add Podspec [\#197](https://github.com/Quick/Quick/pull/197) ([orta](https://github.com/orta))

- Remove functional test files. [\#193](https://github.com/Quick/Quick/pull/193) ([sidraval](https://github.com/sidraval))

## [v0.2.0](https://github.com/Quick/Quick/tree/v0.2.0) (2014-11-10)

[Full Changelog](https://github.com/Quick/Quick/compare/v0.1.0-beta...v0.2.0)

**Implemented enhancements:**

- Add documentation to Objective-C DSL [\#189](https://github.com/Quick/Quick/issues/189)

- README: Add example of shared examples in Objective-C [\#128](https://github.com/Quick/Quick/issues/128)

- Add tests for spec runs and results [\#127](https://github.com/Quick/Quick/issues/127)

- README: Add instructions on how to install via Git submodules [\#119](https://github.com/Quick/Quick/issues/119)

- Integrate the Rewritten Nimble [\#90](https://github.com/Quick/Quick/issues/90)

- Nimble is terrible [\#87](https://github.com/Quick/Quick/issues/87)

- \[Nimble\] The generic matcher should support `Any?` expected parameter [\#86](https://github.com/Quick/Quick/issues/86)

- \[Nimble\] Custom matchers [\#84](https://github.com/Quick/Quick/issues/84)

- \[Nimble\] Tests for Expectation, i.e.: test matchers using Raise matcher [\#82](https://github.com/Quick/Quick/issues/82)

- \[Nimble\] Closure and asynchronous expectation tests [\#75](https://github.com/Quick/Quick/issues/75)

- README screenshot needs to be updated [\#71](https://github.com/Quick/Quick/issues/71)

- Prettier Objective-C syntax [\#66](https://github.com/Quick/Quick/issues/66)

- \[Nimble\] Match \(regex\) matcher [\#65](https://github.com/Quick/Quick/issues/65)

- \[Nimble\] Overload contain\(\) matcher to accept variadic parameter [\#61](https://github.com/Quick/Quick/issues/61)

- README: add section on testing view controllers [\#39](https://github.com/Quick/Quick/issues/39)

- Continuous integration \(or at least a target/script that runs all tests\) [\#25](https://github.com/Quick/Quick/issues/25)

- \[Nimble\] Use of C primitive types in expectations [\#17](https://github.com/Quick/Quick/issues/17)

**Fixed bugs:**

- Breakpoints within an Objective-C example don't consistently work [\#182](https://github.com/Quick/Quick/issues/182)

- Could not get Quick running in Xcode 6.1 on 10.10 Yosemite [\#180](https://github.com/Quick/Quick/issues/180)

- Error when running tests in Xcode 6.1 [\#170](https://github.com/Quick/Quick/issues/170)

- Examples not part of any describe/context should not include "root example group" in their name [\#168](https://github.com/Quick/Quick/issues/168)

- Equal only works with NSDictionary, not with Dictionary [\#131](https://github.com/Quick/Quick/issues/131)

- No tests shown in test navigator [\#129](https://github.com/Quick/Quick/issues/129)

- Swift compiler error on Scenester example [\#98](https://github.com/Quick/Quick/issues/98)

- Does not compile under Xcode beta 3 [\#93](https://github.com/Quick/Quick/issues/93)

- CodeSign issue for Framework in iOS 8.0 [\#79](https://github.com/Quick/Quick/issues/79)

- \[Nimble\] Support for @lazy property [\#70](https://github.com/Quick/Quick/issues/70)

**Closed issues:**

- Focused examples [\#183](https://github.com/Quick/Quick/issues/183)

- there is no beTruthy\(\) swift function [\#162](https://github.com/Quick/Quick/issues/162)

- Support of beforeEach and afterEach for QuickSharedExampleGroups [\#156](https://github.com/Quick/Quick/issues/156)

- Does not work on a physical device [\#149](https://github.com/Quick/Quick/issues/149)

- Suites of tests executed simultaneously  [\#144](https://github.com/Quick/Quick/issues/144)

- Tests Failing Without Running in Xcode 6 RC [\#141](https://github.com/Quick/Quick/issues/141)

- Failure markers disappear in XCode 6b7 [\#139](https://github.com/Quick/Quick/issues/139)

- Provide a way to define a setup for a context [\#138](https://github.com/Quick/Quick/issues/138)

- Quick crashes when tests are run from console with xcodebuild [\#133](https://github.com/Quick/Quick/issues/133)

- Async tests [\#132](https://github.com/Quick/Quick/issues/132)

- Methods stub and expectations [\#124](https://github.com/Quick/Quick/issues/124)

- Can not compile on Xcode beta6 [\#117](https://github.com/Quick/Quick/issues/117)

- Optional value in outside describe block not set [\#112](https://github.com/Quick/Quick/issues/112)

- Unresolved identifiers when running a test? [\#111](https://github.com/Quick/Quick/issues/111)

- \[Quick\]Optionals no longer conform to the BooleanType protocol [\#106](https://github.com/Quick/Quick/issues/106)

- Unable to use any matchers. [\#104](https://github.com/Quick/Quick/issues/104)

- Follow the installation guide, but still can't setup the project well [\#101](https://github.com/Quick/Quick/issues/101)

- Missing xcodeproj file for Quick [\#100](https://github.com/Quick/Quick/issues/100)

**Merged pull requests:**

- Add missing params to DSL docs. [\#192](https://github.com/Quick/Quick/pull/192) ([paulyoung](https://github.com/paulyoung))

- Port documentation from DSL.swift [\#191](https://github.com/Quick/Quick/pull/191) ([paulyoung](https://github.com/paulyoung))

- Shared example metadata [\#190](https://github.com/Quick/Quick/pull/190) ([orta](https://github.com/orta))

- Improve documentation and add more granular access control [\#188](https://github.com/Quick/Quick/pull/188) ([modocache](https://github.com/modocache))

- ExampleGroup: "root example group" not in name [\#187](https://github.com/Quick/Quick/pull/187) ([modocache](https://github.com/modocache))

- Fix breakpoints in Objective-C [\#185](https://github.com/Quick/Quick/pull/185) ([jspahrsummers](https://github.com/jspahrsummers))

- Adds Nimble to Target Dependencies for Quick tests. [\#179](https://github.com/Quick/Quick/pull/179) ([jeffh](https://github.com/jeffh))

- Add missing changes from renaming the test target. [\#176](https://github.com/Quick/Quick/pull/176) ([paulyoung](https://github.com/paulyoung))

- Provide a hook to configure Quick [\#175](https://github.com/Quick/Quick/pull/175) ([modocache](https://github.com/modocache))

- Add example and suite hooks [\#174](https://github.com/Quick/Quick/pull/174) ([modocache](https://github.com/modocache))

- Rename OSX product, targets, and scheme. [\#173](https://github.com/Quick/Quick/pull/173) ([paulyoung](https://github.com/paulyoung))

- Change Mac deployment target to 10.9 [\#172](https://github.com/Quick/Quick/pull/172) ([paulyoung](https://github.com/paulyoung))

- Update contributing guidelines. [\#171](https://github.com/Quick/Quick/pull/171) ([paulyoung](https://github.com/paulyoung))

- Example: Don't include internal root group in name [\#169](https://github.com/Quick/Quick/pull/169) ([modocache](https://github.com/modocache))

- Add .travis.yml [\#166](https://github.com/Quick/Quick/pull/166) ([modocache](https://github.com/modocache))

- Remove Quick.xcworkspace [\#165](https://github.com/Quick/Quick/pull/165) ([modocache](https://github.com/modocache))

- Only allow x86\_64 for OS X builds [\#158](https://github.com/Quick/Quick/pull/158) ([jspahrsummers](https://github.com/jspahrsummers))

- Improves testing UIViewController examples [\#155](https://github.com/Quick/Quick/pull/155) ([ashfurrow](https://github.com/ashfurrow))

- Add tests for spec runs and results [\#154](https://github.com/Quick/Quick/pull/154) ([modocache](https://github.com/modocache))

- Add section about testing UIKit interaction with Quick. [\#151](https://github.com/Quick/Quick/pull/151) ([sidraval](https://github.com/sidraval))

- Use vararg macros for block arguments [\#150](https://github.com/Quick/Quick/pull/150) ([jspahrsummers](https://github.com/jspahrsummers))

- README: add shared examples in Objective-C [\#147](https://github.com/Quick/Quick/pull/147) ([modocache](https://github.com/modocache))

- QCKDSL: no 'qck\_' prefix unless shorthand disabled [\#145](https://github.com/Quick/Quick/pull/145) ([modocache](https://github.com/modocache))

- Add dir to FRAMEWORK\_SEARCH\_PATH [\#143](https://github.com/Quick/Quick/pull/143) ([pepe](https://github.com/pepe))

- Add shorthand for pending. [\#142](https://github.com/Quick/Quick/pull/142) ([paulyoung](https://github.com/paulyoung))

- Update submodules section of README [\#137](https://github.com/Quick/Quick/pull/137) ([joemasilotti](https://github.com/joemasilotti))

- Codesign for iOS [\#136](https://github.com/Quick/Quick/pull/136) ([jbosse](https://github.com/jbosse))

- README: outsource Nimble documentation [\#130](https://github.com/Quick/Quick/pull/130) ([modocache](https://github.com/modocache))

- Add submodule instructions [\#126](https://github.com/Quick/Quick/pull/126) ([nwest](https://github.com/nwest))

- Added SugarRecord to Who Uses Quick section [\#125](https://github.com/Quick/Quick/pull/125) ([pepibumur](https://github.com/pepibumur))

- Ignore .DS\_Store files [\#123](https://github.com/Quick/Quick/pull/123) ([nerdyc](https://github.com/nerdyc))

- Add Squeal to "Who Uses Quick" section. [\#122](https://github.com/Quick/Quick/pull/122) ([nerdyc](https://github.com/nerdyc))

- Pass example metadata to beforeEach/afterEach [\#120](https://github.com/Quick/Quick/pull/120) ([modocache](https://github.com/modocache))

- Added Moya to list of users [\#118](https://github.com/Quick/Quick/pull/118) ([ashfurrow](https://github.com/ashfurrow))

- Swift Fixes for Xcode6-B6 [\#116](https://github.com/Quick/Quick/pull/116) ([bendjones](https://github.com/bendjones))

- Xcode 6 Beta 6 compatibility [\#115](https://github.com/Quick/Quick/pull/115) ([sync](https://github.com/sync))

- Fix "Build Active Architecture Only" build setting for iOS target [\#114](https://github.com/Quick/Quick/pull/114) ([akashivskyy](https://github.com/akashivskyy))

- Use Quick/Quick for the template repo [\#113](https://github.com/Quick/Quick/pull/113) ([nwest](https://github.com/nwest))

- Signify language of code examples in README. [\#110](https://github.com/Quick/Quick/pull/110) ([paulyoung](https://github.com/paulyoung))

- Adds conditional support for falling back to XCTest-style names of tests. [\#109](https://github.com/Quick/Quick/pull/109) ([ashfurrow](https://github.com/ashfurrow))

- Added Artsy's use of Quick to README [\#108](https://github.com/Quick/Quick/pull/108) ([ashfurrow](https://github.com/ashfurrow))

- Xcode 6 Beta 5 compatibility [\#107](https://github.com/Quick/Quick/pull/107) ([tokorom](https://github.com/tokorom))

- Added public currentExampleIndex. [\#105](https://github.com/Quick/Quick/pull/105) ([rokgregoric](https://github.com/rokgregoric))

- Added public scopes for Scenester example. See \#98 [\#103](https://github.com/Quick/Quick/pull/103) ([jeffh](https://github.com/jeffh))

- Updated README's source to new Nimble syntax [\#102](https://github.com/Quick/Quick/pull/102) ([jeffh](https://github.com/jeffh))

- Add public accessors for types to begin supporting XCode 6 beta 4. [\#99](https://github.com/Quick/Quick/pull/99) ([drmohundro](https://github.com/drmohundro))

- Update modocache/Quick =\> Quick/Quick [\#97](https://github.com/Quick/Quick/pull/97) ([itsmeduncan](https://github.com/itsmeduncan))

- Fix link to issue on rake test for iOS [\#96](https://github.com/Quick/Quick/pull/96) ([rastersize](https://github.com/rastersize))

- Integrate New Nimble Matchers [\#95](https://github.com/Quick/Quick/pull/95) ([jeffh](https://github.com/jeffh))

- Update Swift code for Xcode 6 beta 3 [\#94](https://github.com/Quick/Quick/pull/94) ([modocache](https://github.com/modocache))

- \[Nimble\] Added dictionary support to contain\(\) matcher [\#89](https://github.com/Quick/Quick/pull/89) ([endersstocker](https://github.com/endersstocker))

- \[Nimble\] Added dictionary support to isEmpty\(\) matcher [\#88](https://github.com/Quick/Quick/pull/88) ([endersstocker](https://github.com/endersstocker))

- README: Clarified that beEqual\(\) handles values as well as objects [\#85](https://github.com/Quick/Quick/pull/85) ([endersstocker](https://github.com/endersstocker))

- README: Added screenshot with correct information, per issue \#71 [\#78](https://github.com/Quick/Quick/pull/78) ([endersstocker](https://github.com/endersstocker))

- Regexp matcher with correct parent [\#68](https://github.com/Quick/Quick/pull/68) ([garnett](https://github.com/garnett))

- \[Nimble\] Add 'receiveNotification' matcher [\#54](https://github.com/Quick/Quick/pull/54) ([garnett](https://github.com/garnett))

- WIP for using Generics to allow for more flexible type matching [\#31](https://github.com/Quick/Quick/pull/31) ([dmeehan1968](https://github.com/dmeehan1968))

- Test subject is Any, but introduces Swift compiler fatal crash [\#23](https://github.com/Quick/Quick/pull/23) ([dmeehan1968](https://github.com/dmeehan1968))

- \[WIP\] Add ExampleTests [\#15](https://github.com/Quick/Quick/pull/15) ([sharplet](https://github.com/sharplet))

## [v0.1.0-beta](https://github.com/Quick/Quick/tree/v0.1.0-beta) (2014-07-05)

**Implemented enhancements:**

- \[Nimble\] Unify negative fail messages [\#69](https://github.com/Quick/Quick/issues/69)

- \[Nimble\] Contain matcher should test for substring existence [\#48](https://github.com/Quick/Quick/issues/48)

- \[Nimble\] beFalse\(\) matcher [\#47](https://github.com/Quick/Quick/issues/47)

- Create Callsite struct in Nimble [\#46](https://github.com/Quick/Quick/issues/46)

- \[Quick\] Shared examples [\#44](https://github.com/Quick/Quick/issues/44)

- \[Nimble\] Failure reporting using Expected: Got: [\#42](https://github.com/Quick/Quick/issues/42)

- \[Quick\] Test failure errors should include the nested description \(add shared examples\) [\#37](https://github.com/Quick/Quick/issues/37)

- \[Quick\] Change exampleGroups\(\) to spec\(\) [\#30](https://github.com/Quick/Quick/issues/30)

- Extract Quick.Expectations into separate Xcode project [\#29](https://github.com/Quick/Quick/issues/29)

- \[Nimble\] Support expectations in Objective-C [\#26](https://github.com/Quick/Quick/issues/26)

- BeNil matcher [\#19](https://github.com/Quick/Quick/issues/19)

- \[Quick\] QuickSpec Xcode template [\#18](https://github.com/Quick/Quick/issues/18)

- Pending examples [\#16](https://github.com/Quick/Quick/issues/16)

- Add specs for matchers [\#12](https://github.com/Quick/Quick/issues/12)

- Easier installation for iOS/OS X [\#5](https://github.com/Quick/Quick/issues/5)

- beforeSuite/afterSuite [\#2](https://github.com/Quick/Quick/issues/2)

- \[Quick\] Port shared examples DSL to Objective-C [\#80](https://github.com/Quick/Quick/issues/80)

- \[Nimble\] A "raise" matcher [\#8](https://github.com/Quick/Quick/issues/8)

**Fixed bugs:**

- \[Quick\] Shared examples not quite there yet [\#81](https://github.com/Quick/Quick/issues/81)

- Expose nmb\_expect to Objective-C breaks nimble [\#64](https://github.com/Quick/Quick/issues/64)

- beforeSuite/afterSuite are probably not ported to Objective-C [\#63](https://github.com/Quick/Quick/issues/63)

- \[Quick, Nimble\] Missing XCTest.framework in Xcode 6 Beta 2 [\#50](https://github.com/Quick/Quick/issues/50)

- \[Nimble\] Fatal exception if expect is not within it\(\) closure [\#20](https://github.com/Quick/Quick/issues/20)

- Report failures using the correct file and line number [\#7](https://github.com/Quick/Quick/issues/7)

- Linking to Quick.framework from iOS test target fails [\#6](https://github.com/Quick/Quick/issues/6)

- Crash when running a subset of the test suite [\#4](https://github.com/Quick/Quick/issues/4)

- Xcode test navigator integration [\#1](https://github.com/Quick/Quick/issues/1)

- \[Nimble\] Add undocumented matchers to README [\#76](https://github.com/Quick/Quick/issues/76)

**Merged pull requests:**

- \[Nimble\] Added list of matchers to README, per issue \#76 [\#77](https://github.com/Quick/Quick/pull/77) ([endersstocker](https://github.com/endersstocker))

- \[Nimble\] Fixed incorrect `it` descriptions in Contain spec [\#74](https://github.com/Quick/Quick/pull/74) ([endersstocker](https://github.com/endersstocker))

- \[Nimble\] Updated leading comments [\#73](https://github.com/Quick/Quick/pull/73) ([endersstocker](https://github.com/endersstocker))

- \[Nimble\] Changed `to not` to `not to` throughout, per issue \#69 [\#72](https://github.com/Quick/Quick/pull/72) ([endersstocker](https://github.com/endersstocker))

- Regexp matcher [\#67](https://github.com/Quick/Quick/pull/67) ([garnett](https://github.com/garnett))

- \[Nimble\] Added comparison matchers [\#62](https://github.com/Quick/Quick/pull/62) ([endersstocker](https://github.com/endersstocker))

- \[Nimble\] Added beEmpty\(\) matcher [\#60](https://github.com/Quick/Quick/pull/60) ([endersstocker](https://github.com/endersstocker))

- \[Nimble\] Add matcher `BeSameInstanceAs\(\)` [\#59](https://github.com/Quick/Quick/pull/59) ([alexbasson](https://github.com/alexbasson))

- \[Nimble\]\[WIP\] Bridging Nimble to Objective-C [\#58](https://github.com/Quick/Quick/pull/58) ([garnett](https://github.com/garnett))

- \[Nimble\] Use switch-case statement in Contain Matcher [\#57](https://github.com/Quick/Quick/pull/57) ([ikesyo](https://github.com/ikesyo))

- \[Quick, Nimble\] Added template and install script per issue \#18 [\#56](https://github.com/Quick/Quick/pull/56) ([endersstocker](https://github.com/endersstocker))

- Fix XCTest framework for XCode 6 beta 2. [\#55](https://github.com/Quick/Quick/pull/55) ([nmonje](https://github.com/nmonje))

- \[Quick, Nimble\] Updated README.md screenshot and added Xcode Template per issue \#18 [\#53](https://github.com/Quick/Quick/pull/53) ([endersstocker](https://github.com/endersstocker))

- Fix failing test, inherit beTrue/beFalse from 'Equal' matcher [\#52](https://github.com/Quick/Quick/pull/52) ([garnett](https://github.com/garnett))

- \[Nimble\] Addressed issues \#30, 42, 47, 50 [\#51](https://github.com/Quick/Quick/pull/51) ([endersstocker](https://github.com/endersstocker))

- \[Nimble\] Extend Contain matcher to support String's substring matching [\#49](https://github.com/Quick/Quick/pull/49) ([garnett](https://github.com/garnett))

- Extract expectations to separate project [\#45](https://github.com/Quick/Quick/pull/45) ([garnett](https://github.com/garnett))

- Use implicitly unwrapped optionals for subjects under test [\#43](https://github.com/Quick/Quick/pull/43) ([garnett](https://github.com/garnett))

- Catch exceptions thrown during examples and highlight the failed example in Xcode [\#41](https://github.com/Quick/Quick/pull/41) ([sharplet](https://github.com/sharplet))

- \[Nimble\] Create a workaround fix for issue \#20 [\#40](https://github.com/Quick/Quick/pull/40) ([KeithErmel](https://github.com/KeithErmel))

- Add pending tests [\#38](https://github.com/Quick/Quick/pull/38) ([bastos](https://github.com/bastos))

- Fixed grammar in variable name [\#34](https://github.com/Quick/Quick/pull/34) ([endersstocker](https://github.com/endersstocker))

- multibyte language support of selector name [\#33](https://github.com/Quick/Quick/pull/33) ([corosukeK](https://github.com/corosukeK))

- Fix typo in Quickspec.m [\#28](https://github.com/Quick/Quick/pull/28) ([nottombrown](https://github.com/nottombrown))

- One remaining NSObject instead of Any prevented compiling [\#27](https://github.com/Quick/Quick/pull/27) ([dmeehan1968](https://github.com/dmeehan1968))

- Added import of Quick module in README.md [\#24](https://github.com/Quick/Quick/pull/24) ([gscalzo](https://github.com/gscalzo))

- Add support for optionals and beNil \(closes \#19\) [\#21](https://github.com/Quick/Quick/pull/21) ([dmeehan1968](https://github.com/dmeehan1968))

- Add before and after suite [\#13](https://github.com/Quick/Quick/pull/13) ([nottombrown](https://github.com/nottombrown))

- Minor syntax cleanup [\#3](https://github.com/Quick/Quick/pull/3) ([nassersala](https://github.com/nassersala))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*