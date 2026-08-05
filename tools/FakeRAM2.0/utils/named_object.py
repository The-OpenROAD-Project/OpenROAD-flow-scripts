#!/usr/bin/env python3


class NamedObject:
    """
    Simple named object
    """

    def __init__(self, name):
        """Initializer"""
        self._name = name

    def get_name(self):
        """Gets the object name"""
        return self._name
