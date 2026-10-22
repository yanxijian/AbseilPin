# Unification roadmap (AbseilPin → in-process PDF)


<!-- translated-from: docs/zh/ROADMAP.md sha256:612a195c40e9 -->

Milestones aligned with the Volition toolchain.

## Stage 1 (this repo + MPS) — done

1. Build the **`20260107.1`** prefix here (matches pdfium_all lock).  
2. MPS: `protobuf` **v35.1** + `MPS_ABSEIL_PIN_PREFIX` → `find_package(absl)`.  
3. Auto-detect `../AbseilPin/prefix/20260107.1` when the sibling tree exists.  

Accept: a **single** pin `abseil_dll.dll` beside Host / demos.

## Stage 1b — VolitionToolchain — done

Full contract: Volition `docs/en/toolchain.md`.

| Item | Value |
|------|--------|
| C++ | **20** |
| Windows compiler | **MSVC `cl`** + `/MD` |
| Abseil | AbseilPin **`20260107.1`** |
| pdfium in-process | **`PDFIUM_ENABLE_V8=OFF`** (V8 stays libc++ and is not co-loaded with the shell) |

The pdfium fork (`volition-toolchain`) product path defaults to this pin.

## Stage 2 — Volition in-process PDF — done

Prerequisite: pdfium and `mps_*` share **the same pin and STL ABI** for `abseil_dll.dll`.

1. Link pdfium from `volition_pdf.dll`.  
2. Day-to-day path does not need `volition_pdf_render.exe` (optional `-DVOLITION_PDF_OOP_RENDER` + `VOLITION_PDF_OOP=1`).  
3. Keep a single abseil under `build/bin/`.  

Implementation constraint: pin `absl_DIR` at configure time (so other `CMAKE_PREFIX_PATH` / vcpkg packages do not win); stage `pdfium_all/output` from the **V8=OFF** `cmake-msvc` tree.

## Stage 3 (optional)

For load-failure isolation only: a thin `pdfium_adapter.dll` that still **must** share the Client’s pin abseil (no second copy).
