lint:
	@echo "--> Running swiftlint"
	swiftlint

test:
	@echo "--> Running all tests"
	fastlane test

build-carthage:
	@echo "--> Creating Sentry framework package with carthage"
	carthage build --no-skip-current --cache-builds
	carthage archive Sentry KSCrash --output Sentry.framework.zip

test-carthage:
	@echo "--> Testing carthage"
	mkdir -p tmp
	echo 'github "getsentry/sentry-swift"' > tmp/Cartfile && cd tmp && carthage update && cd ..
	rm -rf tmp

release: bump-version lint test pod-example-projects pod-lint build-carthage git-commit-add pod-push

build-time:
	@echo "--> Analysing build time"
	xcodebuild -verbose -project Sentry.xcodeproj -scheme Sentry-iOS -sdk iphonesimulator clean build OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies" | grep ".[0-9]ms" | grep -v "^0.[0-9]ms" | sort -nr > culprits.txt
	open culprits.txt

pod-lint:
	@echo "--> Build local pod"
	pod lib lint --allow-warnings

pod-example-projects:
	@echo "--> Running pod install on all example projects"
	pod repo update
	pod update --project-directory=Examples/SwiftExample
	pod update --project-directory=Examples/SwiftTVOSExample
	pod update --project-directory=Examples/SwiftWatchOSExample
	pod update --project-directory=Examples/ObjcExample
	pod update --project-directory=Examples/MacExample

pod-release:
	@echo "--> Releasing Pod"
	pod trunk push Sentry.podspec --allow-warnings

build-version-bump:
	@echo "--> Building VersionBump"
	cd Utils/VersionBump && swift build

bump-version: build-version-bump
	@echo "--> Bumping version from ${FROM} to ${TO}"
	./Utils/VersionBump/.build/debug/VersionBump ${FROM} ${TO}

clean-version-bump:
	@echo "--> Clean VersionBump"
	cd Utils/VersionBump && rm -rf .build && swift build

git-commit-add:
	@echo "\n\n\n--> Commting git ${TO}"
	git commit -am "Bump version to ${TO}"
	git tag ${TO}
	git push
	git push --tags

pod-push:
	@echo "--> Updating cocoapod"
	pod trunk push Sentry.podspec
