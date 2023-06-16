# FAQs

If you cannot find your question/answer here, please file a GitHub issue to
the appropriate repository or start a discussion.

-   Issues and bugs:
    -   OpenROAD Flow: <https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/issues>
    -   OpenROAD with OpenROAD Flow Scripts: <https://github.com/The-OpenROAD-Project/OpenROAD/issues/>
-   Discussions:
    -   OpenROAD Flow: <https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/discussions>

## How can I contribute?

Thank you for your willingness to contribute. Please see the
[Getting Involved](../contrib/GettingInvolved) guide.

## How do I update the design reference files?

See how to update the Metrics [here](../contrib/Metrics.md).

## Does OpenROAD support libraries with CCS driver model?

Only NLDM is currently supported but CCS is under development.

## Is incremental flow supported?

We do support restarting the flow at a given step.

## Does OpenSTA in OpenROAD support all sdc commands?

Yes, but be careful that there are many proprietary commands that are not in SDC.

## Is SystemVerilog support limited to the constructs that Yosys supports?

Yes. The is the surelog plugin that has a good amount of SV support

## Does OpenROAD do only DRC analysis or also DRV and DFM? Of the DFM analysis I have only seen an antenna rule check.

OpenROAD does max slew/cap/fanout if that is what you mean by DRV. There is no DFM.

## Does OpenROAD provide corner-based optimisation, or it can only show us the characteristics, like wns, for different corners?

OpenROAD can be setup for multi-corner analysis. ORFS does not take advantage of that today.

## Does OpenROAD support crosstalk delay/noise analysis?

No. Once we have CCS for delay it would be natural to tackle this next.
