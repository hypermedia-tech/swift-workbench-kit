# WorkbenchKit developer tasks.

.PHONY: check-swiftlint test lint lint-fix

check-swiftlint:
	@command -v swiftlint >/dev/null 2>&1 || { echo "SwiftLint not installed — run 'brew install swiftlint'"; exit 1; }

# Pure package, no app target, no Metal: swift test is the whole story.
test:
	swift test

lint: check-swiftlint
	swiftlint lint --quiet

lint-fix: check-swiftlint
	swiftlint --fix
	swiftlint lint --quiet
