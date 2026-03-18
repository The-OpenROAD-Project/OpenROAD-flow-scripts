try:
    import pytest
except ImportError:
    pass
else:

    def pytest_configure(config):
        config.addinivalue_line(
            "markers", "integration: mark test as integration test (requires Make)"
        )
