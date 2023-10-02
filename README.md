# Azure Monitor Baseline Alerts Policy Export

Policies from the [Azure Monitor Baseline Alerts](https://azure.github.io/azure-monitor-baseline-alerts/welcome/) project extracted for use in [EPAC](https://aka.ms/epac).

## Usage

- Copy the files from the ```Definitions``` folder to your own EPAC repo.
- Adjust the following fields in the assignment files to suit your environment.
    - ```scope```
    - ```managedIdentityLocations```
    - ```parameters```

## Caveats

- Policies are tested by the owners of the AMBA repositories - for issues with the policies or assignments please refer to the original [project](hhttps://github.com/Azure/azure-monitor-baseline-alerts).
- Eventually these policies will be integrated into the ALZ project and this repo will no longer be maintained.
- The assignment files assumes an ALZ recommended management group structure - as described in [this link](https://github.com/Azure/alz-monitor/wiki/Introduction-to-deploying-ALZ-Monitor#determining-your-management-group-hierarchy).
