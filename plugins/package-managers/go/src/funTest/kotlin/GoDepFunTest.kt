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

package org.ossreviewtoolkit.plugins.packagemanagers.go

import io.kotest.core.spec.style.WordSpec
import io.kotest.matchers.collections.beEmpty
import io.kotest.matchers.collections.shouldHaveSize
import io.kotest.matchers.should
import io.kotest.matchers.shouldBe
import io.kotest.matchers.shouldNotBe
import io.kotest.matchers.string.haveSubstring

import java.io.File

import org.ossreviewtoolkit.analyzer.managers.create
import org.ossreviewtoolkit.analyzer.managers.resolveSingleProject
import org.ossreviewtoolkit.model.Identifier
import org.ossreviewtoolkit.model.Project
import org.ossreviewtoolkit.model.VcsInfo
import org.ossreviewtoolkit.model.toYaml
import org.ossreviewtoolkit.utils.test.getAssetFile
import org.ossreviewtoolkit.utils.test.matchExpectedResult

class GoDepFunTest : WordSpec({
    val testDir = getAssetFile("projects/synthetic/godep")

    "GoDep" should {
        "resolve dependencies from a lockfile correctly" {
            val definitionFile = testDir.resolve("lockfile/Gopkg.toml")
            val expectedResultFile = testDir.resolve("lockfile-expected-output.yml")

            val result = create("GoDep").resolveSingleProject(definitionFile)

            result.toYaml() should matchExpectedResult(expectedResultFile, definitionFile)
        }

        "show error if no lockfile is present" {
            val definitionFile = testDir.resolve("no-lockfile/Gopkg.toml")

            val result = create("GoDep").resolveSingleProject(definitionFile)

            with(result) {
                project.id shouldBe
                    Identifier("GoDep::src/funTest/assets/projects/synthetic/godep/no-lockfile/Gopkg.toml:")
                project.definitionFilePath shouldBe
                    "plugins/package-managers/go/src/funTest/assets/projects/synthetic/godep/no-lockfile/Gopkg.toml"
                packages should beEmpty()
                issues shouldHaveSize 1
                issues.first().message should haveSubstring("IllegalArgumentException: No lockfile found in")
            }
        }

        "invoke the dependency solver if no lockfile is present and allowDynamicVersions is set" {
            val definitionFile = testDir.resolve("no-lockfile/Gopkg.toml")

            val result = create("GoDep", allowDynamicVersions = true).resolveSingleProject(definitionFile)

            with(result) {
                project shouldNotBe Project.EMPTY
                issues should beEmpty()
            }
        }

        "import dependencies from Glide" {
            val definitionFile = testDir.resolve("glide/glide.yaml")
            val expectedResultFile = testDir.resolve("glide-expected-output.yml")

            val result = create("GoDep").resolveSingleProject(definitionFile)

            result.toYaml() should matchExpectedResult(expectedResultFile, definitionFile)
        }

        "import dependencies from godeps" {
            val definitionFile = testDir.resolve("godeps/Godeps/Godeps.json")
            val expectedResultFile = testDir.resolve("godeps-expected-output.yml")

            val result = create("GoDep").resolveSingleProject(definitionFile)

            // TODO: The VCS path of the project in the expected result is not the parent directory of the
            //       definition which is wrong and should be fixed.
            result.toYaml() should matchExpectedResult(expectedResultFile, definitionFile)
        }
    }

    "deduceImportPath()" should {
        val projectDir = getAssetFile("projects/synthetic/godep/lockfile")
        val gopath = File("/tmp/gopath")

        "deduce an import path from VCS info" {
            val vcsInfo = VcsInfo.EMPTY.copy(url = "https://github.com/oss-review-toolkit/ort.git")

            deduceImportPath(projectDir, vcsInfo, gopath) shouldBe
                gopath.resolve("src/github.com/oss-review-toolkit/ort.git")
        }

        "deduce an import path without VCS info" {
            val vcsInfo = VcsInfo.EMPTY

            deduceImportPath(projectDir, vcsInfo, gopath) shouldBe gopath.resolve("src/lockfile")
        }
    }
})
