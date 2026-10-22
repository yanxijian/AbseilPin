# Pin matrix


<!-- translated-from: docs/zh/PIN_MATRIX.md sha256:07a738e7a8ef -->

## Field check (2026-08-08)

| Consumer | Dependency | Abseil |
|----------|------------|--------|
| MultiProcessShell | FetchContent `protobuf` **v35.1** + `MPS_ABSEIL_PIN_PREFIX` | **`20260107.1`** (AbseilPin; upstream protobuf still declares `20250512.1`, overridden via package / `find_package`) |
| pdfium_all | `deps.lock.md` → `thirdparty/abseil-cpp` / vcpkg `abseil` | **`20260107.1`** |
| AbseilPin | `pins/20260107.1` | **`20260107.1`** (unification target / default sibling auto-detect) |

Also pinned: **`20240116.0`** (ships with `protobuf` v29.3; rollback).

## Pins in this repo

| ID | Upstream tag | Role |
|----|--------------|------|
| `20240116.0` | `20240116.0` | protobuf v29.3 companion; rollback |
| `20260107.1` | `20260107.1` | Align with pdfium_all / MPS v35.1 |

## Unification rules

1. **One** `abseil_dll.dll` per process (identical content hash).  
2. Bumping a pin = change `PIN` / `ABSL_PIN_ID` + rebuild the prefix + **re-test every consumer**.  
3. **ABI**: an MSVC-STL pin must **not** mix with pdfium’s **libc++** abseil when V8 is on; in-process PDF needs pdfium **without V8** or a whole-stack STL match.  
4. Unverified mixes are **forbidden** on the main path by default.
