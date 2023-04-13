# Command completion for ort
# Generated by Clikt


### Setup for ort
set -l ort_subcommands 'advise analyze config download evaluate notify report requirements scan upload-curations upload-result-to-postgres upload-result-to-sw360'

## Options for ort
complete -c ort -n "not __fish_seen_subcommand_from $ort_subcommands" -l config -s c -r -F -d 'The path to a configuration file.'
complete -c ort -n "not __fish_seen_subcommand_from $ort_subcommands" -l error -l warn -l info -l debug -d 'Set the verbosity level of log output.'
complete -c ort -n "not __fish_seen_subcommand_from $ort_subcommands" -l stacktrace -d 'Print out the stacktrace for all exceptions.'
complete -c ort -n "not __fish_seen_subcommand_from $ort_subcommands" -s P -r -d 'Override a key-value pair in the configuration file. For example: -P ort.scanner.storages.postgres.connection.schema=testSchema'
complete -c ort -n "not __fish_seen_subcommand_from $ort_subcommands" -l help-all -d 'Display help for all subcommands.'
complete -c ort -n "not __fish_seen_subcommand_from $ort_subcommands" -l generate-completion
complete -c ort -n "not __fish_seen_subcommand_from $ort_subcommands" -l version -s v -d 'Show the version and exit.'
complete -c ort -n "not __fish_seen_subcommand_from $ort_subcommands" -s h -l help -d 'Show this message and exit'


### Setup for advise
complete -c ort -f -n __fish_use_subcommand -a advise -d 'Check dependencies for security vulnerabilities.'

## Options for advise
complete -c ort -n "__fish_seen_subcommand_from advise" -l ort-file -s i -r -F -d 'An ORT result file with an analyzer result to use.'
complete -c ort -n "__fish_seen_subcommand_from advise" -l output-dir -s o -r -F -d 'The directory to write the ORT result file with advisor results to.'
complete -c ort -n "__fish_seen_subcommand_from advise" -l output-formats -s f -r -fa "JSON XML YAML" -d 'The list of output formats to be used for the ORT result file(s).'
complete -c ort -n "__fish_seen_subcommand_from advise" -l label -s l -r -d 'Set a label in the ORT result, overwriting any existing label of the same name. Can be used multiple times. For example: --label distribution=external'
complete -c ort -n "__fish_seen_subcommand_from advise" -l resolutions-file -r -F -d 'A file containing issue and rule violation resolutions.'
complete -c ort -n "__fish_seen_subcommand_from advise" -l advisors -s a -r -d 'The comma-separated advisors to use, any of [GitHubDefects, NexusIQ, OssIndex, OSV, VulnerableCode].'
complete -c ort -n "__fish_seen_subcommand_from advise" -l skip-excluded -d 'Do not check excluded projects or packages.'
complete -c ort -n "__fish_seen_subcommand_from advise" -s h -l help -d 'Show this message and exit'


### Setup for analyze
complete -c ort -f -n __fish_use_subcommand -a analyze -d 'Determine dependencies of a software project.'

## Options for analyze
complete -c ort -n "__fish_seen_subcommand_from analyze" -l input-dir -s i -r -F -d 'The project directory to analyze. As a special case, if only one package manager is enabled, this may point to a definition file for that package manager to only analyze that single project.'
complete -c ort -n "__fish_seen_subcommand_from analyze" -l output-dir -s o -r -F -d 'The directory to write the ORT result file with analyzer results to.'
complete -c ort -n "__fish_seen_subcommand_from analyze" -l output-formats -s f -r -fa "JSON XML YAML" -d 'The list of output formats to be used for the ORT result file(s).'
complete -c ort -n "__fish_seen_subcommand_from analyze" -l repository-configuration-file -r -F -d 'A file containing the repository configuration. If set, overrides any repository configuration contained in a \'.ort.yml\' file in the repository.'
complete -c ort -n "__fish_seen_subcommand_from analyze" -l resolutions-file -r -F -d 'A file containing issue and rule violation resolutions.'
complete -c ort -n "__fish_seen_subcommand_from analyze" -l label -s l -r -d 'Set a label in the ORT result, overwriting any existing label of the same name. Can be used multiple times. For example: --label distribution=external'
complete -c ort -n "__fish_seen_subcommand_from analyze" -l package-managers -s m -r -d 'The comma-separated package managers to enable, any of [Bower, Bundler, Cargo, Carthage, CocoaPods, Composer, Conan, DotNet, GoDep, GoMod, Gradle, GradleInspector, Maven, NPM, NuGet, PIP, Pipenv, PNPM, Poetry, Pub, SBT, SpdxDocumentFile, Stack, Unmanaged, Yarn, Yarn2]. Note that disabling overrides enabling. If set, the \'enabledPackageManagers\' property from configuration files is ignored.'
complete -c ort -n "__fish_seen_subcommand_from analyze" -l not-package-managers -s n -r -d 'The comma-separated package managers to disable, any of [Bower, Bundler, Cargo, Carthage, CocoaPods, Composer, Conan, DotNet, GoDep, GoMod, Gradle, GradleInspector, Maven, NPM, NuGet, PIP, Pipenv, PNPM, Poetry, Pub, SBT, SpdxDocumentFile, Stack, Unmanaged, Yarn, Yarn2]. Note that disabling overrides enabling. If set, the \'disabledPackageManagers\' property from configuration files is ignored.'
complete -c ort -n "__fish_seen_subcommand_from analyze" -s h -l help -d 'Show this message and exit'


### Setup for config
complete -c ort -f -n __fish_use_subcommand -a config -d 'Show different ORT configurations'

## Options for config
complete -c ort -n "__fish_seen_subcommand_from config" -l show-default -d 'Show the default configuration used when no custom configuration is present.'
complete -c ort -n "__fish_seen_subcommand_from config" -l show-active -d 'Show the active configuration used, including any custom configuration.'
complete -c ort -n "__fish_seen_subcommand_from config" -l show-reference -d 'Show the reference configuration. This configuration is never actually used as it just contains example entries for all supported configuration options.'
complete -c ort -n "__fish_seen_subcommand_from config" -l check-syntax -r -F -d 'Check the syntax of the given configuration file.'
complete -c ort -n "__fish_seen_subcommand_from config" -l hocon-to-yaml -r -F -d 'Perform a simple conversion of the given HOCON configuration file to YAML and print the result.'
complete -c ort -n "__fish_seen_subcommand_from config" -s h -l help -d 'Show this message and exit'


### Setup for download
complete -c ort -f -n __fish_use_subcommand -a download -d 'Fetch source code from a remote location.'

## Options for download
complete -c ort -n "__fish_seen_subcommand_from download" -l ort-file -s i -r -F -d 'An ORT result file with an analyzer result to use. Must not be used together with \'--project-url\'.'
complete -c ort -n "__fish_seen_subcommand_from download" -l project-url -r -d 'A VCS or archive URL of a project to download. Must not be used together with \'--ort-file\'.'
complete -c ort -n "__fish_seen_subcommand_from download" -l project-name -r -d 'The speaking name of the project to download. For use together with \'--project-url\'. Ignored if \'--ort-file\' is also specified. (default: the last part of the project URL)'
complete -c ort -n "__fish_seen_subcommand_from download" -l vcs-type -r -d 'The VCS type if \'--project-url\' points to a VCS. Ignored if \'--ort-file\' is also specified. (default: the VCS type detected by querying the project URL)'
complete -c ort -n "__fish_seen_subcommand_from download" -l vcs-revision -r -d 'The VCS revision if \'--project-url\' points to a VCS. Ignored if \'--ort-file\' is also specified. (default: the VCS\'s default revision)'
complete -c ort -n "__fish_seen_subcommand_from download" -l vcs-path -r -d 'The VCS path if \'--project-url\' points to a VCS. Ignored if \'--ort-file\' is also specified. (default: the empty root path)'
complete -c ort -n "__fish_seen_subcommand_from download" -l license-classifications-file -r -F -d 'A file containing the license classifications that are used to limit downloads if the included categories are specified in the \'config.yml\' file. If not specified, all packages are downloaded.'
complete -c ort -n "__fish_seen_subcommand_from download" -l output-dir -s o -r -F -d 'The output directory to download the source code to.'
complete -c ort -n "__fish_seen_subcommand_from download" -l archive -d 'Archive the downloaded source code as ZIP files to the output directory. Is ignored if \'--project-url\' is also specified.'
complete -c ort -n "__fish_seen_subcommand_from download" -l archive-all -d 'Archive all the downloaded source code as a single ZIP file to the output directory. Is ignored if \'--project-url\' is also specified.'
complete -c ort -n "__fish_seen_subcommand_from download" -l package-types -r -fa "PACKAGE PROJECT" -d 'A comma-separated list of the package types from the ORT file\'s analyzer result to limit downloads to.'
complete -c ort -n "__fish_seen_subcommand_from download" -l package-ids -r -d 'A comma-separated list of regular expressions for matching package ids from the ORT file\'s analyzer result to limit downloads to. If not specified, all packages are downloaded.'
complete -c ort -n "__fish_seen_subcommand_from download" -l skip-excluded -d 'Do not download excluded projects or packages. Works only with the \'--ort-file\' parameter.'
complete -c ort -n "__fish_seen_subcommand_from download" -s h -l help -d 'Show this message and exit'


### Setup for evaluate
complete -c ort -f -n __fish_use_subcommand -a evaluate -d 'Evaluate ORT result files against policy rules.'

## Options for evaluate
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l ort-file -s i -r -F -d 'The ORT result file to read as input.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l output-dir -s o -r -F -d 'The directory to write the ORT result file with evaluation results to.  If no output directory is specified, no ORT result file is written and only the exit code signals a success or failure.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l output-formats -s f -r -fa "JSON XML YAML" -d 'The list of output formats to be used for the ORT result file(s).'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l rules-file -s r -r -F -d 'The name of a script file containing rules.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l rules-resource -r -d 'The name of a script resource on the classpath that contains rules.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l copyright-garbage-file -r -F -d 'A file containing copyright statements which are marked as garbage.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l license-classifications-file -r -F -d 'A file containing the license classifications which are passed as parameter to the rules script.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l package-configuration-dir -r -F -d 'A directory that is searched recursively for package configuration files. Each file must only contain a single package configuration.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l package-curations-file -r -F -d 'A file containing package curations. This replaces all package curations contained in the given ORT result file with the ones present in the given file and, if enabled, those from the package configuration.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l package-curations-dir -r -F -d 'A directory containing package curation files. This replaces all package curations contained in the given ORT result file with the ones present in the given directory and, if enabled, those from the package configuration file.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l repository-configuration-file -r -F -d 'A file containing the repository configuration. If set, overrides the repository configuration contained in the ORT result input file.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l resolutions-file -r -F -d 'A file containing issue and rule violation resolutions.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l label -s l -r -d 'Set a label in the ORT result, overwriting any existing label of the same name. Can be used multiple times. For example: --label distribution=external'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -l check-syntax -d 'Do not evaluate the script but only check its syntax. No output is written in this case.'
complete -c ort -n "__fish_seen_subcommand_from evaluate" -s h -l help -d 'Show this message and exit'


### Setup for notify
complete -c ort -f -n __fish_use_subcommand -a notify -d 'Create notifications based on an ORT result.'

## Options for notify
complete -c ort -n "__fish_seen_subcommand_from notify" -l ort-file -s i -r -F -d 'The ORT result file to read as input.'
complete -c ort -n "__fish_seen_subcommand_from notify" -l notifications-file -s n -r -F -d 'The name of a Kotlin script file containing notification rules.'
complete -c ort -n "__fish_seen_subcommand_from notify" -l resolutions-file -r -F -d 'A file containing issue and rule violation resolutions.'
complete -c ort -n "__fish_seen_subcommand_from notify" -l label -s l -r -d 'Set a label in the ORT result passed to the notifier script, overwriting any existing label of the same name. Can be used multiple times. For example: --label distribution=external'
complete -c ort -n "__fish_seen_subcommand_from notify" -s h -l help -d 'Show this message and exit'


### Setup for report
complete -c ort -f -n __fish_use_subcommand -a report -d 'Present Analyzer, Scanner and Evaluator results in various formats.'

## Options for report
complete -c ort -n "__fish_seen_subcommand_from report" -l ort-file -s i -r -F -d 'The ORT result file to use.'
complete -c ort -n "__fish_seen_subcommand_from report" -l output-dir -s o -r -F -d 'The output directory to store the generated reports in.'
complete -c ort -n "__fish_seen_subcommand_from report" -l report-formats -s f -r -d 'The comma-separated reports to generate, any of [CtrlXAutomation, CycloneDx, DocBookTemplate, EvaluatedModel, Excel, FossId, GitLabLicenseModel, HtmlTemplate, ManPageTemplate, Opossum, PdfTemplate, PlainTextTemplate, SpdxDocument, StaticHtml, WebApp].'
complete -c ort -n "__fish_seen_subcommand_from report" -l copyright-garbage-file -r -F -d 'A file containing copyright statements which are marked as garbage. This can make the output inconsistent with the evaluator output but is useful when testing copyright garbage.'
complete -c ort -n "__fish_seen_subcommand_from report" -l custom-license-texts-dir -r -F -d 'A directory which maps custom license IDs to license texts. It should contain one text file per license with the license ID as the filename. A custom license text is used only if its ID has a \'LicenseRef-\' prefix and if the respective license text is not known by ORT.'
complete -c ort -n "__fish_seen_subcommand_from report" -l how-to-fix-text-provider-script -r -F -d 'The path to a Kotlin script which returns an instance of a \'HowToFixTextProvider\'. That provider injects how-to-fix texts in Markdown format for ORT issues.'
complete -c ort -n "__fish_seen_subcommand_from report" -l license-classifications-file -r -F -d 'A file containing the license classifications. This can make the output inconsistent with the evaluator output but is useful when testing license classifications.'
complete -c ort -n "__fish_seen_subcommand_from report" -l package-configuration-dir -r -F -d 'A directory that is searched recursively for package configuration files. Each file must only contain a single package configuration. This can make the output inconsistent with the evaluator output but is useful when testing package configurations.'
complete -c ort -n "__fish_seen_subcommand_from report" -l refresh-resolutions -d 'Use the resolutions from the global and repository configuration instead of the resolved configuration. This can make the output inconsistent with the evaluator output but is useful when testing resolutions.'
complete -c ort -n "__fish_seen_subcommand_from report" -l repository-configuration-file -r -F -d 'A file containing the repository configuration. If set, overrides the repository configuration contained in the ORT result input file. This can make the output inconsistent with the output of previous commands but is useful when testing changes in the repository configuration.'
complete -c ort -n "__fish_seen_subcommand_from report" -l resolutions-file -r -F -d 'A file containing issue and rule violation resolutions.'
complete -c ort -n "__fish_seen_subcommand_from report" -l report-option -s O -r -d 'Specify a report-format-specific option. The key is the (case-insensitive) name of the report format, and the value is an arbitrary key-value pair. For example: -O PlainTextTemplate=template.id=NOTICE_SUMMARY'
complete -c ort -n "__fish_seen_subcommand_from report" -s h -l help -d 'Show this message and exit'


### Setup for requirements
complete -c ort -f -n __fish_use_subcommand -a requirements -d 'Check for the command line tools required by ORT.'

## Options for requirements
complete -c ort -n "__fish_seen_subcommand_from requirements" -s h -l help -d 'Show this message and exit'


### Setup for scan
complete -c ort -f -n __fish_use_subcommand -a scan -d 'Run external license / copyright scanners.'

## Options for scan
complete -c ort -n "__fish_seen_subcommand_from scan" -l ort-file -s i -r -F -d 'An ORT result file with an analyzer result to use. Source code is downloaded automatically if needed. Must not be used together with \'--input-path\'.'
complete -c ort -n "__fish_seen_subcommand_from scan" -l input-path -s p -r -F -d 'An input directory or file to scan. Must not be used together with \'--ort-file\'.'
complete -c ort -n "__fish_seen_subcommand_from scan" -l output-dir -s o -r -F -d 'The directory to write the ORT result file with scan results to.'
complete -c ort -n "__fish_seen_subcommand_from scan" -l output-formats -s f -r -fa "JSON XML YAML" -d 'The list of output formats to be used for the ORT result file(s).'
complete -c ort -n "__fish_seen_subcommand_from scan" -l label -s l -r -d 'Set a label in the ORT result, overwriting any existing label of the same name. Can be used multiple times. For example: --label distribution=external'
complete -c ort -n "__fish_seen_subcommand_from scan" -l scanners -s s -r -d 'A comma-separated list of scanners to use.'
complete -c ort -n "__fish_seen_subcommand_from scan" -l project-scanners -r -d 'A comma-separated list of scanners to use for scanning the source code of projects. By default, projects and packages are scanned with the same scanners as specified by \'--scanners\'.'
complete -c ort -n "__fish_seen_subcommand_from scan" -l package-types -r -fa "PACKAGE PROJECT" -d 'A comma-separated list of the package types from the ORT file\'s analyzer result to limit scans to.'
complete -c ort -n "__fish_seen_subcommand_from scan" -l skip-excluded -d 'Do not scan excluded projects or packages. Works only with the \'--ort-file\' parameter.'
complete -c ort -n "__fish_seen_subcommand_from scan" -l resolutions-file -r -F -d 'A file containing issue and rule violation resolutions.'
complete -c ort -n "__fish_seen_subcommand_from scan" -s h -l help -d 'Show this message and exit'


### Setup for upload-curations
complete -c ort -f -n __fish_use_subcommand -a upload-curations -d 'Upload ORT package curations to ClearlyDefined.'

## Options for upload-curations
complete -c ort -n "__fish_seen_subcommand_from upload-curations" -l input-file -s i -r -F -d 'The file with package curations to upload.'
complete -c ort -n "__fish_seen_subcommand_from upload-curations" -l server -s s -r -fa "PRODUCTION DEVELOPMENT LOCAL" -d 'The ClearlyDefined server to upload to.'
complete -c ort -n "__fish_seen_subcommand_from upload-curations" -s h -l help -d 'Show this message and exit'


### Setup for upload-result-to-postgres
complete -c ort -f -n __fish_use_subcommand -a upload-result-to-postgres -d 'Upload an ORT result to a PostgreSQL database.'

## Options for upload-result-to-postgres
complete -c ort -n "__fish_seen_subcommand_from upload-result-to-postgres" -l ort-file -s i -r -F -d 'The ORT result file to read as input.'
complete -c ort -n "__fish_seen_subcommand_from upload-result-to-postgres" -l table-name -r -d 'The name of the table to upload results to.'
complete -c ort -n "__fish_seen_subcommand_from upload-result-to-postgres" -l column-name -r -d 'The name of the JSONB column to store the ORT result.'
complete -c ort -n "__fish_seen_subcommand_from upload-result-to-postgres" -l create-table -d 'Create the table if it does not exist.'
complete -c ort -n "__fish_seen_subcommand_from upload-result-to-postgres" -s h -l help -d 'Show this message and exit'


### Setup for upload-result-to-sw360
complete -c ort -f -n __fish_use_subcommand -a upload-result-to-sw360 -d 'Upload an ORT result to SW360.'

## Options for upload-result-to-sw360
complete -c ort -n "__fish_seen_subcommand_from upload-result-to-sw360" -l ort-file -s i -r -F -d 'The ORT result file to read as input.'
complete -c ort -n "__fish_seen_subcommand_from upload-result-to-sw360" -l attach-sources -s a -d 'Download sources of packages and upload them as attachments to SW360 releases.'
complete -c ort -n "__fish_seen_subcommand_from upload-result-to-sw360" -s h -l help -d 'Show this message and exit'

