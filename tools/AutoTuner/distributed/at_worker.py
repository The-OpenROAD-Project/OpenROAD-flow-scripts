import ray
from ray.tune.utils.file_transfer import sync_dir_between_nodes
import time

ray.init()
_DEFAULT_MAX_SIZE_BYTES = 5 * 1024 * 1024 * 1024  # 1 GiB

res = []
for i in range(5):
    start = time.time()
    sync_dir_between_nodes(
        source_ip="10.129.0.5",
        source_path="/tmp/owo",
        target_ip="10.129.0.4",
        target_path=f"/tmp/owo{i}",
        max_size_bytes=_DEFAULT_MAX_SIZE_BYTES,
    )
    print(f"Time taken: {time.time() - start}")
    res.append(time.time() - start)

print(
    "Time taken: {} ± {}".format(
        sum(res) / len(res),
        sum((x - sum(res) / len(res)) ** 2 for x in res) / len(res) ** 0.5,
    )
)
