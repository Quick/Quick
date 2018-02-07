import XCTest
@testable import Quick
import Nimble

class ExampleTests: XCTestCase {
    func test_uniqueIdentifier_uniquelyIdentifiesTheExampleAcrossASpec() {
        let rootExampleGroup = ExampleGroup(
            description: "root example group",
            flags: [:],
            isInternalRootExampleGroup: true
        )

        let rootExample = Example(
            description: "root example",
            callsite: Callsite(file: "", line: 0),
            flags: [:]
        ) {}
        rootExampleGroup.appendExample(rootExample)

        let groupContainingExamplesWithDuplicateDescriptions = ExampleGroup(
            description: "inner group",
            flags: [:]
        )

        let dupeExampleA = Example(
            description: "duplicate description",
            callsite: Callsite(file: "", line: 0),
            flags: [:]
        ) {}
        let dupeExampleB = Example(
            description: "duplicate description",
            callsite: Callsite(file: "", line: 0),
            flags: [:]
        ) {}
        let dupeExampleC = Example(
            description: "duplicate description",
            callsite: Callsite(file: "", line: 0),
            flags: [:]
        ) {}
        groupContainingExamplesWithDuplicateDescriptions.appendExample(dupeExampleA)
        groupContainingExamplesWithDuplicateDescriptions.appendExample(dupeExampleB)
        groupContainingExamplesWithDuplicateDescriptions.appendExample(dupeExampleC)

        rootExampleGroup.appendExampleGroup(groupContainingExamplesWithDuplicateDescriptions)

        let groupContainingExamplesDuplicatedAcrossGroupsA = ExampleGroup(
            description: "group duped across a spec",
            flags: [:]
        )
        let exampleDupedAcrossSpecA = Example(
            description: "example duped across different groups",
            callsite: Callsite(file: "", line: 0),
            flags: [:]
        ) {}
        groupContainingExamplesDuplicatedAcrossGroupsA.appendExample(exampleDupedAcrossSpecA)

        let groupContainingExamplesDuplicatedAcrossGroupsB = ExampleGroup(
            description: "group duped across a spec",
            flags: [:]
        )
        let exampleDupedAcrossSpecB = Example(
            description: "example duped across different groups",
            callsite: Callsite(file: "", line: 0),
            flags: [:]
        ) {}
        groupContainingExamplesDuplicatedAcrossGroupsB.appendExample(exampleDupedAcrossSpecB)

        rootExampleGroup.appendExampleGroup(groupContainingExamplesDuplicatedAcrossGroupsA)
        rootExampleGroup.appendExampleGroup(groupContainingExamplesDuplicatedAcrossGroupsB)

        let justAnotherGroup = ExampleGroup(
            description: "just another group",
            flags: [:]
        )
        let justAnotherExample = Example(
            description: "just another example",
            callsite: Callsite(file: "", line: 0),
            flags: [:]
        ) {}

        justAnotherGroup.appendExample(justAnotherExample)

        rootExampleGroup.appendExampleGroup(justAnotherGroup)

        rootExampleGroup.assignUniqueIdentifiersToExamples()

        expect(
            rootExample.uniqueIdentifier
            ).to(
                equal("root_example")
        )

        expect(
            dupeExampleA.uniqueIdentifier
            ).to(
                equal("inner_group_duplicate_description")
        )

        expect(
            dupeExampleB.uniqueIdentifier
            ).to(
                equal("inner_group_duplicate_description_2")
        )

        expect(
            dupeExampleC.uniqueIdentifier
            ).to(
                equal("inner_group_duplicate_description_3")
        )

        expect(
            exampleDupedAcrossSpecA.uniqueIdentifier
            ).to(
                equal("group_duped_across_a_spec_example_duped_across_different_groups")
        )

        expect(
            exampleDupedAcrossSpecB.uniqueIdentifier
            ).to(
                equal("group_duped_across_a_spec_example_duped_across_different_groups_2")
        )

        expect(
            justAnotherExample.uniqueIdentifier
            ).to(
                equal("just_another_group_just_another_example")
        )
    }
}
