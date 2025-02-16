1) Setup two AT instances on same internal network
2) Setup the requirements

```
sudo apt-get install -y python3-pip python3-venv
python3 -m venv .venv
.venv/bin/activate && pip install ray[tune]

```

3) Common setup script
- `at_distributed.sh`

4) Worker script
- `at_worker.py`
- `mkdir -p /tmp/owo && touch /tmp/owo/abc`


5) Benchmark file transfers (do on worker)
- Observation: sync_dir just makes sure the files are sync-ed. So neat feature is that only file diffs are transffered.
- You do not have to create the dest_dir, sync_dir does that for you.
- `max_size_bytes` is limited to 1GiB. So we have to lift up the restriction manually if needed.
- Bottleneck seems to start at 1GiB transfers and above
- `dd if=/dev/zero of=/tmp/owo/owo bs=1M count=100` - creates 100MB file. (Time taken: 2.2103039264678954 ± 0.556972017400803)
- `dd if=/dev/zero of=/tmp/owo/owo bs=1M count=1000` - creates 1Gb file. (Time taken: 8.897777223587036 ± 0.6503669298689543)
- `dd if=/dev/zero of=/tmp/owo/owo bs=1M count=5000` - creates 5Gb file. (Time taken: 54.920665216445926 ± 1.0533714623736783)