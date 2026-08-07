# Pin 20260107.1

- **Upstream**: https://github.com/abseil/abseil-cpp  
- **Tag**: `20260107.1`  
- **Commit**: `255c84dadd029fd8ad25c5efb5933e47beaa00c7`（pdfium_all `deps.lock.md`）  
- **Consumers**: pdfium_all；MPS `protobuf` **v35.1** via `MPS_ABSEIL_PIN_PREFIX`  
- **Default**: `ABSL_PIN_ID` / sibling auto-detect target  
- **Note**: upstream protobuf still declares abseil `20250512.1`; pin overrides via `find_package`
