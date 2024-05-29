import os
import re
import warnings

def parse_flow_variables(source = 'docs', configurable = True):
    """
    Parse the flow variables from the document ./docs/user/FlowVariables.md
    or the Makefile located at ./flow/Makefile.

    TODO: Tests.

    Args:
    - source: source of the flow variables. Must be either 'docs' or 'makefile'.
    - configurable: if True, only return the configurable flow variables. This mode
    is only valid for Makefile.

    Output:
    - flow_variables: set of flow variables
    """
    assert source in ['docs', 'makefile'],\
     "Invalid source. Must be either 'docs' or 'makefile'."

    DOCS_REL_PATH = "../../../../docs/user/FlowVariables.md" 
    MAKEFILE_REL_PATH = "../../../../flow/Makefile"

    # if this is operated in a ray setup
    if "ray" in os.getcwd():
        DOCS_REL_PATH = "../../" + DOCS_REL_PATH
        MAKEFILE_REL_PATH = "../../" + MAKEFILE_REL_PATH
    
    if source == 'docs' and configurable:
        warnings.warn("Warning: configurable mode is only valid for Makefile.")

    cur_path = os.path.dirname(os.path.realpath(__file__))
    if source == 'docs':
        fv_path = os.path.join(cur_path, "../../../../docs/user/FlowVariables.md")
        with open(fv_path) as f:
            # Regex to parse all variables with "``" identifiers that are uppercase.
            regex = r"`(.+?)`"
            flow_variables = set(match 
                                for line in f
                                for match in re.findall(regex, line)
                                if match.isupper())
            for line in f:
                matches = re.findall(regex, line)
                for match in matches:
                    if not match.isupper(): continue
                    flow_variables.add(match)
    else:
        fv_path = os.path.join(cur_path, "../../../../flow/Makefile")
        with open(fv_path) as f:
            # Regular expression to match uppercase variables ending with '?=' 
            pattern = r"[A-Z_\s]+(?=\?=)" if configurable else r"[A-Z_]+"
            matches = re.findall(pattern, f.read())
            
            flow_variables = set(s.strip() 
                                for match in matches
                                for s in match.split('\n') 
                                if len(s))
    return flow_variables


if __name__ == "__main__":
    set1 = parse_flow_variables('docs')
    set2 = parse_flow_variables('makefile', False)
    for i in sorted(set2):
        print(i)