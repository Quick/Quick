import Quick
import Nimble

class WorldExampleMetadataFunctionalTests: QuickSpec {
    override func spec() {

        describe("World metadata") {
            it("provides the name of the current example") {
                let metadata = World.sharedWorld().currentExampleMetadata!
                expect(metadata.example.name).to(equal("World metadata, provides the name of the current example"))
            }
        }

        it("should have the correct file as the callsite"){
            let file: String = __FILE__

            let metadata = World.sharedWorld().currentExampleMetadata!
            expect(metadata.example.callsite.file).to(equal(file))
        }
    }
}
