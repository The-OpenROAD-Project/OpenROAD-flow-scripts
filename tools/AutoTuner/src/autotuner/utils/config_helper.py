import yaml


def parse_config(file_path: str):
    """
    Parses a YAML configuration file and returns the content as a dictionary.

    :param file_path: Path to the YAML configuration file.
    :return: Dictionary containing the parsed configuration.
    """
    with open(file_path) as file:
        config = yaml.safe_load(file)
    return config


if __name__ == "__main__":
    config = parse_config("config.yaml")
    print(config)
