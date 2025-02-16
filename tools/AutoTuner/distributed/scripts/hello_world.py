import ray


@ray.remote
def hello_world():
    return "hello world"


# Automatically connect to the running Ray cluster.
ray.init()
print(ray.get(hello_world.remote()))
