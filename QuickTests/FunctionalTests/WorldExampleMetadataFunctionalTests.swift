import Quick
import Nimble

class WorldExampleMetadataFunctionalTests: QuickSpec {
    override func spec() {

        let testName = "should be able to access the name of this test"
        it(testName) {
            let metadata = World.sharedWorld().currentExampleMetadata!
            expect(metadata.example.name).to(equal(testName))
        }

        it("should have the correct file as the callsite"){
            let file: String = __FILE__

            let metadata = World.sharedWorld().currentExampleMetadata!
            expect(metadata.example.callsite.file).to(equal(file))
        }
    }
}
