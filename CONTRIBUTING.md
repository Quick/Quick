<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Welcome to Quick!](#welcome-to-quick!)
  - [Reporting Bugs](#reporting-bugs)
  - [Building the Project](#building-the-project)
  - [Pull Requests](#pull-requests)
    - [Style Conventions](#style-conventions)
  - [Commit Bits](#commit-bits)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Welcome to Quick!

We're building a BDD framework for a new generation of Swift and
Objective-C developers.

Quick should be easy to use and easy to maintain. Let's keep things
simple and well-tested.

**tl;dr:** If you've added a file to the project, make sure it's
included in both the OS X and iOS targets.

## Reporting Bugs

Nothing is off-limits. If you're having a problem, we want to hear about
it.

- See a crash? File an issue.
- Code isn't compiling, but you don't know why? Sounds like you should
  submit a new issue, bud.
- Went to the kitchen, only to forget why you went in the first place?
  Better submit an issue.

## Building the Project

- Use `Quick.xcworkspace` to work on Quick, Nimble, and the example
  apps.

## Pull Requests

- Nothing is trivial. Submit pull requests for anything: typos,
  whitespace, you name it.
- Not all pull requests will be merged, but all will be acknowledged. If
  no one has provided feedback on your request, ping one of the owners
  by name.
- Make sure your pull request includes any necessary updates to the
  README or other documentation.
- Be sure the unit tests for both the OS X and iOS targets of both Quick
  and Nimble pass before submitting your pull request. You can run all
  the OS X unit tests using `rake test` (hopefully this will support iOS
  soon, see: https://github.com/modocache/Quick/issues/25).
- If you've added a file to the project, make sure it's included in both
  the OS X and iOS targets.

### Style Conventions

- Indent using 4 spaces.
- Keep lines 100 characters or shorter. Break long statements into
  shorter ones over multiple lines.
- In Objective-C, use `#pragma mark -` to mark public, internal,
  protocol, and superclass methods. See `QuickSpec.m` for an example.

## Commit Bits

If a few of your pull requests have been merged, and you'd like a
controlling stake in the project, file an issue asking for write access
to the repository.

