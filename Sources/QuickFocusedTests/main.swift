import Quick

QCKMain([
    FunctionalTests_FocusedSpec_Focused(),
    FunctionalTests_FocusedSpec_Unfocused(),
    FocusedTests(),
],
configurations: [FunctionalTests_FocusedSpec_SharedExamplesConfiguration.self]
)
