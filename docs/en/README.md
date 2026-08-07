# AbseilPin

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](../../LICENSE)

Pin repo that builds **one** shared Windows `abseil_dll.dll` so MultiProcessShell (protobuf) and pdfium_all / Volition can align ABI.

> Not a product library. The only `interface` is: **fixed LTS tag → install prefix usable with `find_package(absl)`**.

Canonical Chinese docs live at the [root README](../../README.md) and under [../zh/](../zh/).

## Why

A process must not load two different `abseil_dll.dll` builds (same basename loads once; mismatched symbols → error 127).  
MPS and pdfium historically pinned different LTS tags; this repo owns the chosen pin and the unification path.

## Pin matrix (summary)

| Pin ID | Abseil LTS | Matches | Status |
|--------|------------|---------|--------|
| **`20260107.1`** (default) | [20260107.1](https://github.com/abseil/abseil-cpp/releases/tag/20260107.1) | pdfium_all `deps.lock`; MPS `protobuf` **v35.1** via pin | **Buildable; MPS can consume via package** |
| **`20240116.0`** | [20240116.0](https://github.com/abseil/abseil-cpp/releases/tag/20240116.0) | Legacy MPS `protobuf` v29.3 | Rollback only |

Details: [PIN_MATRIX.md](PIN_MATRIX.md) · Roadmap: [ROADMAP.md](ROADMAP.md)

## Quick start (Windows MSVC x64)

```bat
:: x64 Native Tools / vcvars
set PIN=20260107.1
powershell -File scripts\build_pin.ps1 -Pin %PIN% -Prefix %CD%\prefix\%PIN%
```

Outputs:

- `prefix/<pin>/bin/abseil_dll.dll`
- `prefix/<pin>/lib/cmake/absl/abslConfig.cmake` (`find_package(absl CONFIG)`)

## Consumers (stage 1)

### MultiProcessShell

```bat
cmake -S . -B build-shared -G Ninja ^
  -DMPS_ABSEIL_PIN_PREFIX=D:/Codes/AbseilPin/prefix/20260107.1 ^
  ...
```

When `MPS_ABSEIL_PIN_PREFIX` is set (or the sibling prefix is auto-detected), protobuf uses `find_package(absl)` and does not FetchContent a second `abseil_dll`.

### pdfium_all / Volition

See [ROADMAP.md](ROADMAP.md). Until STL ABI matches (typically pdfium without V8), Volition keeps the **`volition_pdf_render`** out-of-process path.

## Documentation

| Topic | 中文（主） | English |
|-------|------------|---------|
| Pin matrix | [../zh/PIN_MATRIX.md](../zh/PIN_MATRIX.md) | [PIN_MATRIX.md](PIN_MATRIX.md) |
| Roadmap | [../zh/ROADMAP.md](../zh/ROADMAP.md) | [ROADMAP.md](ROADMAP.md) |
| Overview | [../../README.md](../../README.md) | [README.md](README.md) |

## License

Abseil is Apache-2.0. Scripts and docs in this repo are Apache-2.0 ([LICENSE](../../LICENSE)).
