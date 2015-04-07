# Installing Quick

> **If you're using Xcode 6.2 & Swift 1.1,** use Quick `v0.2.*`.
> New releases are developed on the `swift-1.1` branch.
>
> **If you're using Xcode 6.3 & Swift 1.2,** use the latest version of Quick--`v0.3.0` at the time of writing.
> New releases are developed on the `master` branch.

Quick provides the syntax to define examples and example groups. Nimble
provides the `expect(...).to` assertion syntax. You may use either one,
or both, in your tests.

There are three recommended ways of linking Quick to your tests:

1. Git Submodules
2. CocoaPods
3. Carthage

Choose one and follow the instructions below. Once you've completed them,
you should be able to `import Quick` from within files in your test target.

## Git Submodules

To link Quick and Nimble using Git submodules:

1. Add submodules for Quick and Nimble.
2. Add `Quick.xcodeproj` and `Nimble.xcodeproj` to your project's `.xcworkspace`.
3. Link `Quick.framework` and `Nimble.framework` in your test target's
   "Link Binary with Libraries" build phase.

First, if you don't already have one, create a directory for your Git submodules.
Let's assume you have a directory named `Vendor`.

**Step One:** Download Quick and Nimble as Git submodules:

```sh
git submodule add git@github.com:Quick/Quick.git Vendor/Quick
git submodule add git@github.com:Quick/Nimble.git Vendor/Nimble
git submodule update --init --recursive
```

**Step Two:** Add the `Quick.xcodeproj` and `Nimble.xcodeproj` files downloaded above to
your project's `.xcworkspace`. For example, this is `Guanaco.xcworkspace`, the
workspace for a project that is tested using Quick and Nimble:

![](http://f.cl.ly/items/2b2R0e1h09003u2f0Z3U/Screen%20Shot%202015-02-27%20at%202.19.37%20PM.png)

**Step Three:** Link the `Quick.framework` during your test target's
`Link Binary with Libraries` build phase. You should see two
`Quick.frameworks`; one is for OS X, and the other is for iOS.

![](http://cl.ly/image/2L0G0H1a173C/Screen%20Shot%202014-06-08%20at%204.27.48%20AM.png)

Do the same for the `Nimble.framework`, and you're done!

**Updating the Submodules:** If you ever want to update the Quick
or Nimble submodules to latest version, enter the Quick directory
and pull from the master repository:

```sh
cd /path/to/your/project/Vendor/Quick
git checkout master
git pull --rebase origin master
```

Your Git repository will track changes to submodules. You'll want to
commit the fact that you've updated the Quick submodule:

```sh
cd /path/to/your/project
git commit -m "Updated Quick submodule"
```

**Cloning a Repository that Includes a Quick Submodule:** After other people
clone your repository, they'll have to pull down the submodules as well.
They can do so by running the `git submodule update` command:

```sh
git submodule update --init --recursive
```

You can read more about Git submodules [here](http://git-scm.com/book/en/Git-Tools-Submodules).

## CocoaPods

First, update CocoaPods to Version 0.36.0 or newer, which is necessary to install CocoaPods using Swift.

Then, add Quick and Nimble to your Podfile. Additionally, the ```use_frameworks!``` line is necessary for using Swift in CocoaPods:

```rb
# Podfile

target 'MyTests' do
  use_frameworks!
  pod 'Quick'
  pod 'Nimble'
end
```

Finally, download and link Quick and Nimble to your tests:

```sh
pod install
```

## [Carthage](https://github.com/Carthage/Carthage)

As test targets do not have the "Embedded Binaries" section, the frameworks must
be added to the target's "Link Binary With Libraries" as well as a "Copy Files" build phase
to copy them to the target's Frameworks destination.

 > As Carthage builds dynamic frameworks, you will need a valid code signing identity set up.

1. Add Quick to your `[Cartfile.private](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfileprivate)`:

    ```
    github "Quick/Quick"
    github "Quick/Nimble"
    ```

2. Run `carthage update`.
3. From your `Carthage/Build/[platform]/` directory, add both Quick and Nimble to your test target's "Link Binary With Libraries" build phase:
    ![](http://i.imgur.com/pBkDDk5.png)

4. For your test target, create a new build phase of type "Copy Files":
    ![](http://i.imgur.com/jZATIjQ.png)

5. Set the "Destination" to "Frameworks", then add both frameworks:
    ![](http://i.imgur.com/rpnyWGH.png)

This is not "the one and only way" to use Carthage to manage dependencies.
For further reference check out the [Carthage documentation](https://github.com/Carthage/Carthage/blob/master/README.md).

### (Not Recommended) Running Quick Specs on a Physical iOS Device

In order to run specs written in Quick on device, you need to add `Quick.framework` and
`Nimble.framework` as `Embedded Binaries` to the `Host Application` of the
test target. After adding a framework as an embedded binary, Xcode will
automatically link the host app against the framework.

![](http://indiedev.kapsi.fi/images/embed-in-host.png)
