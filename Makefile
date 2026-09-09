# WorkbenchKit developer tasks.

.PHONY: test lint lint-fix

# Pure package, no app target, no Metal: swift test is the whole story.
test:
	swift test

lint:
	@command -v swiftlint >/dev/null 2>&1 || { echo "SwiftLint not installed — run 'brew install swiftlint'"; exit 0; }
	swiftlint lint --quiet

lint-fix:
	@command -v swiftlint >/dev/null 2>&1 || { echo "SwiftLint not installed — run 'brew install swiftlint'"; exit 0; }
	swiftlint --fix
	swiftlint lint --quiet
