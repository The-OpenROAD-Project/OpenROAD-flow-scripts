# CI Guide

This document describes the pipelines available to the developers and code
maintainers in the [Jenkins server](https://jenkins.openroad.tools/). Note
that pipelines with the suffix `*-Private` are only available to code
maintainers and The OpenROAD Project members as they can contain confidential
information. Thus, to access Private pipelines one needs to have authorization
to access confidential data and be logged in the Jenkins website.

Below there is a list of the available features. Instructions on how to
navigate Jenkins to access these features are available
[here](https://docs.google.com/presentation/d/1kWHLjUBFcd0stnDaPNi_pt9WFrrsR7tQ95BGhT1yOvw/edit?usp=sharing).

-   Find your build through Jenkins website or from GitHub.
-   See test status: Pass/Fail.
-   Log files for each test.
-   Build artifacts to reproduce failures.
-   HTML reports about code coverage and metrics.

## OpenROAD Flow

-   OpenROAD-flow-script-Public [folder]
    -   `public_tests_all`
        -   Description: runs flow tests that finish in less than three hours.
        -   Target: master branch.
    -   `public_tests_all-pr`
        -   Description: runs flow tests that finish in less than three hours.
        -   Target: all open PRs.
    -   `publish-results-to-dashboard`
        -   Description: uploads metrics to dashboard website.
        -   Target: master branch.
-   OpenROAD-flow-scripts-Nightly-Public
    -   Description: runs all flow tests including RTLMP designs.
    -   Target: master branch.
-   OpenROAD-flow-scripts-Private [folder]
    -   `public_tests_small`
        -   Description: runs fast flow tests that finish in less than one hour.
        -   Target: all branches that are not filed as PR. CI will run for PR
            branches on the public side after "Ready to Sync Public" workflow.
-   OpenROAD-flow-scripts-All-Tests-Private
    -   Description: runs flow tests for private branches.
    -   Target: secure branches.
