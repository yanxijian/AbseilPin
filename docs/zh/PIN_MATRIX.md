# Pin 矩阵

## 现场实测（2026-08-08）

| 消费方 | 依赖 | Abseil |
|--------|------|--------|
| MultiProcessShell | FetchContent `protobuf` **v35.1** + `MPS_ABSEIL_PIN_PREFIX` | **`20260107.1`**（AbseilPin；官方 protobuf 自带 pin 仍为 `20250512.1`，经 package/`find_package` 覆盖） |
| pdfium_all | `deps.lock.md` → `thirdparty/abseil-cpp` / vcpkg `abseil` | **`20260107.1`** |
| AbseilPin | `pins/20260107.1` | **`20260107.1`**（统一目标 / 默认 sibling 自动探测） |

另保留 pin：`protobuf` v29.3 自带的 **`20240116.0`**（回退用）。

## 本仓 pins

| ID | Upstream tag | 用途 |
|----|--------------|------|
| `20240116.0` | `20240116.0` | protobuf v29.3 配套；回退 |
| `20260107.1` | `20260107.1` | 与 pdfium_all / MPS v35.1 对齐 |

## 统一原则

1. **进程内只允许一份** `abseil_dll.dll`（内容哈希一致）。  
2. 升 pin = 改 `PIN` / `ABSL_PIN_ID` + 重编 prefix + **所有消费方跟测**。  
3. **ABI**：MSVC STL 的 pin 与开 V8 时 pdfium 用的 **libc++** abseil **不能**混用；同进程 PDF 需 pdfium **关 V8** 或整栈统一 STL。  
4. 未验证的「混用」默认 **禁止** 进主路径。
