/*
 * Copyright (C) 2021 The ORT Project Authors (see <https://github.com/oss-review-toolkit/ort/blob/main/NOTICE>)
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

plugins {
    // Apply precompiled plugins.
    id("ort-library-conventions")
}

dependencies {
    api(projects.model)
    api(projects.utils.scriptingUtils)

    implementation(projects.utils.ortUtils)

    implementation("org.jetbrains.kotlin:kotlin-scripting-common")
    implementation("org.jetbrains.kotlin:kotlin-scripting-jvm-host")
    implementation(libs.jakartaMail)
    implementation(libs.jiraRestClientApi)
    implementation(libs.jiraRestClientApp) {
        exclude("org.slf4j", "slf4j-log4j12")
            .because("the SLF4J implementation from Log4j 2 is used")
    }

    testImplementation(libs.greenmail)
    testImplementation(libs.mockk)
}
