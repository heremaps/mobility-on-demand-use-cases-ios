#!/bin/sh
LINT_CYCLOMATIC_COMPLEXITY=10
LINT_NPATH_COMPLEXITY=300
LINT_SHORT_VARIABLE_NAME=3
LINT_LONG_VARIABLE_NAME=64

# rules
LINT_RULES="-rc CYCLOMATIC_COMPLEXITY=${LINT_CYCLOMATIC_COMPLEXITY} \
      -rc NPATH_COMPLEXITY=${LINT_NPATH_COMPLEXITY} \
      -rc SHORT_VARIABLE_NAME=${LINT_SHORT_VARIABLE_NAME} \
      -rc LONG_VARIABLE_NAME=${LINT_LONG_VARIABLE_NAME}"

# disabled rules
LINT_DISABLE_RULES="-disable-rule=LongLine \
					-disable-rule=LongMethod \
					-disable-rule=UnusedMethodParameter \
					-disable-rule=UseObjectSubscripting"

# Threshold
LINT_PRIORITY_1_THRESHOLD=0
LINT_PRIORITY_2_THRESHOLD=5
LINT_PRIORITY_3_THRESHOLD=10
LINT_THRESHOLD="-max-priority-1=${LINT_PRIORITY_1_THRESHOLD} \
    -max-priority-2=${LINT_PRIORITY_2_THRESHOLD} \
    -max-priority-3=${LINT_PRIORITY_3_THRESHOLD}"

LINT_INCLUDES="OnDemandPassenger"
LINT_EXCLUDES="Pods|Carthage"
LINT_REPORTS_DIR=oclint-reports
LINT_REPORT_FILE=report.xml
LINT_REPORT_TYPE=xcode

mkdir -p ${LINT_REPORTS_DIR}

xcodebuild clean
xcodebuild -project OnDemandPassenger.xcodeproj CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO | xcpretty -r json-compilation-database --output compile_commands.json
oclint-json-compilation-database \
	-i ${LINT_INCLUDES} \
	-- \
	-report-type ${LINT_REPORT_TYPE} \
	${LINT_RULES} \
	${LINT_DISABLE_RULES} \
	${LINT_THRESHOLD} \
	-o ${LINT_REPORTS_DIR}/${LINT_REPORT_FILE} \
	-stats \
	-verbose \
	-list-enabled-rules
