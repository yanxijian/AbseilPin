# 统一路线（AbseilPin → 同进程 PDF）

与 Volition 工具链对齐的里程碑。

## 阶段 1（本仓 + MPS）— 完成

1. 本仓编出 **`20260107.1`** prefix（与 pdfium_all lock 一致）。  
2. MPS：`protobuf` **v35.1** + `MPS_ABSEIL_PIN_PREFIX` → `find_package(absl)`。  
3. 旁路存在时自动探测 `../AbseilPin/prefix/20260107.1`。  

验收：Host / Demo 旁只有 **一份** pin 的 `abseil_dll.dll`。

## 阶段 1b — VolitionToolchain — 完成

全栈契约见 Volition `docs/zh/toolchain.md`：

| 项 | 值 |
|----|-----|
| C++ | **20** |
| Windows 编译器 | **MSVC `cl`** + `/MD` |
| Abseil | AbseilPin **`20260107.1`** |
| pdfium 同进程 | **`PDFIUM_ENABLE_V8=OFF`**（V8 仍为 libc++，不与壳同进程） |

pdfium fork（`volition-toolchain`）产品路径默认接本仓 pin。

## 阶段 2 — Volition 同进程 PDF — 完成

前提：pdfium 与 `mps_*` 依赖 **同一 pin、同一 STL ABI** 的 `abseil_dll.dll`。

1. `volition_pdf.dll` 直接链接 pdfium。  
2. 日常路径不依赖 `volition_pdf_render.exe`（可选 `-DVOLITION_PDF_OOP_RENDER` + `VOLITION_PDF_OOP=1`）。  
3. `build/bin/` 仅一份 abseil。  

实现约束：配置时将 `absl_DIR` 固定到本仓 pin（避免其它 `CMAKE_PREFIX_PATH` / vcpkg 包抢先）；`pdfium_all/output` 须来自 **V8=OFF** 的 `cmake-msvc` stage。

## 阶段 3（可选）

若需要加载失败隔离：浅 `pdfium_adapter.dll`，仍须与 Client **共用** pin 的 abseil（禁止第二份）。
