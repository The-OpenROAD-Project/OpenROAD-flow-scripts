#!/usr/bin/env python3


class FactoryBase:
    """Base class for factory registration and creation"""

    _registry = {}

    @classmethod
    def get_key(self, memory_type, port_config):
        """Returns the key from the memory_type and port_config"""
        return f"{port_config}_{memory_type}"

    @classmethod
    def register(self, memory_type, port_config, klass):
        """Registers a class for the given memory_type and port_config"""
        self._registry[self.get_key(memory_type, port_config)] = klass

    @classmethod
    def create(self, mem_config, memory_type, port_config, process, timing_data):
        """
        Creates and returns the requested object based on the factory registry

        Parameters:
        mem_config (MemoryConfig): memory parameter container
        memory_type (str): type of memory to create (RAM or RF)
        port_config (str): port configuration (SP or DP)
        process_data (Process): process data container
        timing_data (TimingData): timing data container
        """
        key = self.get_key(memory_type, port_config)
        klass = self._registry.get(key)
        if klass is None:
            raise ValueError(
                f"No class registered under key: {memory_type} {port_config}"
            )
        return klass(mem_config, process, timing_data)
