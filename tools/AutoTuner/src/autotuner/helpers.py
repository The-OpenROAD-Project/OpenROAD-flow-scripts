import os
import re

def parse_flow_variables():
    """
    Parse the flow variables from the document ./docs/user/FlowVariables.md
    TODO: Tests.

    Args:
    - None

    Output:
    - flow_variables: set of flow variables
    """
    flow_variables = set()
    cur_path = os.path.dirname(os.path.realpath(__file__))
    fv_path = os.path.join(cur_path, "../../../../docs/user/FlowVariables.md")

    with open(fv_path) as f:
        # use regex to parse all variables with "``" identifiers.
        # if the variable is not all capital letters, it is not a flow variable.
        regex = r"`(.+?)`"
        for line in f:
            matches = re.findall(regex, line)
            for match in matches:
                if not match.isupper(): continue
                flow_variables.add(match)
    return flow_variables


if __name__ == "__main__":
    print(parse_flow_variables())