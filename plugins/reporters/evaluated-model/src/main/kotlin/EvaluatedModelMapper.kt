/*
 * Copyright (C) 2017 The ORT Project Authors (see <https://github.com/oss-review-toolkit/ort/blob/main/NOTICE>)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

package org.ossreviewtoolkit.plugins.reporters.evaluatedmodel

import org.ossreviewtoolkit.model.AdvisorResult
import org.ossreviewtoolkit.model.CuratedPackage
import org.ossreviewtoolkit.model.DependencyNode
import org.ossreviewtoolkit.model.Identifier
import org.ossreviewtoolkit.model.Issue
import org.ossreviewtoolkit.model.LicenseFinding
import org.ossreviewtoolkit.model.PackageLinkage
import org.ossreviewtoolkit.model.Project
import org.ossreviewtoolkit.model.Provenance
import org.ossreviewtoolkit.model.RemoteArtifact
import org.ossreviewtoolkit.model.Repository
import org.ossreviewtoolkit.model.ResolvedConfiguration
import org.ossreviewtoolkit.model.RuleViolation
import org.ossreviewtoolkit.model.ScanResult
import org.ossreviewtoolkit.model.TextLocation
import org.ossreviewtoolkit.model.VcsInfo
import org.ossreviewtoolkit.model.config.IssueResolution
import org.ossreviewtoolkit.model.config.LicenseFindingCuration
import org.ossreviewtoolkit.model.config.PathExclude
import org.ossreviewtoolkit.model.config.RepositoryConfiguration
import org.ossreviewtoolkit.model.config.Resolutions
import org.ossreviewtoolkit.model.config.RuleViolationResolution
import org.ossreviewtoolkit.model.config.ScopeExclude
import org.ossreviewtoolkit.model.config.VulnerabilityResolution
import org.ossreviewtoolkit.model.licenses.LicenseView
import org.ossreviewtoolkit.model.toYaml
import org.ossreviewtoolkit.model.utils.FindingCurationMatcher
import org.ossreviewtoolkit.model.utils.FindingsMatcher
import org.ossreviewtoolkit.model.utils.RootLicenseMatcher
import org.ossreviewtoolkit.model.vulnerabilities.Vulnerability
import org.ossreviewtoolkit.reporter.ReporterInput
import org.ossreviewtoolkit.reporter.StatisticsCalculator.getStatistics
import org.ossreviewtoolkit.utils.ort.ProcessedDeclaredLicense
import org.ossreviewtoolkit.utils.spdx.calculatePackageVerificationCode

/**
 * Maps the [reporter input][input] to an [EvaluatedModel].
 */
@Suppress("TooManyFunctions")
internal class EvaluatedModelMapper(private val input: ReporterInput) {
    private val packages = mutableMapOf<Identifier, EvaluatedPackage>()
    private val paths = mutableListOf<EvaluatedPackagePath>()
    private val dependencyTrees = mutableListOf<DependencyTreeNode>()
    private val scanResults = mutableListOf<EvaluatedScanResult>()
    private val copyrights = mutableListOf<CopyrightStatement>()
    private val licenses = mutableListOf<LicenseId>()
    private val scopes = mutableMapOf<String, EvaluatedScope>()
    private val issues = mutableListOf<EvaluatedIssue>()
    private val issueResolutions = mutableListOf<IssueResolution>()
    private val pathExcludes = mutableListOf<PathExclude>()
    private val scopeExcludes = mutableListOf<ScopeExclude>()
    private val ruleViolations = mutableListOf<EvaluatedRuleViolation>()
    private val ruleViolationResolutions = mutableListOf<RuleViolationResolution>()
    private val vulnerabilities = mutableListOf<EvaluatedVulnerability>()
    private val vulnerabilitiesResolutions = mutableListOf<VulnerabilityResolution>()

    private val curationsMatcher = FindingCurationMatcher()
    private val findingsMatcher = FindingsMatcher(RootLicenseMatcher(input.ortConfig.licenseFilePatterns))

    private data class PackageExcludeInfo(
        var id: Identifier,
        var isExcluded: Boolean,
        val pathExcludes: MutableList<PathExclude> = mutableListOf(),
        val scopeExcludes: MutableList<ScopeExclude> = mutableListOf()
    )

    private val packageExcludeInfo = mutableMapOf<Identifier, PackageExcludeInfo>()

    /**
     * Build an [EvaluatedModel] instance. If [deduplicateDependencyTree] is *true*, remove duplicate subtrees from
     * the dependency tree. This may be necessary for huge projects to avoid excessive memory consumption.
     */
    fun build(deduplicateDependencyTree: Boolean = false): EvaluatedModel {
        createExcludeInfo()

        val resultProjects = input.ortResult.getProjects().sortedBy { it.id }
        val resultPackages = input.ortResult.getPackages().sortedBy { it.metadata.id }

        resultProjects.forEach { project ->
            createScopes(project)
        }

        resultProjects.forEach { project ->
            addProject(project)
        }

        resultPackages.forEach { curatedPkg ->
            addPackage(curatedPkg)
        }

        input.ortResult.evaluator?.violations?.forEach { ruleViolation ->
            addRuleViolation(ruleViolation)
        }

        input.ortResult.advisor?.results?.advisorResults?.forEach { (id, results) ->
            val pkg = packages.getValue(id)

            results.forEach { result ->
                addAdvisorResult(pkg, result)
            }
        }

        resultProjects.forEach { project ->
            val pkg = packages.getValue(project.id)
            addDependencyTree(project, pkg, deduplicateDependencyTree)
        }

        resultProjects.forEach { project ->
            addShortestPaths(project)
        }

        return EvaluatedModel(
            pathExcludes = pathExcludes,
            scopeExcludes = scopeExcludes,
            issueResolutions = issueResolutions,
            issues = issues,
            copyrights = copyrights,
            licenses = licenses,
            scopes = scopes.values.toList(),
            scanResults = scanResults,
            packages = packages.values.toList(),
            paths = paths,
            dependencyTrees = dependencyTrees,
            ruleViolationResolutions = ruleViolationResolutions,
            ruleViolations = ruleViolations,
            vulnerabilitiesResolutions = vulnerabilitiesResolutions,
            vulnerabilities = vulnerabilities,
            statistics = with(input) { getStatistics(ortResult, licenseInfoResolver, ortConfig) },
            repository = input.ortResult.repository.deduplicateResolutions(),
            severeIssueThreshold = input.ortConfig.severeIssueThreshold,
            severeRuleViolationThreshold = input.ortConfig.severeRuleViolationThreshold,
            repositoryConfiguration = input.ortResult.repository.config.toYaml(),
            labels = input.ortResult.labels,
            metadata = MetadataCalculator().getMetadata(input.ortResult)
        )
    }

    private fun createExcludeInfo() {
        input.ortResult.getProjects().forEach { project ->
            packageExcludeInfo[project.id] = PackageExcludeInfo(project.id, true)
        }

        input.ortResult.getPackages().forEach { pkg ->
            packageExcludeInfo[pkg.metadata.id] = PackageExcludeInfo(pkg.metadata.id, true)
        }

        input.ortResult.getProjects().forEach { project ->
            val pathExcludes = input.ortResult.getExcludes().findPathExcludes(project, input.ortResult)
            val dependencies = input.ortResult.dependencyNavigator.projectDependencies(project)
            if (pathExcludes.isEmpty()) {
                val info = packageExcludeInfo.getValue(project.id)
                if (info.isExcluded) {
                    info.isExcluded = false
                    info.pathExcludes.clear()
                    info.scopeExcludes.clear()
                }
            } else {
                dependencies.forEach { id ->
                    val info = packageExcludeInfo.getOrPut(id) { PackageExcludeInfo(id, true) }

                    if (info.isExcluded) {
                        info.pathExcludes += pathExcludes
                    }
                }
            }

            input.ortResult.dependencyNavigator.scopeDependencies(project).forEach { (scopeName, dependencies) ->
                val scopeExcludes = input.ortResult.getExcludes().findScopeExcludes(scopeName)
                if (scopeExcludes.isNotEmpty()) {
                    dependencies.forEach { id ->
                        val info = packageExcludeInfo.getOrPut(id) { PackageExcludeInfo(id, true) }
                        if (info.isExcluded) {
                            info.scopeExcludes += scopeExcludes
                        }
                    }
                } else if (pathExcludes.isEmpty()) {
                    dependencies.forEach { id ->
                        val info = packageExcludeInfo.getOrPut(id) { PackageExcludeInfo(id, true) }
                        info.isExcluded = false
                        info.pathExcludes.clear()
                        info.scopeExcludes.clear()
                    }
                }
            }
        }
    }

    private fun createScopes(project: Project) {
        input.ortResult.dependencyNavigator.scopeNames(project).sorted().forEach { scope ->
            scopes[scope] = EvaluatedScope(
                name = scope,
                excludes = scopeExcludes.addIfRequired(input.ortResult.getExcludes().findScopeExcludes(scope))
            )
        }
    }

    private fun TextLocation.getRelativePathToRoot(id: Identifier): String =
        input.ortResult.getProject(id)?.let { input.ortResult.getFilePathRelativeToAnalyzerRoot(it, path) } ?: path

    private fun getLicenseFindingCurations(id: Identifier, provenance: Provenance): List<LicenseFindingCuration> =
        if (input.ortResult.isProject(id)) {
            input.ortResult.repository.config.curations.licenseFindings
        } else {
            input.packageConfigurationProvider.getPackageConfigurations(id, provenance)
                .flatMap { it.licenseFindingCurations }
        }

    private fun getPathExcludes(id: Identifier, provenance: Provenance): List<PathExclude> =
        if (input.ortResult.isProject(id)) {
            input.ortResult.getExcludes().paths
        } else {
            input.packageConfigurationProvider.getPackageConfigurations(id, provenance)
                .flatMap { it.pathExcludes }
        }

    private fun addProject(project: Project) {
        val scanResults = mutableListOf<EvaluatedScanResult>()
        val detectedLicenses = mutableSetOf<LicenseId>()
        val detectedExcludedLicenses = mutableSetOf<LicenseId>()
        val findings = mutableListOf<EvaluatedFinding>()
        val issues = mutableListOf<EvaluatedIssue>()

        val applicablePathExcludes = input.ortResult.getExcludes().findPathExcludes(project, input.ortResult)
        val evaluatedPathExcludes = pathExcludes.addIfRequired(applicablePathExcludes)

        val evaluatedPackage = EvaluatedPackage(
            id = project.id,
            isProject = true,
            definitionFilePath = project.definitionFilePath,
            authors = project.authors,
            declaredLicenses = project.declaredLicenses.map { licenses.addIfRequired(LicenseId(it)) },
            declaredLicensesProcessed = project.declaredLicensesProcessed.evaluate(),
            detectedLicenses = detectedLicenses,
            detectedExcludedLicenses = detectedExcludedLicenses,
            concludedLicense = null,
            description = "",
            homepageUrl = project.homepageUrl,
            binaryArtifact = RemoteArtifact.EMPTY,
            sourceArtifact = RemoteArtifact.EMPTY,
            vcs = project.vcs,
            vcsProcessed = project.vcsProcessed,
            curations = emptyList(),
            paths = mutableListOf(),
            levels = sortedSetOf(0),
            scopes = mutableSetOf(),
            scanResults = scanResults,
            findings = findings,
            isExcluded = applicablePathExcludes.isNotEmpty(),
            pathExcludes = evaluatedPathExcludes,
            scopeExcludes = emptyList(),
            issues = issues
        )

        packages[evaluatedPackage.id] = evaluatedPackage

        issues += addAnalyzerIssues(project.id, evaluatedPackage)

        input.ortResult.getScanResultsForId(project.id).mapTo(scanResults) { result ->
            convertScanResult(result, findings, evaluatedPackage)
        }

        findings.filter { it.type == EvaluatedFindingType.LICENSE }.mapNotNullTo(detectedLicenses) { it.license }

        val includedDetectedLicenses = findings.filter {
            it.type == EvaluatedFindingType.LICENSE && it.pathExcludes.isEmpty()
        }.mapNotNullTo(mutableSetOf()) { it.license }

        detectedExcludedLicenses += detectedLicenses - includedDetectedLicenses
    }

    private fun addPackage(curatedPkg: CuratedPackage) {
        val pkg = curatedPkg.metadata

        val scanResults = mutableListOf<EvaluatedScanResult>()
        val detectedLicenses = mutableSetOf<LicenseId>()
        val detectedExcludedLicenses = mutableSetOf<LicenseId>()
        val findings = mutableListOf<EvaluatedFinding>()
        val issues = mutableListOf<EvaluatedIssue>()

        val excludeInfo = packageExcludeInfo.getValue(pkg.id)

        val evaluatedPathExcludes = pathExcludes.addIfRequired(excludeInfo.pathExcludes)
        val evaluatedScopeExcludes = scopeExcludes.addIfRequired(excludeInfo.scopeExcludes)

        val evaluatedPackage = EvaluatedPackage(
            id = pkg.id,
            isProject = false,
            definitionFilePath = "",
            purl = pkg.purl,
            authors = pkg.authors,
            declaredLicenses = pkg.declaredLicenses.map { licenses.addIfRequired(LicenseId(it)) },
            declaredLicensesProcessed = pkg.declaredLicensesProcessed.evaluate(),
            detectedLicenses = detectedLicenses,
            detectedExcludedLicenses = detectedExcludedLicenses,
            concludedLicense = pkg.concludedLicense,
            effectiveLicense = input.licenseInfoResolver.resolveLicenseInfo(pkg.id).filterExcluded().effectiveLicense(
                LicenseView.CONCLUDED_OR_DECLARED_AND_DETECTED,
                input.ortResult.getPackageLicenseChoices(pkg.id),
                input.ortResult.getRepositoryLicenseChoices()
            )?.sorted(),
            description = pkg.description,
            homepageUrl = pkg.homepageUrl,
            binaryArtifact = pkg.binaryArtifact,
            sourceArtifact = pkg.sourceArtifact,
            vcs = pkg.vcs,
            vcsProcessed = pkg.vcsProcessed,
            curations = curatedPkg.curations,
            paths = mutableListOf(),
            levels = sortedSetOf(),
            scopes = mutableSetOf(),
            scanResults = scanResults,
            findings = findings,
            isExcluded = excludeInfo.isExcluded,
            pathExcludes = evaluatedPathExcludes,
            scopeExcludes = evaluatedScopeExcludes,
            issues = issues
        )

        packages[evaluatedPackage.id] = evaluatedPackage

        issues += addAnalyzerIssues(pkg.id, evaluatedPackage)

        input.ortResult.getScanResultsForId(pkg.id).mapTo(scanResults) { result ->
            convertScanResult(result, findings, evaluatedPackage)
        }

        findings.filter { it.type == EvaluatedFindingType.LICENSE }.mapNotNullTo(detectedLicenses) { it.license }

        val includedDetectedLicenses = findings.filter {
            it.type == EvaluatedFindingType.LICENSE && it.pathExcludes.isEmpty()
        }.mapNotNullTo(mutableSetOf()) { it.license }

        detectedExcludedLicenses += detectedLicenses - includedDetectedLicenses
    }

    private fun addAnalyzerIssues(id: Identifier, pkg: EvaluatedPackage): List<EvaluatedIssue> {
        val result = mutableListOf<EvaluatedIssue>()

        input.ortResult.analyzer?.result?.issues?.get(id)?.let { analyzerIssues ->
            result += addIssues(analyzerIssues, EvaluatedIssueType.ANALYZER, pkg, null, null)
        }

        return result
    }

    private fun addRuleViolation(ruleViolation: RuleViolation) {
        val resolutions = addResolutions(ruleViolation)
        val pkg = ruleViolation.pkg?.let { id ->
            packages[id] ?: createEmptyPackage(id)
        }

        val license = ruleViolation.license?.let { licenses.addIfRequired(LicenseId(it.toString())) }

        val evaluatedViolation = EvaluatedRuleViolation(
            rule = ruleViolation.rule,
            pkg = pkg,
            license = license,
            licenseSource = ruleViolation.licenseSource,
            severity = ruleViolation.severity,
            message = ruleViolation.message,
            howToFix = ruleViolation.howToFix,
            resolutions = resolutions
        )

        ruleViolations += evaluatedViolation
    }

    private fun addAdvisorResult(pkg: EvaluatedPackage, result: AdvisorResult) {
        // TODO: Add defects from the result to the model.

        result.vulnerabilities.forEach { vulnerability ->
            addVulnerability(pkg, vulnerability)
        }

        addIssues(result.summary.issues, EvaluatedIssueType.ADVISOR, pkg, null, null)
    }

    private fun addVulnerability(pkg: EvaluatedPackage, vulnerability: Vulnerability) {
        val resolutions = addResolutions(vulnerability)

        vulnerabilities += EvaluatedVulnerability(
            pkg = pkg,
            id = vulnerability.id,
            summary = vulnerability.summary,
            description = vulnerability.description,
            references = vulnerability.references,
            resolutions = resolutions
        )
    }

    private fun convertScanResult(
        result: ScanResult,
        findings: MutableList<EvaluatedFinding>,
        pkg: EvaluatedPackage
    ): EvaluatedScanResult {
        val issues = mutableListOf<EvaluatedIssue>()

        val evaluatedScanResult = EvaluatedScanResult(
            provenance = result.provenance,
            scanner = result.scanner,
            startTime = result.summary.startTime,
            endTime = result.summary.endTime,
            packageVerificationCode = input.ortResult.getFileListForId(pkg.id)?.let { fileList ->
                calculatePackageVerificationCode(fileList.files.map { it.sha1 }.asSequence())
            }.orEmpty(),
            issues = issues
        )

        val actualScanResult = scanResults.addIfRequired(evaluatedScanResult)

        issues += addIssues(
            result.summary.issues,
            EvaluatedIssueType.SCANNER,
            pkg,
            actualScanResult,
            null
        )

        addLicensesAndCopyrights(pkg.id, result, actualScanResult, findings)

        return actualScanResult
    }

    private fun addDependencyTree(project: Project, pkg: EvaluatedPackage, deduplicateDependencyTree: Boolean) {
        val visitedNodes = mutableMapOf<Any, DependencyTreeNode>()

        fun createDependencyNode(
            dependency: EvaluatedPackage,
            linkage: PackageLinkage,
            issues: List<EvaluatedIssue>,
            children: List<DependencyTreeNode> = emptyList()
        ) = DependencyTreeNode(
            linkage = linkage,
            pkg = dependency,
            scope = null,
            children = children,
            pathExcludes = emptyList(),
            scopeExcludes = emptyList(),
            issues = issues
        )

        fun DependencyNode.toEvaluatedTreeNode(
            scope: EvaluatedScope,
            path: List<EvaluatedPackage>
        ): DependencyTreeNode {
            val dependency = packages.getOrPut(id) { createEmptyPackage(id) }
            val issues = mutableListOf<EvaluatedIssue>()
            val packagePath = EvaluatedPackagePath(
                pkg = dependency,
                project = pkg,
                scope = scope,
                path = path
            )

            dependency.levels += path.size
            dependency.scopes += scope

            if (this.issues.isNotEmpty()) {
                paths += packagePath
                issues += addIssues(this.issues, EvaluatedIssueType.ANALYZER, dependency, null, packagePath)
            }

            visitedNodes += getInternalId() to createDependencyNode(dependency, linkage, issues)

            val children = visitDependencies { dependencies ->
                dependencies
                    .map { it.getStableReference() } // Obtain stable reference to not lose node data when sorting.
                    .sortedBy { it.id }
                    .map { node ->
                        val nodeId = node.getInternalId()

                        if (deduplicateDependencyTree && nodeId in visitedNodes) {
                            // Cut the duplicate subtree here and only return the node without its children.
                            visitedNodes.getValue(nodeId).copy(children = emptyList())
                        } else {
                            node.toEvaluatedTreeNode(scope, path + dependency)
                        }
                    }.toList()
            }

            return createDependencyNode(dependency, linkage, issues, children)
        }

        val scopeTrees = input.ortResult.dependencyNavigator.scopeNames(project).sorted().map { scope ->
            // Deduplication should not happen across scopes.
            visitedNodes.clear()

            val subTrees = input.ortResult.dependencyNavigator.directDependencies(project, scope)
                .map { it.getStableReference() } // Obtain stable reference to not lose node data when sorting.
                .sortedBy { it.id }
                .mapTo(mutableListOf()) { it.toEvaluatedTreeNode(scopes.getValue(scope), mutableListOf()) }

            val applicableScopeExcludes = input.ortResult.getExcludes().findScopeExcludes(scope)
            val evaluatedScopeExcludes = scopeExcludes.addIfRequired(applicableScopeExcludes)

            DependencyTreeNode(
                linkage = null,
                pkg = null,
                scope = scopes.getValue(scope),
                children = subTrees,
                pathExcludes = emptyList(),
                scopeExcludes = evaluatedScopeExcludes,
                issues = emptyList()
            )
        }

        val tree = DependencyTreeNode(
            linkage = null,
            pkg = pkg,
            scope = null,
            children = scopeTrees,
            pathExcludes = pkg.pathExcludes,
            scopeExcludes = emptyList(),
            issues = emptyList()
        )

        dependencyTrees += tree
    }

    private fun createEmptyPackage(id: Identifier): EvaluatedPackage {
        val excludeInfo = packageExcludeInfo[id] ?: PackageExcludeInfo(id, isExcluded = false)

        val evaluatedPathExcludes = pathExcludes.addIfRequired(excludeInfo.pathExcludes)
        val evaluatedScopeExcludes = scopeExcludes.addIfRequired(excludeInfo.scopeExcludes)

        val evaluatedPackage = EvaluatedPackage(
            id = id,
            isProject = false,
            definitionFilePath = "",
            purl = null,
            authors = emptySet(),
            declaredLicenses = emptyList(),
            declaredLicensesProcessed = EvaluatedProcessedDeclaredLicense(null, emptyList(), emptyList()),
            detectedLicenses = emptySet(),
            detectedExcludedLicenses = emptySet(),
            concludedLicense = null,
            description = "",
            homepageUrl = "",
            binaryArtifact = RemoteArtifact.EMPTY,
            sourceArtifact = RemoteArtifact.EMPTY,
            vcs = VcsInfo.EMPTY,
            vcsProcessed = VcsInfo.EMPTY,
            curations = emptyList(),
            paths = mutableListOf(),
            levels = sortedSetOf(),
            scopes = mutableSetOf(),
            scanResults = emptyList(),
            findings = emptyList(),
            isExcluded = excludeInfo.isExcluded,
            pathExcludes = evaluatedPathExcludes,
            scopeExcludes = evaluatedScopeExcludes,
            issues = emptyList()
        )

        packages[id] = evaluatedPackage

        return evaluatedPackage
    }

    private fun addIssues(
        issues: List<Issue>,
        type: EvaluatedIssueType,
        pkg: EvaluatedPackage,
        scanResult: EvaluatedScanResult?,
        path: EvaluatedPackagePath?
    ): List<EvaluatedIssue> {
        val evaluatedIssues = issues.map { issue ->
            val resolutions = addResolutions(issue)

            EvaluatedIssue(
                timestamp = issue.timestamp,
                type = type,
                source = issue.source,
                message = issue.message,
                severity = issue.severity,
                resolutions = resolutions,
                pkg = pkg,
                scanResult = scanResult,
                path = path,
                howToFix = input.howToFixTextProvider.getHowToFixText(issue).orEmpty()
            )
        }

        this.issues += evaluatedIssues

        return evaluatedIssues
    }

    private fun addResolutions(issue: Issue): List<IssueResolution> {
        val matchingResolutions = input.ortResult.getResolutionsFor(issue)

        return issueResolutions.addIfRequired(matchingResolutions)
    }

    private fun addResolutions(ruleViolation: RuleViolation): List<RuleViolationResolution> {
        val matchingResolutions = input.ortResult.getResolutionsFor(ruleViolation)

        return ruleViolationResolutions.addIfRequired(matchingResolutions)
    }

    private fun addResolutions(vulnerability: Vulnerability): List<VulnerabilityResolution> {
        val matchingResolutions = input.ortResult.getResolutionsFor(vulnerability)

        return vulnerabilitiesResolutions.addIfRequired(matchingResolutions)
    }

    private fun addLicensesAndCopyrights(
        id: Identifier,
        scanResult: ScanResult,
        evaluatedScanResult: EvaluatedScanResult,
        findings: MutableList<EvaluatedFinding>
    ) {
        val pathExcludes = getPathExcludes(id, scanResult.provenance)
        val licenseFindingCurations = getLicenseFindingCurations(id, scanResult.provenance)
        // Sort the curated findings here to avoid the need to sort in the web-app each time it is loaded.
        val curatedFindings = curationsMatcher.applyAll(scanResult.summary.licenseFindings, licenseFindingCurations)
            .mapNotNull { it.curatedFinding }.toSortedSet(LicenseFinding.COMPARATOR)
        val matchResult = findingsMatcher.match(curatedFindings, scanResult.summary.copyrightFindings)
        val matchedFindings = matchResult.matchedFindings.entries.groupBy { it.key.license }.mapValues { entry ->
            val licenseFindings = entry.value.map { it.key }
            val copyrightFindings = entry.value.flatMapTo(mutableSetOf()) { it.value }
            Pair(licenseFindings, copyrightFindings)
        }

        matchedFindings.forEach { (license, findingPairs) ->
            val (licenseFindings, copyrightFindings) = findingPairs
            copyrightFindings.forEach { copyrightFinding ->
                val actualCopyright = copyrights.addIfRequired(CopyrightStatement(copyrightFinding.statement))

                val evaluatedPathExcludes = pathExcludes
                    .filter { it.matches(copyrightFinding.location.getRelativePathToRoot(id)) }
                    .let { this@EvaluatedModelMapper.pathExcludes.addIfRequired(it) }

                findings += EvaluatedFinding(
                    type = EvaluatedFindingType.COPYRIGHT,
                    license = null,
                    copyright = actualCopyright,
                    path = copyrightFinding.location.path,
                    startLine = copyrightFinding.location.startLine,
                    endLine = copyrightFinding.location.endLine,
                    scanResult = evaluatedScanResult,
                    pathExcludes = evaluatedPathExcludes
                )
            }

            val actualLicense = licenses.addIfRequired(LicenseId(license.toString()))

            licenseFindings.forEach { licenseFinding ->
                val evaluatedPathExcludes = pathExcludes
                    .filter { it.matches(licenseFinding.location.getRelativePathToRoot(id)) }
                    .let { this@EvaluatedModelMapper.pathExcludes.addIfRequired(it) }

                findings += EvaluatedFinding(
                    type = EvaluatedFindingType.LICENSE,
                    license = actualLicense,
                    copyright = null,
                    path = licenseFinding.location.path,
                    startLine = licenseFinding.location.startLine,
                    endLine = licenseFinding.location.endLine,
                    scanResult = evaluatedScanResult,
                    pathExcludes = evaluatedPathExcludes
                )
            }
        }
    }

    private fun addShortestPaths(project: Project) {
        input.ortResult.dependencyNavigator.getShortestPaths(project).toSortedMap().forEach { (scopeName, scopePaths) ->
            scopePaths.forEach { (id, path) ->
                val pkg = packages.getValue(id)

                val packagePath = EvaluatedPackagePath(
                    pkg = pkg,
                    project = packages.getValue(project.id),
                    scope = scopes.getValue(scopeName),
                    path = path.map { parentId -> packages.getValue(parentId) }
                )

                paths += packagePath
                pkg.paths += packagePath
            }
        }
    }

    private fun ProcessedDeclaredLicense.evaluate(): EvaluatedProcessedDeclaredLicense =
        EvaluatedProcessedDeclaredLicense(
            spdxExpression = spdxExpression,
            mappedLicenses = decompose().map { licenses.addIfRequired(LicenseId(it.toString())) },
            unmappedLicenses = unmapped.map { licenses.addIfRequired(LicenseId(it)) }
        )

    /**
     * Add the [value] to this list if the list does not already contain an equal item. Return the item contained in the
     * list. This is important to make sure that there is only one instance of equal items used in the model, because
     * when Jackson generates IDs each instance gets a new ID, no matter if they are equal or not.
     */
    private fun <T> MutableList<T>.addIfRequired(value: T): T = find { it == value } ?: value.also { add(it) }

    /**
     * Similar to [addIfRequired], but for multiple input values.
     */
    private fun <T> MutableList<T>.addIfRequired(values: Collection<T>): List<T> =
        values.map { addIfRequired(it) }.distinct()

    /**
     * Return a copy of the [RepositoryConfiguration] with [Resolutions] that refer to the same instances as the
     * [ResolvedConfiguration] for equal [Resolutions]. This is required for the [EvaluatedModel] to contained indexed
     * references instead of duplicate [Resolutions].
     */
    private fun Repository.deduplicateResolutions(): Repository {
        val resolutions = with(config.resolutions) {
            copy(
                issues = issues.map { resolution -> issueResolutions.find { resolution == it } ?: resolution },
                ruleViolations = ruleViolations.map { resolution ->
                    ruleViolationResolutions.find { resolution == it } ?: resolution
                },
                vulnerabilities = vulnerabilities.map { resolution ->
                    vulnerabilitiesResolutions.find { resolution == it } ?: resolution
                }
            )
        }

        return copy(config = config.copy(resolutions = resolutions))
    }
}
