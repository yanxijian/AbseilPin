# Unification roadmap (AbseilPin → in-process PDF)

Stages aligned with the Volition discussion.

## Stage 1 (this repo + MPS) — version alignment landed

1. Build the **`20260107.1`** prefix here (matches pdfium_all lock).  
2. MPS: `protobuf` **v35.1** + `MPS_ABSEIL_PIN_PREFIX` → `find_package(absl)`; no second abseil build.  
3. Auto-detect `../AbseilPin/prefix/20260107.1` when the sibling tree exists.  
4. Volition does **not** fold pdfium back yet; keep `volition_pdf_render` until one-abseil / ABI checks pass.

Acceptance: Demo / Volition Host directories contain **one** pin-built `abseil_dll.dll`.

## Stage 1b — VolitionToolchain (in progress)

Contract: Volition `docs/en/toolchain.md`.

| Item | Value |
|------|--------|
| C++ | **20** (shell and pdfium; do not down-level pdfium to 17) |
| Windows compiler | **MSVC `cl`** + `/MD` |
| Abseil | AbseilPin **`20260107.1`** |
| pdfium in-process | **`PDFIUM_ENABLE_V8=OFF`** (V8 ON still uses libc++ and conflicts) |

Gap: pdfium fork (`volition-toolchain`) builds with `cl` on the product path and defaults to this pin.

## Stage 2 — Volition in-process PDF

Prerequisite: pdfium and `mps_*` share **the same pin and the same STL ABI** for `abseil_dll.dll`.

1. Link pdfium directly from `volition_pdf.dll` (delay-load OK).  
2. Retire day-to-day `volition_pdf_render.exe` (optional debug switch `VOLITION_PDF_OOP_RENDER` + `VOLITION_PDF_OOP=1`).  
3. Keep a single abseil under `bin/`.

Landing notes: pdfium and MPS both **FORCE `absl_DIR` to this pin** (so a cached vcpkg absl cannot win); restage `pdfium_all/output` from the **V8=OFF** `cmake-msvc` tree.

## Stage 3 (optional)

For load-failure isolation only: a thin `pdfium_adapter.dll` that still **must** share the Client’s pin abseil (no second copy).
