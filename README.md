# AbseilPin

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

共享 **一份** Windows `abseil_dll.dll` 的 pin 仓：给 MultiProcessShell（protobuf）与 pdfium_all / Volition 对齐 ABI。

> 不是业务库。`interface` 只有：**固定 LTS tag → 编出可 `find_package(absl)` 的 prefix**。

## 为何需要

同进程不能加载两套不同的 `abseil_dll.dll`（同名只装一次，符号对不上就 127）。  
MPS 与 pdfium 当前钉的 LTS **不一致**，本仓负责钉住「要用的那一份」并给出统一路线。

## 当前 pin 矩阵

| Pin ID | Abseil LTS | 匹配谁 | 状态 |
|--------|------------|--------|------|
| **`20240116.0`**（默认 active） | [20240116.0](https://github.com/abseil/abseil-cpp/releases/tag/20240116.0) | MPS `protobuf v29.3` 自带 submodule | **可编、可给 MPS `package` 消费** |
| **`20260107.1`** | [20260107.1](https://github.com/abseil/abseil-cpp/releases/tag/20260107.1) | pdfium_all `deps.lock` | 统一目标；需先升 MPS protobuf（见 [docs/ROADMAP.md](docs/ROADMAP.md)） |

详情：[docs/PIN_MATRIX.md](docs/PIN_MATRIX.md) · 路线：[docs/ROADMAP.md](docs/ROADMAP.md)

## 快速开始（Windows MSVC x64）

```bat
:: x64 Native Tools / vcvars
set PIN=20240116.0
powershell -File scripts\build_pin.ps1 -Pin %PIN% -Prefix %CD%\prefix\%PIN%
```

产物：

- `prefix/<pin>/bin/abseil_dll.dll`
- `prefix/<pin>/lib/cmake/absl/abslConfig.cmake`（`find_package(absl CONFIG)`）

## 消费方（阶段 1）

### MultiProcessShell

```bat
cmake -S . -B build-shared -G Ninja ^
  -DMPS_ABSEIL_PIN_PREFIX=D:/Codes/AbseilPin/prefix/20240116.0 ^
  ...
```

`MPS_ABSEIL_PIN_PREFIX` 非空时：`protobuf_ABSL_PROVIDER=package`，不再用 protobuf 树内 abseil 编第二份 DLL。

### pdfium_all / Volition

见 ROADMAP：在 active pin 升到 `20260107.1`（或 pdfium 能链 `20240116.0`）之前，Volition 继续用 **旁路 `volition_pdf_render`**。

## 布局

```text
pins/<id>/PIN.md     该 pin 的 commit / 校验说明
scripts/build_pin.ps1
CMakeLists.txt       按 ABSL_PIN_ID FetchContent 并 install
docs/
```

## License

Abseil 本身为 Apache-2.0。本仓脚本与文档同 Apache-2.0（见 [LICENSE](LICENSE)）。
