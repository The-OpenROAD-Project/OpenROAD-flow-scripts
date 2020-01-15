---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

**Preamble (delete this section after reading)**
EDA bug fixing is difficult because the inputs used to replicate the bug are often under a non-disclosure agreement (NDA). Fixing bugs without inputs is time-consuming, and we can't dedicate significant resources towards fixing esoteric bugs. Therefore, we assign bugs different "classes" and will allocate resources based on ease of reproduction. A higher class indicates the issue will be responded to more quickly. All criteria must be met to be part of the class, subject to developer interpretation.

_Issues which do not meet the minimum criteria are subject to immediate closure!_

|  | Class 1 (Highest Priority) | Class 2 | Class 3 |
| :-- | :--: | :--: | :--: |
| Issue report | All applicable template fields filled | All applicable template fields filled | All applicable template fields filled |
| File uploads | All required inputs provided | Most inputs provided | Few inputs provided |
| Reproducibility | Issue is reproducible from provided inputs | Issue is not reproducible | Issue is not reproducible |
| Issue identification | Faulty behavior clearly identified | Faulty behavior clearly identified | Faulty behavior satisfactorily identified |

**Describe the bug**
A clear and concise description of what the bug is. Please include any tags that apply to this issue:
* [Toolname] for runtime issues (e.g. [RePlAce], [FastRoute])
* [Documentation] for documentation errors
* [Build] for compilation-related issues
* [Flow] for any util, flow Makefile, or flow script issues
* [Design] for example design issues (i.e. the design does not pass functional validation, etc.)

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem (e.g. layout screenshots).

**Environment (please complete the following information):**
Please only report issues for supported OSs.
 - OS: [e.g. CentOS 7]
 - OpenROAD-flow commit [e.g. 02c01cd]

**File Uploads**
For runtime issues, provide your inputs for the identified tool or command in a single tar file. Do not upload NDA materials; supported open-source platforms are preferred (e.g. Nangate45).

**Additional context**
Add any other context about the problem here.
