# Azure Monitor Baseline Alerts Policy Export

Policies from the [Azure Monitor Baseline Alerts](https://azure.github.io/azure-monitor-baseline-alerts/welcome/) project extracted for use in [EPAC](https://aka.ms/epac).

The definitions files are updated weekly around Thursday by deploying the solution and then extracting all the policies. 

## Deployment Patterns

- If you are following the ALZ deployment methodology use the files below to assign alerting policies to the correct scopes
    - alerting-connectivity-policySet.jsonc
    - alerting-identity-policySet.jsonc
    - alerting-management-policySet.jsonc
    - alerting-landingzone-policySet.jsonc
    - alerting-servicehealth-policySet.jsonc
    - notification-assets-policySet.jsonc
- Copy the files from the ```Definitions``` folder to your own EPAC repo and delete any assignment files that aren't listed above. See below for how to use these files for non ALZ aligned environments. 
- Adjust the following fields in the assignment files to suit your environment.
    - ```scope```
    - ```managedIdentityLocations```
    - ```parameters```

- If you are not following the ALZ structure and want to deploy alerts for a single group of services e.g. Key Vault - then deploy the matching policy assignment. In the case of Key Vault you would deploy ```alerting-keymanagement-policySet.jsonc```

## Caveats

- Policies are tested by the owners of the AMBA repositories - for issues with the policies or assignments please refer to the original [project](hhttps://github.com/Azure/azure-monitor-baseline-alerts).
- Eventually these policies will be integrated into the ALZ project and this repo will no longer be maintained.
- The assignment files assumes an ALZ recommended management group structure - as described in [this link](https://github.com/Azure/alz-monitor/wiki/Introduction-to-deploying-ALZ-Monitor#determining-your-management-group-hierarchy).
