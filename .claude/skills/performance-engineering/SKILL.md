---
name: performance-engineering
description: Use when encountering performance issues, slow operations, high latency, memory problems, or need to identify bottlenecks through systematic profiling and optimization
---

# Performance Engineering

## Overview

Systematic performance analysis using profiling tools to identify bottlenecks, root causes, and propose measurable optimizations.

**Core principle:** Measure first, optimize second. Never optimize without profiling data.

## Profiling Tools Reference

| Language | CPU Profiling | Memory | Benchmarks |
|----------|---------------|---------|------------|
| **Rust** | `cargo flamegraph`, `perf` | `valgrind --tool=massif`, `heaptrack` | `cargo bench` |
| **Node** | `node --prof`, `clinic.js`, `0x` | `node --inspect` + DevTools | `autocannon` (HTTP) |
| **Python** | `cProfile`, `py-spy` | `memory_profiler` | `locust` |
| **Java** | JFR, VisualVM, async-profiler | VisualVM, JProfiler | JMH |
| **Go** | `go test -cpuprofile`, `pprof` | `go test -memprofile` | `go test -bench` |

## Workflow

**1. Clarify Goals**
Ask: What to optimize? Performance target? Current metrics? Production or test data?

**2. Profile (Baseline)**
Run appropriate tool for language. Collect CPU time, memory allocations, I/O wait.

**3. Identify Hotspots**
- Functions >5% CPU time
- Unexpected memory allocations
- I/O blocking operations
- Lock contention (multi-threaded)
- GC pressure

**4. Root Cause Analysis**

Common issues:
- O(n²) where O(n log n) possible
- Redundant computation
- Cache misses, poor data locality
- Excessive I/O, N+1 queries
- Memory churn (allocations/deallocations)
- Serialization overhead

**5. Propose Optimizations**

Format:
```
Bottleneck: [function] - [metric]
Root Cause: [specific issue]
Solution: [algorithm/code change]
Expected: [new metric] ([X]x improvement)
Trade-offs: [downsides]
Verification: [benchmark command]
```

**6. Benchmark & Verify**
- Run baseline
- Apply optimization
- Re-benchmark
- Verify correctness (run full tests)

## Performance Principles

1. **Algorithmic efficiency** > micro-optimizations
2. **Do less work** - eliminate unnecessary computation
3. **Cache effectively** - precompute, memoize
4. **Parallelize** where appropriate
5. **Reduce allocations** - reuse memory
6. **Batch I/O** - async, compression
7. **Profile continuously** - catch regressions

## Common Mistakes

| Mistake | Reality |
|---------|---------|
| Optimizing without profiling | Guess wrong 90% of the time |
| Micro-optimizing readable code | Algorithm change > micro-opts |
| Ignoring trade-offs | Memory vs CPU, readability vs speed matter |
| Not benchmarking after | Verify improvement actually happened |
| Production vs test data mismatch | Profile with production-like workloads |

## Red Flags - STOP

- Profiling requires production credentials (ask first)
- Optimization compromises security (don't do it)
- Violates SOLID principles significantly (reconsider)
- Unclear if optimization needed (measure first)
